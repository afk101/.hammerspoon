# cmux 快捷切换（packages/cmux）

通过快捷键切换 cmux 终端的显示/隐藏状态。

## 快捷键

- **默认快捷键**：`Cmd + Alt + E`
- **配置项**：`CMUX_SHORTCUT`、`CMUX_APP`、`CMUX_BUNDLE`

## 功能行为

- cmux 未运行 → 启动 cmux
- cmux 运行中且窗口可见 → 隐藏 cmux
- cmux 运行中但窗口隐藏 → 显示 cmux

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# cmux 快捷键
CMUX_SHORTCUT=cmd+alt+E

# cmux 应用路径（用于启动应用）
CMUX_APP=/Applications/cmux.app

# cmux bundleID（用于查找运行中的应用）
CMUX_BUNDLE=com.cmuxterm.app
```
