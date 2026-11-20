# shellcheck shell=sh
# Shared by fish and zsh. Plain export/alias lines only.
export LANG=en_US.UTF-8
# Overrides an inherited LC_CTYPE=UTF-8 from the parent environment.
export LC_CTYPE=en_US.UTF-8
export PNPM_HOME="$HOME/Library/pnpm"

# Homebrew settings
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=30
export HOMEBREW_NO_ENV_HINTS=1

# Telemetry opt-outs
export SHELL_SESSIONS_DISABLE=1
export PYTHON_HISTORY=/dev/null
export PYTHONSTARTUP="/dev/null"
export CLAUDE_CODE_ENABLE_TELEMETRY=0
export DISABLE_TELEMETRY=1
export NEXT_TELEMETRY_DISABLED=1
export ASTRO_TELEMETRY_DISABLED=1
