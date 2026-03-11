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

--- 处理批量压缩完成后的汇总提示与剪切板写入
--- @param compressedPaths table 压缩成功的文件路径列表
--- @param successCount number 压缩成功的文件数量
--- @param failedCount number 压缩失败的文件数量
local function handleBatchComplete(compressedPaths, successCount, failedCount)
  if #compressedPaths > 0 then
    hs.pasteboard.setContents(table.concat(compressedPaths, "\n"))
  end

  if failedCount == 0 then
    hs.alert.show("⭐️All " .. successCount .. " file(s) compressed!")
  else
    hs.alert.show("⚠️Compressed " .. successCount .. " file(s), " .. failedCount .. " failed.")
  end
end

--- 压缩单个文件，使用通用 Node 脚本执行函数
--- @param filePath string 要压缩的文件路径
--- @param scriptPath string 压缩脚本的绝对路径
--- @param onComplete function(compressedPath) 压缩成功时的回调
--- @param onError function() 压缩失败时的回调
local function compressFile(filePath, scriptPath, onComplete, onError)
  Utils.runNodeScript(scriptPath, {filePath}, {
    outputPattern = "###COMPRESSED_START###(.-)###COMPRESSED_END###",
    onSuccess = function(compressedPath)
      if onComplete then onComplete(compressedPath) end
    end,
    onPatternMissing = function(stdOut)
      print("压缩脚本输出: " .. stdOut)
      hs.alert.show("⚠️Compress finished but no path returned: " .. filePath)
      if onError then onError() end
    end,
    onError = function(errInfo)
      hs.alert.show("❌Compress Failed: " .. filePath)
      print("压缩错误日志: " .. errInfo)
      if onError then onError() end
    end
  })
end

M.compressHotkey = hs.hotkey.bind(mods, key, function()
  local scriptPath = hs.configdir .. "/packages/compress/compress.js"

  -- 1. 优先尝试获取 Finder 中选中的文件
  local finderFiles = Utils.get_selected_finder_files()
  if finderFiles and #finderFiles > 0 then
    hs.alert.show("⏳Compressing " .. #finderFiles .. " file(s) from Finder...")
    local compressedPaths = {}
    local totalCount = #finderFiles
    -- 使用双计数器跟踪成功和失败的任务数量，确保所有任务完成后触发汇总回调
    local completedCount = 0
    local failedCount = 0

    for _, fp in ipairs(finderFiles) do
      compressFile(fp, scriptPath, function(compressedPath)
        -- 压缩成功回调
        table.insert(compressedPaths, compressedPath)
        completedCount = completedCount + 1
        if completedCount + failedCount == totalCount then
          handleBatchComplete(compressedPaths, completedCount, failedCount)
        end
      end, function()
        -- 压缩失败回调
        failedCount = failedCount + 1
        if completedCount + failedCount == totalCount then
          handleBatchComplete(compressedPaths, completedCount, failedCount)
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
  compressFile(filePath, scriptPath, function(compressedPath)
    hs.pasteboard.setContents(compressedPath)
    hs.alert.show("⭐️Compress Success! Path copied.")
  end)
end)

return M
