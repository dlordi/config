local os = require('os')
local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- BEGIN Windows-specific settings
config.default_prog = { 'cmd.exe', '/k', '%CMDER_ROOT%\\vendor\\init.bat' }
config.default_cwd = os.getenv('USERPROFILE') .. '\\Desktop' -- NOTE: backslashes MUST be escaped!
-- END Windows-specific settings

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 10
config.enable_tab_bar = false

return config
