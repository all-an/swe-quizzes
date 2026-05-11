import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter, Router } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { of, throwError } from 'rxjs';
import { vi } from 'vitest';
import { QuizComponent } from './quiz.component';
import { QuizService } from '../services/quiz.service';
import { Quiz } from '../models/quiz.model';

const mockQuiz: Quiz = {
  id: 1,
  title: 'AWS Fundamentals',
  description: 'AWS basics',
  timeSeconds: 300,
  category: { id: 1, name: 'AWS', slug: 'aws' },
  questions: [
    {
      id: 1,
      text: 'What does S3 stand for?',
      timeSeconds: 30,
      answers: [
        { id: 1, description: 'Simple Storage Service', correct: true },
        { id: 2, description: 'Super Secure Storage', correct: false },
      ],
    },
    {
      id: 2,
      text: 'Serverless compute on AWS?',
      timeSeconds: 30,
      answers: [
        { id: 3, description: 'Lambda', correct: true },
        { id: 4, description: 'EC2', correct: false },
      ],
    },
  ],
};

describe('QuizComponent', () => {
  let fixture: ComponentFixture<QuizComponent>;
  let component: QuizComponent;
  const quizServiceSpy = { getById: vi.fn() };

  beforeEach(async () => {
    quizServiceSpy.getById = vi.fn().mockReturnValue(of(mockQuiz));

    await TestBed.configureTestingModule({
      imports: [QuizComponent],
      providers: [
        provideRouter([]),
        { provide: QuizService, useValue: quizServiceSpy },
        { provide: ActivatedRoute, useValue: { snapshot: { paramMap: { get: () => '1' } } } },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(QuizComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  afterEach(() => component.ngOnDestroy());

  it('loads quiz on init', () => {
    expect(component.quiz()?.title).toBe('AWS Fundamentals');
    expect(component.currentIndex()).toBe(0);
  });

  it('selecting correct answer increments score', () => {
    component.selectAnswer(0);
    expect(component.score()).toBe(1);
    expect(component.selectedAnswerIndex()).toBe(0);
  });

  it('selecting wrong answer does not increment score', () => {
    component.selectAnswer(1);
    expect(component.score()).toBe(0);
  });

  it('ignores second selection after answer is chosen', () => {
    component.selectAnswer(0);
    component.selectAnswer(1);
    expect(component.selectedAnswerIndex()).toBe(0);
  });

  it('next advances to the next question', () => {
    component.selectAnswer(0);
    component.next();
    expect(component.currentIndex()).toBe(1);
    expect(component.selectedAnswerIndex()).toBeNull();
  });

  it('redirects to home on error', async () => {
    quizServiceSpy.getById.mockReturnValue(throwError(() => new Error('fail')));
    const router = TestBed.inject(Router);
    const navigateSpy = vi.spyOn(router, 'navigate');
    component.ngOnInit();
    expect(navigateSpy).toHaveBeenCalledWith(['/']);
  });
});
