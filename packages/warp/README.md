# warp 快捷切换（packages/warp）

通过快捷键切换 warp 终端的显示/隐藏状态。

## 快捷键

- **默认快捷键**：`Cmd + Alt + E`
- **配置项**：`WARP_SHORTCUT`、`WARP_APP`、`WARP_BUNDLE`

## 功能行为

- warp 未运行 → 启动 warp
- warp 运行中且窗口可见 → 隐藏 warp
- warp 运行中但窗口隐藏 → 显示 warp

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# warp 快捷键
WARP_SHORTCUT=cmd+alt+E

# warp 应用路径（用于启动应用）
WARP_APP=/Applications/Warp.app

# warp bundleID（用于查找运行中的应用）
WARP_BUNDLE=dev.warp.Warp-Stable
```
