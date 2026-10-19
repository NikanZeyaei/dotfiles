-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Output names can be found with hyprctl monitors.

-- HDMI-A-1 on top, eDP-1 below it
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60",
    position = "0x1080",
    scale    = "1",
})
