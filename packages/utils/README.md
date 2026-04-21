# 工具函数库（packages/utils）

提供通用工具函数供其他包使用。

## 模块结构

```
packages/utils/
├── init.lua        # 主入口，导出所有工具函数
├── env.lua         # 环境变量解析
├── shortcut.lua    # 快捷键解析
└── package.json    # 包元数据
```

## 导出函数

### `loadEnv()`

解析 `.env` 文件，返回键值对表。

```lua
local Utils = require("packages.utils")
local env = Utils.loadEnv()
print(env["CHROME_SHORTCUT"])  -- 输出: alt+space
```

**特性**：
- 支持 `#` 注释行
- 忽略空行
- 解析 `KEY=VALUE` 格式
- 自动去除键值首尾空白

### `parseShortcut(shortcutStr)`

解析快捷键字符串，返回修饰键和按键。

```lua
local mods, key = Utils.parseShortcut("cmd+alt+X")
-- mods = {"cmd", "alt"}
-- key = "X"
```

**支持修饰键**：
- `cmd` / `command`
- `alt` / `option`
- `ctrl` / `control`
- `shift`

**大小写不敏感**：
- `CMD+ALT+X` 和 `cmd+alt+x` 等效

## 使用示例

```lua
local Utils = require("packages.utils")

-- 读取环境变量
local env = Utils.loadEnv()
local shortcutStr = env["MY_SHORTCUT"] or "cmd+alt+X"

-- 解析快捷键
local mods, key = Utils.parseShortcut(shortcutStr)

-- 绑定快捷键
hs.hotkey.bind(mods, key, function()
    print("快捷键触发")
end)
```
