import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { AccessLog, LogPage, SessionLog, Settings } from '../models/quiz.model';
import { AuthService } from './auth.service';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class SettingsService {
  private readonly api = `${environment.apiUrl}/api`;
  readonly settings = signal<Settings | null>(null);

  constructor(private http: HttpClient, private auth: AuthService) {}

  loadPublic(): Observable<Settings> {
    return this.http.get<Settings>(`${this.api}/settings/public`).pipe(
      tap(settings => this.settings.set(settings))
    );
  }

  getAdminSettings(): Observable<Settings> {
    return this.http.get<Settings>(`${this.api}/admin/settings`, this.auth.authHeaders()).pipe(
      tap(settings => this.settings.set(settings))
    );
  }

  update(settings: Pick<Settings, 'disableLogin' | 'disableRegister'>): Observable<Settings> {
    return this.http.put<Settings>(`${this.api}/admin/settings`, settings, this.auth.authHeaders()).pipe(
      tap(updated => this.settings.set(updated))
    );
  }

  accessLogs(page: number): Observable<LogPage<AccessLog>> {
    return this.http.get<LogPage<AccessLog>>(`${this.api}/admin/access-logs?page=${page}`, this.auth.authHeaders());
  }

  sessionLogs(page: number): Observable<LogPage<SessionLog>> {
    return this.http.get<LogPage<SessionLog>>(`${this.api}/admin/session-logs?page=${page}`, this.auth.authHeaders());
  }

  logFirstAccess() {
    if (sessionStorage.getItem('swe_quizzes_access_logged')) return;
    const sessionKey = this.sessionKey();
    this.http.post(`${this.api}/access-log`, { sessionKey }).subscribe({
      next: () => sessionStorage.setItem('swe_quizzes_access_logged', 'true'),
      error: () => undefined,
    });
  }

  private sessionKey(): string {
    const key = 'swe_quizzes_session_key';
    let value = sessionStorage.getItem(key);
    if (!value) {
      value = this.randomUuid();
      sessionStorage.setItem(key, value);
    }
    return value;
  }

  // crypto.randomUUID exists only in secure contexts (HTTPS / localhost). Served
  // over plain HTTP it is undefined, so fall back to a manual v4 UUID.
  private randomUuid(): string {
    if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
      return crypto.randomUUID();
    }
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, char => {
      const random = (Math.random() * 16) | 0;
      const value = char === 'x' ? random : (random & 0x3) | 0x8;
      return value.toString(16);
    });
  }
}
