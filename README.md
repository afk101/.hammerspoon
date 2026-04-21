# Hammerspoon 配置仓库

 Hammerspoon 自动化配置，提供多种实用的快捷键功能。

## 项目位置

```bash
cd ~/.hammerspoon
```

## 功能模块

| 模块 | 功能 | 快捷键 | 文档 |
|------|------|--------|------|
| upload | 文件上传到 QCDN | `Cmd + Alt + X` | [packages/upload/README.md](packages/upload/README.md) |
| chrome | Chrome 快捷切换 | `Alt + Space` | [packages/chrome/README.md](packages/chrome/README.md) |
| compress | 图片压缩 | `Cmd + Alt + M` | [packages/compress/README.md](packages/compress/README.md) |
| merge-lines | 多行文本合并 | `Cmd + Alt + O` | [packages/merge-lines/README.md](packages/merge-lines/README.md) |
| cmux | cmux 终端切换 | `Cmd + Alt + E` | [packages/cmux/README.md](packages/cmux/README.md) |

## 快速开始

1. **克隆仓库**
   ```bash
   git clone <repo-url> ~/.hammerspoon
   ```

2. **配置环境变量**
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，修改配置项
   ```

3. **重新加载 Hammerspoon**
   - 在 Hammerspoon 控制台执行 `hs.reload()`
   - 或通过菜单栏重新加载配置

## 配置说明

详细配置说明请参考各模块的 README.md 文件，或查看 `.env.example` 文件中的注释。
