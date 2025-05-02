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

rem ──────────────── ② 可选：先比对 MD5，如未改变则跳过 ───────────────
if exist "%CONFIG_FILE%" (
    for /f %%H in ('certutil -hashfile "%CONFIG_FILE%" MD5 ^| find /i /v "MD5"') do set "OLD_MD5=%%H"
) else (
    set "OLD_MD5="
)

echo 正在下载远程映射…
powershell -Command "Invoke-WebRequest -Uri '%MAP_URL%' -OutFile '%CONFIG_FILE%.tmp' -UseBasicParsing"

for /f %%H in ('certutil -hashfile "%CONFIG_FILE%.tmp" MD5 ^| find /i /v "MD5"') do set "NEW_MD5=%%H"

if /I "%OLD_MD5%"=="%NEW_MD5%" (
    echo 映射文件未改变，直接启动同步器…
    del "%CONFIG_FILE%.tmp"
) else (
    move /Y "%CONFIG_FILE%.tmp" "%CONFIG_FILE%" >nul
    echo 映射文件已更新: %CONFIG_FILE%
)

rem ──────────────── ③ 启动打包好的 SimpleFileUpdater.exe ───────────────
start /wait "" "%ROOT%SimpleFileUpdater.exe" "%CONFIG_FILE%"
echo ✅ 全部操作完成
