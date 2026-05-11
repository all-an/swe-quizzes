-- Expand Java and Angular starter quizzes with focused async questions.
UPDATE quiz SET time_seconds = 360 WHERE id IN (2, 3);

-- Java Core: CompletableFuture and async programming
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What is the primary purpose of Java CompletableFuture?', 30, 2),
    ('Which CompletableFuture method runs a task asynchronously and returns no result?', 30, 2),
    ('Which CompletableFuture method transforms the result of a completed stage?', 30, 2),
    ('Which CompletableFuture method is used to flatten a nested asynchronous computation?', 30, 2),
    ('What does CompletableFuture.allOf(...) return?', 30, 2),
    ('Which method should be used to handle both a successful result and an exception from a CompletableFuture?', 30, 2),
    ('What is the difference between join() and get() on CompletableFuture?', 30, 2),
    ('Which executor is used by CompletableFuture async methods when no executor is supplied?', 30, 2),
    ('Which method completes a CompletableFuture with a fallback value when an exception occurs?', 30, 2),
    ('What does thenCombine(...) do in CompletableFuture?', 30, 2);

-- Angular Basics: RxJS Observable patterns
INSERT INTO question (text, time_seconds, quiz_id) VALUES
    ('What does an RxJS Observable represent in Angular?', 30, 3),
    ('What must happen for a cold Observable to start producing values?', 30, 3),
    ('Which Angular service commonly returns Observables for HTTP requests?', 30, 3),
    ('Which RxJS operator transforms each emitted value into a new value?', 30, 3),
    ('Which RxJS operator cancels the previous inner Observable when a new value arrives?', 30, 3),
    ('What is the main benefit of using the async pipe in Angular templates?', 30, 3),
    ('Which RxJS subject stores the latest value and emits it immediately to new subscribers?', 30, 3),
    ('Which operator is commonly used to stop an Observable subscription when a component is destroyed?', 30, 3),
    ('What does catchError(...) allow you to do in an Observable pipeline?', 30, 3),
    ('Which RxJS creation function combines multiple Observables and emits after all complete?', 30, 3);

INSERT INTO answer (description, correct, question_id)
SELECT v.description, v.correct, q.id
FROM (VALUES
    ('Represent a value that may be completed manually or by an asynchronous computation', TRUE,  'What is the primary purpose of Java CompletableFuture?'),
    ('Define a checked exception type for threads', FALSE, 'What is the primary purpose of Java CompletableFuture?'),
    ('Create immutable collections with futures inside them', FALSE, 'What is the primary purpose of Java CompletableFuture?'),
    ('Replace Java streams for synchronous collection processing', FALSE, 'What is the primary purpose of Java CompletableFuture?'),

    ('runAsync(...)', TRUE,  'Which CompletableFuture method runs a task asynchronously and returns no result?'),
    ('supplyAsync(...)', FALSE, 'Which CompletableFuture method runs a task asynchronously and returns no result?'),
    ('thenApply(...)', FALSE, 'Which CompletableFuture method runs a task asynchronously and returns no result?'),
    ('completedFuture(...)', FALSE, 'Which CompletableFuture method runs a task asynchronously and returns no result?'),

    ('thenApply(...)', TRUE,  'Which CompletableFuture method transforms the result of a completed stage?'),
    ('thenAccept(...)', FALSE, 'Which CompletableFuture method transforms the result of a completed stage?'),
    ('thenRun(...)', FALSE, 'Which CompletableFuture method transforms the result of a completed stage?'),
    ('allOf(...)', FALSE, 'Which CompletableFuture method transforms the result of a completed stage?'),

    ('thenCompose(...)', TRUE,  'Which CompletableFuture method is used to flatten a nested asynchronous computation?'),
    ('thenApply(...)', FALSE, 'Which CompletableFuture method is used to flatten a nested asynchronous computation?'),
    ('thenAcceptBoth(...)', FALSE, 'Which CompletableFuture method is used to flatten a nested asynchronous computation?'),
    ('completeAsync(...)', FALSE, 'Which CompletableFuture method is used to flatten a nested asynchronous computation?'),

    ('A CompletableFuture<Void> that completes when all supplied futures complete', TRUE,  'What does CompletableFuture.allOf(...) return?'),
    ('A List containing each supplied future result', FALSE, 'What does CompletableFuture.allOf(...) return?'),
    ('The first completed future result', FALSE, 'What does CompletableFuture.allOf(...) return?'),
    ('A Stream of completed results', FALSE, 'What does CompletableFuture.allOf(...) return?'),

    ('handle(...)', TRUE,  'Which method should be used to handle both a successful result and an exception from a CompletableFuture?'),
    ('thenAccept(...)', FALSE, 'Which method should be used to handle both a successful result and an exception from a CompletableFuture?'),
    ('thenRun(...)', FALSE, 'Which method should be used to handle both a successful result and an exception from a CompletableFuture?'),
    ('cancel(...)', FALSE, 'Which method should be used to handle both a successful result and an exception from a CompletableFuture?'),

    ('join() throws unchecked CompletionException, while get() throws checked exceptions', TRUE,  'What is the difference between join() and get() on CompletableFuture?'),
    ('join() is non-blocking, while get() always blocks forever', FALSE, 'What is the difference between join() and get() on CompletableFuture?'),
    ('join() cancels the future, while get() completes it', FALSE, 'What is the difference between join() and get() on CompletableFuture?'),
    ('join() is only available for completedFuture(...), while get() works for all futures', FALSE, 'What is the difference between join() and get() on CompletableFuture?'),

    ('ForkJoinPool.commonPool()', TRUE,  'Which executor is used by CompletableFuture async methods when no executor is supplied?'),
    ('A new Thread for every task', FALSE, 'Which executor is used by CompletableFuture async methods when no executor is supplied?'),
    ('The current servlet request thread', FALSE, 'Which executor is used by CompletableFuture async methods when no executor is supplied?'),
    ('Executors.newSingleThreadExecutor()', FALSE, 'Which executor is used by CompletableFuture async methods when no executor is supplied?'),

    ('exceptionally(...)', TRUE,  'Which method completes a CompletableFuture with a fallback value when an exception occurs?'),
    ('thenRun(...)', FALSE, 'Which method completes a CompletableFuture with a fallback value when an exception occurs?'),
    ('orTimeout(...)', FALSE, 'Which method completes a CompletableFuture with a fallback value when an exception occurs?'),
    ('completeOnTimeout(...)', FALSE, 'Which method completes a CompletableFuture with a fallback value when an exception occurs?'),

    ('Combines results from two independent completion stages', TRUE,  'What does thenCombine(...) do in CompletableFuture?'),
    ('Retries a failed completion stage until it succeeds', FALSE, 'What does thenCombine(...) do in CompletableFuture?'),
    ('Converts a future into a blocking queue', FALSE, 'What does thenCombine(...) do in CompletableFuture?'),
    ('Runs a callback only when both stages fail', FALSE, 'What does thenCombine(...) do in CompletableFuture?'),

    ('A stream of values over time that can emit zero or more values', TRUE,  'What does an RxJS Observable represent in Angular?'),
    ('A synchronous-only variable stored in component state', FALSE, 'What does an RxJS Observable represent in Angular?'),
    ('A dependency injection token', FALSE, 'What does an RxJS Observable represent in Angular?'),
    ('A compiled Angular template', FALSE, 'What does an RxJS Observable represent in Angular?'),

    ('It must be subscribed to', TRUE,  'What must happen for a cold Observable to start producing values?'),
    ('It must be declared in providers', FALSE, 'What must happen for a cold Observable to start producing values?'),
    ('It must be converted to a Signal first', FALSE, 'What must happen for a cold Observable to start producing values?'),
    ('It must be added to app.routes.ts', FALSE, 'What must happen for a cold Observable to start producing values?'),

    ('HttpClient', TRUE,  'Which Angular service commonly returns Observables for HTTP requests?'),
    ('RouterOutlet', FALSE, 'Which Angular service commonly returns Observables for HTTP requests?'),
    ('FormBuilder', FALSE, 'Which Angular service commonly returns Observables for HTTP requests?'),
    ('Renderer2', FALSE, 'Which Angular service commonly returns Observables for HTTP requests?'),

    ('map', TRUE,  'Which RxJS operator transforms each emitted value into a new value?'),
    ('tap', FALSE, 'Which RxJS operator transforms each emitted value into a new value?'),
    ('catchError', FALSE, 'Which RxJS operator transforms each emitted value into a new value?'),
    ('debounceTime', FALSE, 'Which RxJS operator transforms each emitted value into a new value?'),

    ('switchMap', TRUE,  'Which RxJS operator cancels the previous inner Observable when a new value arrives?'),
    ('mergeMap', FALSE, 'Which RxJS operator cancels the previous inner Observable when a new value arrives?'),
    ('concatMap', FALSE, 'Which RxJS operator cancels the previous inner Observable when a new value arrives?'),
    ('exhaustMap', FALSE, 'Which RxJS operator cancels the previous inner Observable when a new value arrives?'),

    ('It subscribes and unsubscribes automatically for the template binding', TRUE,  'What is the main benefit of using the async pipe in Angular templates?'),
    ('It converts every Observable into a Promise permanently', FALSE, 'What is the main benefit of using the async pipe in Angular templates?'),
    ('It makes HTTP requests synchronous', FALSE, 'What is the main benefit of using the async pipe in Angular templates?'),
    ('It disables change detection for that component', FALSE, 'What is the main benefit of using the async pipe in Angular templates?'),

    ('BehaviorSubject', TRUE,  'Which RxJS subject stores the latest value and emits it immediately to new subscribers?'),
    ('Subject', FALSE, 'Which RxJS subject stores the latest value and emits it immediately to new subscribers?'),
    ('ReplaySubject without a buffer', FALSE, 'Which RxJS subject stores the latest value and emits it immediately to new subscribers?'),
    ('AsyncSubject before completion', FALSE, 'Which RxJS subject stores the latest value and emits it immediately to new subscribers?'),

    ('takeUntil(...)', TRUE,  'Which operator is commonly used to stop an Observable subscription when a component is destroyed?'),
    ('shareReplay(...)', FALSE, 'Which operator is commonly used to stop an Observable subscription when a component is destroyed?'),
    ('scan(...)', FALSE, 'Which operator is commonly used to stop an Observable subscription when a component is destroyed?'),
    ('distinctUntilChanged(...)', FALSE, 'Which operator is commonly used to stop an Observable subscription when a component is destroyed?'),

    ('Recover from or replace an error with another Observable', TRUE,  'What does catchError(...) allow you to do in an Observable pipeline?'),
    ('Prevent subscribers from ever receiving values', FALSE, 'What does catchError(...) allow you to do in an Observable pipeline?'),
    ('Convert every emitted value into JSON', FALSE, 'What does catchError(...) allow you to do in an Observable pipeline?'),
    ('Run cleanup logic after unsubscription only', FALSE, 'What does catchError(...) allow you to do in an Observable pipeline?'),

    ('forkJoin', TRUE,  'Which RxJS creation function combines multiple Observables and emits after all complete?'),
    ('combineLatest', FALSE, 'Which RxJS creation function combines multiple Observables and emits after all complete?'),
    ('race', FALSE, 'Which RxJS creation function combines multiple Observables and emits after all complete?'),
    ('interval', FALSE, 'Which RxJS creation function combines multiple Observables and emits after all complete?')
) AS v(description, correct, question_text)
JOIN question q ON q.text = v.question_text;
