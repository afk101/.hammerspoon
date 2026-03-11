local Constants = require("config.constants")
local Node = require("packages.utils.node")
local M = {}

--- 通用 Node.js 脚本执行函数
--- 封装 hs.task 的创建、Node 路径查找、输出匹配等通用逻辑
--- @param scriptPath string Node.js 脚本的绝对路径
--- @param args table 传递给脚本的参数列表
--- @param options table 配置选项表，包含以下字段：
---   - outputPattern string 用于从 stdout 中匹配结果的 Lua 模式
---   - onSuccess function(result) 匹配成功时的回调，result 为匹配到的字符串
---   - onError function(errInfo) 任务执行失败时的回调，errInfo 为错误信息字符串
---   - onPatternMissing function(stdOut) 任务成功但未匹配到结果时的回调
function M.runNodeScript(scriptPath, args, options)
  local nodePath = Node.findNodePath()

  -- 构建完整的参数列表：脚本路径 + 用户参数
  local taskArgs = { scriptPath }
  for _, arg in ipairs(args) do
    table.insert(taskArgs, arg)
  end

  local task = hs.task.new(nodePath, function(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      -- 任务执行成功，尝试从输出中匹配结果
      local result = stdOut:match(options.outputPattern)
      if result and result ~= "" then
        if options.onSuccess then options.onSuccess(result) end
      else
        -- 任务成功但未匹配到预期输出
        if options.onPatternMissing then
          options.onPatternMissing(stdOut)
        end
      end
    else
      -- 任务执行失败
      if options.onError then
        options.onError(stdErr or "Unknown error")
      end
    end
  end, taskArgs)

  if task then
    task:setWorkingDirectory(hs.configdir)
    task:start()
  else
    -- 任务创建失败
    if options.onError then
      options.onError(Constants.NODE_TASK.CREATE_FAILED_MSG)
    else
      hs.alert.show(Constants.NODE_TASK.CREATE_FAILED_MSG)
    end
  end
end

return M
