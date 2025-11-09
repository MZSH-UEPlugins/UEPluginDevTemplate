@echo off
REM Install Git Hooks

echo Installing Git Hooks...
echo.

REM 切换到项目根目录（.Template的上一级）
cd /d "%~dp0.."

REM 检查是否在Git仓库中
if not exist ".git\hooks" (
    echo Error: Not a git repository
    echo Please run this script from inside a git project
    pause
    exit /b 1
)

REM 复制hook文件
copy /Y ".Template\hooks\pre-push" ".git\hooks\pre-push" >nul

echo Success! Git Hook installed
echo.
echo Documentation changes will automatically sync to public repo on push
echo.
pause
