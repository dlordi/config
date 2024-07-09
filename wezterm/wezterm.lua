local os = require('os')
local wezterm = require('wezterm')
local config = {}

-- BEGIN Windows-specific settings
config.default_prog = { 'cmd.exe', '/k', '%CMDER_ROOT%\\vendor\\init.bat' }
config.default_cwd = os.getenv('USERPROFILE') .. '\\Desktop' -- NOTE: backslashes MUST be escaped!
-- END Windows-specific settings

config.font_size = 10

return config
