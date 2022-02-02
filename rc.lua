-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Keys
local keys = require("keys")
-- Rules
local rules = require("rules")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ 
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) 
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")

local modkey = "Mod4"

awful.layout.layouts = {
  awful.layout.suit.tile,
}
-- }}}

-- {{{ Set keys
root.keys(keys.globalkeys)
-- }}}

-- {{{ Notification

-- }}}

-- {{{ Set rules
awful.rules.rules = rules
-- }}}

-- {{{ Signals

-- }}}

-- {{{ Widgets
local cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, " CPU $1%", 1)

local memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem," RAM $1%", 1)

local batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat," BAT $2%", 61, "BAT0")

local mytextclock = wibox.widget.textclock()

local mykeyboardlayout = awful.widget.keyboardlayout()
-- }}}

-- {{{ Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)
-- }}}

-- {{{ Task list
local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal( "request::activate", "tasklist", {raise = true})
		end
	end),
	awful.button({ }, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
	end)
)
-- }}}

-- {{{ Configure screens
awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc( 1) end),
      awful.button({ }, 5, function () awful.layout.inc(-1) end)
    )
  )
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
  screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
		style = {
			shape_border_width = beautiful.border_width,
			shape_border_color = '#777777',
			shape  = gears.shape.rounded_bar,
		},
		layout   = {
			spacing = 10,
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
			layout  = wibox.layout.flex.horizontal
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
				left  = 10,
				right = 10,
				widget = wibox.container.margin
			},
			id     = 'background_role',
			widget = wibox.container.background,
		}
  }

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = "bottom",
    screen = s,
    height = 25
	})

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,{
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      cpuwidget,
      memwidget,
      batwidget,
      mykeyboardlayout,
      wibox.widget.systray(),
      mytextclock,
      s.mylayoutbox,
    },
  }
end)
-- }}}

-- {{{ Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
  c.shape = function(cr,w,h)
    gears.shape.rounded_rect(cr,w,h,10)
  end
end)
-- }}}

-- {{{ Remove titlebar on floating
client.connect_signal("property::floating", function(c)
  if c.floating then
    awful.titlebar.show(c)
    awful.placement.centered()
  else
    awful.titlebar.hide(c)
  end
end)
-- }}}

-- {{{ Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
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
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
-- }}}

-- {{{ Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  -- awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ AutorRun
awful.spawn.with_shell("feh --bg-fill --randomize ~/Pictures/wallpapers/*")
awful.spawn.with_shell("xss-lock --transfer-sleep-lock -- slock")
awful.spawn.with_shell("xautolock -time 20 -locker slock")
awful.spawn.with_shell("xfce4-power-manager")
awful.spawn.with_shell("pgrep xfce4-clipman || xfce4-clipman")
awful.spawn.with_shell("mate-polkit")
awful.spawn.with_shell("pgrep volumeicon || volumeicon")
awful.spawn.with_shell("pamac-tray")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("picom")
-- }}}

beautiful.useless_gap = 2
naughty.config.defaults['icon_size'] = 100

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
