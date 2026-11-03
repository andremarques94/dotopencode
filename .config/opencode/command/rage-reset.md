---
description: Delete a PR's local review worktree and draft to start over. Usage /rage-reset <pr-number>
subagent: false
---

Reset the local rage-baiter review for PR $1 in the current repository. This invocation authorizes deleting that review's disposable worktree (including its local changes) and saved draft. Do not post anything to GitHub.

1. Validate that the argument is exactly one positive integer before using it in commands. Otherwise show the usage and stop. Confirm the current directory is in a Git repository; no GitHub connection is required for this cleanup.
2. Resolve the same paths used by `/rage-baiter` and `/rage-post`:
   - `REPO=$(basename "$(git rev-parse --show-toplevel)")`
   - `WT="${TMPDIR:-/tmp}/rage-baiter/$REPO-$1"`
   - `DRAFT="$(git rev-parse --path-format=absolute --git-common-dir)/rage-baiter/pr-$1.json"`
3. Inspect `git worktree list --porcelain` and match the exact resolved `$WT` path. Remove it only if it is a registered, detached worktree belonging to this repository, is not the main worktree, and does not contain the current working directory. If these checks fail, or the path exists but is not registered to this repository, stop and explain the mismatch; do not recursively delete it or guess another location. If both the registration and directory are absent, consider the worktree already removed.
4. For a matching worktree, run `git worktree remove --force "$WT"`. Do not suppress errors or bypass a worktree lock. If removal fails, stop and report the failure, leaving the draft in place.
5. Delete only the exact `$DRAFT` file with `rm -f "$DRAFT"`. If this fails, report the partial cleanup. Leave other PR drafts, worktrees, branches, and the user's source files alone.
6. On success, discard this PR's prior findings, decisions, and approval state from the active workflow. Report what was removed or already absent, and say: "Run `/rage-baiter $1` to start a fresh review." A subsequent review must fetch and investigate the PR anew rather than reuse prior findings. This resets local review artifacts, not chat history or reviews already posted to GitHub; for an empty conversation context, start a new session before rerunning.
