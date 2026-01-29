# UEPluginDevTemplate 使用说明

## 项目结构

```
UEPluginDevTemplate/
├── .Template/                # 模板工具目录
│   ├── Hooks/                # Git Hooks
│   └── Scripts/              # 自动化脚本
├── Docs/                     # 插件公开文档（会同步到文档仓库）
├── Plugins/                  # 插件开发目录，支持多个插件共存
│   └── YourPlugin/
│       ├── Source/
│       ├── Content/
│       └── YourPlugin.uplugin
├── AutoSetup.bat             # 一键安装脚本
├── README.md                 # 项目简介
├── .gitignore                # 已配置常用中间目录屏蔽
└── UEPluginDevTemplate.uproject
```

## 使用方式

1. 通过 GitHub 点击 "Use this template" 按钮，创建新的插件开发仓库
2. 克隆仓库到本地，运行 `AutoSetup.bat` 完成初始化
3. 修改 `Plugins/YourPlugin/` 目录为你的插件名称并放入源码
4. 使用 Rider / Visual Studio 打开 `.uproject` 进行开发
5. 插件功能可在项目中直接调试测试
6. 插件开发完成后，可通过打包脚本导出 `.zip` 用于发布
7. 所有提交应通过 Pull Request 合并到主分支（main）

## 模板工具

### 一键安装

双击运行项目根目录下的 `AutoSetup.bat`，会自动完成：
- 更新模板文件到最新版本
- 安装 Git Hooks

### 文档自动同步

安装完成后，推送时若 `Docs/` 目录有变更，会自动同步到 [UEPluginDocs](https://github.com/MZSH-UEPlugins/UEPluginDocs) 仓库。

以下情况会跳过同步：
- 模板仓库本身（通过 GitHub API 自动识别）
- 未推送到 GitHub 的本地仓库
- 无法连接 GitHub

## Pull Request 流程建议

为保持清晰的提交历史与项目质量，建议每次合并遵循以下规则：

- 使用 Squash merge 方式合并 PR
- 配置默认合并信息为：Pull request title and commit details
- 所有分支合并主分支（main）都应通过 PR 执行
- 合并后自动删除分支，保持仓库整洁
- 推荐开启线性历史（Require linear history）防止 merge commit 污染

## 源码头部声明规范

建议每个 `.h` 和 `.cpp` 文件添加如下声明，以明确插件归属与使用约定：

```cpp
// Copyright mengzhishanghun 2025 All Rights Reserved.
```

## 常见问题

### Q: 文档同步不生效？

A: 检查以下几点：
1. 确认已运行 `AutoSetup.bat`
2. 确认仓库属于 `MZSH-UEPlugins` 组织
3. 检查 `Docs/` 目录是否有实际变更

### Q: 如何添加新插件？

A: 在 `Plugins/` 目录下创建新文件夹，按标准 UE 插件结构组织代码即可。多个插件可并存开发。
