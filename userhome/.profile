if [ "$BASH" ]; then
	if [ -f ~/.bashrc ]; then
		. ~/.bashrc
	fi
fi

. "$HOME/.cargo/env"
export PATH="$PATH:/root/.local/bin"
