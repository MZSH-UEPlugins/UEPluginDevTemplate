#!/bin/bash
# 安装 Git Hooks

cd "$(dirname "$0")/.."
if [ ! -d ".git/hooks" ]; then
    echo "Error: Not a git repository"
    exit 1
fi

cp -f ".Template/hooks/pre-push" ".git/hooks/pre-push"
chmod +x ".git/hooks/pre-push"
echo "Git Hook installed"
