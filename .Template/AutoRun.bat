@echo off
chcp 65001 >nul
setlocal
rem 安装脚本 - 由 AutoSetup 调用

cd /d "%~dp0"
set "PROJECT_ROOT=%~1"
set "TEMPLATE_DIR=%~dp0"

echo [INFO] Installing Git Hooks...
if exist "%PROJECT_ROOT%.git\hooks" (
    if exist "%TEMPLATE_DIR%hooks\pre-push" (
        copy /Y "%TEMPLATE_DIR%hooks\pre-push" "%PROJECT_ROOT%.git\hooks\pre-push" >nul
        echo [OK] Git Hook installed
    )
) else (
    echo [WARN] Not a git repository
)
echo [OK] Done
