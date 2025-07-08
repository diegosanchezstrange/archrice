return
{
    "goolord/alpha-nvim",
    config = function ()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Set header
        dashboard.section.header.val = {


            [[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
            [[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
            [[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
            [[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
        }

        -- Set footer
        dashboard.section.footer.val = {
            [[  ]],
        }


        -- Set options
        dashboard.opts.noautocmd = true

        -- Load the dashboard
        alpha.setup(dashboard.opts)
    end
}
