-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

local wallpaper = os.getenv("HOME") .. "/.config/hypr/random-wallpaper.sh"

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd(wallpaper)
    hl.exec_cmd("xhost +SI:localuser:root")
end)

-- new random wallpaper per monitor on every config reload
hl.on("config.reloaded", function ()
    hl.exec_cmd(wallpaper)
end)
