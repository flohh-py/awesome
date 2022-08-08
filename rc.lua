pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local keys = require('keys')
local rules = require('rules')
require("awful.hotkeys_popup.keys")
require("awful.autofocus")

-- {{{ Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_configuration_dir() .. "/theme/theme.lua")

local modkey = "Mod4"


-- {{{ Tag layout
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.max,
    })
end)
-- }}}

-- {{{ Set keys
root.keys(keys.globalkeys)

client.connect_signal("request::default_keybindings", function()
    -- awful.keyboard.append_global_keybindings(keys.globalkeys)
    awful.keyboard.append_client_keybindings(keys.clientkeys)
end)

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings(keys.clientbuttons)
end)
-- }}}

-- {{{ Notification
naughty.config.defaults['icon_size'] = 100
naughty.config.defaults['height'] = 100
naughty.config.defaults['width'] = 300
-- naughty.config.defaults['shape'] = gears.shape.rounded_rect
naughty.config.defaults['border_width'] = 5
naughty.config.defaults['bg'] = nil
naughty.config.defaults['position'] = 'top_middle'
naughty.config.defaults['opacity'] = 100


naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
-- }}}

-- {{{ Task list
screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = keys.taglist_buttons,
        -- style   = {
        --   shape_border_width = beautiful.border_width,
        --   shape_border_color = '#777777',
        --   shape              = gears.shape.rounded_rect
        -- },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = keys.tasklist_buttons,
        style           = {
            shape_border_width = beautiful.border_width,
            shape_border_color = beautiful.border_normal,
            shape              = gears.shape.rounded_bar,
        },
        layout          = {
            spacing        = 10,
            spacing_widget = {
                {
                    forced_width = 5,
                    shape        = gears.shape.circle,
                    widget       = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout         = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 10,
                right  = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "bottom",
        screen   = s,
        height   = beautiful.menu_height,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock(),
                s.mylayoutbox,
            },
        }
    }
end)
-- }}}

-- {{{ Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 10)
    end
end)
-- }}}

-- {{{ Show titlebar on floating
client.connect_signal("property::floating", function(c)
    if c.floating then
        awful.titlebar.show(c)
        awful.placement.centered()
        awful.placement.no_offscreen()
    else
        awful.titlebar.hide(c)
    end
end)
-- }}}

-- {{{ Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({}, 1, function()
            c:activate { context = "titlebar", action = "mouse_move" }
        end),
        awful.button({}, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize" }
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
-- }}}

-- {{{ Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ AutorRun
awful.spawn.with_shell("xautolock -time 10 -locker i3lock -c 000000")
awful.spawn.with_shell("xss-lock --transfer-sleep-lock -- i3lock -c 000000 --nofork")
awful.spawn.with_shell("feh --bg-fill ~/.config/awesome/theme/brackground.jpg")
awful.spawn.with_shell("pgrep xfce4-power-manager || xfce4-power-manager")
awful.spawn.with_shell("pgrep clipit || clipit")
awful.spawn.with_shell("pgrep volumeicon || volumeicon")
awful.spawn.with_shell("pgrep pamac-tray || pamac-tray")
awful.spawn.with_shell("pgrep nm-applet || nm-applet")
awful.spawn.with_shell("pgrep picom || picom")

-- mate polkint
-- awful.spawn.with_shell("mate-polkit")
awful.spawn.with_shell("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
-- }}}

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
