# Skills

The installer links `.agents` to `~/.agents`, where OpenCode discovers external skills. Each skill lives at `.agents/skills/<name>/SKILL.md`; `.agents/.skill-lock.json` records where installed skills came from.

Name a skill in your request when you want to guarantee its use. Other skills may be selected automatically when the task matches their description. Skills marked **Explicit** must be named directly.

## Engineering

| Skill | Use it for | Invocation |
| --- | --- | --- |
| `backend-development` | APIs, authentication, databases, security, performance, testing, and deployment. | "Use `backend-development` to design a REST API with JWT authentication." |
| `code-review` | Two-axis review of a branch, PR, or worktree against a fixed point and specification. | "Use `code-review` to review changes since `main`." A fixed point is required. |
| `codebase-design` | Designing or reshaping module interfaces, seams, depth, and testability. | "Use `codebase-design` to redesign the payment module interface." |
| `code-security` | Secure-code guidance across common languages, OWASP risks, and infrastructure. | "Use `code-security` to review this authentication change." |
| `deslop` | Removing AI-generated code clutter while preserving behavior. | "Use `deslop` to clean up AI-generated code in this branch." |
| `domain-modeling` | Establishing domain terminology, maintaining `CONTEXT.md`, and recording qualifying ADRs. | "Use `domain-modeling` to define the order cancellation terminology." |
| `find-skills` | Finding and installing an additional skill from the skills ecosystem. | "Use `find-skills` to find a Playwright testing skill." |
| `grilling` | Stress-testing a plan, decision, or idea through a one-question-at-a-time interview. | "Use `grilling` to stress-test my authentication design." |
| `nestjs-best-practices` | Writing, reviewing, or refactoring NestJS applications. | "Use `nestjs-best-practices` to review this NestJS module." |
| `research` | Researching a topic from primary sources and saving cited findings in the repository. | "Use `research` to investigate the current OAuth 2.1 PKCE requirements." |
| `skill-creator` | Creating, evaluating, improving, or packaging skills. | "Use `skill-creator` to create a release-notes skill." |

## Planning And Research

| Skill | Use it for | Invocation |
| --- | --- | --- |
| `grilling` | Stress-testing a plan, decision, or design through an interview. | Automatic or named |
| `grill-me` | A rigorous interview to sharpen a plan or design. | **Explicit** |
| `research` | Researching a topic from primary sources and saving cited findings in the repository. | Automatic or named |
| `handoff` | Preparing a compact handoff document for a later agent session. | **Explicit** |

## Skill Administration

| Skill | Use it for | Invocation |
| --- | --- | --- |
| `find-skills` | Finding an installable skill for a capability not already available. | Automatic or named |
| `setup-matt-pocock-skills` | Configuring issue tracking, triage labels, and domain documentation for compatible engineering skills. | **Explicit**; run once per repository |
| `skill-creator` | Creating, evaluating, improving, or packaging skills. | Automatic or named |

## Maintain The Catalog

Install a global skill with:

```sh
npx skills@latest add owner/repo -g
```

Because `~/.agents` points to this repository, the install updates `.agents/skills` and `.agents/.skill-lock.json`. After adding, removing, or updating a skill:

1. Update this catalog to match the installed skill and its invocation mode.
2. Verify the lock file and skill directories agree.
3. Quit and restart OpenCode so it reloads the skill library.

```sh
node scripts/validate-skill-lock.mjs
opencode debug config
```
