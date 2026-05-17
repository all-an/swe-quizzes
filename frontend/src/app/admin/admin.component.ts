import { Component, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { AccessLog, LogPage, SessionLog, Settings } from '../models/quiz.model';
import { SettingsService } from '../services/settings.service';

const EMPTY_LOG_PAGE: LogPage<never> = { items: [], page: 0, pageSize: 10, totalPages: 0, totalElements: 0 };

@Component({
  selector: 'app-admin',
  imports: [FormsModule],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.css',
})
export class AdminComponent implements OnInit {
  settings = signal<Settings | null>(null);
  accessLogs = signal<LogPage<AccessLog>>(EMPTY_LOG_PAGE);
  sessionLogs = signal<LogPage<SessionLog>>(EMPTY_LOG_PAGE);
  accessPage = signal(0);
  sessionPage = signal(0);
  message = signal('');
  loading = signal(true);

  constructor(private settingsService: SettingsService) {}

  ngOnInit() {
    this.refresh();
  }

  refresh() {
    this.loading.set(true);
    this.settingsService.getAdminSettings().subscribe({
      next: settings => {
        this.settings.set(settings);
        this.loading.set(false);
      },
      error: () => {
        this.message.set('Unable to load admin settings.');
        this.loading.set(false);
      },
    });
    this.loadAccessLogs(this.accessPage());
    this.loadSessionLogs(this.sessionPage());
  }

  loadAccessLogs(page: number) {
    this.settingsService.accessLogs(page).subscribe({
      next: result => {
        this.accessLogs.set(result);
        this.accessPage.set(result.page);
      },
      error: () => undefined,
    });
  }

  loadSessionLogs(page: number) {
    this.settingsService.sessionLogs(page).subscribe({
      next: result => {
        this.sessionLogs.set(result);
        this.sessionPage.set(result.page);
      },
      error: () => undefined,
    });
  }

  nextAccessPage() {
    if (this.accessPage() + 1 < this.accessLogs().totalPages) {
      this.loadAccessLogs(this.accessPage() + 1);
    }
  }

  prevAccessPage() {
    if (this.accessPage() > 0) {
      this.loadAccessLogs(this.accessPage() - 1);
    }
  }

  nextSessionPage() {
    if (this.sessionPage() + 1 < this.sessionLogs().totalPages) {
      this.loadSessionLogs(this.sessionPage() + 1);
    }
  }

  prevSessionPage() {
    if (this.sessionPage() > 0) {
      this.loadSessionLogs(this.sessionPage() - 1);
    }
  }

  save() {
    const settings = this.settings();
    if (!settings) return;
    this.settingsService.update({
      disableLogin: settings.disableLogin,
      disableRegister: settings.disableRegister,
    }).subscribe({
      next: updated => {
        this.settings.set(updated);
        this.message.set('Settings saved.');
      },
      error: () => this.message.set('Unable to save settings.'),
    });
  }
}
