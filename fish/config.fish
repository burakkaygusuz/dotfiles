# ------------------------------------------------------------------------------
# PATH & SYSTEM ENVIRONMENT
# ------------------------------------------------------------------------------
set -g fish_greeting

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Core Paths
fish_add_path /opt/homebrew/opt/node/bin
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path /opt/homebrew/opt/python@3.14/libexec/bin
fish_add_path $HOME/.local/bin

# Java Configuration
set -gx JAVA_HOME (/opt/homebrew/bin/brew --prefix)/opt/openjdk
fish_add_path $JAVA_HOME/bin

# .NET Configuration
set -gx DOTNET_ROOT $HOME/.dotnet
fish_add_path $DOTNET_ROOT
fish_add_path $DOTNET_ROOT/tools

# PNPM Configuration
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# ------------------------------------------------------------------------------
# SHELL INTEGRATIONS & SECRETS
# ------------------------------------------------------------------------------
# Load local secrets
if test -f ~/.secrets.env
    for line in (cat ~/.secrets.env | grep -v '^#' | grep -v '^$')
        set -l kv (string split -m 1 "=" (string replace "export " "" $line))
        set -gx $kv[1] (string trim -c '"' $kv[2])
    end
end

# Starship Prompt
if status is-interactive
    /opt/homebrew/bin/starship init fish | source
end

# OrbStack initialization
if test -f ~/.orbstack/shell/init.fish
    source ~/.orbstack/shell/init.fish
end
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# ------------------------------------------------------------------------------
# PRIVACY & TELEMETRY (Opt-out)
# ------------------------------------------------------------------------------
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx SHELL_SESSIONS_DISABLE 1
set -gx PYTHON_HISTORY /dev/null
set -gx PYTHONSTARTUP /dev/null

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
