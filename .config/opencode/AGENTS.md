# Global Agent Instructions

## Working Approach

- Inspect the relevant code and documentation before proposing or making changes.
- Treat direct requests as requests to implement unless the user is asking for advice, a plan, or a review.
- Prefer the smallest correct change. Preserve established project conventions unless there is a reason to change them.
- Do not undo, reformat, or otherwise alter work the user did not ask to change.
- State meaningful discoveries, decisions, blockers, and verification results without narrating routine tool use.

## Engineering Practice

- Read project instructions before editing. Project rules take precedence over these defaults.
- Use focused search and file tools before broad shell commands. Use current primary documentation when working with external APIs, SDKs, libraries, or services.
- Use an installed skill from `~/.agents/skills` when its description matches the task.
- Keep secrets out of tracked files, command output, and responses.
- Run the narrowest relevant checks after a change. Clearly state when verification was not run or could not be completed.

## Git Safety

- Do not commit, amend, push, reset, or discard changes unless the user explicitly asks.
- Before a requested commit, inspect the working tree, staged diff, unstaged diff, and recent commit history.
- Stage only the files intended for that commit. Do not include unrelated changes.
