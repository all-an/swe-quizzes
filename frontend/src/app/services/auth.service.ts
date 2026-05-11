import { Injectable, signal } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { Account, AuthResponse } from '../models/quiz.model';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly tokenKey = 'swe_quizzes_token';
  private readonly accountKey = 'swe_quizzes_account';
  private readonly tokenSignal = signal<string | null>(localStorage.getItem(this.tokenKey));
  readonly account = signal<Account | null>(this.readAccount());

  constructor(private http: HttpClient) {}

  token(): string | null {
    return this.tokenSignal();
  }

  isLoggedIn(): boolean {
    return this.tokenSignal() !== null && this.account() !== null;
  }

  isAdmin(): boolean {
    return this.account()?.role === 'ADMIN';
  }

  authHeaders(): { headers: HttpHeaders } {
    const token = this.tokenSignal();
    return {
      headers: token ? new HttpHeaders({ Authorization: `Bearer ${token}` }) : new HttpHeaders(),
    };
  }

  register(name: string, email: string, password: string): Observable<AuthResponse> {
    return this.http.post<AuthResponse>('/api/accounts/register', { name, email, password }).pipe(
      tap(response => this.store(response))
    );
  }

  login(email: string, password: string): Observable<AuthResponse> {
    return this.http.post<AuthResponse>('/api/auth/login', { email, password }).pipe(
      tap(response => this.store(response))
    );
  }

  logout() {
    const options = this.authHeaders();
    this.clear();
    this.http.post('/api/auth/logout', {}, options).subscribe({ error: () => undefined });
  }

  private store(response: AuthResponse) {
    localStorage.setItem(this.tokenKey, response.token);
    localStorage.setItem(this.accountKey, JSON.stringify(response.account));
    this.tokenSignal.set(response.token);
    this.account.set(response.account);
  }

  private clear() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.accountKey);
    this.tokenSignal.set(null);
    this.account.set(null);
  }

  private readAccount(): Account | null {
    const raw = localStorage.getItem(this.accountKey);
    if (!raw) return null;
    try {
      return JSON.parse(raw) as Account;
    } catch {
      localStorage.removeItem(this.accountKey);
      return null;
    }
  }
}
