@echo off
chcp 65001 >nul
setlocal
rem 更新脚本 - 下载并运行 SimpleFileUpdater

cd /d "%~dp0"
set "PROJECT_ROOT=%~1"
set "TEMPLATE_DIR=%~dp0"
set "BASE_URL=https://raw.githubusercontent.com/MZSH-UEPlugins/UEPluginDevTemplate/main/.Template"
set "UPDATER_EXE=%TEMPLATE_DIR%SimpleFileUpdater.exe"
set "CONFIG_FILE=%TEMPLATE_DIR%.FileUpdate"

echo [INFO] Downloading SimpleFileUpdater...
curl -sL "%BASE_URL%/SimpleFileUpdater.exe" -o "%UPDATER_EXE%"
if not exist "%UPDATER_EXE%" ( echo [ERROR] Download failed & exit /b 1 )

echo [INFO] Downloading config...
curl -sL "%BASE_URL%/.FileUpdate" -o "%CONFIG_FILE%"
if not exist "%CONFIG_FILE%" ( echo [ERROR] Download failed & exit /b 1 )

echo [INFO] Running SimpleFileUpdater...
set "PYTHONIOENCODING=utf-8"
set "PYTHONUTF8=1"
echo. | "%UPDATER_EXE%" "%CONFIG_FILE%" 2>nul || echo [WARN] Updater error (files may still be updated)
echo [OK] Update completed
