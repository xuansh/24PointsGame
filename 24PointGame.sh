#!/bin/sh
printf '\033c\033]0;%s\a' 24PointGame
base_path="$(dirname "$(realpath "$0")")"
"$base_path/24PointGame.x86_64" "$@"
