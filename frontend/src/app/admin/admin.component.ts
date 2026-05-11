import { Component, OnInit, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { AccessLog, SessionLog, Settings } from '../models/quiz.model';
import { SettingsService } from '../services/settings.service';

@Component({
  selector: 'app-admin',
  imports: [FormsModule],
  templateUrl: './admin.component.html',
  styleUrl: './admin.component.css',
})
export class AdminComponent implements OnInit {
  settings = signal<Settings | null>(null);
  accessLogs = signal<AccessLog[]>([]);
  sessionLogs = signal<SessionLog[]>([]);
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
    this.settingsService.accessLogs().subscribe({ next: logs => this.accessLogs.set(logs), error: () => undefined });
    this.settingsService.sessionLogs().subscribe({ next: logs => this.sessionLogs.set(logs), error: () => undefined });
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
