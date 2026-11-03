---
description: Review a PR with context-specific skills, then walk through each finding interactively. Nothing gets posted. Usage /rage-baiter <pr-number>
subagent: false
---

You are drafting a review of pull request #$1 for the repo in the current directory. The review will later be posted under MY GitHub account, so write it the way I would: first person, direct, no "As an AI", no emojis, no fluff.

**Nothing gets posted in this command.** You draft, then we discuss. Posting only happens when I run `/rage-post $1`.

To discard a review's saved draft and worktree, run `/rage-reset $1`, then rerun this command for a fresh review.

## My code quality bar

<!-- EDIT THIS SECTION. This is what the reviewer judges against. -->
- Readability beats cleverness. If I have to read a line twice, flag it.
- Functions do one thing. Long functions with multiple responsibilities get called out.
- Names must say what things are. No `data`, `tmp`, `handle`, `doStuff`, single letters outside tiny loops.
- No dead code, commented-out code, or leftover debug logs.
- No copy-pasted logic; duplication should be extracted. Reuse existing helpers in the codebase instead of reinventing them.
- Errors are handled explicitly, never swallowed silently.
- No magic numbers or strings; use named constants.
- New behavior needs tests. Bug fixes need a test that would have caught the bug.
- Types are precise: no `any` / untyped escape hatches without a reason.
- Keep PRs focused; unrelated changes should be split out.

## Tone

Blunt and a bit spicy, like a senior dev who has seen this mistake a hundred times. Roast the code, never the person. Every complaint must point at a specific line and say what to do instead. If something is genuinely good, you can say so briefly. Don't invent problems to fill space; if the PR is clean, say it's clean.

## Steps

### 1. Set up
- Validate that the argument is exactly one positive integer before using it in commands. Otherwise show the usage and stop.
- Confirm we're in a git repo with a GitHub remote: `gh repo view --json nameWithOwner`. If not, stop and tell me to run this from inside the repo.
- Get PR metadata: `gh pr view $1 --json title,body,author,baseRefName,headRefName,headRefOid,files`
- Get the diff: `gh pr diff $1`
- Set paths:
  - `REPO=$(basename "$(git rev-parse --show-toplevel)")`
  - `WT="${TMPDIR:-/tmp}/rage-baiter/$REPO-$1"` (worktree with the PR code)
  - `DRAFT="$(git rev-parse --path-format=absolute --git-common-dir)/rage-baiter/pr-$1.json"` (draft lives inside `.git`, so it's never committed)
- Check out the PR into a separate worktree. Never touch my current branch or working tree:
  - First check whether `$DRAFT` exists or `$WT` exists/is registered in `git worktree list --porcelain`. If any review artifacts already exist, stop and tell me to run `/rage-reset $1` before starting over. Do not overwrite the draft or delete an existing worktree automatically.
   ```
   git fetch origin "pull/$1/head"
   git worktree add --detach "$WT" FETCH_HEAD
  ```

### 2. Investigate (all inside `$WT`)
- Read the applicable repository instructions before reviewing. Inspect the changed files, package manifests, and infrastructure configuration to identify the actual scope; don't infer it from the PR title or file extensions alone.
- Select and load available skills whose descriptions match that scope. General language, framework, and infrastructure skills are applicable: use their standards and best practices as review criteria; they do not need to be review-specific. Don't follow unrelated implementation or redesign workflows. Skill names below are examples, not required dependencies: check availability, don't invent names or install skills automatically, and fall back to repository conventions, project configuration, and the quality bar above when no suitable skill exists. Briefly tell me which skills you selected and why. For mixed PRs, apply each skill to the relevant changes:
  - TypeScript: use an applicable TypeScript skill for type modeling, narrowing, generics, async behavior, and language best practices, alongside the repository's compiler settings and conventions.
  - React: select an available React skill for component behavior, hooks, state, and rendering. Use UI/UX skills when the changes affect interaction, accessibility, or visual behavior, rather than loading design skills just because a file is TSX.
  - Backend/NestJS: use `backend-development` or `nestjs-best-practices` when their scope applies.
  - Infrastructure (Docker, CI, Terraform, Kubernetes, nginx, etc.): use available infrastructure-specific skills where applicable, and `code-security` for infrastructure configuration. Review build/runtime assumptions, deployment behavior, and permissions against actual configuration.
  - Use `code-security` for security review and changes handling inputs, authentication, file operations, database queries, network requests, or cryptography, following its trigger requirements.
  - Use `code-review` when available for the review workflow. Preserve this command's draft-only output and interactive session; a skill's review report does not finish this command.
- Read the changed files in full, not just the hunks.
- Grep for callers/usages of anything the PR changes, renames or removes, and check they still work.
- Look for existing helpers/patterns in the codebase that the PR duplicates or ignores.
- Check whether tests exist for the touched code and whether the PR adds/updates them.
- Run the project's checks if they exist (figure them out from package.json, Makefile, pyproject, Cargo.toml, etc.): linter, type checker, tests. Install dependencies first if needed, using the lockfile's package manager. If setup is too heavy or fails, skip it and say so. Scope test runs to the affected area when the full suite is slow.
- Use failures from these checks as evidence in comments, only when they're caused by this PR (compare against the base branch if unsure).
- Separate demonstrated defects from assumptions and optional preferences. Verify facts from code, documentation, or checks before asking me. If a concern depends on an unverified assumption, investigate it or label it as an open question; don't present it as a proven blocker. Don't request hypothetical future-proofing or tests that only mirror an implementation without identifying meaningful risk.

### 3. Write the draft
Only comment on lines that are part of the diff. Pick a verdict:
- `REQUEST_CHANGES` if anything must be fixed
- `COMMENT` for only nitpicks/suggestions
- `APPROVE` only if it genuinely meets the bar
- If the PR author is me (`gh api user --jq .login`), use `COMMENT`; GitHub won't let me approve or block my own PR.

Write the draft to `$DRAFT` (create the folder) as a GitHub review payload:
```json
{
  "commit_id": "<headRefOid>",
  "event": "REQUEST_CHANGES",
  "body": "Short overall summary (2-5 sentences): main problems and what has to happen before this merges.",
  "comments": [
    { "path": "src/foo.ts", "line": 42, "side": "RIGHT", "body": "Comment text" }
  ]
}
```
- `line` = line number in the new file for added/context lines (`side: RIGHT`); for removed lines use the old line number and `side: LEFT`. Add `start_line` (and `start_side`) for multi-line ranges. Double-check every line number against the diff hunks.
- For concrete fixes, use a GitHub suggestion block in the body:
  ```suggestion
  replacement code
  ```

### 4. Required interactive grill session
This workflow is self-contained; no grilling skill is required. You lead an interview until we reach a shared understanding: probe assumptions and tradeoffs, resolve dependencies between decisions first, and follow each decision branch one question at a time. Give your recommendation with each question, then wait for my answer. Look up discoverable facts yourself; review decisions are mine. Do not end with a review dump or "tell me what to change". Saving the draft is not completion, and silence is not approval.

Start with a short overview: provisional verdict, number of findings, and checks run (passed / failed / skipped, with limitations). Then present the first finding as a formatted final chat response and end the turn. Keep this discussion in the current session. Ending a turn to wait for an answer is not completion of the review.

For each finding, strongest blockers first and low-confidence items last:
1. Present only that finding in a final chat response: stable `#n`, `path:line`, severity, confidence, a short fenced code quote, and the exact proposed comment as a blockquote (suggestions in fenced blocks). Use short paragraphs under **Impact**, **Evidence / uncertainty**, and **Proposed comment**, not a wall of text. Confidence and discussion notes stay out of the GitHub payload. End with a recommendation and one focused question: "Keep, edit, drop, explain, or investigate? Reply directly, or say 'choices' for selectable actions." Stop the turn here; do not open a question tool in the same turn as this presentation.
2. If I reply **choices**, use the question tool with **one short question** identifying the finding and single-select choices: **Keep**, **Edit wording**, **Drop**, **Explain / challenge**, and **Investigate further**. Keep the card plain text, at most two short sentences; no Markdown, code, full comments, or long explanations in tool fields. Put your recommended action first and mark it recommended. Accept direct text decisions and follow-up questions without requiring a menu. The menu follows an already completed chat turn, so the explanation remains a separate readable response.
3. Wait for my answer before moving on. Process the returned answer before calling the question tool again:
   - **Explain / challenge** is a request for an explanation now, not a request to ask me to formulate another question. Its option description should say "Explain the impact, evidence, and counterarguments before I decide." If I selected it without extra text, explain the current finding in more depth automatically. If I typed a question, answer that specific question first.
   - Deliver the explanation as a formatted **final chat response and end the turn**, not commentary followed by another question-tool call. Internal reasoning, shell output, changed wording, and option descriptions do not count as answering me. State the direct conclusion, the conditions under which the issue occurs, the relevant code/configuration evidence, and what remains unverified. Distinguish actual breakage from inconsistency or an optional improvement. Include a concrete execution example when useful. Never duplicate the explanation inside a question card.
   - For example, if I ask "Does this break running the image locally, or is it just inconsistent?", explain the startup/configuration path with and without the variable, and whether a failure is demonstrated, inferred, or still unknown. Inspect the relevant files or run a focused check if needed; do not simply soften the comment and ask whether to keep it.
   - **Investigate further** means perform the relevant lookup/check, then visibly explain the result and its effect on the finding before asking again. If verification is blocked, explain the limitation rather than implying the issue is confirmed.
   - End that response with the same finding's focused text decision question and wait for a new user message. Open a menu only if I subsequently request choices. Neither explanation nor investigation accepts the finding. If I ask again, address the remaining uncertainty with a different explanation or additional evidence rather than repeating the original claim.
   - For edits, obtain wording or visibly propose a revision and ask me to confirm it.
4. Defend a supported finding when challenged, but drop it if I insist. Honor free-form directions such as "merge 2 and 4", "soften this", or "add one about X"; investigate new claims and put new or materially changed comments through the same loop. Keep IDs stable during discussion.
5. Update `$DRAFT` after each agreed change. Show only what changed unless I ask for the whole review. Keep track of pending decisions; don't silently accept them. If I explicitly ask to accept the remaining findings or skip the walkthrough, honor that and move to final confirmation.

If the question tool is unavailable, ask one plain-text question with the same numbered choices and wait; don't fall back to a passive full-report ending.

### 5. Confirm the complete review
After all findings are resolved (or immediately if there are none), show the final verdict, exact summary, and retained comments in readable form, not raw JSON. Reconcile the verdict with the retained findings and the own-PR restriction above.

Present that complete review in a formatted final chat response, ending with one question: **Finalize draft**, **Change verdict / summary**, or **Revisit a finding**? Wait for my response; if I request choices, offer those actions in a short question-tool card in the next turn. Changes return to the relevant discussion and then to final confirmation. Do not describe the review as approved or ready to post before I explicitly finalize it. If I pause the session, say the saved draft is unfinished and identify the next pending decision.

After finalization, save the agreed payload and briefly confirm the verdict and comment count. Remind me to run `/rage-post $1`. Do not post it yourself, even if I say "ship it" here; point me to `/rage-post $1` instead.
