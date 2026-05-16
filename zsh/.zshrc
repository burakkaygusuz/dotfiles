# --- ZSH Configuration ---

# Path & Environment
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="/opt/homebrew/opt/node/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# Created by pipx / uv
export PATH="/Users/burak/.local/bin:$PATH"

# Load API Keys from a secure file
if [ -f ~/.secrets.env ]; then
    source ~/.secrets.env
fi

# Load OrbStack (if exists)
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Shell Settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt AUTO_CD
autoload -Uz compinit && compinit

# Prompt (Simple)
PROMPT='%n@%m %~ %# '

# Homebrew Optimizations
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=1
export HOMEBREW_NO_ENV_HINTS=1

# .NET CLI Telemetry Opt-Out
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Aliases - Clean & Standardized
alias ll='ls -la'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias py='python3'
alias node='node --no-warnings'
alias npm='npm'
