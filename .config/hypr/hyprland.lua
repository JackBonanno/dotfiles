-- You can split this configuration into multiple files
-- Create your files separately and then require them like this:
require("monitors")

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi -i --show drun"
local browser     = "firefox"
local lock        = "hyprlock"
local is_mirrored = false
local lcd_off = false

local function count_connected_monitors()
    local count = 0
    local p = io.popen("grep -l '^connected$' /sys/class/drm/card*-*/status 2>/dev/null")
    if p then
        for _ in p:lines() do
            count = count + 1
        end
        p:close()
    end
    return count
end

-- Shared function used by both SUPER + ] and the physical Lid Switch
local function set_edp(disable)
    if disable then
        -- Safety check: only disable eDP-1 if an external display is connected
        if count_connected_monitors() < 2 then
            hl.exec_cmd("hyprctl notify 0 3000 'rgb(f38ba8)' 'Cannot disable eDP-1: No external monitor connected!'")
            return
        end
        lcd_off = true
        hl.monitor({
            output   = "eDP-1",
            disabled = true,
        })
        hl.exec_cmd("hyprctl notify 1 2000 'rgb(89b4fa)' 'eDP-1 Disabled (External Only)'")
    else
        lcd_off = false
        hl.monitor({
            output   = "eDP-1",
            mode     = "preferred",
            position = "auto",
            scale    = 1,
            disabled = false,
        })
        hl.exec_cmd("hyprctl notify 1 2000 'rgb(a6e3a1)' 'eDP-1 Enabled'")
    end
end

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    --hl.exec_cmd('hyprctl dispatch workspace 10; hyprctl dispatch exec "[workspace 3] ' .. terminal .. '"')
    hl.exec_cmd('hyprctl dispatch exec "[workspace 3 silent] ' .. terminal .. '"')
    hl.exec_cmd('hyprctl dispatch focusmonitor 1')
    hl.exec_cmd('hyprctl dispatch moveworkspacetomonitor 10 1')
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd('pgrep -x "wl-gammarelay" > /dev/null || wl-gammarelay')
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 3,
        col = {
            active_border = "rgba(89b4faff)",
        },
    },

    decoration = {
        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,
            ignore_opacity    = true,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        -- pseudotile = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
    },
})


---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout          = "us",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "",
        kb_rules           = "",
        numlock_by_default = true,
        repeat_rate        = 35,
        repeat_delay       = 400,
        follow_mouse       = 1,
        accel_profile      = "flat",
        -- force_no_accel  = true,

        touchpad = {
            disable_while_typing = true,
            natural_scroll       = true,
            scroll_factor        = 0.7,
        },
    },
})

hl.device({
    name        = "logitech-usb-receiver",
    sensitivity = -0.3,
})

hl.device({
    name        = "elan0688:00-04f3:320b-touchpad",
    sensitivity = 0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

-- Application & System Binds
hl.bind(mainMod .. " + RETURN",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + E",              hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + A",              hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + S",              hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + D",              hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + SHIFT + G",      hl.dsp.exec_cmd("gimp"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode="maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + S",      hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + U",      hl.dsp.exec_cmd("systemctl poweroff"), { locked = true })
hl.bind(mainMod .. " + SHIFT + PERIOD", hl.dsp.exec_cmd("systemctl suspend"),  { locked = true })
hl.bind(mainMod .. " + SHIFT + escape", hl.dsp.exec_cmd("systemctl suspend"),  { locked = true })
hl.bind(mainMod .. " + escape",         hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + V",              hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + bracketleft", function()
    is_mirrored = not is_mirrored

    local monitors = hl.get_monitors({ all=true })
    local focused_mon = nil

    -- Find the focused monitor
    for _, mon in ipairs(monitors) do
        if mon.focused then
            focused_mon = mon.name
            break
        end
    end
    -- Fallback to the first monitor if focus fails
    if not focused_mon and #monitors > 0 then
        focused_mon = monitors[1].name
    end

    if not focused_mon then return end

    -- Apply mirroring to every other connected monitor
    for _, mon in ipairs(monitors) do
        if mon.name ~= focused_mon then
            hl.monitor({
                output   = mon.name,
                scale    = mon.scale or 1,
                mirror   = (is_mirrored and mon.name ~=focused_mon) and focused_mon or "",
            })
        end
    end

end, {locked=true})

hl.bind(mainMod .. " + bracketright", function()
    set_edp(not lcd_off)
end, {locked=true})

hl.bind(mainMod .. " + M",              hl.dsp.exec_cmd(terminal .. " -e ncpamixer"))
hl.bind(mainMod .. " + B",              hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B",      hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind(mainMod .. " + SHIFT + code:201",          hl.dsp.exec_cmd(browser .. ' -new-window "https://gemini.google.com/app"'))
hl.bind(mainMod .. " + SHIFT + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + P",              hl.dsp.exec_cmd("wofi-pass --type"))
hl.bind(mainMod .. " + N",              hl.dsp.exec_cmd("~/.config/hypr/scripts/nightmode.sh"), { locked = true })
hl.bind(mainMod .. " + SHIFT + N",      hl.dsp.exec_cmd("hyprctl dismissnotify"), { locked =true} )

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Resize window with mainMod + CTRL + hjkl
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true}), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true}), { repeating = true })

-- Workspaces [1-10]: Switch, Move Window, and Move Workspace to Current Monitor
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))

    if i <= 9 then
        hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.workspace.move({ workspace = i, monitor="current"}))
    end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Media controls (Requires playerctl)
hl.bind("Pause",         hl.dsp.exec_cmd("playerctl --player=spotify,%any play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl --player=spotify,%any next"),       { locked = true })
hl.bind("XF86AudioPause",hl.dsp.exec_cmd("playerctl --player=spotify,%any play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --player=spotify,%any play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl --player=spotify,%any previous"),   { locked = true })

-- 2. Automatic Clamshell Mode on Lid Close / Open
hl.bind("switch:on:Lid Switch", function()
    set_edp(true)
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
    set_edp(false)
end, { locked = true })

local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind(mainMod.."+ Z", zoom)
hl.bind(mainMod.."+ equal", function()
    zoom(0.5)
end)
hl.bind(mainMod.."+ minus", function()
    zoom(-0.5)
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
 hl.window_rule({
     name           = "suppress-maximize-events",
     match          = { class = ".*" },
     suppress_event = "maximize",
 })

 hl.window_rule({
     name     = "fix-xwayland-drags",
     match    = {
         class      = "^$",
         title      = "^$",
         xwayland   = true,
         float      = true,
         fullscreen = false,
         pin        = false,
     },
     no_focus = true,
 })

 hl.window_rule({
    name = "xwayland-video-bridge-fixes",
    match = {
        class = "xwaylandvideobridge"
    },

    no_initial_focus = true,
    no_focus = true,
    no_anim = true,
    no_blur = true,
    max_size = {1,1},
    opacity = 0.0
})
