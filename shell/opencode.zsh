# opencode feature flags
export OPENCODE_ENABLE_EXA=true
export OPENCODE_EXPERIMENTAL_LSP_TOOL=true

# Local secrets and machine-specific overrides.
if [ -n "${OPENCODE_SETUP_DIR:-}" ] && [ -f "$OPENCODE_SETUP_DIR/shell/opencode.local.zsh" ]; then
  source "$OPENCODE_SETUP_DIR/shell/opencode.local.zsh"
fi
