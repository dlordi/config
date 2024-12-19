local os = require("os")
local wezterm = require("wezterm")
local config = wezterm.config_builder()

if package.config:sub(1, 1) == "\\" then
  -- Windows-specific settings
  config.default_prog = { "cmd.exe", "/k", "%CMDER_ROOT%\\vendor\\init.bat" }
  config.default_cwd = os.getenv("USERPROFILE") .. "\\Desktop"
end

-- config.font = wezterm.font("JetBrainsMonoNL Nerd Font")
config.font = wezterm.font("JetBrainsMonoNL NFM")
config.font_size = 10
config.enable_tab_bar = false

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
