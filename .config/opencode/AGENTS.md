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

## MCP Use

- Use Context7 for version-specific library, framework, SDK, or API documentation, setup, configuration, and migration questions. Prefer first-party sources when Context7 does not cover the needed documentation.
- Use `gh_grep` for public implementation examples or to check prevailing API usage. Do not use it to search code already in this workspace.
- Use Chrome DevTools only for browser-visible behavior: reproducing UI bugs, inspecting console or network errors, validating user flows, layout debugging, or performance traces. Do not start it for backend-only work.

## Git Safety

- Do not commit, amend, push, reset, or discard changes unless the user explicitly asks.
- Before a requested commit, inspect the working tree, staged diff, unstaged diff, and recent commit history.
- Stage only the files intended for that commit. Do not include unrelated changes.
