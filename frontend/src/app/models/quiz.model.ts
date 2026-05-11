export interface Category {
  id: number;
  name: string;
  slug: string;
}

export interface Answer {
  id: number;
  description: string;
  codeSnippet?: string | null;
  codeLanguage?: CodeLanguage | null;
  correct: boolean;
}

export interface Question {
  id: number;
  text: string;
  codeSnippet?: string | null;
  codeLanguage?: CodeLanguage | null;
  timeSeconds: number;
  answers: Answer[];
}

export interface Quiz {
  id: number;
  title: string;
  description: string;
  category: Category;
  timeSeconds: number;
  randomized: boolean;
  questions: Question[];
}

export type CodeLanguage = 'java' | 'typescript';
export type AccountRole = 'USER' | 'ADMIN';

export interface Account {
  id: number;
  name: string;
  email: string;
  role: AccountRole;
  createdAt: string;
}

export interface AuthResponse {
  token: string;
  account: Account;
}

export interface Settings {
  id: number;
  disableLogin: boolean;
  disableRegister: boolean;
  updatedAt: string;
}

export interface AccessLog {
  id: number;
  sessionKey?: string | null;
  ipAddress: string;
  country: string;
  userAgent?: string | null;
  createdAt: string;
}

export interface SessionLog {
  id: number;
  account?: Account | null;
  eventType: string;
  ipAddress: string;
  country: string;
  userAgent?: string | null;
  createdAt: string;
}

export interface CreateAnswerPayload {
  description: string;
  codeSnippet?: string | null;
  codeLanguage?: CodeLanguage | null;
  correct: boolean;
}

export interface CreateQuestionPayload {
  text: string;
  codeSnippet?: string | null;
  codeLanguage?: CodeLanguage | null;
  timeSeconds: number;
  answers: CreateAnswerPayload[];
}

export interface CreateQuizPayload {
  title: string;
  description: string;
  categorySlug: string;
  timeSeconds: number;
  randomized: boolean;
  questions: CreateQuestionPayload[];
  systemQuestionIds: number[];
}
