import { Component, OnInit, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { QuizService } from '../services/quiz.service';
import { Quiz } from '../models/quiz.model';

@Component({
  selector: 'app-category-page',
  templateUrl: './category-page.component.html',
  styleUrl: './category-page.component.css',
})
export class CategoryPageComponent implements OnInit {
  slug = signal('');
  quizzes = signal<Quiz[]>([]);
  loading = signal(true);
  error = signal('');

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private quizService: QuizService
  ) {}

  ngOnInit() {
    const slug = this.route.snapshot.paramMap.get('slug') ?? '';
    this.slug.set(slug);
    this.quizService.getByCategory(slug).subscribe({
      next: quizzes => {
        this.quizzes.set(quizzes);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('Failed to load quizzes.');
        this.loading.set(false);
      },
    });
  }

  start(id: number) {
    this.router.navigate(['/quiz', id]);
  }

  goBack() {
    this.router.navigate(['/']);
  }
}
