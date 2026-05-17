import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { AccessLog, LogPage, SessionLog, Settings } from '../models/quiz.model';
import { AuthService } from './auth.service';

@Injectable({ providedIn: 'root' })
export class SettingsService {
  readonly settings = signal<Settings | null>(null);

  constructor(private http: HttpClient, private auth: AuthService) {}

  loadPublic(): Observable<Settings> {
    return this.http.get<Settings>('/api/settings/public').pipe(
      tap(settings => this.settings.set(settings))
    );
  }

  getAdminSettings(): Observable<Settings> {
    return this.http.get<Settings>('/api/admin/settings', this.auth.authHeaders()).pipe(
      tap(settings => this.settings.set(settings))
    );
  }

  update(settings: Pick<Settings, 'disableLogin' | 'disableRegister'>): Observable<Settings> {
    return this.http.put<Settings>('/api/admin/settings', settings, this.auth.authHeaders()).pipe(
      tap(updated => this.settings.set(updated))
    );
  }

  accessLogs(page: number): Observable<LogPage<AccessLog>> {
    return this.http.get<LogPage<AccessLog>>(`/api/admin/access-logs?page=${page}`, this.auth.authHeaders());
  }

  sessionLogs(page: number): Observable<LogPage<SessionLog>> {
    return this.http.get<LogPage<SessionLog>>(`/api/admin/session-logs?page=${page}`, this.auth.authHeaders());
  }

  logFirstAccess() {
    if (sessionStorage.getItem('swe_quizzes_access_logged')) return;
    const sessionKey = this.sessionKey();
    this.http.post('/api/access-log', { sessionKey }).subscribe({
      next: () => sessionStorage.setItem('swe_quizzes_access_logged', 'true'),
      error: () => undefined,
    });
  }

  private sessionKey(): string {
    const key = 'swe_quizzes_session_key';
    let value = sessionStorage.getItem(key);
    if (!value) {
      value = crypto.randomUUID();
      sessionStorage.setItem(key, value);
    }
    return value;
  }
}
