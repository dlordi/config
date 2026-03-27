@echo off
powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File "%~dp0apply.ps1" %* || pause
