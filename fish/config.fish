# --- Fish Shell Configuration ---

# Remove greeting
set -g fish_greeting

# Homebrew Setup (Essential)
eval (/opt/homebrew/bin/brew shellenv)

# Custom PATHs
fish_add_path /opt/homebrew/opt/node/bin
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path /opt/homebrew/opt/openjdk/bin
fish_add_path /opt/homebrew/opt/python@3.14/libexec/bin
fish_add_path $HOME/.antigravity/antigravity/bin
fish_add_path $HOME/.local/bin

# Dotnet Setup
set -x DOTNET_ROOT $HOME/.dotnet
fish_add_path $DOTNET_ROOT
fish_add_path $DOTNET_ROOT/tools

# Java Home
set -x JAVA_HOME (/opt/homebrew/bin/brew --prefix)/opt/openjdk

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Load API Keys from secure file (if exists)
if test -f ~/.secrets.env
    # Export variables from .env file for fish
    for line in (cat ~/.secrets.env | grep -v '^#' | grep -v '^$')
        set -l kv (string split -m 1 "=" (string replace "export " "" $line))
        set -gx $kv[1] (string trim -c '"' $kv[2])
    end
end

# Load OrbStack (if exists)
if test -f ~/.orbstack/shell/init.fish
    source ~/.orbstack/shell/init.fish
end

# Starship Prompt Initialization
if status is-interactive
    /opt/homebrew/bin/starship init fish | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Homebrew Optimizations
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# Added by codebase-memory-mcp install
fish_add_path /Users/burak/.local/bin

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
