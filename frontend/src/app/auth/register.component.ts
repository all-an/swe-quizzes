import { Component, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { SettingsService } from '../services/settings.service';

@Component({
  selector: 'app-register',
  imports: [FormsModule, RouterLink],
  templateUrl: './register.component.html',
  styleUrl: './auth.component.css',
})
export class RegisterComponent implements OnInit {
  name = '';
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

  register() {
    if (this.settingsService.settings()?.disableRegister) {
      this.message.set('New registrations are disabled right now.');
      return;
    }
    this.loading.set(true);
    this.message.set('');
    this.auth.register(this.name, this.email, this.password).subscribe({
      next: response => {
        this.loading.set(false);
        this.router.navigate([response.account.role === 'ADMIN' ? '/admin' : '/my-quizzes']);
      },
      error: error => {
        this.loading.set(false);
        this.message.set(error.status === 403 ? 'New registrations are disabled right now.' : 'Unable to create account.');
      },
    });
  }
}
