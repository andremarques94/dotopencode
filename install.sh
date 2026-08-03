#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' "Usage: ./install.sh [--no-brew] [--no-zshrc] [--dry-run] [--with-claude-skills]"
}

NO_BREW=0
NO_ZSHRC=0
DRY_RUN=0
WITH_CLAUDE_SKILLS=0

for arg in "$@"; do
  case "$arg" in
    --no-brew) NO_BREW=1 ;;
    --no-zshrc) NO_ZSHRC=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --with-claude-skills) WITH_CLAUDE_SKILLS=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; usage; exit 1 ;;
  esac
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

backup_path() {
  local path="$1"
  local backup="${path}.backup.${TIMESTAMP}"
  printf 'Backing up %s to %s\n' "$path" "$backup"
  run mv "$path" "$backup"
}

link_path() {
  local source="$1"
  local target="$2"
  local parent
  parent="$(dirname "$target")"

  run mkdir -p "$parent"

  if [ -L "$target" ]; then
    local current
    current="$(readlink "$target")"
    if [ "$current" = "$source" ]; then
      printf 'Already linked: %s -> %s\n' "$target" "$source"
      return
    fi
    backup_path "$target"
  elif [ -e "$target" ]; then
    backup_path "$target"
  fi

  printf 'Linking %s -> %s\n' "$target" "$source"
  run ln -s "$source" "$target"
}

if [ "$NO_BREW" -eq 0 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is not installed. Install it first: https://brew.sh/\n' >&2
    exit 1
  fi
  printf 'Installing Homebrew dependencies...\n'
  run brew bundle --file "$REPO_DIR/Brewfile"
fi

link_path "$REPO_DIR/.config/opencode" "$HOME/.config/opencode"
link_path "$REPO_DIR/.agents" "$HOME/.agents"

if [ "$WITH_CLAUDE_SKILLS" -eq 1 ]; then
  link_path "$REPO_DIR/.agents/skills" "$HOME/.claude/skills"
fi

if [ ! -f "$REPO_DIR/shell/opencode.local.zsh" ]; then
  printf 'Creating local secrets file from example.\n'
  run cp "$REPO_DIR/shell/opencode.local.zsh.example" "$REPO_DIR/shell/opencode.local.zsh"
fi

if [ ! -f "$REPO_DIR/.config/opencode/opencode.local.jsonc" ]; then
  printf 'Creating local OpenCode config from example.\n'
  run cp "$REPO_DIR/.config/opencode/opencode.local.jsonc.example" "$REPO_DIR/.config/opencode/opencode.local.jsonc"
fi

if [ "$NO_ZSHRC" -eq 0 ]; then
  ZSHRC="$HOME/.zshrc"
  START_MARKER="# >>> opencode-setup >>>"
  END_MARKER="# <<< opencode-setup <<<"
  BLOCK="${START_MARKER}
export OPENCODE_SETUP_DIR=\"$REPO_DIR\"
source \"\$OPENCODE_SETUP_DIR/shell/opencode.zsh\"
${END_MARKER}"

  if [ ! -f "$ZSHRC" ]; then
    printf 'Creating %s\n' "$ZSHRC"
    run touch "$ZSHRC"
  fi

  if grep -qF "$START_MARKER" "$ZSHRC" && grep -qF "$END_MARKER" "$ZSHRC"; then
    printf 'Updating managed zshrc block.\n'
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '[dry-run] update managed block in %s\n' "$ZSHRC"
    else
      cp "$ZSHRC" "${ZSHRC}.backup.${TIMESTAMP}"
      awk -v start="$START_MARKER" -v end="$END_MARKER" -v block="$BLOCK" '
        $0 == start { print block; skip = 1; next }
        $0 == end { skip = 0; next }
        !skip { print }
      ' "$ZSHRC" > "${ZSHRC}.tmp"
      mv "${ZSHRC}.tmp" "$ZSHRC"
    fi
  else
    printf 'Appending managed zshrc block.\n'
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '[dry-run] append managed block to %s\n' "$ZSHRC"
    else
      cp "$ZSHRC" "${ZSHRC}.backup.${TIMESTAMP}"
      printf '\n%s\n' "$BLOCK" >> "$ZSHRC"
    fi
  fi
fi

if command -v pre-commit >/dev/null 2>&1 && [ -d "$REPO_DIR/.git" ]; then
  printf 'Installing pre-commit hooks...\n'
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] pre-commit install\n'
  else
    (cd "$REPO_DIR" && pre-commit install)
  fi
fi

if command -v opencode >/dev/null 2>&1; then
  printf 'opencode version: '
  opencode --version || true
fi

printf '\nSetup complete. Restart your shell or run: source ~/.zshrc\n'
printf 'Fill local secrets in: %s\n' "$REPO_DIR/shell/opencode.local.zsh"
