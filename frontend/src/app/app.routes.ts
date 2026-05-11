import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { CategoryPageComponent } from './category-page/category-page.component';
import { QuizComponent } from './quiz/quiz.component';
import { ResultComponent } from './result/result.component';
import { LoginComponent } from './auth/login.component';
import { RegisterComponent } from './auth/register.component';
import { MyQuizzesComponent } from './my-quizzes/my-quizzes.component';
import { CreateQuizComponent } from './my-quizzes/create-quiz.component';
import { AdminComponent } from './admin/admin.component';
import { adminGuard, authGuard } from './auth/auth.guard';

export const routes: Routes = [
  { path: '',                  component: HomeComponent },
  { path: 'login',             component: LoginComponent },
  { path: 'register',          component: RegisterComponent },
  { path: 'my-quizzes',        component: MyQuizzesComponent, canActivate: [authGuard] },
  { path: 'my-quizzes/new',    component: CreateQuizComponent, canActivate: [authGuard] },
  { path: 'my-quizzes/:id/edit', component: CreateQuizComponent, canActivate: [authGuard] },
  { path: 'admin',             component: AdminComponent, canActivate: [adminGuard] },
  { path: 'category/:slug',    component: CategoryPageComponent },
  { path: 'quiz/:id',          component: QuizComponent },
  { path: 'result',            component: ResultComponent },
  { path: '**',                redirectTo: '' },
];
