# Instructions

## Communication

- Give information in short, clear sentences with standard grammar.

## Architecture & Design

- Choose the simplest design that satisfies requirements.
- Start with a minimal working version as the base for long-term architecture.
- Reject temporary solutions and avoid speculative abstractions.
- Add each new capability incrementally on top of verified working code.
- Do not keep backward compatibility for internal code. Remove obsolete code without compatibility layers.
- Do not break persistent data formats or database schemas.
- Use existing project dependencies and established libraries before writing custom code.
- Verify library documentation and types before assuming a capability is missing.

## Code Discovery & Performance

- Use `git grep` with `--untracked` and `git ls-files` to find text and files in repositories.
- For large files, locate line numbers with `git grep -n` before reading specific ranges.
- Run test and build commands with quiet flags to show only failures.
- Limit command output size with command flags or shell filters.
- Use `git diff --stat` or specify file paths to inspect code changes.

## Verification & Git

- Run project tests and type checks to verify changes before task completion.
- Do not commit changes without user approval. Use scoped Conventional Commits.

## Advisor

- Ask the advisor before committing to a big plan, when the same error appears a second time, and before calling a long task done.
