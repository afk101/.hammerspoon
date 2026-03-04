local M = {}
local Utils = require("packages.utils")

-- 从 .env 读取配置
local env = Utils.loadEnv()

-- 豆包浏览器 bundleID，用于查找正在运行的应用
local bundleID = env["DOUBAO_BROWSER_BUNDLE"] or "com.bot.pc.doubao.browser"

-- 豆包浏览器应用路径，用于启动应用
local appPath = env["DOUBAO_BROWSER_APP"] or "/Applications/Doubao.app/Contents/Helpers/Doubao Browser.app"

-- 解析快捷键配置
local mods, key = Utils.parseShortcut(env["DOUBAO_BROWSER_SHORTCUT"])

-- 如果未配置或解析失败，使用默认快捷键 Alt + Space
if not mods or not key then
    mods = {"alt"}
    key = "space"
end

--- 切换豆包浏览器的显示/隐藏状态
local function toggleBrowser()
    -- 通过 bundleID 精确查找应用
    local app = hs.application.get(bundleID)
    if app then
        local win = app:mainWindow()
        if win and win:isVisible() then
            -- 有可见窗口，隐藏应用
            app:hide()
        else
            -- 窗口不可见或被系统回收，用 open 重新拉起窗口
            hs.application.open(appPath)
        end
    else
        -- 应用未运行，启动它
        hs.application.open(appPath)
    end
end

-- 将快捷键对象存储在模块表 M 中，防止被垃圾回收机制清理导致快捷键失效
M.toggleHotkey = hs.hotkey.bind(mods, key, toggleBrowser)

return M
