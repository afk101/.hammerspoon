# Chrome 快捷切换（packages/chrome）

通过快捷键切换 Chrome 的显示/隐藏状态。

## 快捷键

- **默认快捷键**：`Alt + Space`
- **配置项**：`CHROME_SHORTCUT`、`CHROME_APP`、`CHROME_BUNDLE`

## 功能行为

- Chrome 未运行 → 启动 Chrome
- Chrome 运行中且窗口可见 → 隐藏 Chrome
- Chrome 运行中但窗口隐藏 → 显示 Chrome

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# Chrome 快捷键
CHROME_SHORTCUT=alt+space

# Chrome 应用路径（用于启动应用）
CHROME_APP=/Applications/Google Chrome.app

# Chrome bundleID（用于查找运行中的应用）
CHROME_BUNDLE=com.google.Chrome
```

## 注意事项

- 默认配置使用 Chrome 稳定版
- 如使用 Canary/Dev/Beta 版本，需修改 `CHROME_APP` 和 `CHROME_BUNDLE` 配置
