#!/usr/bin/env bash
# Set a random wallpaper from DIR on every connected monitor (different pick per monitor when possible).
DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"

# wait for hyprpaper IPC (up to ~10s)
for _ in $(seq 20); do hyprctl hyprpaper listactive >/dev/null 2>&1 && break; sleep 0.5; done

mapfile -t imgs < <(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf)
[ "${#imgs[@]}" -gt 0 ] || exit 1

i=0
for mon in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$mon,${imgs[$((i % ${#imgs[@]}))]},cover"
    i=$((i + 1))
done
