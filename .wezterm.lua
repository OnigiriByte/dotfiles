-- Pull in the wezterm API
local wezterm = require 'wezterm'

local action = wezterm.action
local io = require 'io'
local os = require 'os'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.window_decorations = "RESIZE"
-- Disable the bell.
config.audible_bell = "Disabled"

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night Storm (Gogh)'

config.font = wezterm.font 'JetBrains Mono'

-- and finally, return the configuration to wezterm

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable.this implies paths like the following
-- are for github. ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim
-- | wez/wezterm | "wez/wezterm.git" ) as long as a full url hyperlink regex
-- exists above this it should not match a full url to github or gitlab /
-- bitbucket (i.e. https://gitlab.com/user/project.git is
-- still a whole clickable url)
table.insert(config.hyperlink_rules, {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = 'https://www.github.com/$1/$3',
})



-- NOTE: Shows which keytable is active in the status area
wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
        name = 'TABLE: ' .. name
    end

    window:set_right_status(name or '')
end)


config.leader = { key = 'A', mods = 'CTRL' }
config.keys = {

    -- {
    --         key = 'w',
    --         mods = 'LEADER',
    --         action = action.PaneSelect
    -- },

    -- WARN: Might not be needed, in favor of switch to pane
    -- VIM Like, Pane Switching

    -- NOTE: Pane splitting
    {
        key = 's',
        mods = 'LEADER',
        action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = action.SplitVertical { domain = 'CurrentPaneDomain' },
    },


    {
        key = 'E',
        mods = 'LEADER',
        action = action { EmitEvent = "trigger-nvim-with-visible-text" }
    },

    -- NOTE: CLOSE pane
    {
        key = 'x',
        mods = 'LEADER',
        action = action.CloseCurrentPane { confirm = true }
    },

    -- NOTE: ZOOM current pane
    {
        key = 'z',
        mods = 'LEADER',
        action = action.TogglePaneZoomState
    },

    {
        key = 'p',
        mods = 'LEADER',
        action = action.PaneSelect { mode = 'SwapWithActive' }
    },

    { key = 'w', mods = 'LEADER', action = action.ActivateKeyTable { name = 'window_menu', one_shot = false, timeout_milliseconds = 400 } },

    -- NOTE: Workspaces
    {
        key = 'o',
        mods = 'LEADER',
        action = action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }
    },

    {
        key = 'W',
        mods = 'LEADER',
        action = action.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                        action.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        },
    },

    {
        key = 'R',
        mods = 'LEADER',
        action = action.PromptInputLine {
            description = wezterm.format {
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter new name for workspace' },
            },
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    wezterm.mux.rename_workspace(
                        wezterm.mux.get_active_workspace(),
                        line
                    )
                    -- window:perform_action(
                    --         action.SwitchToWorkspace {
                    --                 name = line,
                    --         },
                    --         pane
                    -- )
                end
            end),
        },
    },

    {
        key = 't',
        mods = "LEADER",
        action = action.ShowTabNavigator
    }
}


config.key_tables = {
    --NOTE: Defines the keys that are active in our resize-pane mode.
    --one_shot=false to allow for multiple adjustments.
    -- We have to also define a key to get out of this mode.


    -- NOTE: Resize Panes
    resize_pane = {

        {
            key = 'h',
            action = action.AdjustPaneSize { 'Left', 1 }
        },
        {
            key = 'j',
            action = action.AdjustPaneSize { 'Down', 1 }
        },
        {
            key = 'k',
            action = action.AdjustPaneSize { 'Up', 1 }
        },
        {
            key = 'l',
            action = action.AdjustPaneSize { 'Right', 1 }
        },

        -- NOTE: Cancel the mode by escaping
        { key = '[', mods = 'CTRL', action = 'PopKeyTable' }
    },


    -- NOTE: Focus Panes
    focus_pane = {

        -- NOTE: Cancel the mode by escaping
        { key = '[', mods = 'CTRL', action = 'PopKeyTable' },
        {
            key = 'h',
            action = action { ActivatePaneDirection = 'Left' },
        },
        {
            key = 'l',
            action = action { ActivatePaneDirection = 'Right' },
        },
        {
            key = 'k',
            action = action { ActivatePaneDirection = 'Up' },
        },
        {
            key = 'j',
            action = action { ActivatePaneDirection = 'Down' },
        },
    },

    window_menu = {
        -- NOTE: Cancel the mode by escaping
        --action = action.ActivateKeyTable { name = 'resize_pane', one_shot = false }
        -- NOTE: Cancel the mode by escaping
        { key = 'Escape', action = 'PopKeyTable' },
        {
            key = '[',
            mods = 'CTRL',
            action =
            'PopKeyTable'
        },
        { key = 'r',      action = action.ActivateKeyTable { name = 'resize_pane', one_shot = false, replace_current = true, timeout_milliseconds = 400 } },
        { key = 'f',      action = action.ActivateKeyTable { name = 'focus_pane', one_shot = false, replace_current = true } },
        {
            key = 'h',
            action = action { ActivatePaneDirection = 'Left' },
        },
        {
            key = 'j',
            action = action { ActivatePaneDirection = 'Down' },
        },
        {
            key = 'k',
            action = action { ActivatePaneDirection = 'Up' },
        },
        {
            key = 'l',
            action = action { ActivatePaneDirection = 'Right' },
        },
        {
            key = 'w',
            action = action.Multiple {
                action.PopKeyTable,
                action.PaneSelect
            }

        }


    }
}


-- NOTE: Capture scrollback and open with nvim.
wezterm.on('trigger-nvim-with-visible-text', function(window, pane)
    -- Retrieve the current viewport's text
    local viewport_text = pane:get_lines_as_text()

    -- Create a temporary file to pass to vim
    local name = os.tmpname()
    local f = io.open(name, 'w+')

    f:write(viewport_text)
    f:flush()
    f:close()

    -- Open a new window running vim and tell it to open the file
    window:perform_action(
        action.SpawnCommandInNewWindow {
            args = { 'nvim', name }
        },
        pane)

    -- NOTE: Wait enough time for nvim to read the file before we remove it
    wezterm.sleep_ms(1000)
    os.remove(name)
end)



return config
