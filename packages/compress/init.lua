local M = {}
local Utils = require("packages.utils")

-- 将快捷键对象存储在模块表 M 中，防止被垃圾回收机制清理导致快捷键失效
-- 读取配置并绑定快捷键
local env = Utils.loadEnv()
local mods, key = Utils.parseShortcut(env["COMPRESS_SHORTCUT"])

-- 如果未配置或解析失败，使用默认快捷键 Cmd + Alt + C
if not mods or not key then
    mods = {"cmd", "alt"}
    key = "C"
end

-- 压缩单个文件的函数
local function compressFile(filePath, scriptPath, nodePath, onComplete)
  local task = hs.task.new(nodePath, function(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      local compressedPath = stdOut:match("###COMPRESSED_START###(.-)###COMPRESSED_END###")
      if compressedPath and compressedPath ~= "" then
        if onComplete then onComplete(compressedPath) end
      else
        print("压缩脚本输出: " .. stdOut)
        hs.alert.show("⚠️Compress finished but no path returned: " .. filePath)
      end
    else
      hs.alert.show("❌Compress Failed: " .. filePath)
      print("压缩错误日志: " .. stdErr)
    end
  end, {scriptPath, filePath})

  if task then
    task:setWorkingDirectory(hs.configdir)
    task:start()
  else
    hs.alert.show("Internal Error: Failed to create compress task")
  end
end

M.compressHotkey = hs.hotkey.bind(mods, key, function()
  local scriptPath = hs.configdir .. "/packages/compress/compress.js"
  local nodePath = Utils.findNodePath()

  -- 1. 优先尝试获取 Finder 中选中的文件
  local finderFiles = Utils.get_selected_finder_files()
  if finderFiles and #finderFiles > 0 then
    hs.alert.show("⏳Compressing " .. #finderFiles .. " file(s) from Finder...")
    local compressedPaths = {}
    for _, fp in ipairs(finderFiles) do
      compressFile(fp, scriptPath, nodePath, function(compressedPath)
        table.insert(compressedPaths, compressedPath)
        if #compressedPaths == #finderFiles then
          hs.pasteboard.setContents(table.concat(compressedPaths, "\n"))
          hs.alert.show("⭐️All " .. #compressedPaths .. " file(s) compressed!")
        end
      end)
    end
    return
  end

  -- 2. 回退到剪切板方式
  local filePath = Utils.get_file_path_from_clipboard()
  if not filePath then
    hs.alert.show("❌No file selected in Finder or Clipboard")
    return
  end

  hs.alert.show("⏳Compressing: " .. filePath)
  compressFile(filePath, scriptPath, nodePath, function(compressedPath)
    hs.pasteboard.setContents(compressedPath)
    hs.alert.show("⭐️Compress Success! Path copied.")
  end)
end)

return M
