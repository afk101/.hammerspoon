local Text = require("packages.utils.text")
local File = require("packages.utils.file")
local M = {}

-- 从剪切板获取文件路径的核心函数
function M.get_file_path_from_clipboard()
  -- 方法 1: 使用 AppleScript 获取（这是获取 Finder 选中文件路径最可靠的方法）
  local script = [[
    try
      -- 尝试将剪切板内容转换为别名，再获取其 POSIX 路径（绝对路径）
      return POSIX path of (the clipboard as alias)
    on error
      -- 如果出错（例如剪切板不是文件），返回空字符串
      return ""
    end try
  ]]
  -- 执行 AppleScript
  local success, result = hs.osascript.applescript(script)
  -- 如果执行成功且结果不为空，则直接返回路径
  if success and result and result ~= "" then
      return result
  end

  -- 方法 2: 降级方案，尝试读取 URL（适用于某些拖拽或复制场景）
  local url = hs.pasteboard.readURL()

  if url then
      -- 如果返回的是 table（新版 Hammerspoon 可能会返回 NSURL 对象）
      if type(url) == "table" then
          -- 尝试从已知属性中提取路径
          if url.path then return url.path end
          if url.filePath then return url.filePath end
          -- 如果有 absoluteString，尝试解析 file:// 协议
          if url.absoluteString then
             local s = url.absoluteString
             if string.sub(s, 1, 7) == "file://" then
                 return Text.unescape(s:sub(8))
             end
          end
      -- 如果返回的是字符串
      elseif type(url) == "string" then
          -- 检查是否以 file:// 开头
          if string.sub(url, 1, 7) == "file://" then
               local parts = hs.http.urlParts(url)
               if parts and parts.path then
                   -- 解码路径中的特殊字符（如空格被编码为 %20）
                   return Text.unescape(parts.path)
               end
          end
      end
  end

  -- 方法 3: 检查剪切板是否包含图像
  -- 当使用截图工具截图并直接复制到剪切板时，剪切板中包含的是图像数据
  local image = hs.pasteboard.readImage()
  if image then
      local file_path = File.get_temp_file_path("upload_screenshot_", "png")

      -- 将图像保存为临时文件
      if image:saveToFile(file_path) then
          return file_path
      end
  end

  -- 方法 4: 检查剪切板是否包含 SVG 代码文本
  -- 当直接复制 SVG 代码时，将其保存为临时 SVG 文件
  local text_content = hs.pasteboard.readString()
  if text_content then
      -- 简单的特征检测：检查是否包含 <svg 和 </svg> 标签
      -- 移除首尾空白字符以提高匹配准确率
      local trim_content = string.match(text_content, "^%s*(.-)%s*$")

      if trim_content and string.find(trim_content, "^<svg") and string.find(trim_content, "</svg>$") then
          local file_path = File.get_temp_file_path("upload_svg_", "svg")

          -- 将 SVG 内容写入临时文件
          local file = io.open(file_path, "w")
          if file then
              file:write(trim_content)
              file:close()
              return file_path
          end
      end
  end

  -- 如果所有方法都失败，返回 nil
  return nil
end

-- 获取 Finder 中当前选中的文件路径列表
function M.get_selected_finder_files()
    local script = [[
        tell application "Finder"
            set theSelection to selection
            if (count of theSelection) is 0 then
                return ""
            end if
            set pathList to {}
            repeat with anItem in theSelection
                set end of pathList to POSIX path of (anItem as alias)
            end repeat
            set AppleScript's text item delimiters to linefeed
            return pathList as text
        end tell
    ]]
    local success, result = hs.osascript.applescript(script)
    if success and result and result ~= "" then
        local paths = {}
        for line in result:gmatch("[^\n]+") do
            table.insert(paths, line)
        end
        return paths
    end
    return nil
end

return M
