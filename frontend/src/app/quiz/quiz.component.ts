import { Component, OnInit, OnDestroy, signal, computed } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { QuizService } from '../services/quiz.service';
import { Quiz, Question } from '../models/quiz.model';

@Component({
  selector: 'app-quiz',
  templateUrl: './quiz.component.html',
  styleUrl: './quiz.component.css',
})
export class QuizComponent implements OnInit, OnDestroy {
  quiz = signal<Quiz | null>(null);
  currentIndex = signal(0);
  selectedAnswerIndex = signal<number | null>(null);
  score = signal(0);
  timeLeft = signal(0);

  currentQuestion = computed<Question | null>(() => {
    const q = this.quiz();
    return q ? q.questions[this.currentIndex()] : null;
  });

  private timer?: ReturnType<typeof setInterval>;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private quizService: QuizService
  ) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.quizService.getById(id).subscribe({
      next: quiz => {
        this.quiz.set(quiz);
        this.startTimer();
      },
      error: () => this.router.navigate(['/']),
    });
  }

  ngOnDestroy() {
    clearInterval(this.timer);
  }

  selectAnswer(index: number) {
    if (this.selectedAnswerIndex() !== null) return;
    this.selectedAnswerIndex.set(index);
    clearInterval(this.timer);
    if (this.currentQuestion()!.answers[index].correct) {
      this.score.update(s => s + 1);
    }
  }

  next() {
    clearInterval(this.timer);
    const quiz = this.quiz()!;
    if (this.currentIndex() + 1 >= quiz.questions.length) {
      this.router.navigate(['/result'], {
        queryParams: {
          score: this.score(),
          total: quiz.questions.length,
          title: quiz.title,
        },
      });
      return;
    }
    this.currentIndex.update(i => i + 1);
    this.selectedAnswerIndex.set(null);
    this.startTimer();
  }

  private startTimer() {
    const q = this.currentQuestion();
    if (!q) return;
    this.timeLeft.set(q.timeSeconds);
    this.timer = setInterval(() => {
      if (this.timeLeft() <= 1) {
        this.next();
      } else {
        this.timeLeft.update(t => t - 1);
      }
    }, 1000);
  }
}
