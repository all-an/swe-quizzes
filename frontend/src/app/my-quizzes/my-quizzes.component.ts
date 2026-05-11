import { Component, OnInit, signal } from '@angular/core';
import { Router } from '@angular/router';
import { Quiz } from '../models/quiz.model';
import { QuizService } from '../services/quiz.service';

@Component({
  selector: 'app-my-quizzes',
  templateUrl: './my-quizzes.component.html',
  styleUrl: './my-quizzes.component.css',
})
export class MyQuizzesComponent implements OnInit {
  quizzes = signal<Quiz[]>([]);
  loading = signal(true);
  error = signal('');

  constructor(private quizService: QuizService, private router: Router) {}

  ngOnInit() {
    this.quizService.getMyQuizzes().subscribe({
      next: quizzes => {
        this.quizzes.set(quizzes);
        this.loading.set(false);
      },
      error: () => {
        this.error.set('Unable to load your quizzes.');
        this.loading.set(false);
      },
    });
  }

  create() {
    this.router.navigate(['/my-quizzes/new']);
  }

  start(id: number) {
    this.router.navigate(['/quiz', id]);
  }

  edit(id: number) {
    this.router.navigate(['/my-quizzes', id, 'edit']);
  }
}
