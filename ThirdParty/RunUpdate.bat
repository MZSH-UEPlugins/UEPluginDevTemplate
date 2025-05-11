@echo off
chcp 65001 >nul
setlocal

rem ───────────────── ① 固定远程映射 URL ─────────────────
set "MAP_URL=https://raw.githubusercontent.com/MZSH-UEPlugins/UEPluginDevTemplate/main/.FileUpdate"

rem 获取脚本所在目录 (带反斜杠)
set "ROOT=%~dp0"

rem 提取 URL 文件名，组合成本地绝对路径作为配置文件
for %%F in ("%MAP_URL%") do set "CONFIG_FILE=%ROOT%%%~nxF"

echo 使用配置文件: %CONFIG_FILE%

rem ──────────────── ② 直接下载并覆盖 ───────────────
echo 正在下载远程映射…
powershell -Command "Invoke-WebRequest -Uri '%MAP_URL%' -OutFile '%CONFIG_FILE%' -UseBasicParsing"

if exist "%CONFIG_FILE%" (
    echo ✅ 配置文件已更新: %CONFIG_FILE%
) else (
    echo ❌ 下载失败，配置文件未生成。
    exit /b 1
)

rem ──────────────── ③ 启动打包好的 SimpleFileUpdater.exe ───────────────
start /wait "" "%ROOT%SimpleFileUpdater.exe" "%CONFIG_FILE%"
echo ✅ 全部操作完成
