# Airails

Rules and conventions for LLM coding assistants.

## Purpose

This repository centralizes reusable instructions, guardrails, and skill definitions that guide LLM agents (such as OpenCode, Copilot, Cursor, etc.) when working on projects.

Instead of repeating the same rules across every repo, clone or symlink this repository and point your agent config to it.

## Structure

```
AGENTS.md          # Top-level rules loaded by the agent at session start
skills/
  git-commit/      # Commit and branch conventions (Conventional Commits + Gitmoji)
```

## Included rules

### AGENTS.md

- **Source scope** — agents must never read, write, or index files outside the target repository unless explicitly authorized by the user.
- **Commit reference** — delegates branch and commit conventions to the `git-commit` skill.

### Skills

Skills are task-specific instruction sets loaded on demand by the agent.

| Skill        | Trigger                              | Description                                                  |
| ------------ | ------------------------------------ | ------------------------------------------------------------ |
| `git-commit` | Commit or branch operation requested | Branch naming, Conventional Commits format, Gitmoji prefixes |

## Usage

1. Install skills with:
   ```bash
   gh skill install jboz/airails <skill-name>
   # or
   npx skills add https://github.com/jboz/airails.git -g -y -s <skill-name>
   ```
2. The agent will automatically load `AGENTS.md` at session start.
3. Skills are loaded contextually when the agent detects a matching task.
