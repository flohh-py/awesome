local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local modkey = "Mod4"
local altkey = "Mod1"
local keys = {}

keys.clientkeys = gears.table.join(
    awful.key({ modkey, "Shift" }, "f",
        function(c)
            c.fullscreen = not
                c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),
    awful.key({ modkey, }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }
    ),
    awful.key({ modkey, }, "f", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end,
        { description = "move to master", group = "client" }
    ),
    awful.key({ modkey, }, "t", function(c)
        c.ontop = not c.ontop
    end,
        { description = "toggle keep on top", group = "client" }
    ),
    awful.key({ modkey, }, "c", function()
        awful.placement.centered()
    end,
        { description = "center float client", group = "client" }
    ),
    -- awful.key({ modkey, "Shift" }, ",", function (c)
    --   c:move_to_screen(-1) end,
    --   {description = "move client to screen", group = "client"}
    -- ),
    -- awful.key({ modkey, "Shift" }, ".", function (c)
    --   c:move_to_screen(1) end,
    --   {description = "move client to screen", group = "client"}
    -- ),
    awful.key({ modkey, "Shift" }, "o", function(c)
        c:move_to_screen()
    end,
        { description = "move client to screen", group = "client" }
    )
)

keys.clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

keys.globalkeys = gears.table.join(
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.util.spawn("pactl set-sink-volume 0 +5%", false)
    end
    ),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.util.spawn("pactl set-sink-volume 0 -5%", false)
    end
    ),
    awful.key({}, "XF86AudioMute", function()
        awful.util.spawn("pactl set-sink-mute 0 toggle", false)
    end
    ),
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn_with_shell("playerctl --all-players play-pause")
    end
    ),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn_with_shell("playerctl --all-players next")
    end
    ),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn_with_shell("playerctl --all-players previous")
    end
    ),
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    awful.key({ modkey, }, "h", awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    awful.key({ modkey, }, "l", awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),
    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end,
        { description = "swap with next client by index", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end,
        { description = "swap with previous client by index", group = "client" }
    ),
    awful.key({ modkey, }, ",", function()
        awful.screen.focus_relative(-1)
    end,
        { description = "focus the previous screen", group = "screen" }
    ),
    awful.key({ modkey, }, ".", function()
        awful.screen.focus_relative(1)
    end,
        { description = "focus the next screen", group = "screen" }
    ),
    awful.key({ modkey, }, "Up", function()
        awful.layout.inc(1)
    end,
        { description = "select next layout", group = "layout" }
    ),
    awful.key({ modkey, }, "Down", function()
        awful.layout.inc(-1)
    end,
        { description = "select previous layout", group = "layout" }
    ),
    -- Standard program
    awful.key({ modkey, }, "Return", function()
        awful.spawn("xfce4-terminal")
    end,
        { description = "open a terminal", group = "launcher" }
    ),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),
    awful.key({ modkey, "Shift" }, "q", function()
        awful.screen.focused()
        awful.spawn.with_shell("~/.config/awesome/rofi_power_menu")
    end,
        { description = "quit awesome", group = "awesome" }
    ),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incmwfact(0.01)
    end,
        { description = "increase master width factor", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incmwfact(-0.01)
    end,
        { description = "decrease master width factor", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "i", function()
        awful.tag.incnmaster(1, nil, true)
    end,
        { description = "increase the number of master clients", group = "layout" }
    ),
    awful.key({ modkey, "Shift" }, "d", function()
        awful.tag.incnmaster(-1, nil, true)
    end,
        { description = "decrease the number of master clients", group = "layout" }
    ),
    awful.key({ modkey }, "space", function()
        awful.screen.focused()
        awful.util.spawn("rofi -show")
    end,
        { description = "run rofi", group = "launcher" }
    ),
    awful.key({ modkey, "Shift" }, "Print", function()
        awful.util.spawn("flameshot gui")
    end,
        { description = "take screenshots" }
    ),
    awful.key({ modkey }, "v", function()
        awful.screen.focused()
        awful.util.spawn("mpv --profile=low-latency /dev/video0")
    end,
        { description = "Run cam view", group = "utils" }
    )
)

for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }
        ),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        ),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        )
    )
end

keys.tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

keys.taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
return keys
