import { Component, OnInit, signal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-result',
  templateUrl: './result.component.html',
  styleUrl: './result.component.css',
})
export class ResultComponent implements OnInit {
  score = signal(0);
  total = signal(0);
  title = signal('');

  percentage = () => Math.round((this.score() / this.total()) * 100);

  constructor(private route: ActivatedRoute, private router: Router) {}

  ngOnInit() {
    const p = this.route.snapshot.queryParamMap;
    this.score.set(Number(p.get('score') ?? 0));
    this.total.set(Number(p.get('total') ?? 0));
    this.title.set(p.get('title') ?? 'Quiz');
  }

  goHome() {
    this.router.navigate(['/']);
  }
}
