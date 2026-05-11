import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { QuizService } from './quiz.service';
import { Category, Quiz } from '../models/quiz.model';

const mockCategory: Category = { id: 1, name: 'AWS', slug: 'aws' };

const mockQuiz: Quiz = {
  id: 1,
  title: 'AWS Fundamentals',
  description: 'Test your AWS knowledge.',
  timeSeconds: 300,
  randomized: false,
  category: mockCategory,
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
  ],
};

describe('QuizService', () => {
  let service: QuizService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    service = TestBed.inject(QuizService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => httpMock.verify());

  it('getCategories returns category list', () => {
    service.getCategories().subscribe(cats => {
      expect(cats.length).toBe(1);
      expect(cats[0].slug).toBe('aws');
    });
    httpMock.expectOne('/api/categories').flush([mockCategory]);
  });

  it('getByCategory returns quizzes for slug', () => {
    service.getByCategory('aws').subscribe(quizzes => {
      expect(quizzes.length).toBe(1);
      expect(quizzes[0].category.slug).toBe('aws');
    });
    httpMock.expectOne('/api/quizzes?category=aws').flush([mockQuiz]);
  });

  it('getById returns a single quiz', () => {
    service.getById(1).subscribe(quiz => {
      expect(quiz.id).toBe(1);
    });
    httpMock.expectOne('/api/quizzes/1').flush(mockQuiz);
  });
});
