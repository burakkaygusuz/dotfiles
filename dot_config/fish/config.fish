# ------------------------------------------------------------------------------
# PATH & SYSTEM ENVIRONMENT
# ------------------------------------------------------------------------------
set -g fish_greeting

# Homebrew
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Core Paths
fish_add_path /opt/homebrew/opt/node/bin
fish_add_path /opt/homebrew/opt/curl/bin
fish_add_path /opt/homebrew/opt/python@3.14/libexec/bin
fish_add_path $HOME/.local/bin

# Java Configuration
set -gx JAVA_HOME /opt/homebrew/opt/openjdk
fish_add_path $JAVA_HOME/bin

# PNPM Configuration
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME

# ------------------------------------------------------------------------------
# SHELL INTEGRATIONS & SECRETS
# ------------------------------------------------------------------------------
# Load local secrets
if test -f ~/.secrets.env
    for line in (grep -v '^#' ~/.secrets.env | grep -v '^\s*$')
        set -l clean (string replace --regex '^\s*export\s+' '' $line)
        set -l kv (string split -m 1 '=' $clean)
        if test (count $kv) -eq 2
            set -l key (string trim $kv[1])
            set -l val (string trim $kv[2] | string replace --regex '^["\'](.*)["\'\']$' '$1')
            if string match --regex '^[A-Za-z_][A-Za-z0-9_]*$' -- $key >/dev/null
                set -gx $key $val
            end
        end
    end
end

# Starship Prompt
if status is-interactive
    /opt/homebrew/bin/starship init fish | source
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
