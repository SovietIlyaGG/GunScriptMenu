-- Guns Script Menu By IlyaHacker
-- Main.lua - Загрузчик v2.0 (Fixed)

repeat wait() until game.Players.LocalPlayer.Character

if _G.GunsMenuLoaded then
    _G.GunsMenu.Main.Visible = true
    return
end
_G.GunsMenuLoaded = true

local function loadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Ошибка загрузки модуля: " .. tostring(result))
        return nil
    end
    return result
end

-- Загружаем GUI
local GUI = loadModule("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/GUI.lua")

if not GUI then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить GUI",
        Duration = 5
    })
    return
end

-- Загружаем Functions
local Functions = loadModule("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/Functions.lua")

if not Functions then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ошибка",
        Text = "Не удалось загрузить функции",
        Duration = 5
    })
    return
end

-- Инициализация
local GUIInstance = GUI:Create()
Functions.Init(GUIInstance)

game.StarterGui:SetCore("SendNotification", {
    Title = "Guns Script Menu",
    Text = "Загружено! Нажмите красную кнопку",
    Duration = 3
})

print("Guns Script Menu By IlyaHacker - Loaded Successfully!")
