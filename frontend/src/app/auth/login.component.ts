import { Component, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { SettingsService } from '../services/settings.service';

@Component({
  selector: 'app-login',
  imports: [FormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrl: './auth.component.css',
})
export class LoginComponent implements OnInit {
  email = '';
  password = '';
  loading = signal(false);
  message = signal('');

  constructor(
    public settingsService: SettingsService,
    private auth: AuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.settingsService.loadPublic().subscribe({ error: () => undefined });
  }

  login() {
    this.loading.set(true);
    this.message.set('');
    this.auth.login(this.email, this.password).subscribe({
      next: response => {
        this.loading.set(false);
        this.router.navigate([response.account.role === 'ADMIN' ? '/admin' : '/my-quizzes']);
      },
      error: error => {
        this.loading.set(false);
        if (error.status === 403 && this.settingsService.settings()?.disableLogin) {
          this.message.set('Only admin login is available right now.');
        } else {
          this.message.set('Invalid email or password.');
        }
      },
    });
  }
}
