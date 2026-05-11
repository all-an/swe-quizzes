import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { of, throwError } from 'rxjs';
import { vi } from 'vitest';
import { CategoryPageComponent } from './category-page.component';
import { QuizService } from '../services/quiz.service';
import { Quiz } from '../models/quiz.model';

const mockQuizzes: Quiz[] = [
  {
    id: 1,
    title: 'AWS Fundamentals',
    description: 'AWS basics',
    timeSeconds: 300,
    randomized: false,
    category: { id: 1, name: 'AWS', slug: 'aws' },
    questions: [],
  },
];

describe('CategoryPageComponent', () => {
  let fixture: ComponentFixture<CategoryPageComponent>;
  let component: CategoryPageComponent;
  const quizServiceSpy = { getByCategory: vi.fn() };

  beforeEach(async () => {
    quizServiceSpy.getByCategory = vi.fn();

    await TestBed.configureTestingModule({
      imports: [CategoryPageComponent],
      providers: [
        provideRouter([]),
        { provide: QuizService, useValue: quizServiceSpy },
        { provide: ActivatedRoute, useValue: { snapshot: { paramMap: { get: () => 'aws' } } } },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(CategoryPageComponent);
    component = fixture.componentInstance;
  });

  it('loads quizzes for the category', () => {
    quizServiceSpy.getByCategory.mockReturnValue(of(mockQuizzes));
    fixture.detectChanges();
    expect(component.quizzes().length).toBe(1);
    expect(component.slug()).toBe('aws');
    expect(component.loading()).toBe(false);
  });

  it('shows error when service fails', () => {
    quizServiceSpy.getByCategory.mockReturnValue(throwError(() => new Error('fail')));
    fixture.detectChanges();
    expect(component.error()).toBeTruthy();
    expect(component.loading()).toBe(false);
  });

  it('shows empty state when no quizzes', () => {
    quizServiceSpy.getByCategory.mockReturnValue(of([]));
    fixture.detectChanges();
    expect(component.quizzes().length).toBe(0);
  });
});
