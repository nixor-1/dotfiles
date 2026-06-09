-- Monitors
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60.01",
  position = "0x0",
  scale = 1,
})

-- Program variables
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "wofi --show drun"
local mainMod = "SUPER"

-- Autostart
hl.on("hyprland.start", function()
  -- 1. Tell D-Bus and Systemd that Wayland is alive (Crucial for Dunst)
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- 2. Launch each daemon in its own clean, asynchronous call
  hl.exec_cmd("dunst")
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)

-- Environment variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("PASSWORD_STORE", "gnome")

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 7,
    border_size = 2,
    col = {
      active_border = "rgba(ffffffff)",
      inactive_border = "rgba(000000ff)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 0,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,

    -- Bezier curves defined as key-value pairs
    bezier = {
      easeOutQuint   = { 0.23, 1, 0.32, 1 },
      easeInOutCubic = { 0.65, 0.05, 0.36, 1 },
      linear         = { 0, 0, 1, 1 },
      almostLinear   = { 0.5, 0.5, 0.75, 1 },
      quick          = { 0.15, 0, 0.1, 1 },
    },

    -- Animations map: { name, enabled, speed, curve, [style] }
    animation = {
      { "global",        true, 10,   "default" },
      { "border",        true, 5.39, "easeOutQuint" },
      { "windows",       true, 4.79, "easeOutQuint" },
      { "windowsIn",     true, 4.1,  "easeOutQuint", "popin 87%" },
      { "windowsOut",    true, 1.49, "linear",       "popin 87%" },
      { "fadeIn",        true, 1.73, "almostLinear" },
      { "fadeOut",       true, 1.46, "almostLinear" },
      { "fade",          true, 3.03, "quick" },
      { "layers",        true, 3.81, "easeOutQuint" },
      { "layersIn",      true, 4,    "easeOutQuint", "fade" },
      { "layersOut",     true, 1.5,  "linear",       "fade" },
      { "fadeLayersIn",  true, 1.79, "almostLinear" },
      { "fadeLayersOut", true, 1.39, "almostLinear" },
      { "workspaces",    true, 1.94, "almostLinear", "fade" },
      { "workspacesIn",  true, 1.21, "almostLinear", "fade" },
      { "workspacesOut", true, 1.94, "almostLinear", "fade" },
      { "zoomFactor",    true, 7,    "quick" },
    },
  },

  windowrules = {
    -- Ignore maximize requests from apps
    { rule = "suppress_event maximize", match = { class = ".*" } },

    -- Fix dragging issues with XWayland
    {
      rule = "no_focus on",
      match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false
      }
    },
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
  },

  input = {
    kb_layout = "dk",
    kb_options = "compose:menu",
    repeat_delay = 200,
    repeat_rate = 60,
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
    },
  },

  device = {
    {
      name = "epic-mouse-v1",
      sensitivity = -0.5,
    },
  },
})

-- Touchpad gestures
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- Define external scripts used in bindings
local home = os.getenv("HOME")
local vol_script = home .. "/.config/hypr/scripts/volume.sh"
local screen_brightness_script = home .. "/.config/hypr/scripts/screen-brightness.sh"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.kill())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.layout("pseudo"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("anki"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- ==========================================
-- 2. WINDOW FOCUS NAVIGATION
-- ==========================================
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- ==========================================
-- 3. WORKSPACE NAVIGATION (Loops 1 to 10)
-- ==========================================
for i = 1, 10 do
  local key = tostring(i % 10)
  local ws = tostring(i)

  -- Switch workspace
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))

  -- Move active window to workspace
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- Special Workspace (Scratchpad)
hl.bind(mainMod .. " + S", function()
  hl.dsp.togglespecialworkspace("magic")
end)

hl.bind(mainMod .. " + SHIFT + S", function()
  hl.dsp.movetoworkspace("special:magic")
end)

-- ==========================================
-- 4. MOUSE WORKSPACE SCROLLING
-- ==========================================
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ==========================================
-- 5. WINDOW RESIZING & MOVING (Mouse + Modifiers)
-- ==========================================
-- Flags are handled via the metadata table: { mouse = true, drag = true/false }
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + right", function() hl.dsp.resizeactive("10 0") end, { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", function() hl.dsp.resizeactive("-10 0") end, { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", function() hl.dsp.resizeactive("0 -10") end, { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", function() hl.dsp.resizeactive("0 10") end, { repeating = true })

-- ==========================================
-- 6. MULTIMEDIA & AUDIO CONTROLS
-- ==========================================

-- Audio Mute (Using your script cleanly, no function wrappers)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(vol_script .. " mute"), { locked = true })

-- Microphone Mute
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Volume Controls (Repeating allowed, works on lockscreen)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(vol_script .. " up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(vol_script .. " down"), { repeating = true, locked = true })

-- Brightness Controls (Repeating allowed, works on lockscreen)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(screen_brightness_script .. " up"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(screen_brightness_script .. " down"),
  { repeating = true, locked = true })

-- Media Player Controls (Requires playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
