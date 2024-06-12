local wezterm = require('wezterm')
local config = {}

-- BEGIN Windows-specific settings
config.default_prog = { 'cmd.exe', '/k', '%CMDER_ROOT%\\vendor\\init.bat' }
config.default_cwd = '%USERPROFILE%\\Desktop' -- NOTE: replace %USERPROFILE% with the actual value of the environment variable; backslashes MUST be escaped!
-- END Windows-specific settings

config.font_size = 10

return config
