# My Quizzes Feature Plan

## Todo Plan

1. Define Account model and ownership rules
   - Create `Account` entity with fields like `id`, `name`, `email`, `passwordHash`, `role`, `createdAt`.
   - Decide whether email must be unique. Recommended: yes.
   - Add roles:
     - `USER` for normal accounts.
     - `ADMIN` for administration features.
   - Seed or bootstrap one admin account through a safe mechanism, such as environment variables or a one-time migration with a generated temporary password.
   - Add relationship: `Account -> Quiz` as owner.
   - Keep existing seeded/system quizzes public and ownerless.
   - Users without an account must still be able to browse and take all existing public system quizzes.

2. Add authentication backend
   - Add register endpoint: `POST /api/accounts/register`.
   - Add login endpoint: `POST /api/auth/login`.
   - Add logout behavior on frontend by clearing token/session.
   - Use password hashing, not plain text passwords.
   - Do not require authentication for public system quiz browsing or quiz-taking endpoints.
   - Require admin role for admin-only endpoints.
   - When login is disabled for non-admin users, allow only admin accounts to log in.
   - When registration is disabled, block new account registration.
   - Choose auth style:
     - JWT token auth is probably simplest for this app.
     - Session/cookie auth is also valid but needs more backend/frontend coordination.

3. Update database schema
   - Add Flyway migration for `account`.
   - Add `role` to `account`.
   - Add nullable `account_id` or `owner_id` to `quiz`.
   - Possibly add `is_system` boolean to `quiz` or infer system quizzes by `account_id IS NULL`.
   - Public system quizzes remain represented by `account_id IS NULL` unless an explicit `is_system` flag is added.
   - Add `settings` table with at least:
     - `id`
     - `disable_login BOOLEAN NOT NULL DEFAULT FALSE`
     - `disable_register BOOLEAN NOT NULL DEFAULT FALSE`
     - `updated_at`
   - Seed a single settings row with `disable_login = FALSE` and `disable_register = FALSE`.
   - Add `access_log` table to track first page access:
     - `id`
     - `session_key` or visitor key
     - `ip_address`
     - `country`
     - `user_agent`
     - `created_at`
   - Add `session_log` table to track login and register sessions:
     - `id`
     - `account_id`, nullable for failed login/register attempts
     - `event_type`, for example `LOGIN`, `REGISTER`, `LOGIN_BLOCKED`, `REGISTER_BLOCKED`
     - `ip_address`
     - `country`
     - `user_agent`
     - `created_at`
   - Ensure existing seed quizzes continue working.

4. Add settings and admin backend
   - Add `Settings` entity and repository.
   - Add endpoint for reading public auth settings:
     - `GET /api/settings/public`
   - Add admin-only endpoint for reading full settings:
     - `GET /api/admin/settings`
   - Add admin-only endpoint for updating settings:
     - `PUT /api/admin/settings`
   - Admin can toggle:
     - login disabled for non-admin users.
     - registration disabled for all new users.
   - Add admin-only endpoint to view recent access logs:
     - `GET /api/admin/access-logs`
   - Add admin-only endpoint to view recent session logs:
     - `GET /api/admin/session-logs`

5. Add access and session logging backend
   - Track first access to the single-page app only once per browser/session.
   - Add endpoint:
     - `POST /api/access-log`
   - Frontend calls this once when the app first loads.
   - Store IP address from request headers/server request.
   - Store country using a simple lookup strategy:
     - Prefer trusted proxy headers if deployed behind a provider that sends country.
     - Otherwise store `UNKNOWN` until a GeoIP provider is added.
   - Record session logs for:
     - successful login.
     - failed login.
     - blocked non-admin login when `disable_login = TRUE`.
     - successful register.
     - failed register.
     - blocked register when `disable_register = TRUE`.

6. Update Quiz model
   - Add owner relationship to `Quiz`.
   - Add fields needed for user-created quizzes:
     - `title`
     - `description`
     - `category`
     - `timeSeconds`
     - `questions`
     - `answers`
   - Add optional code snippet fields where needed:
     - question-level `codeSnippet`
     - question-level `codeLanguage`, limited to values like `java` or `typescript`
     - answer-level `codeSnippet`
     - answer-level `codeLanguage`, limited to values like `java` or `typescript`
   - Render code snippets on screen as fenced code blocks, for example:

     ````markdown
     ```java
     code here
     ```
     ````
   - Decide if custom quizzes must belong to existing categories or can create custom categories.

7. Create quiz creation API
   - Add endpoint: `POST /api/quizzes`.
   - Require logged-in account.
   - Accept quiz details, questions, answers, correct answers, optional code snippets, code language, and time settings.
   - Validate:
     - quiz title is required.
     - at least one question.
     - each question has answers.
     - each question has at least one correct answer.
     - time is positive.
     - code language is valid when a code snippet is present.

8. Add My Quizzes API
   - Add endpoint: `GET /api/quizzes/my`.
   - Return only quizzes owned by the logged-in account.
   - Add endpoint for viewing one owned quiz if needed: `GET /api/quizzes/my/{id}`.
   - Add edit/delete later if desired, but not required for the first version.
   - Keep existing public endpoints unauthenticated:
     - `GET /api/categories`
     - `GET /api/quizzes`
     - `GET /api/quizzes?category={slug}`
     - `GET /api/quizzes/{id}` for system public quizzes.

9. Support choosing system questions
   - Add backend endpoint to list reusable system questions, probably filtered by category:
     - `GET /api/questions/system?category=java`
   - Or reuse existing quiz data and let frontend select questions from public quizzes.
   - When creating a custom quiz, copy selected system questions into the user quiz instead of linking directly, so the custom quiz is stable.

10. Frontend auth flow
   - Add register page.
   - Add login page or modal.
   - Store auth token in a frontend auth service.
   - Update API service to attach token to authenticated requests.
   - On app startup, fetch public settings so the UI knows if login or registration is disabled.
   - If login is disabled:
     - Login click should show a message that only admin login is available.
     - Admin login should still be possible.
     - Non-admin login attempts should be rejected by the backend.
   - If registration is disabled:
     - Register page should show that new registrations are disabled.
     - Backend must still enforce this even if the UI is bypassed.
   - Change button behavior:
     - logged out: show `Login`.
     - logged in: show `My Quizzes` and `Logout` in the top-right area.
     - logged in as admin: also show `Admin`.

11. Frontend admin page
   - Route: `/admin`.
   - Guard route so only admin accounts can access it.
   - Add settings controls:
     - toggle `disable_login`.
     - toggle `disable_register`.
   - Show the current effect of each setting in plain UI text.
   - Add simple views for:
     - recent access logs.
     - recent session logs.

12. Frontend access logging
   - On first application load, call `POST /api/access-log`.
   - Only call this once per browser session, using session storage or a similar browser-side marker.
   - Do not call it for every internal route change.
   - Backend should still tolerate duplicate calls safely.

13. Frontend My Quizzes page
   - Route: `/my-quizzes`.
   - Show quizzes created by the logged-in user.
   - Add button: `Create Quiz`.
   - Handle empty state.

14. Frontend Create Quiz flow
    - Route: `/my-quizzes/new`.
    - Form fields:
      - title
      - description
      - category
      - quiz time
    - Question creation options:
      - choose from system questions
      - create custom questions
    - For each custom question:
      - question text
      - optional code snippet input
      - code language selector: Java or TypeScript
      - time seconds
      - answers
      - correct answer selection
    - For each answer:
      - answer text
      - optional code snippet input
      - code language selector: Java or TypeScript
    - Submit to `POST /api/quizzes`.

15. Frontend code rendering
    - Render question and answer code snippets in a dedicated code block area.
    - Preserve formatting and indentation.
    - Use the selected language to render fenced code blocks like:

      ````markdown
      ```typescript
      code here
      ```
      ````
    - Avoid mixing code into the normal question or answer text field.

16. Frontend guards and state
    - Protect `/my-quizzes` and `/my-quizzes/new` so logged-out users are redirected to login.
    - Protect `/admin` so non-admin users are redirected away.
    - Do not protect the home page, category pages, public quiz-taking pages, or result page.
    - Logged-out users can still access and complete existing public system quizzes.
    - Ensure navbar reacts immediately after login/logout.
    - Keep quiz-taking flow compatible with both system and user-created quizzes.

17. Backend tests
    - Test account creation.
    - Test duplicate email rejection.
    - Test registration is blocked when `disable_register = TRUE`.
    - Test login success/failure.
    - Test non-admin login is blocked when `disable_login = TRUE`.
    - Test admin login still works when `disable_login = TRUE`.
    - Test admin-only settings endpoints reject normal users.
    - Test admin can toggle login and registration settings.
    - Test access log creation stores IP and country.
    - Test session log creation for login/register success, failure, and blocked events.
    - Test creating a quiz requires authentication.
    - Test user can list only their own quizzes.
    - Test creating questions and answers with Java and TypeScript code snippets.
    - Test unauthenticated users can list and take public system quizzes.
    - Test existing public quiz endpoints still work.

18. Frontend tests
    - Test navbar shows `Login` when logged out.
    - Test navbar shows `My Quizzes` and `Logout` when logged in.
    - Test navbar shows `Admin` when logged in as admin.
    - Test login click shows admin-only message when login is disabled.
    - Test register page shows disabled message when registration is disabled.
    - Test admin page toggles login/register settings.
    - Test access log request is sent once on first app load.
    - Test logged-out users can browse categories, open public quizzes, and complete public quiz flow.
    - Test create quiz form validation.
    - Test question and answer code snippet inputs.
    - Test code snippets render with preserved formatting.
    - Test quiz service sends authenticated create request.

19. Documentation
    - Update backend README with auth and quiz creation endpoints.
    - Document admin settings endpoints.
    - Document access/session log tables and retention assumptions.
    - Update frontend README with any new npm scripts or usage notes.
    - Add example request bodies for register, login, and create quiz with code snippets.

## Recommended Implementation Order

1. Backend schema/entities.
2. Backend settings/admin controls.
3. Backend access and session logging.
4. Backend auth with account roles.
5. Backend quiz ownership and create/list APIs.
6. Backend tests.
7. Frontend auth service, register page, and navbar.
8. Frontend admin page.
9. Frontend access logging call.
10. Frontend My Quizzes page.
11. Frontend Create Quiz form with code snippet inputs.
12. Frontend code rendering.
13. Frontend tests and docs.
