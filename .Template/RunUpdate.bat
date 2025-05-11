@echo off
chcp 65001 >nul
setlocal

rem ────────────────────────────────────────────────
rem 🚀 同步远程 .FileUpdate 并执行 SimpleFileUpdater
rem ✅ 支持中文路径、UTF8 预览、强制覆盖、哈希校验
rem 📁 当前目录：批处理所在路径
rem ────────────────────────────────────────────────

set "MAP_URL=https://raw.githubusercontent.com/MZSH-UEPlugins/UEPluginDevTemplate/main/.Template/.FileUpdate"
set "TARGET_DIR=%~dp0"
set "CONFIG_FILE=%TARGET_DIR%.FileUpdate"
set "UPDATER_EXE=%TARGET_DIR%SimpleFileUpdater.exe"

echo [INFO] 当前路径: %TARGET_DIR%
echo [INFO] 使用配置文件: %CONFIG_FILE%

rem ───── 删除旧配置文件 ─────
if exist "%CONFIG_FILE%" (
    echo [INFO] 删除旧文件...
    del /f /q "%CONFIG_FILE%"
)

rem ───── 下载远程配置文件 ─────
echo [INFO] 使用 curl 下载远程文件...
curl -L "%MAP_URL%" -o "%CONFIG_FILE%"

rem ───── 校验是否下载成功 ─────
if exist "%CONFIG_FILE%" (
    echo ✅ 文件下载成功: %CONFIG_FILE%
    echo [INFO] 当前文件 MD5 哈希：
    certutil -hashfile "%CONFIG_FILE%" MD5
    echo.
    echo ▼ 文件内容预览（前10行）:
    powershell -Command "Get-Content -Path '%CONFIG_FILE%' -Encoding UTF8 | Select-Object -First 10"
) else (
    echo ❌ 下载失败，文件不存在！
    pause
    exit /b 1
)

rem ───── 启动 SimpleFileUpdater 执行资源下载 ─────
if exist "%UPDATER_EXE%" (
    echo [INFO] 正在启动 SimpleFileUpdater...
    start /wait "" "%UPDATER_EXE%" "%CONFIG_FILE%"
    echo ✅ SimpleFileUpdater 执行完成
) else (
    echo ⚠️ 未找到 SimpleFileUpdater.exe: %UPDATER_EXE%
)

echo.
echo ✅ 所有操作完成。
pause
