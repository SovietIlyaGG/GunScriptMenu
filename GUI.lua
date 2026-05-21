-- Guns Script Menu By IlyaHacker
-- GUI.lua - Интерфейс

local GUI = {}
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local cam = workspace.CurrentCamera

function GUI:CreateFloatingButton(parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(0, 20, 0, 300)
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = "⭐"
    btn.TextSize = 28
    btn.TextColor3 = Color3.fromRGB(255, 255, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    
    local drag, startPos, startInput = false, nil, nil
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; startInput = input.Position; startPos = btn.Position
            ts:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 65, 0, 65)}):Play()
        end
    end)
    
    uis.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - startInput
            btn.Position = UDim2.new(0, math.clamp(startPos.X.Offset + delta.X, 0, cam.ViewportSize.X - 60), 0, math.clamp(startPos.Y.Offset + delta.Y, 0, cam.ViewportSize.Y - 60))
        end
    end)
    
    uis.InputEnded:Connect(function(input)
        if drag then
            drag = false
            ts:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        end
    end)
    
    return btn
end

function GUI:Create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "GunsMenu"; gui.Parent = game.CoreGui; gui.ResetOnSpawn = false
    _G.GunsMenu = gui
    
    local floatBtn = GUI:CreateFloatingButton(gui)
    
    -- Главное окно
    local main = Instance.new("Frame")
    main.Name = "Main"; main.Size = UDim2.new(0, 350, 0, 500); main.Position = UDim2.new(0.5, -175, 0.5, -250)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); main.BorderSizePixel = 0; main.Visible = false; main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40); title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    title.Text = "⭐ GUNS SCRIPT MENU ⭐"; title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16; title.Font = Enum.Font.SourceSansBold; title.Parent = main
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20); subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundColor3 = Color3.fromRGB(180, 0, 0); subtitle.Text = "By IlyaHacker"
    subtitle.TextColor3 = Color3.fromRGB(255, 255, 255); subtitle.TextSize = 12
    subtitle.Font = Enum.Font.SourceSans; subtitle.Parent = main
    
    -- Вкладки (теперь только 4)
    local tabNames = {"ОРУЖИЕ", "БРОНЯ/ФОРМА", "ВЕРТОЛЁТ", "РАДИО"}
    local tabBtns, tabFrames = {}, {}
    
    for i, name in pairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 85, 0, 25); btn.Position = UDim2.new(0, (i-1)*87, 0, 62)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 9
        btn.Font = Enum.Font.SourceSansBold; btn.BorderSizePixel = 0; btn.Parent = main
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        tabBtns[i] = btn
        
        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, -10, 1, -95); frame.Position = UDim2.new(0, 5, 0, 90)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); frame.BorderSizePixel = 0
        frame.ScrollBarThickness = 5; frame.CanvasSize = UDim2.new(0, 0, 0, 600)
        frame.Visible = (i == 1); frame.Parent = main
        tabFrames[i] = frame
        
        btn.MouseButton1Click:Connect(function()
            for j, f in pairs(tabFrames) do
                f.Visible = (j == i)
                tabBtns[j].BackgroundColor3 = (j == i) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
            end
        end)
    end
    
    tabBtns[1].BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    -- Открытие/закрытие
    local open = false
    floatBtn.MouseButton1Click:Connect(function()
        open = not open; main.Visible = open
        floatBtn.Text = open and "❌" or "⭐"
    end)
    
    -- Кнопка выстрела
    local shootBtn = Instance.new("TextButton")
    shootBtn.Size = UDim2.new(0, 90, 0, 90); shootBtn.Position = UDim2.new(1, -110, 1, -200)
    shootBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0); shootBtn.Text = "ОГОНЬ"
    shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255); shootBtn.TextSize = 16
    shootBtn.Font = Enum.Font.SourceSansBold; shootBtn.BorderSizePixel = 0; shootBtn.Parent = gui
    Instance.new("UICorner", shootBtn).CornerRadius = UDim.new(1, 0)
    
    -- Круглые кнопки движения на экране
    local moveBtns = {}
    local moveNames = {"ПРИСЕД", "ЛЁЖА", "СТОЙКА"}
    local moveCallbacks = {}
    
    for i, name in pairs(moveNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 70, 0, 70)
        btn.Position = UDim2.new(0, 20, 0, 380 + (i-1)*80)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.SourceSansBold
        btn.BorderSizePixel = 0
        btn.Parent = gui
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        
        -- Белая обводка
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Parent = btn
        
        moveBtns[name] = btn
    end
    
    return {
        Gui = gui,
        Main = main,
        FloatBtn = floatBtn,
        ShootBtn = shootBtn,
        MoveBtns = moveBtns,
        TabFrames = tabFrames,
        AddButton = function(self, tabIdx, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Position = UDim2.new(0, 0, 0, #tabFrames[tabIdx]:GetChildren() * 38)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 14
            btn.Font = Enum.Font.SourceSans; btn.BorderSizePixel = 0; btn.Parent = tabFrames[tabIdx]
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            btn.MouseButton1Click:Connect(callback)
            tabFrames[tabIdx].CanvasSize = UDim2.new(0, 0, 0, #tabFrames[tabIdx]:GetChildren() * 38 + 10)
        end
    }
end

return GUI
