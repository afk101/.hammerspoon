local M = {}
local Utils = require("packages.utils")

-- 将快捷键对象存储在模块表 M 中，防止被垃圾回收机制清理导致快捷键失效
-- 读取配置并绑定快捷键
local env = Utils.loadEnv()
local mods, key = Utils.parseShortcut(env["UPLOAD_SHORTCUT"])

-- 如果未配置或解析失败，使用默认快捷键 Cmd + Alt + X
if not mods or not key then
    mods = {"cmd", "alt"}
    key = "X"
end

M.uploadHotkey = hs.hotkey.bind(mods, key, function()
  -- 1. 获取剪切板中的文件路径
  local filePath = Utils.get_file_path_from_clipboard()
  if not filePath then
    hs.alert.show("❌Please check the Clipboard")
    return
  end

  -- 2. 显示开始上传的提示
  hs.alert.show("⏳Uploading: " .. filePath)

  -- 3. 准备执行上传脚本的参数
  local scriptPath = hs.configdir .. "/packages/upload/upload.js"

  -- 4. 使用通用 Node 脚本执行函数完成上传
  -- 匹配模式 ###URL_START###...###URL_END###
  Utils.runNodeScript(scriptPath, {filePath}, {
    outputPattern = "###URL_START###(.-)###URL_END###",
    onSuccess = function(url)
      -- 提取成功：将 URL 写入剪切板并提示成功
      hs.pasteboard.setContents(url)
      hs.alert.show("⭐️Upload Success! URL copied.")
    end,
    onPatternMissing = function(stdOut)
      -- 脚本执行成功但没捕获到 URL（可能是输出格式不对）
      print("上传脚本输出: " .. stdOut)
      hs.alert.show("⚠️Upload finished but no URL returned")
    end,
    onError = function(errInfo)
      -- 任务失败（ExitCode 非 0）
      hs.alert.show("❌Upload Failed")
      print("上传错误日志: " .. errInfo)
    end
  })
end)

return M
