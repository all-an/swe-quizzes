# Frontend

Angular frontend for the Software Engineering Quizzes app.

## Development server

Install dependencies:

```bash
npm install
```

Start the local development server:

```bash
npm start
```

Once the server is running, open your browser and navigate to `http://localhost:4200/`. The application will automatically reload whenever you modify any of the source files.

Public system quizzes can be browsed and taken without logging in. Register or log in to create custom quizzes, use My Quizzes, and access admin features when your account has the admin role.

Owned quizzes can be edited from the My Quizzes page. The edit form highlights missing required fields after Save is clicked.

When creating or editing a quiz, you can either choose an existing category or create a new category directly from the Quiz Details section.

Logged-out users see only public system categories on the home page. Logged-in users see system categories plus categories they created or used in their own quizzes.

The first registered account is treated as the admin account by the backend.

## Building

To build the project run:

```bash
npm run build
```

This will compile your project and store the build artifacts in the `dist/` directory. By default, the production build optimizes your application for performance and speed.

## Running unit tests

To execute unit tests with the [Vitest](https://vitest.dev/) test runner, use the following command:

```bash
npm test
```
