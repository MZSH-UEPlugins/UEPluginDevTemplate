@echo off
rem 安装 Git Hooks

cd /d "%~dp0.."
if not exist ".git\hooks" (
    echo Error: Not a git repository
    pause
    exit /b 1
)

copy /Y ".Template\hooks\pre-push" ".git\hooks\pre-push" >nul
echo Git Hook installed
pause
