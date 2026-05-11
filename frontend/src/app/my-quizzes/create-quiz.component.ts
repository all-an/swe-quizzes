import { Component, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Category, CodeLanguage, CreateQuestionPayload, Question, Quiz } from '../models/quiz.model';
import { QuizService } from '../services/quiz.service';

type DraftAnswer = {
  description: string;
  codeSnippet: string;
  codeLanguage: CodeLanguage;
  correct: boolean;
};

type DraftQuestion = {
  text: string;
  codeSnippet: string;
  codeLanguage: CodeLanguage;
  timeSeconds: number;
  answers: DraftAnswer[];
};

@Component({
  selector: 'app-create-quiz',
  imports: [FormsModule],
  templateUrl: './create-quiz.component.html',
  styleUrl: './create-quiz.component.css',
})
export class CreateQuizComponent implements OnInit {
  title = '';
  description = '';
  categorySlug = '';
  newCategoryName = '';
  timeSeconds = 300;
  randomized = false;
  categories = signal<Category[]>([]);
  systemQuestions = signal<Question[]>([]);
  systemQuestionsPage = signal(0);
  readonly systemQuestionsPageSize = 10;
  selectedSystemQuestionIds = new Set<number>();
  questions: DraftQuestion[] = [this.newQuestion()];
  loading = signal(false);
  loadingQuiz = signal(false);
  message = signal('');
  messageKind = signal<'success' | 'error'>('error');
  editId = signal<number | null>(null);
  submitted = signal(false);

  constructor(
    private quizService: QuizService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const idParam = this.route.snapshot.paramMap.get('id');
    this.editId.set(idParam ? Number(idParam) : null);
    this.quizService.getCategories().subscribe({
      next: categories => {
        this.categories.set(categories);
        if (this.editId()) {
          this.loadExistingQuiz(this.editId()!);
        } else {
          this.categorySlug = categories[0]?.slug ?? '';
          this.loadSystemQuestions();
        }
      },
      error: () => this.message.set('Unable to load categories.'),
    });
  }

  loadSystemQuestions() {
    if (!this.categorySlug) return;
    this.selectedSystemQuestionIds.clear();
    this.systemQuestionsPage.set(0);
    this.quizService.getSystemQuestions(this.categorySlug).subscribe({
      next: questions => this.systemQuestions.set(questions),
      error: () => this.systemQuestions.set([]),
    });
  }

  pagedSystemQuestions(): Question[] {
    const start = this.systemQuestionsPage() * this.systemQuestionsPageSize;
    return this.systemQuestions().slice(start, start + this.systemQuestionsPageSize);
  }

  systemQuestionsTotalPages(): number {
    return Math.max(1, Math.ceil(this.systemQuestions().length / this.systemQuestionsPageSize));
  }

  nextSystemQuestionsPage() {
    if (this.systemQuestionsPage() + 1 < this.systemQuestionsTotalPages()) {
      this.systemQuestionsPage.update(page => page + 1);
    }
  }

  previousSystemQuestionsPage() {
    if (this.systemQuestionsPage() > 0) {
      this.systemQuestionsPage.update(page => page - 1);
    }
  }

  toggleSystemQuestion(id: number, checked: boolean) {
    if (checked) {
      this.selectedSystemQuestionIds.add(id);
    } else {
      this.selectedSystemQuestionIds.delete(id);
    }
  }

  createCategory() {
    const name = this.newCategoryName.trim();
    if (!name) {
      this.setError('Enter a category name before creating it.');
      return;
    }
    const slug = this.slugify(name);
    if (!slug) {
      this.setError('Use at least one letter or number in the category name.');
      return;
    }
    if (this.categories().some(category => category.slug === slug)) {
      this.categorySlug = slug;
      this.newCategoryName = '';
      this.loadSystemQuestions();
      return;
    }
    this.quizService.createCategory(name, slug).subscribe({
      next: category => {
        this.categories.update(categories => [...categories, category]);
        this.categorySlug = category.slug;
        this.newCategoryName = '';
        this.systemQuestions.set([]);
        this.selectedSystemQuestionIds.clear();
        this.setSuccess(`Category "${category.name}" created.`);
      },
      error: () => this.setError('Unable to create category. It may already exist.'),
    });
  }

  addQuestion() {
    this.questions.push(this.newQuestion());
  }

  removeQuestion(index: number) {
    this.questions.splice(index, 1);
  }

  addAnswer(question: DraftQuestion) {
    question.answers.push(this.newAnswer(false));
  }

  removeAnswer(question: DraftQuestion, index: number) {
    question.answers.splice(index, 1);
  }

  create() {
    this.submitted.set(true);
    const customQuestions = this.questions
      .filter(question => question.text.trim() || question.answers.some(answer => answer.description.trim()))
      .map(question => this.toPayload(question));
    if (!this.isFormValid()) {
      this.setError('Fill all required fields highlighted below.');
      return;
    }
    if (customQuestions.length === 0 && this.selectedSystemQuestionIds.size === 0) {
      this.setError('Add at least one custom question or choose a system question.');
      return;
    }

    this.loading.set(true);
    this.message.set('');
    const payload = {
      title: this.title,
      description: this.description,
      categorySlug: this.categorySlug,
      timeSeconds: this.timeSeconds,
      randomized: this.randomized,
      questions: customQuestions,
      systemQuestionIds: Array.from(this.selectedSystemQuestionIds),
    };
    const request = this.editId()
      ? this.quizService.update(this.editId()!, payload)
      : this.quizService.create(payload);
    request.subscribe({
      next: quiz => {
        this.loading.set(false);
        if (this.editId()) {
          this.router.navigate(['/my-quizzes']);
        } else {
          this.router.navigate(['/quiz', quiz.id]);
        }
      },
      error: () => {
        this.loading.set(false);
        this.setError(`Unable to ${this.editId() ? 'update' : 'create'} quiz. Check all required fields.`);
      },
    });
  }

  titleInvalid(): boolean {
    return this.submitted() && !this.title.trim();
  }

  descriptionInvalid(): boolean {
    return this.submitted() && !this.description.trim();
  }

  categoryInvalid(): boolean {
    return this.submitted() && !this.categorySlug;
  }

  quizTimeInvalid(): boolean {
    return this.submitted() && (!this.timeSeconds || this.timeSeconds <= 0);
  }

  questionRequired(question: DraftQuestion): boolean {
    return this.selectedSystemQuestionIds.size === 0 || this.questionHasContent(question);
  }

  questionTextInvalid(question: DraftQuestion): boolean {
    return this.submitted() && this.questionRequired(question) && !question.text.trim();
  }

  questionTimeInvalid(question: DraftQuestion): boolean {
    return this.submitted() && this.questionRequired(question) && (!question.timeSeconds || question.timeSeconds <= 0);
  }

  answerInvalid(question: DraftQuestion, answer: DraftAnswer): boolean {
    return this.submitted() && this.questionRequired(question) && !answer.description.trim();
  }

  correctAnswerInvalid(question: DraftQuestion): boolean {
    return this.submitted() && this.questionRequired(question) && !question.answers.some(answer => answer.correct);
  }

  private loadExistingQuiz(id: number) {
    this.loadingQuiz.set(true);
    this.quizService.getById(id).subscribe({
      next: quiz => {
        this.populate(quiz);
        this.loadingQuiz.set(false);
        this.loadSystemQuestions();
      },
      error: () => {
        this.setError('Unable to load quiz for editing.');
        this.loadingQuiz.set(false);
      },
    });
  }

  private setSuccess(message: string) {
    this.messageKind.set('success');
    this.message.set(message);
  }

  private setError(message: string) {
    this.messageKind.set('error');
    this.message.set(message);
  }

  private populate(quiz: Quiz) {
    this.title = quiz.title;
    this.description = quiz.description;
    this.categorySlug = quiz.category.slug;
    this.timeSeconds = quiz.timeSeconds;
    this.randomized = quiz.randomized;
    this.selectedSystemQuestionIds.clear();
    this.questions = quiz.questions.map(question => ({
      text: question.text,
      codeSnippet: question.codeSnippet ?? '',
      codeLanguage: this.languageOrDefault(question.codeLanguage),
      timeSeconds: question.timeSeconds,
      answers: question.answers.map(answer => ({
        description: answer.description,
        codeSnippet: answer.codeSnippet ?? '',
        codeLanguage: this.languageOrDefault(answer.codeLanguage),
        correct: answer.correct,
      })),
    }));
    if (this.questions.length === 0) {
      this.questions = [this.newQuestion()];
    }
  }

  private newQuestion(): DraftQuestion {
    return {
      text: '',
      codeSnippet: '',
      codeLanguage: 'java',
      timeSeconds: 30,
      answers: [this.newAnswer(true), this.newAnswer(false)],
    };
  }

  private newAnswer(correct: boolean): DraftAnswer {
    return {
      description: '',
      codeSnippet: '',
      codeLanguage: 'java',
      correct,
    };
  }

  private toPayload(question: DraftQuestion): CreateQuestionPayload {
    return {
      text: question.text,
      codeSnippet: question.codeSnippet.trim() || null,
      codeLanguage: question.codeSnippet.trim() ? question.codeLanguage : null,
      timeSeconds: question.timeSeconds,
      answers: question.answers.map(answer => ({
        description: answer.description,
        codeSnippet: answer.codeSnippet.trim() || null,
        codeLanguage: answer.codeSnippet.trim() ? answer.codeLanguage : null,
        correct: answer.correct,
      })),
    };
  }

  private languageOrDefault(language: string | null | undefined): CodeLanguage {
    return language === 'typescript' ? 'typescript' : 'java';
  }

  private slugify(value: string): string {
    return value
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  private isFormValid(): boolean {
    if (!this.title.trim() || !this.description.trim() || !this.categorySlug || !this.timeSeconds || this.timeSeconds <= 0) {
      return false;
    }

    const customQuestions = this.questions.filter(question => this.questionHasContent(question));
    if (customQuestions.length === 0 && this.selectedSystemQuestionIds.size === 0) {
      return false;
    }

    const questionsToValidate = customQuestions.length > 0 ? customQuestions : this.questions.slice(0, 1);
    return questionsToValidate.every(question =>
      question.text.trim()
      && question.timeSeconds > 0
      && question.answers.length > 0
      && question.answers.every(answer => answer.description.trim())
      && question.answers.some(answer => answer.correct)
    );
  }

  private questionHasContent(question: DraftQuestion): boolean {
    return !!(
      question.text.trim()
      || question.codeSnippet.trim()
      || question.answers.some(answer => answer.description.trim() || answer.codeSnippet.trim())
    );
  }
}
