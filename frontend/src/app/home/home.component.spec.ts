import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { of, throwError } from 'rxjs';
import { vi } from 'vitest';
import { HomeComponent } from './home.component';
import { QuizService } from '../services/quiz.service';
import { Category } from '../models/quiz.model';

const mockCategories: Category[] = [
  { id: 1, name: 'AWS',     slug: 'aws' },
  { id: 2, name: 'Java',    slug: 'java' },
  { id: 3, name: 'Angular', slug: 'angular' },
];

describe('HomeComponent', () => {
  let fixture: ComponentFixture<HomeComponent>;
  let component: HomeComponent;
  const quizServiceSpy = { getCategories: vi.fn() };

  beforeEach(async () => {
    quizServiceSpy.getCategories = vi.fn();

    await TestBed.configureTestingModule({
      imports: [HomeComponent],
      providers: [
        provideRouter([]),
        { provide: QuizService, useValue: quizServiceSpy },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
  });

  it('shows categories after load', () => {
    quizServiceSpy.getCategories.mockReturnValue(of(mockCategories));
    fixture.detectChanges();
    expect(component.categories().length).toBe(3);
    expect(component.loading()).toBe(false);
  });

  it('shows error when service fails', () => {
    quizServiceSpy.getCategories.mockReturnValue(throwError(() => new Error('fail')));
    fixture.detectChanges();
    expect(component.error()).toBeTruthy();
    expect(component.loading()).toBe(false);
  });
});
