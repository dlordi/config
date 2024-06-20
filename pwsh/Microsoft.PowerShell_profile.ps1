# to find which modules to install, see https://github.com/JanDeDobbeleer/oh-my-posh:
# Install-Module posh-git -Scope CurrentUser
# Install-Module oh-my-posh -Scope CurrentUser
# Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck

# Import-Module posh-git
# Import-Module oh-my-posh
# Set-Theme pure

# move cursor to the end-of-line when scrolling thru the command history with cursor up/down
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Ctrl+D: exit the shell only if current command line is empty
Set-PSReadlineKeyHandler -Chord ctrl+d -Function DeleteCharOrExit

# Ctrl+L: clear screen (should be the default behaviour)
# Set-PSReadlineKeyHandler -Chord ctrl+l -Function ClearScreen

# cursor up: scroll thru the history of commands matching what has already been typed
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward

# Ctrl+E: move to the end-of-line
Set-PSReadLineKeyHandler -Chord ctrl+e -Function MoveToEndOfLine

# shorten current directory name displayed on the prompt
function prompt {
  $currentDir = (Convert-Path .)
  if ($currentDir.Contains($HOME)) {
    $currentDir = $currentDir.Replace($HOME, "~")
  }
  "PS $currentDir> "
}

# example of custom autocompleter for the yarn command
# Register-ArgumentCompleter -Native -CommandName yarn -ScriptBlock {
#   param($wordToComplete, $commandAst, $cursorPosition)
#   @( "outdated", "upgrade" ) | where { $_ -like "$wordToComplete*" }
# }
