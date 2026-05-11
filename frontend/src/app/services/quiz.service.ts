import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Category, CreateQuizPayload, Question, Quiz } from '../models/quiz.model';
import { AuthService } from './auth.service';

@Injectable({ providedIn: 'root' })
export class QuizService {
  private readonly quizzesApi = '/api/quizzes';
  private readonly categoriesApi = '/api/categories';

  constructor(private http: HttpClient, private auth: AuthService) {}

  getCategories(): Observable<Category[]> {
    return this.http.get<Category[]>(this.categoriesApi, this.auth.authHeaders());
  }

  createCategory(name: string, slug: string): Observable<Category> {
    return this.http.post<Category>(this.categoriesApi, { name, slug }, this.auth.authHeaders());
  }

  getByCategory(slug: string): Observable<Quiz[]> {
    return this.http.get<Quiz[]>(`${this.quizzesApi}?category=${slug}`, this.auth.authHeaders());
  }

  getById(id: number): Observable<Quiz> {
    return this.http.get<Quiz>(`${this.quizzesApi}/${id}`, this.auth.authHeaders());
  }

  getMyQuizzes(): Observable<Quiz[]> {
    return this.http.get<Quiz[]>(`${this.quizzesApi}/my`, this.auth.authHeaders());
  }

  create(payload: CreateQuizPayload): Observable<Quiz> {
    return this.http.post<Quiz>(this.quizzesApi, payload, this.auth.authHeaders());
  }

  update(id: number, payload: CreateQuizPayload): Observable<Quiz> {
    return this.http.put<Quiz>(`${this.quizzesApi}/${id}`, payload, this.auth.authHeaders());
  }

  getSystemQuestions(categorySlug: string): Observable<Question[]> {
    return this.http.get<Question[]>(`/api/questions/system?category=${categorySlug}`);
  }
}
