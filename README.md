# opencode-setup

A portable OpenCode environment for macOS. It keeps shared configuration, skills, shell setup, and bootstrap tooling in one repository.

## Features

| Feature | What it provides |
| --- | --- |
| Shared OpenCode config | Global defaults, permissions, MCP definitions, and agent guidance in `.config/opencode`. |
| Portable skills | A versioned skill library in `.agents/skills`, available to OpenCode after installation. |
| Local overrides | Git-ignored files for machine-specific secrets, providers, and MCP servers. |
| Shell setup | Zsh environment settings and an `OPENCODE_CONFIG` override for local OpenCode config. |
| Bootstrap tooling | Homebrew dependencies, safe symlink setup, optional Claude Code skill support, and pre-commit hook installation. |

## Install

Install Homebrew if needed, then clone the repository and run the installer:

```sh
git clone git@github.com:<you>/opencode-setup.git "$HOME/opencode-setup"
cd "$HOME/opencode-setup"
./install.sh
```

Add machine-local secrets, authenticate with the model providers you use, then restart the shell:

```sh
$EDITOR "$HOME/opencode-setup/shell/opencode.local.zsh"
opencode auth login
source ~/.zshrc
```

The installer creates these links:

```text
~/.config/opencode -> <repo>/.config/opencode
~/.agents -> <repo>/.agents
```

To share the same skills with Claude Code, install with:

```sh
./install.sh --with-claude-skills
```

This also links `~/.claude/skills` to `.agents/skills`.

## Configuration

| Scope | File | Purpose |
| --- | --- | --- |
| Shared | `.config/opencode/opencode.jsonc` | Committed OpenCode defaults and disabled-by-default MCP definitions. |
| Shared | `.config/opencode/AGENTS.md` | Global engineering and Git working rules. |
| Local | `.config/opencode/opencode.local.jsonc` | Git-ignored provider, agent, and MCP overrides. Created from the example during installation. |
| Local | `shell/opencode.local.zsh` | Git-ignored environment variables and secrets. Created from the example during installation. |

`shell/opencode.zsh` exports the local config through `OPENCODE_CONFIG`, which OpenCode merges after the shared configuration. OpenCode V2 reloads configuration and agent files automatically; use `/reload` to force a full reload.

Keep secrets in local files only. The shared Context7 configuration reads `CONTEXT7_API_KEY` from the environment.

### Orchestrator agents

Select `orchestrator` explicitly for delegated implementation and review. Its workers are
`orchestrator-implementer`, `orchestrator-implementer-fast`, `orchestrator-reviewer`,
and `orchestrator-reviewer-deep`. They are hidden from the general subagent catalog
and denied by shared permissions; only `orchestrator` grants permission to launch
them. Built-in agents such as `build`, `plan`, `general`, and `explore` keep their
normal behavior and do not select these workers.

Set `agents.<id>.model` directly to a `provider/model` string in
`.config/opencode/opencode.local.jsonc` for each agent's machine-specific model.
Shared agent files do not pin models; workers without a local model setting inherit
the parent session's model. Keep local/project permission overrides from granting
other agents access to `orchestrator-*` workers.

## Skills

Installed skills live in `.agents/skills`, and `.agents/.skill-lock.json` records their source and version metadata. OpenCode discovers these through the `~/.agents` link.

See [SKILLS.md](SKILLS.md) for the available skills, when to use each one, and how to maintain the catalog.

## Update And Verify

```sh
git pull
./install.sh
opencode debug config
node scripts/validate-skill-lock.mjs
brew bundle check --file Brewfile
gitleaks dir .
pre-commit run --all-files
```

## Installer Options

| Option | Effect |
| --- | --- |
| `--no-brew` | Skip Homebrew dependency installation. |
| `--no-zshrc` | Do not add or update the managed Zsh configuration block. |
| `--dry-run` | Print actions without changing files. |
| `--with-claude-skills` | Link the shared skills for Claude Code. |
