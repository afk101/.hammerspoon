local M = {}
local Utils = require("packages.utils")

-- 将快捷键对象存储在模块表 M 中，防止被垃圾回收机制清理导致快捷键失效
-- 读取配置并绑定快捷键
local env = Utils.loadEnv()
local mods, key = Utils.parseShortcut(env["MERGE_LINES_SHORTCUT"])

-- 如果未配置或解析失败，使用默认快捷键 Cmd + Alt + O
if not mods or not key then
    mods = {"cmd", "alt"}
    key = "O"
end

--- 将多行文本合并为单行
--- 处理逻辑：按换行符分割 → 去除每行首尾空白 → 过滤空行 → 用空格连接
--- @param text string 待合并的多行文本
--- @return string 合并后的单行文本
local function mergeLines(text)
  -- 统一处理 \r\n 和 \n 两种换行符
  local lines = {}
  for line in text:gmatch("([^\r\n]*)[\r\n]?") do
    -- 去除每行首尾空白字符
    local trimmed = line:match("^%s*(.-)%s*$")
    -- 过滤空行
    if trimmed and trimmed ~= "" then
      table.insert(lines, trimmed)
    end
  end
  -- 用单个空格连接各行
  return table.concat(lines, " ")
end

--- 读取剪贴板多行文本，合并为一行后写回剪贴板
--- 包含剪贴板为空、内容无变化等边界情况的处理
local function handleMergeLines()
  local clipText = hs.pasteboard.readString()

  -- 剪贴板无文本内容时提示用户
  -- readString() 在剪贴板为空或内容为非文本（如图片）时均返回 nil
  if not clipText then
    hs.alert.show("⚠️No text in clipboard")
    return
  end

  -- 剪贴板文本为空字符串时提示用户
  if clipText == "" then
    hs.alert.show("⚠️Clipboard is empty")
    return
  end

  local merged = mergeLines(clipText)

  -- 合并后内容为空时提示（极端情况：剪贴板全是空白字符）
  if merged == "" then
    hs.alert.show("⚠️Clipboard contains only whitespace")
    return
  end

  -- 内容无变化时提示用户（已经是单行文本）
  if merged == clipText then
    hs.alert.show("✅Already single line")
    return
  end

  -- 写回剪贴板
  hs.pasteboard.setContents(merged)
  hs.alert.show("⭐️Lines merged!")
end

M.mergeHotkey = hs.hotkey.bind(mods, key, handleMergeLines)

return M
