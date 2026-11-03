---
description: Post the approved rage-baiter draft for a PR, then clean up. Usage /rage-post <pr-number>
subagent: false
---

Post the review draft for pull request #$1 under my GitHub account, exactly as drafted. Do not rewrite, add or remove comments.

The saved file may be an unfinished draft from the interactive `/rage-baiter` walkthrough. If this session does not establish that I finalized this exact draft, show its verdict, summary, and inline comments in readable form and use the question tool to ask **Post this draft** or **Resume refinement**. Wait for my selection; resume refinement returns to the one-finding-at-a-time walkthrough in `/rage-baiter` without posting. If the question tool is unavailable, ask the same question in plain text and wait. A file existing does not mean I approved it.

1. Locate the files:
   - `DRAFT="$(git rev-parse --path-format=absolute --git-common-dir)/rage-baiter/pr-$1.json"`
   - `WT="${TMPDIR:-/tmp}/rage-baiter/$(basename "$(git rev-parse --show-toplevel)")-$1"`
   - If `$DRAFT` doesn't exist, stop and tell me to run `/rage-baiter $1` first.
2. Make sure the PR hasn't moved since the draft: compare the draft's `commit_id` with `gh pr view $1 --json headRefOid --jq .headRefOid`. If they differ, STOP and tell me new commits were pushed, so the review may be stale. Ask whether to post anyway or re-run `/rage-baiter $1`.
3. Validate the JSON (`jq . "$DRAFT"`), then post:
   `gh api "repos/{owner}/{repo}/pulls/$1/reviews" --method POST --input "$DRAFT"`
4. If GitHub rejects it because a comment's line isn't part of the diff, fix only that comment's line/side (check `gh pr diff $1`), tell me which comment you fixed, and retry once. If it still fails, stop and show me the error. Don't drop comments without asking.
5. On success, clean up:
   - `git worktree remove --force "$WT"` (ignore if already gone)
   - `rm "$DRAFT"`
6. Tell me the verdict, the number of inline comments posted, and the review URL.
