# ------------------------------------------------------------------------------
# SHARED ENVIRONMENT & SECRETS (see ~/.config/shell)
# ------------------------------------------------------------------------------
set -g fish_greeting

source ~/.config/shell/env.sh
if test -f ~/.config/shell/secrets.sh
    source ~/.config/shell/secrets.sh
end

# Homebrew initialization (Apple Silicon)
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

# Canonical PATH hierarchy (.local/bin > pnpm > homebrew > system)
fish_add_path -g -P -p $HOME/.local/bin $PNPM_HOME

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
