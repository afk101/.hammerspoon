# 图片压缩（packages/compress）

快捷键压缩剪切板中的图片文件，压缩后文件保存在原文件同目录，文件名添加 `.min` 后缀。

## 快捷键

- **默认快捷键**：`Cmd + Alt + M`
- **配置项**：`COMPRESS_SHORTCUT`、`COMPRESS_QUALITY`

## 功能特性

- 支持格式：PNG、JPEG、WebP、GIF、SVG
- 命名规则：`a.png` → `a.min.png`，`a.min.png` → `a.min.min.png`
- 压缩后自动将新文件路径写入剪切板

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# 图片压缩快捷键
COMPRESS_SHORTCUT=cmd+alt+M

# 压缩质量 (1-100, 默认 80)
# 数值越低压缩率越高，但画质损失越大
COMPRESS_QUALITY=80
```

## 使用方式

1. 在 Finder 中复制图片文件
2. 按下快捷键 `Cmd + Alt + M`
3. 压缩后的图片保存在原文件同目录，文件名添加 `.min` 后缀
4. 压缩后文件路径自动写入剪切板
