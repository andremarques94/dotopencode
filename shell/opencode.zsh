# opencode feature flags
export OPENCODE_ENABLE_EXA=true
export OPENCODE_EXPERIMENTAL_LSP_TOOL=true

# Local secrets and machine-specific overrides.
if [ -n "${OPENCODE_SETUP_DIR:-}" ] && [ -f "$OPENCODE_SETUP_DIR/shell/opencode.local.zsh" ]; then
  source "$OPENCODE_SETUP_DIR/shell/opencode.local.zsh"
fi

if [ -n "${OPENCODE_SETUP_DIR:-}" ] && [ -f "$OPENCODE_SETUP_DIR/.config/opencode/opencode.local.jsonc" ]; then
  export OPENCODE_CONFIG="$OPENCODE_SETUP_DIR/.config/opencode/opencode.local.jsonc"
fi
