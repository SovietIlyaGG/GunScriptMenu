-- Guns Script Menu By IlyaHacker
-- Main.lua - Загрузчик

repeat wait() until game.Players.LocalPlayer.Character

if _G.GunsMenuLoaded then return end
_G.GunsMenuLoaded = true

local function loadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Ошибка загрузки: " .. tostring(result))
        return nil
    end
    return result
end

local GUI = loadModule("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/GUI.lua")
if not GUI then return end

local Functions = loadModule("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/Functions.lua")
if not Functions then return end

Functions.Init(GUI)
