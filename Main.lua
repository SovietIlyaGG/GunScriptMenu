--[[
    ⭐ Guns Script Menu By IlyaHacker ⭐
    Main Loader - GitHub Raw Content
    GitHub: github.com/SovietIlyaGG/GunsScriptMenu
    Версия: 4.0 Final
]]

-- Защита от повторного запуска
if _G.GunsScriptMenuLoaded then
    return
end
_G.GunsScriptMenuLoaded = true

local Player = game.Players.LocalPlayer
local Success, Result

-- Загрузка GUI
Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/GUI.lua"))()
end)

if not Success then
    warn("❌ Ошибка загрузки GUI: " .. tostring(Result))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить GUI",
        Duration = 5
    })
    return
end

local GUI = Result

-- Загрузка Functions
Success, Result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/Functions.lua"))()
end)

if not Success then
    warn("❌ Ошибка загрузки Functions: " .. tostring(Result))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить функции",
        Duration = 5
    })
    return
end

local Functions = Result

-- Инициализация
Functions.Init(GUI)

-- Уведомление об успешной загрузке
game.StarterGui:SetCore("SendNotification", {
    Title = "Guns Script Menu",
    Text = "✅ Загружено успешно! Нажми ⭐",
    Duration = 5
})

print("⭐ Guns Script Menu By IlyaHacker - Loaded")
print("📱 GitHub: github.com/SovietIlyaGG/GunsScriptMenu")
print("🎮 Delta Executor Mobile Ready")