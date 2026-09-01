# git-commit

Commit and branch conventions for LLM coding assistants.

## Rules

- **Branches** — create a dedicated branch per change; never commit directly on `main`/`master`.
- **Format** — Conventional Commits prefixed with a Gitmoji:
  ```
  <gitmoji> <type>(scope): <description>
  ```
- **Types** — `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **Scope** — optional, lowercase, no punctuation.
- **Description** — imperative, no capital letter, no trailing period.

## Install

```bash
gh skill install jboz/airails git-commit
```
