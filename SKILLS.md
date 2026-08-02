# Available Skills

This repository exposes skills from `.agents/skills/` after `./install.sh`
creates the `~/.agents` symlink. OpenCode automatically loads that directory
as an external skill source. The global configuration also permits skill use
(`.config/opencode/opencode.jsonc`).

Name a skill in your request to invoke it. Skills without an explicit-only
restriction may also be selected automatically when the task matches.

## Installed And Usable

| Skill | What it is for | How to invoke it |
| --- | --- | --- |
| `backend-development` | APIs, authentication, databases, security, performance, testing, and deployment. | "Use `backend-development` to design a REST API with JWT authentication." |
| `code-review` | Two-axis review of a branch, PR, or worktree against a fixed point and specification. | "Use `code-review` to review changes since `main`." A fixed point is required. |
| `codebase-design` | Designing or reshaping module interfaces, seams, depth, and testability. | "Use `codebase-design` to redesign the payment module interface." |
| `deslop` | Removing AI-generated code clutter while preserving behavior. | "Use `deslop` to clean up AI-generated code in this branch." |
| `domain-modeling` | Establishing domain terminology, maintaining `CONTEXT.md`, and recording qualifying ADRs. | "Use `domain-modeling` to define the order cancellation terminology." |
| `find-skills` | Finding and installing an additional skill from the skills ecosystem. | "Use `find-skills` to find a Playwright testing skill." |
| `grilling` | Stress-testing a plan, decision, or idea through a one-question-at-a-time interview. | "Use `grilling` to stress-test my authentication design." |
| `nestjs-best-practices` | Writing, reviewing, or refactoring NestJS applications. | "Use `nestjs-best-practices` to review this NestJS module." |
| `research` | Researching a topic from primary sources and saving cited findings in the repository. | "Use `research` to investigate the current OAuth 2.1 PKCE requirements." |
| `skill-creator` | Creating, evaluating, improving, or packaging skills. | "Use `skill-creator` to create a release-notes skill." |

## Explicit-Only Workflows

These skills are installed, but their metadata disables automatic model
invocation. Ask for them explicitly.

| Skill | What it is for | How to invoke it |
| --- | --- | --- |
| `grill-me` | A rigorous interview to sharpen a plan or design. | "Use `grill-me` to challenge my authentication design." It must be requested explicitly. |
| `handoff` | A redacted handoff document in the invocation workspace's `.tmp/` directory for a later agent session. | "Use `handoff` for the next session to finish the deployment work." It must be requested explicitly. |
| `setup-matt-pocock-skills` | Sets up the repository's issue-tracker, triage-label, and domain-document conventions for compatible engineering skills. Run once before first use of those skills. | "Use `setup-matt-pocock-skills` to configure this repository." It must be requested explicitly. |

## Not Available In This Setup

No installed skill is disabled by `.config/opencode/opencode.jsonc`; every
skill listed above is permitted. A skill not listed in this document is not
installed by this repository and cannot be invoked until it is added.

Install another global skill with:

```sh
npx skills@latest add owner/repo -g
```

The repository tracks installed skills in `.agents/.skill-lock.json`. After
adding or changing skills, quit and restart OpenCode so it reloads them.

## Verify The Active Configuration

Run this after installation to inspect the configuration OpenCode actually
loaded:

```sh
opencode debug config
```
