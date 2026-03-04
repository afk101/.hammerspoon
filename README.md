文件位置：
cd ~/.hammerspoon

## 功能模块

### 1. 文件上传（packages/upload）

快捷键上传剪切板中的文件到 QCDN，上传成功后自动将 URL 写入剪切板。

- 默认快捷键：`Cmd + Alt + X`
- 配置项：`UPLOAD_SHORTCUT`

#### 剪切板文件获取功能支持

目前脚本支持从以下 4 种剪切板内容中自动获取或生成文件路径：

1.  **Finder 文件选择**：
    *   直接获取在 Finder 中复制的文件（ctrl+c）（通过 AppleScript 实现）。
2.  **文件 URL (file://)**：
    *   解析剪切板中的 `file://` 链接，支持从浏览器或其他应用复制的文件链接。
3.  **图像数据**：
    *   如果剪切板包含图像数据（例如截图工具直接复制），会自动保存为临时 PNG 文件并返回路径。
4.  **SVG 代码文本**：
    *   如果剪切板包含 SVG 源代码（以 `<svg` 开头并以 `</svg>` 结尾），会自动检测并保存为临时 SVG 文件。

### 2. 豆包浏览器快捷切换（packages/doubao-browser）

通过快捷键切换豆包浏览器的显示/隐藏状态。

- 默认快捷键：`Alt + Space`
- 配置项：`DOUBAO_BROWSER_SHORTCUT`、`DOUBAO_BROWSER_APP`、`DOUBAO_BROWSER_BUNDLE`
- 行为：
  - 窗口可见 → 隐藏
  - 窗口隐藏/被回收 → 重新拉起显示
  - 应用未运行 → 启动应用

## 配置

复制 `.env.example` 为 `.env`，按需修改配置项：

```bash
cp .env.example .env
```

详细配置说明见 `.env.example`。

## TODO

- 如果剪切板的内容是gif、jpg等等其他格式的图片数据，保留原格式（现在默认.png）