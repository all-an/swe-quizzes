# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Code Quality Standards

- **Clarity over cleverness** — write code that reads like prose. If a name needs a comment to explain it, rename it.
- **Small, focused units** — functions and components do one thing. If you need "and" to describe it, split it.
- **No dead code** — remove unused variables, imports, functions, and commented-out blocks immediately.
- **Fail loudly** — validate at boundaries (API inputs, external data). Inside the system, trust the types and contracts.
- **Flat over nested** — prefer early returns and guard clauses to deeply indented logic.
- **No magic values** — every literal constant that carries meaning gets a named constant.

## Project Structure

```
backend/    # Server-side code
frontend/   # Client-side code
```
