# 剪贴板多行合并（packages/merge-lines）

将剪贴板中的多行文本合并为单行，去除每行首尾空白，用空格连接。

## 快捷键

- **默认快捷键**：`Cmd + Alt + O`
- **配置项**：`MERGE_LINES_SHORTCUT`

## 功能逻辑

1. 读取剪贴板文本
2. 按换行符分割
3. 去除每行首尾空白字符
4. 过滤空行
5. 用单个空格连接各行
6. 写回剪贴板

## 配置

在 `.env` 文件中配置以下环境变量：

```env
# 剪贴板多行合并快捷键
MERGE_LINES_SHORTCUT=cmd+alt+O
```

## 使用场景

- 合并复制多行代码为一行
- 去除文本中的换行符
- 清理格式化的多行文本

## 边界情况处理

- 剪贴板为空：提示 "⚠️No text in clipboard"
- 剪贴板仅包含空白字符：提示 "⚠️Clipboard contains only whitespace"
- 文本已经是单行：提示 "✅Already single line"
- 合并成功：提示 "⭐️Lines merged!"
