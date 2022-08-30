local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")

pouptest = awful.popup {
    widget       = {
        {
            {
                text   = 'foobar',
                widget = wibox.widget.textbox
            },
            {
                {
                    text   = 'foobar',
                    widget = wibox.widget.textbox
                },
                bg     = '#ff00ff',
                clip   = true,
                shape  = gears.shape.rounded_bar,
                widget = wibox.widget.background
            },
            {
                value         = 0.5,
                forced_height = 30,
                forced_width  = 100,
                widget        = wibox.widget.progressbar
            },
            layout = wibox.layout.fixed.vertical,
        },
        margins = 10,
        widget  = wibox.container.margin
    },
    border_color = '#00ff00',
    border_width = 5,
    ontop        = true,
    placement    = awful.placement.top_right,
    shape        = gears.shape.rounded_rect,
    visible      = true,
}
pouptest.visible = false
naughty.disconnect_signal("request::display", naughty.default_notification_handler)

naughty.connect_signal("request::display", function(n)
    local w = naughty.widget.box {
        notification    = n,
        shape           = gears.shape.rounded_bar,
        border_width    = 2,
        placement       = awful.placement.top,
        offset          = 20,
        widget_template = {
            {
                {
                    naughty.widget.icon { notification = n },
                    {
                        naughty.widget.title { notification = n },
                        naughty.widget.message { notification = n },
                        layout = wibox.layout.fixed.vertical
                    },
                    fill_space = true,
                    layout     = wibox.layout.fixed.horizontal
                },
                naughty.widget.actionlist { notification = n },
                spacing_widget = {
                    forced_height = 10,
                    span_ratio    = 0.9,
                    color         = "#ff0000",
                    widget        = wibox.widget.separator
                },
                spacing        = 10,
                layout         = wibox.layout.fixed.vertical
            },
            left   = 20,
            right  = 20,
            top    = 5,
            widget = wibox.container.margin
        },
    }
end)
