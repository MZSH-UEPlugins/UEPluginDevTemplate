@echo off
chcp 65001 >nul
setlocal

rem ================================================
rem Install script - maintained remotely
rem Only handles installation/initialization logic
rem Usage: AutoRun.bat <PROJECT_ROOT>
rem ================================================

cd /d "%~dp0"
set "PROJECT_ROOT=%~1"
set "TEMPLATE_DIR=%~dp0"

rem ===== Install Git Hooks =====
echo [INFO] Installing Git Hooks...
if exist "%PROJECT_ROOT%.git\hooks" (
    if exist "%TEMPLATE_DIR%hooks\pre-push" (
        copy /Y "%TEMPLATE_DIR%hooks\pre-push" "%PROJECT_ROOT%.git\hooks\pre-push" >nul
        echo [OK] Git Hook installed
    )
) else (
    echo [WARN] Not a git repository
)

echo.
echo [OK] All operations completed.
