#!/bin/bash

# JDK 21 环境检测
check_java() {
    # 检测Java是否存在
    if ! command -v java &> /dev/null; then
        echo -e "\033[31m错误：未检测到Java运行时环境！\033[0m"
        show_install_guide
        exit 1
    fi

    # 获取Java版本
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    
    # 提取主版本号
    major_version=$(echo $java_version | awk -F '.' '{if ($1=="1") print $2; else print $1}')

    if [ -z "$major_version" ] || [ $major_version -lt 21 ]; then
        echo -e "当前Java版本: \033[33mJDK ${java_version}\033[0m"
        echo -e "要求最低版本: \033[32mJDK 21\033[0m"
        show_install_guide
        exit 1
    fi
}

show_install_guide() {
    echo
    echo "============== 跨平台环境配置指引 =============="
    
    case "$(uname -s)" in
        Linux*)
            echo "1. Ubuntu/Debian:"
            echo "   sudo apt-get install openjdk-21-jdk"
            echo
            echo "2. CentOS/RHEL:"
            echo "   sudo yum install java-21-openjdk-devel"
            echo
            echo "3. 手动下载:"
            echo "   https://adoptium.net/temurin/releases/?version=21"
            ;;
        Darwin*)
            echo "1. 使用 Homebrew:"
            echo "   brew install --cask temurin"
            echo
            echo "2. 手动下载:"
            echo "   https://adoptium.net/temurin/releases/?version=21"
            ;;
        *)
            echo "访问下载页面:"
            echo "https://adoptium.net/temurin/releases/?version=21"
            ;;
    esac

    echo
    echo "3. 验证安装:"
    echo "   java -version"
    echo
    echo "正在打开下载页面..."
    xdg-open "https://adoptium.net/temurin/releases/?version=21" || open "https://adoptium.net/temurin/releases/?version=21"
}

# 主程序
check_java
echo -e "\033[32m检测到JDK ${major_version}，启动应用程序...\033[0m"
nohup java -jar ai-assistant-1.0@mastudy.jar > logs.log 2>&1 &