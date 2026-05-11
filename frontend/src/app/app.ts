import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterOutlet } from '@angular/router';
import { AuthService } from './services/auth.service';
import { SettingsService } from './services/settings.service';

@Component({
  selector: 'app-root',
  imports: [RouterLink, RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  constructor(
    public auth: AuthService,
    private router: Router,
    private settingsService: SettingsService
  ) {}

  ngOnInit() {
    this.settingsService.loadPublic().subscribe({ error: () => undefined });
    this.settingsService.logFirstAccess();
  }

  login() {
    this.router.navigate(['/login']);
  }

  logout() {
    this.auth.logout();
    this.router.navigate(['/']);
  }
}
