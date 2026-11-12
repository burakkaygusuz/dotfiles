# ------------------------------------------------------------------------------
# SHARED ENVIRONMENT (see ~/.config/shell)
# ------------------------------------------------------------------------------
set -g fish_greeting

source ~/.config/shell/env.sh

# Homebrew initialization (Apple Silicon)
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

# Canonical PATH hierarchy (.local/bin > pnpm > homebrew > system)
fish_add_path -g -P -p $HOME/.local/bin $PNPM_HOME /opt/homebrew/opt/python@3.14/libexec/bin

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
function starship_transient_prompt_func
    echo -n -e "\e[1;37m \e[0m"
end
if status is-interactive
    if type -q starship
        starship init fish | source
        enable_transience
    end
end

# ------------------------------------------------------------------------------
# ALIASES (Interactive only)
# ------------------------------------------------------------------------------
if status is-interactive
    source ~/.config/shell/aliases.sh
end
