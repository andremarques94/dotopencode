# Skills

The installer links `.agents` to `~/.agents`, where OpenCode discovers external skills. Each skill lives at `.agents/skills/<name>/SKILL.md`; `.agents/.skill-lock.json` records where installed skills came from.

Name a skill in your request when you want to guarantee its use. Other skills may be selected automatically when the task matches their description. Skills marked **Explicit** must be named directly.

## Engineering

| Skill | Use it for | Invocation |
| --- | --- | --- |
| `backend-development` | Backend APIs, data stores, authentication, security, testing, operations, and performance. | Automatic or named |
| `code-review` | Reviewing changes against a branch, commit, tag, or merge base and the relevant specification. | Automatic or named; provide a fixed point |
| `codebase-design` | Improving module boundaries, interfaces, seams, and testability. | Automatic or named |
| `deslop` | Removing generated clutter while preserving behavior. | Automatic or named |
| `domain-modeling` | Establishing domain language, `CONTEXT.md`, and qualifying architectural decisions. | Automatic or named |
| `nestjs-best-practices` | Writing, reviewing, or refactoring NestJS applications. | Automatic or named |

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
