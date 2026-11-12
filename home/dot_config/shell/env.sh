# shellcheck shell=sh
# Shared by fish and zsh. Plain export/alias lines only.
export LANG=en_US.UTF-8
# Overrides an inherited LC_CTYPE=UTF-8 from the parent environment.
export LC_CTYPE=en_US.UTF-8
export PNPM_HOME="$HOME/Library/pnpm"

# Telemetry opt-outs
export SHELL_SESSIONS_DISABLE=1
export PYTHON_HISTORY=/dev/null
export PYTHONSTARTUP="/dev/null"
export VSCODE_CLI_TELEMETRY_OPTOUT=1
export CLAUDE_CODE_ENABLE_TELEMETRY=0
export DISABLE_TELEMETRY=1
export NEXT_TELEMETRY_DISABLED=1
export ASTRO_TELEMETRY_DISABLED=1
export PI_TELEMETRY=0
