# 文件上传（packages/upload）

快捷键上传剪切板中的文件到 QCDN，上传成功后自动将 URL 写入剪切板。

## 快捷键

- **默认快捷键**：`Cmd + Alt + X`
- **配置项**：`UPLOAD_SHORTCUT`

## 剪切板文件获取功能支持

目前脚本支持从以下 5 种剪切板内容中自动获取或生成文件路径：

1. **Finder 文件选择**：
   - 直接获取在 Finder 中复制的文件（ctrl+c）（通过 AppleScript 实现）。

2. **文件 URL (file://)**：
   - 解析剪切板中的 `file://` 链接，支持从浏览器或其他应用复制的文件链接。

3. **图像数据**：
   - 如果剪切板包含图像数据（例如截图工具直接复制），会自动保存为临时 PNG 文件并返回路径。

4. **SVG 代码文本**：
   - 如果剪切板包含 SVG 源代码（以 `<svg` 开头并以 `</svg>` 结尾），会自动检测并保存为临时 SVG 文件。

5. **文件绝对路径文本**：
   - 如果剪切板包含纯文本形式的文件绝对路径（如 `/Users/xxx/image.png`），会自动检测路径是否存在且为普通文件（非目录），支持所有文件类型。适用于从终端或其他应用复制的文件完整路径。

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# Node.js 执行路径
NODE_PATH=/Users/qihoo/.nvm/versions/node/v22.14.0/bin/node

# Upload 快捷键
UPLOAD_SHORTCUT=cmd+alt+X

# 临时文件存储路径
TMPDIR=/tmp/

# 上传配置
UPLOAD_HTTPS=true
UPLOAD_MIN=true
UPLOAD_FORCE=false
```
