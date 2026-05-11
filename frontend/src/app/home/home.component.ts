import { Component, effect, signal } from '@angular/core';
import { Router } from '@angular/router';
import { QuizService } from '../services/quiz.service';
import { AuthService } from '../services/auth.service';
import { Category } from '../models/quiz.model';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.css',
})
export class HomeComponent {
  categories = signal<Category[]>([]);
  loading = signal(true);
  error = signal('');

  constructor(
    private quizService: QuizService,
    private auth: AuthService,
    private router: Router
  ) {
    effect(() => {
      this.auth.account();
      this.loadCategories();
    });
  }

  open(slug: string) {
    this.router.navigate(['/category', slug]);
  }

  private loadCategories() {
    this.loading.set(true);
    this.error.set('');
    this.quizService.getCategories().subscribe({
      next: categories => {
        this.categories.set(categories);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('Failed to load categories. Is the backend running?');
        this.loading.set(false);
      },
    });
  }
}
