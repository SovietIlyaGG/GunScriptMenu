--[[
    ⭐ Guns Script Menu By IlyaHacker ⭐
    GUI Module - Плавающая кнопка + Боевой интерфейс
    Версия: 4.0 Final
]]

local GUI = {}
local Player = game.Players.LocalPlayer
local UserInputService = game.UserInputService
local TweenService = game.TweenService
local RunService = game.RunService
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- ==================== ПЛАВАЮЩАЯ КНОПКА ⭐ ====================
function GUI:CreateFloatingButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FloatingButtonGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- Главная кнопка
    local Button = Instance.new("TextButton")
    Button.Name = "MainButton"
    Button.Size = UDim2.new(0, 65, 0, 65)
    Button.Position = UDim2.new(0, 20, 0, 300)
    Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Button.Text = "⭐"
    Button.TextSize = 30
    Button.TextColor3 = Color3.fromRGB(255, 255, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.ZIndex = 10
    Button.Parent = ScreenGui
    
    -- Круглая форма
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Button
    
    -- Обводка
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 215, 0)
    Stroke.Thickness = 2
    Stroke.Parent = Button
    
    -- Свечение
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1.3, 0, 1.3, 0)
    Glow.Position = UDim2.new(-0.15, 0, -0.15, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://2842789757"
    Glow.ImageColor3 = Color3.fromRGB(255, 100, 100)
    Glow.ImageTransparency = 0.85
    Glow.Visible = false
    Glow.ZIndex = 9
    Glow.Parent = Button
    
    -- Статус меню
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 1, 5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "ЗАКРЫТО"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.SourceSansBold
    StatusLabel.ZIndex = 10
    StatusLabel.Parent = Button
    
    -- Перемещение кнопки
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragConnection
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            Glow.Visible = true
            
            TweenService:Create(Button, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 70, 0, 70),
                BackgroundTransparency = 0.1
            }):Play()
            
            dragConnection = UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local delta = input.Position - dragStart
                    local newX = math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - 65)
                    local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - 65)
                    
                    Button.Position = UDim2.new(0, newX, 0, newY)
                end
            end)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if dragging then
            dragging = false
            Glow.Visible = false
            if dragConnection then
                dragConnection:Disconnect()
            end
            
            TweenService:Create(Button, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 65, 0, 65),
                BackgroundTransparency = 0.2
            }):Play()
        end
    end)
    
    return Button
end

-- ==================== КРАСИВЫЕ ЭЛЕМЕНТЫ ====================
function GUI:CreateToggle(Tab, Name, Default, Callback)
    local Toggle = Tab:AddToggle({
        Name = Name,
        Default = Default or false,
        Color = Color3.fromRGB(255, 0, 0),
        Flag = Name:gsub(" ", "_"),
        Save = true,
        Callback = function(Value)
            Callback(Value)
        end
    })
    return Toggle
end

function GUI:CreateDropdown(Tab, Name, Options, Default, Callback)
    local Dropdown = Tab:AddDropdown({
        Name = Name,
        Default = Default or Options[1],
        Options = Options,
        Color = Color3.fromRGB(255, 50, 50),
        Flag = Name:gsub(" ", "_"),
        Save = true,
        Callback = function(Value)
            Callback(Value)
        end
    })
    return Dropdown
end

function GUI:CreateSlider(Tab, Name, Min, Max, Default, Callback)
    local Slider = Tab:AddSlider({
        Name = Name,
        Min = Min or 0,
        Max = Max or 100,
        Default = Default or 50,
        Color = Color3.fromRGB(255, 0, 0),
        Increment = 1,
        ValueName = "%",
        Flag = Name:gsub(" ", "_"),
        Save = true,
        Callback = function(Value)
            Callback(Value)
        end
    })
    return Slider
end

function GUI:CreateSection(Tab, Name)
    Tab:AddSection({Name = Name})
end

function GUI:CreateButton(Tab, Name, Callback)
    Tab:AddButton({
        Name = Name,
        Callback = Callback
    })
end

function GUI:CreateColorPicker(Tab, Name, Default, Callback)
    local ColorPicker = Tab:AddColorpicker({
        Name = Name,
        Default = Default or Color3.fromRGB(255, 0, 0),
        Flag = Name:gsub(" ", "_"),
        Save = true,
        Callback = function(Value)
            Callback(Value)
        end
    })
    return ColorPicker
end

-- ==================== ОСНОВНОЕ ОКНО ====================
function GUI:Create()
    local FloatingButton = GUI:CreateFloatingButton()
    
    local Window = OrionLib:MakeWindow({
        Name = "⭐ GUNS SCRIPT MENU ⭐",
        Subtitle = "By IlyaHacker",
        HidePremium = false,
        IntroEnabled = true,
        IntroText = "⭐ GUNS SCRIPT MENU ⭐",
        IntroIcon = "rbxassetid://4483345998",
        IntroSubtitle = "By IlyaHacker",
        ConfigFolder = "GunsScriptMenuByIlyaHacker"
    })
    
    -- Прячем окно
    Window.Hide()
    
    -- Обработчик кнопки ⭐
    local MenuOpen = false
    FloatingButton.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        
        if MenuOpen then
            Window.Show()
            FloatingButton.Text = "❌"
            FloatingButton.StatusLabel.Text = "ОТКРЫТО"
            FloatingButton.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            TweenService:Create(FloatingButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(180, 0, 0),
                Rotation = 180
            }):Play()
        else
            Window.Hide()
            FloatingButton.Text = "⭐"
            FloatingButton.StatusLabel.Text = "ЗАКРЫТО"
            FloatingButton.StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            TweenService:Create(FloatingButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Rotation = 0
            }):Play()
        end
    end)
    
    -- Вкладки
    local Tabs = {
        Weapons = Window:MakeTab({
            Name = "🔫 ОРУЖИЕ",
            Icon = "rbxassetid://4483345998"
        }),
        Armor = Window:MakeTab({
            Name = "🛡 БРОНЯ",
            Icon = "rbxassetid://4483346002"
        }),
        Uniform = Window:MakeTab({
            Name = "🎖 ФОРМА",
            Icon = "rbxassetid://4483346005"
        }),
        Headgear = Window:MakeTab({
            Name = "🎩 ГОЛОВНЫЕ УБОРЫ",
            Icon = "rbxassetid://4483346003"
        }),
        Vehicles = Window:MakeTab({
            Name = "🚁 ТЕХНИКА",
            Icon = "rbxassetid://4483346008"
        }),
        Radio = Window:MakeTab({
            Name = "📻 РАДИО",
            Icon = "rbxassetid://4483346007"
        }),
        Movement = Window:MakeTab({
            Name = "🏃 ДВИЖЕНИЕ",
            Icon = "rbxassetid://4483346006"
        }),
        Settings = Window:MakeTab({
            Name = "⚙ НАСТРОЙКИ",
            Icon = "rbxassetid://4483346010"
        })
    }
    
    local Colors = {
        Main = Color3.fromRGB(255, 0, 0),
        Secondary = Color3.fromRGB(180, 0, 0),
        Accent = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(25, 25, 25),
        Border = Color3.fromRGB(255, 100, 100)
    }
    
    return {
        Window = Window,
        Tabs = Tabs,
        Colors = Colors,
        FloatingButton = FloatingButton
    }
end

function GUI:Notify(Title, Message, Time)
    OrionLib:MakeNotification({
        Name = Title,
        Content = Message,
        Image = "rbxassetid://4483345998",
        Time = Time or 5
    })
end

return GUI