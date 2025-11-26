@echo off
chcp 65001 >nul
setlocal

rem ────────────────────────────────────────────────
rem Update script - maintained remotely
rem Downloads and runs SimpleFileUpdater
rem Usage: AutoUpdate.bat <PROJECT_ROOT>
rem ────────────────────────────────────────────────

set "PROJECT_ROOT=%~1"
set "TEMPLATE_DIR=%PROJECT_ROOT%.Template\"
set "BASE_URL=https://raw.githubusercontent.com/MZSH-UEPlugins/UEPluginDevTemplate/main/.Template"
set "UPDATER_EXE=%TEMPLATE_DIR%SimpleFileUpdater.exe"
set "CONFIG_FILE=%TEMPLATE_DIR%.FileUpdate"

rem ───── 下载 SimpleFileUpdater ─────
echo [INFO] Downloading SimpleFileUpdater...
curl -sL "%BASE_URL%/SimpleFileUpdater.exe" -o "%UPDATER_EXE%"
if not exist "%UPDATER_EXE%" (
    echo [ERROR] Failed to download SimpleFileUpdater.exe
    exit /b 1
)

rem ───── 下载配置文件 ─────
echo [INFO] Downloading config...
curl -sL "%BASE_URL%/.FileUpdate" -o "%CONFIG_FILE%"
if not exist "%CONFIG_FILE%" (
    echo [ERROR] Failed to download config
    exit /b 1
)

rem ───── 执行 SimpleFileUpdater ─────
echo [INFO] Running SimpleFileUpdater...
"%UPDATER_EXE%" "%CONFIG_FILE%"
echo [OK] Update completed
