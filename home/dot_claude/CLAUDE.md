# Instructions

## Communication

- Use short, clear sentences with standard grammar.
- Reply in the language that the user writes in.
- Write code, code comments, and commit messages in English.
- Before you start, state the assumptions that affect the result.
- Make routine decisions yourself.
- Until you complete all parts that the user asked for, continue the task. Before a risky or irreversible step, ask the user.
- If different readings of a request cause very different work, list the readings. Then ask the user.
- If a simpler approach than the requested one exists, tell the user in one sentence. Then continue with the requested approach.

## Architecture & Design

- Choose the simplest design that meets the requirements.
- First, build a minimal version that works. If the current version does not pass its checks, do not add a feature.
- Do not add temporary solutions or speculative abstractions.
- Do not add error checks for conditions that cannot occur. Invalid input from users, files, or networks can always occur. Keep the error checks that prevent data loss.
- Do not add compatibility layers for removed code.
- Do not break persistent data formats or database schemas.
- Before you write custom code, use established libraries and the dependencies that the project has.
- Before you decide that a capability is not available, check the library documentation and types. Your information about a library can be out of date.

## Surgical Changes

- Change only the code the task requires.
- Do not refactor or improve other code, comments, or formatting. Unrelated edits make a diff hard to review.
- Match the code style of the project.
- Remove the code that your change made obsolete or unused.
- Report dead code that existed before your change. If the user does not ask you to remove it, do not remove it.

## Code Discovery & Performance

- In a git repository:
  - Use `git grep --untracked` to locate text.
  - Use `git ls-files -co --exclude-standard` to locate files.
  - Before you read a range in a large file, find line numbers with `git grep -n`.
  - Use `git diff --stat` or specific file paths to inspect changes.
- In a `grep` or `git grep` search, first list only the files that match, with `-l`.
- Cut long lines in search output with `| cut -c1-300`.
- Before a text search, if the LSP tool is available, use it to find definitions and references.
- Run test and build commands with quiet flags, such as `-q`, to keep the output short.

## Verification & Git

- Before you start a task that has more than one step, state a short plan. For each step, name the check that shows that the step is correct.
- Before you finish a task, run a test or type check that exercises the change. A syntax check is not enough. A task that you did not check can fail without a warning.
- If the user does not ask for a commit, do not commit.
- Use Conventional Commits with a scope, for example `fix(parser): handle empty input`.
