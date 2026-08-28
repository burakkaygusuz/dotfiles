# ------------------------------------------------------------------------------
# PATH & SYSTEM ENVIRONMENT
# ------------------------------------------------------------------------------
set -g fish_greeting

# Homebrew initialization (dynamic path discovery)
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
end

# Java Configuration
if set -q HOMEBREW_PREFIX; and test -d $HOMEBREW_PREFIX/opt/openjdk
    set -gx JAVA_HOME $HOMEBREW_PREFIX/opt/openjdk
end

# PNPM Configuration
set -gx PNPM_HOME "$HOME/Library/pnpm"

# Canonical PATH hierarchy (.local/bin > pnpm > java > homebrew > system)
if set -q JAVA_HOME
    fish_add_path -p $HOME/.local/bin $PNPM_HOME $JAVA_HOME/bin
else
    fish_add_path -p $HOME/.local/bin $PNPM_HOME
end

# ------------------------------------------------------------------------------
# SHELL INTEGRATIONS & SECRETS
# ------------------------------------------------------------------------------
# Load local secrets (in-process string parsing — no subprocess forks)
if test -f ~/.secrets.env
    for line in (string match -rv '^\s*(#|$)' < ~/.secrets.env)
        set -l clean (string replace --regex '^\s*export\s+' '' $line)
        set -l kv (string split -m 1 '=' $clean)
        if test (count $kv) -eq 2
            set -l key (string trim $kv[1])
            set -l val (string trim $kv[2] | string replace --regex '^["\'](.*)["\']$' '$1')
            if string match --regex '^[A-Za-z_][A-Za-z0-9_]*$' -- $key >/dev/null
                set -gx $key $val
            end
        end
    end
end

# Starship Prompt
if status is-interactive
    if type -q starship
        starship init fish | source
    end
end


# ------------------------------------------------------------------------------
# PRIVACY & TELEMETRY (Opt-out)
# ------------------------------------------------------------------------------
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx VSCODE_CLI_TELEMETRY_OPTOUT 1
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

# Modern CLI tools in interactive sessions
if type -q bfs
    alias find='bfs'
end
if type -q ugrep
    alias grep='ugrep'
    alias egrep='ugrep -E'
    alias fgrep='ugrep -F'
end
