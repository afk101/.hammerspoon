local M = {}

M.DEFAULT_NODE_PATHS = {
  "/usr/local/bin/node",    -- Intel Mac
  "/opt/homebrew/bin/node", -- M1/M2 Mac
  "/usr/bin/node"           -- System default
}

-- Node 任务相关的错误提示常量
M.NODE_TASK = {
  CREATE_FAILED_MSG = "Internal Error: Failed to create task",
  NODE_NOT_FOUND_MSG = "Internal Error: Node.js not found",
}

return M
