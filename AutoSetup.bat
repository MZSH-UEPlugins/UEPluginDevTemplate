@echo off
chcp 65001 >nul
setlocal

rem ================================================
rem Bootstrap script - downloads and runs AutoUpdate + AutoRun
rem This file should NEVER need modification
rem ================================================

set "PROJECT_ROOT=%~dp0"
set "TEMPLATE_DIR=%PROJECT_ROOT%.Template\"
set "BASE_URL=https://raw.githubusercontent.com/MZSH-UEPlugins/UEPluginDevTemplate/main/.Template"

echo [INFO] Project root: %PROJECT_ROOT%

rem ===== Download and run AutoUpdate =====
echo [INFO] Downloading AutoUpdate...
curl -sL "%BASE_URL%/AutoUpdate.bat" -o "%TEMPLATE_DIR%AutoUpdate.bat"
if exist "%TEMPLATE_DIR%AutoUpdate.bat" (
    call "%TEMPLATE_DIR%AutoUpdate.bat" "%PROJECT_ROOT%"
)

rem ===== Download and run AutoRun =====
echo [INFO] Downloading AutoRun...
curl -sL "%BASE_URL%/AutoRun.bat" -o "%TEMPLATE_DIR%AutoRun.bat"
if exist "%TEMPLATE_DIR%AutoRun.bat" (
    call "%TEMPLATE_DIR%AutoRun.bat" "%PROJECT_ROOT%"
)

pause
