# --- Fish Shell Configuration ---

# Remove greeting
set -g fish_greeting

# Homebrew Setup (Essential)
if command -sq brew
    eval (brew shellenv)
else if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Homebrew behavior
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 604800
set -gx HOMEBREW_NO_ENV_HINTS 1

if command -sq brew
    set -l brew_prefix (brew --prefix)
    fish_add_path $brew_prefix/opt/node/bin
    fish_add_path $brew_prefix/opt/curl/bin
    fish_add_path $brew_prefix/opt/openjdk/bin
    set -gx JAVA_HOME $brew_prefix/opt/openjdk
end

# Custom PATHs
fish_add_path /opt/homebrew/opt/python@3.14/libexec/bin
fish_add_path $HOME/.antigravity/antigravity/bin
fish_add_path $HOME/.local/bin

# Dotnet Setup
set -x DOTNET_ROOT $HOME/.dotnet
fish_add_path $DOTNET_ROOT
fish_add_path $DOTNET_ROOT/tools

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
