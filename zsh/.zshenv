# ENV config

export HISTFILE=$HOME/.zhistory
export DEFAULT_USER=`whoami`

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"