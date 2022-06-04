local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule {
    id         = "global",
    rule       = {},
    properties = {
      focus            = awful.client.focus.filter,
      raise            = true,
      screen           = awful.screen.preferred,
      -- placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
      placement        = awful.placement.no_offscreen,
      size_hints_honor = false
    }
  }

  -- Floating clients.
  ruled.client.append_rule {
    id         = "floating",
    rule_any   = {
      instance = { "copyq", "pinentry" },
      class    = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
        "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
      },
      name     = {
        "Event Tester",
      },
      role     = {
        "AlarmWindow",
        "ConfigManager",
        "pop-up",
      }
    },
    properties = { floating = true }
  }
  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id         = "titlebars",
    rule_any   = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false }
  }

  -- Polybar settings
  ruled.client.append_rule {
    rule       = { class = "Polybar" },
    properties = {
      titlebars_enabled = false,
      fullscreen = true,
      size_hints_honor = true
    }
  }
  ruled.client.append_rule {
    rule       = { class = "Libreoffice" },
    properties = {
      floating = false,
    }
  }
  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- ruled.client.append_rule {
  --     rule       = { class = "Firefox"     },
  --     properties = { screen = 1, tag = "2" }
  -- }
end)
