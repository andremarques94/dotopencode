# opencode-setup

Reusable opencode and Agent Skills setup for new machines.

## What This Manages

- Global opencode config in `.config/opencode`
- Portable Agent Skills in `.agents/skills`
- Skill install metadata in `.agents/.skill-lock.json`
- Shell environment snippets in `shell`
- Bootstrap tooling with `install.sh` and `Brewfile`

## New Machine Setup

Install Homebrew first if it is missing:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Clone this repo and run the installer:

```sh
git clone git@github.com:<you>/opencode-setup.git "$HOME/opencode-setup"
cd "$HOME/opencode-setup"
./install.sh
```

Fill local secrets:

```sh
$EDITOR "$HOME/opencode-setup/shell/opencode.local.zsh"
```

Login to model providers on each machine:

```sh
opencode auth login
```

Restart your shell or run:

```sh
source ~/.zshrc
```

## Symlinks

The installer creates these symlinks:

```text
~/.config/opencode -> <repo>/.config/opencode
~/.agents -> <repo>/.agents
```

Use Claude Code skills too:

```sh
./install.sh --with-claude-skills
```

This additionally creates:

```text
~/.claude/skills -> <repo>/.agents/skills
```

## Installing Skills

Because `~/.agents` is symlinked into this repo, global skill installs update the repo-backed skills directory and lock file:

```sh
npx skills@latest add owner/repo -g
```

The canonical layout is:

```text
.agents/.skill-lock.json
.agents/skills/<skill-name>/SKILL.md
```

## Secrets

Do not commit secrets. Put machine-local secrets in:

```text
shell/opencode.local.zsh
```

The committed config reads Context7 from:

```text
CONTEXT7_API_KEY
```

If a real key was ever committed or pushed, rotate it.

## Updating

```sh
cd "$HOME/opencode-setup"
git pull
./install.sh
```

## Validation

```sh
opencode debug config
brew bundle check --file Brewfile
gitleaks dir .
pre-commit run --all-files
```

## Installer Flags

```sh
./install.sh --no-brew
./install.sh --no-zshrc
./install.sh --dry-run
./install.sh --with-claude-skills
```
