@echo off
setlocal enabledelayedexpansion

:: 平台检测
for /f "tokens=1-3 delims=: " %%i in ('ver') do (
    set os=%%i %%j
    set build=%%k
)

:: JDK检测模块
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：未检测到Java运行时环境！
    call :showInstallGuide
    exit /b 1
)

:: 版本验证
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set javaversion=%%i
    goto checkVersion
)

:checkVersion
set "javaversion=!javaversion:"=!"
for /f "tokens=1,2 delims=." %%a in ("!javaversion!") do (
    if "%%a" == "1" (set major=%%b) else (set major=%%a)
)

if !major! lss 21 (
    echo 当前Java版本: JDK !major!
    echo 要求最低版本: JDK 21
    call :showInstallGuide
    exit /b 1
)

:: 启动程序
echo 检测到JDK !major!，启动应用程序...
start /b javaw -jar ai-assistant-1.0@mastudy.jar > logs.log 2>&1
exit /b 0

:showInstallGuide
echo;
echo ============== Windows 环境配置指引 ==============
echo 1. 下载 JDK 21 (MSI安装包):
echo    https://aka.ms/download-jdk/microsoft-jdk-21-windows-x64.msi
echo;
echo 2. 或使用 OpenJDK:
echo    https://adoptium.net/temurin/releases/?version=21
echo;
echo 正在打开下载页面...
start "" "https://adoptium.net/temurin/releases/?version=21"
timeout /t 15
exit /b 1