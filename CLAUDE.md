# Hammerspoon 项目规范

## Package 结构规范

每个 package 目录下**必须**包含 `package.json` 文件，即使是纯 Lua 包也不例外：

- 有 Node.js 依赖的包：参考 `compress/package.json`、`upload/package.json`，需声明 `dependencies`、`type: "module"` 等字段
- 纯 Lua 包（无 Node.js 依赖）：参考 `doubao-browser/package.json`、`utils/package.json`，设置 `private: true`，`setup` 脚本输出提示无需安装依赖

## 新建 Package 检查清单

创建新 package 时，务必检查以下文件是否齐全：

1. `packages/<name>/init.lua` — 核心功能模块
2. `packages/<name>/package.json` — 包元信息（**不可遗漏**）
3. `init.lua` — 追加 `require("packages.<name>")`
4. `.env` — 追加相关配置项
5. `.env.example` — 同步追加配置模板
