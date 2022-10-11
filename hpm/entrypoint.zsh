#!/bin/zsh
set -e
zmodload zsh/datetime
MTIME=30
trapath="$HPM_ROOT/asrcpq/mytrash/files"
if [ -z "$1" ]; then
	filelist="$(find "$trapath" -maxdepth 1 -mtime +$MTIME -print)"
	du -d 0 "$trapath"
	if [ -z "$filelist" ]; then
		return 0
	fi
	echo -E "$filelist"
	echo "Proceed?"
	if (read -q); then
		find "$trapath" -maxdepth 1 -mtime +$MTIME -exec rm --one-file-system -rf {} \+
		du -d 0 "$trapath"
	fi
else
	mkdir -p "$trapath"
	for var in "$@"; do
		if [ -L "$var" ]; then
			echo "Remove symlink $var"
			rm "$var"
		elif ! [ -e "$var" ]; then
			echo "$var not found!"
			exit 1
		else
			touch "$var"
			mv -v --backup=numbered "$var" "$trapath/${var:t}-$EPOCHSECONDS"
		fi
	done
fi
