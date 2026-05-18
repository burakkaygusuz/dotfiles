# ------------------------------------------------------------------------------
# PATH & SYSTEM ENVIRONMENT
# ------------------------------------------------------------------------------
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="/opt/homebrew/opt/node/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"
export PATH="/Users/burak/.local/bin:$PATH"

# Java Configuration
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

# .NET Configuration
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# ------------------------------------------------------------------------------
# SHELL INTEGRATIONS & SECRETS
# ------------------------------------------------------------------------------
# Load local secrets
if [ -f ~/.secrets.env ]; then
    source ~/.secrets.env
fi

# OrbStack initialization
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# ------------------------------------------------------------------------------
# SHELL BEHAVIOR & CONFIGURATION
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_CD

# Completion
autoload -Uz compinit && compinit

# Prompt
PROMPT='%n@%m %~ %# '

# ------------------------------------------------------------------------------
# PRIVACY & TELEMETRY (Opt-out)
# ------------------------------------------------------------------------------
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=1
export HOMEBREW_NO_ENV_HINTS=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SHELL_SESSIONS_DISABLE=1
export PYTHON_HISTORY=/dev/null
export PYTHONSTARTUP="/dev/null"

# ------------------------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------------------------
alias ..='cd ..'
alias ll='ls -lahG'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias py='python3'
alias node='node --no-warnings'
export VSCODE_CLI_TELEMETRY_OPTOUT=1
