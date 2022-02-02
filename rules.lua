local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local keys = require("keys")

beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")
-- Rules to apply to new clients (through the "manage" signal).
local rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = { 
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },
  -- Floating clients.
	{
    rule_any = {
		  instance = {
			  "DTA",  -- Firefox addon DownThemAll.
			  "copyq",  -- Includes session name in class.
			  "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "mpv",
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = {
      floating = true
    }
  },

  -- Add titlebars to normal clients and dialogs
	{
    rule_any = {
    type = {
      "normal",
      "dialog"
      }
    },
    properties = {
      titlebars_enabled = false
    }
  }
}

return rules
