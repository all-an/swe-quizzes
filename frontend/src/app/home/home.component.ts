import { Component, OnInit, signal } from '@angular/core';
import { Router } from '@angular/router';
import { QuizService } from '../services/quiz.service';
import { Category } from '../models/quiz.model';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.css',
})
export class HomeComponent implements OnInit {
  categories = signal<Category[]>([]);
  loading = signal(true);
  error = signal('');

  constructor(private quizService: QuizService, private router: Router) {}

  ngOnInit() {
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

  open(slug: string) {
    this.router.navigate(['/category', slug]);
  }
}
