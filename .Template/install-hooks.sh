#!/bin/bash
# Install Git Hooks

echo "Installing Git Hooks..."
echo ""

# 切换到项目根目录（.Template的上一级）
cd "$(dirname "$0")/.."

# 检查是否在Git仓库中
if [ ! -d ".git/hooks" ]; then
    echo "Error: Not a git repository"
    echo "Please run this script from inside a git project"
    exit 1
fi

# 复制hook文件
cp -f ".Template/hooks/pre-push" ".git/hooks/pre-push"
chmod +x ".git/hooks/pre-push"

echo "Success! Git Hook installed"
echo ""
echo "Documentation changes will automatically sync to public repo on push"
