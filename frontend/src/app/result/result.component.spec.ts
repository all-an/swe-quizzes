import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { ResultComponent } from './result.component';

function makeRoute(score: string, total: string, title: string) {
  return {
    snapshot: {
      queryParamMap: {
        get: (key: string) => ({ score, total, title }[key] ?? null),
      },
    },
  };
}

describe('ResultComponent', () => {
  let fixture: ComponentFixture<ResultComponent>;
  let component: ResultComponent;

  async function setup(score: string, total: string, title = 'AWS Fundamentals') {
    await TestBed.configureTestingModule({
      imports: [ResultComponent],
      providers: [
        provideRouter([]),
        { provide: ActivatedRoute, useValue: makeRoute(score, total, title) },
      ],
    }).compileComponents();
    fixture = TestBed.createComponent(ResultComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }

  it('reads score from query params', async () => {
    await setup('3', '5');
    expect(component.score()).toBe(3);
    expect(component.total()).toBe(5);
    expect(component.title()).toBe('AWS Fundamentals');
  });

  it('computes percentage correctly', async () => {
    await setup('4', '5');
    expect(component.percentage()).toBe(80);
  });

  it('shows 100% for perfect score', async () => {
    await setup('5', '5');
    expect(component.percentage()).toBe(100);
  });
});
