# UEPluginDevTemplate 插件开发模板

这是一个用于开发 Unreal Engine 插件的通用项目模板，包含：

- 一个标准的空白 UE 项目 (`.uproject`)；
- 可直接放置插件到 `Plugins/` 下进行开发与测试；
- 自带通用 `.gitignore`、LICENSE 文件、README 结构；
- 可用于快速搭建多个插件的测试与迭代环境；
- 支持 PR 合并流程配置与规范提交记录（适合长期维护）。

---

## 📁 项目结构说明

```
UEPluginDevTemplate/
├── Plugins/                  # 插件开发目录，支持多个插件共存
│   └── YourPlugin/
│       ├── Source/
│       ├── Content/
│       └── YourPlugin.uplugin
├── LICENSE                   # 通用英文许可证（可商用，禁止转售）
├── README.md                 # 本说明文件
├── .gitignore                # 已配置常用中间目录屏蔽
├── UEPluginDevTemplate.uproject
```

---

## 📄 使用方式

1. 通过 GitHub 点击 "Use this template" 按钮，创建新的插件开发仓库；
2. 修改 `Plugins/YourPlugin/` 目录为你的插件名称并放入源码；
3. 使用 Rider / Visual Studio 打开 `.uproject` 进行开发；
4. 插件功能可在项目中直接调试测试；
5. 插件开发完成后，可通过打包脚本导出 `.zip` 用于发布；
6. 所有提交应通过 Pull Request 合并到主分支（main）；

---

## 🔀 Pull Request 流程建议

为了保持清晰的提交历史与项目质量，建议每次合并遵循以下规则：

- ✅ 使用 Squash merge 方式合并 PR；
- ✅ 配置默认合并信息为：**Pull request title and commit details**；
- ✅ 所有分支合并主分支（main）都应通过 PR 执行；
- ✅ 合并后自动删除分支，保持仓库整洁；
- ✅ 推荐开启线性历史（Require linear history）防止 merge commit 污染。

---

## 📜 许可证说明

本模板附带的 `LICENSE` 文件为自定义英文授权协议：

- ✅ 允许在个人或商业项目中自由使用、修改；
- ❌ 禁止二次出售、转售、打包传播此模板本体；
- 📮 有任何建议或问题可联系作者：`mengzhishanghun@outlook.com`

你可以直接使用该 LICENSE 于你自己的插件项目中，无需修改。

---

## 📌 源码头部声明规范

建议每个 `.h` 和 `.cpp` 文件添加如下声明，以明确插件归属与使用约定：

```cpp
// mengzhishanghun 2025 All Rights Reserved.
```

你可以根据此模板批量添加到所有源文件中，以提升项目的专业性与合规性。

---

## 🧑‍💻 适用场景

- 插件原型开发 / 框架验证 / 性能测试；
- 多插件并行开发测试；
- 提交到 FAB 或 GitHub 前的发布打包准备环境。

---

## 📬 联系方式

如有合作意向、插件开发定制、模板建议等，欢迎联系作者：

**作者署名**：mengzhishanghun  
**邮箱地址**：mengzhishanghun@outlook.com