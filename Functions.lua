--[[
    ⭐ Guns Script Menu By IlyaHacker ⭐
    Functions Module - Все механики
    Версия: 4.0 Final
]]

local Functions = {}
local Player = game.Players.LocalPlayer
local RunService = game.RunService
local UserInputService = game.UserInputService
local TweenService = game.TweenService
local Camera = workspace.CurrentCamera
local GUI

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================
function Functions.Init(GUIInstance)
    GUI = GUIInstance
    
    Functions.SetupWeapons(GUI.Tabs.Weapons)
    Functions.SetupArmor(GUI.Tabs.Armor)
    Functions.SetupUniform(GUI.Tabs.Uniform)
    Functions.SetupHeadgear(GUI.Tabs.Headgear)
    Functions.SetupVehicles(GUI.Tabs.Vehicles)
    Functions.SetupRadio(GUI.Tabs.Radio)
    Functions.SetupMovement(GUI.Tabs.Movement)
    Functions.SetupSettings(GUI.Tabs.Settings)
    
    Functions.SetupShootButton()
end

-- ==================== ОРУЖИЕ ====================
Functions.CurrentWeapon = nil
Functions.WeaponModel = nil
Functions.Ammo = 30
Functions.MaxAmmo = 30

function Functions.CreateWeapon(Name, Config)
    local Tool = Instance.new("Tool")
    Tool.Name = Name
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false
    
    local Handle = Instance.new("Part")
    Handle.Size = Config.Size or Vector3.new(0.5, 2, 0.5)
    Handle.BrickColor = BrickColor.new(Config.Color or "Really black")
    Handle.Material = Config.Material or Enum.Material.Metal
    Handle.Name = "Handle"
    Handle.Parent = Tool
    Tool.Parent = Player.Backpack
    
    Tool.Activated:Connect(function()
        if Functions.Ammo > 0 then
            Functions.ShootWeapon(Config)
            Functions.Ammo = Functions.Ammo - 1
        end
    end)
    
    return Tool
end

function Functions.ShootWeapon(Config)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    local Bullet = Instance.new("Part")
    Bullet.Size = Config.BulletSize or Vector3.new(0.3, 0.3, 1.5)
    Bullet.BrickColor = BrickColor.new(Config.BulletColor or "Bright yellow")
    Bullet.Material = Config.BulletMaterial or Enum.Material.Neon
    Bullet.Anchored = true
    Bullet.CanCollide = false
    Bullet.Position = Root.Position + Vector3.new(0, 2, 0)
    Bullet.CFrame = CFrame.new(Bullet.Position, Root.Position + Root.CFrame.LookVector * 100)
    Bullet.Parent = workspace
    
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1,1,1) * 99999
    BV.Velocity = Bullet.CFrame.LookVector * (Config.Speed or 300)
    BV.Parent = Bullet
    
    Bullet.Touched:Connect(function(Hit)
        if Hit.Parent and Hit.Parent:FindFirstChild("Humanoid") and Hit.Parent ~= Char then
            Hit.Parent.Humanoid:TakeDamage(Config.Damage or 25)
            
            if Config.Explosive then
                local Explosion = Instance.new("Explosion")
                Explosion.Position = Bullet.Position
                Explosion.BlastRadius = Config.BlastRadius or 5
                Explosion.BlastPressure = 500
                Explosion.Parent = workspace
            end
        end
        Bullet:Destroy()
    end)
    
    game.Debris:AddItem(Bullet, 3)
end

function Functions.SetupWeapons(Tab)
    -- Секции
    GUI:CreateSection(Tab, "🔫 СТАНДАРТНОЕ ОРУЖИЕ")
    
    local StandardWeapons = {
        {"AK-47", {Damage = 25, Speed = 300, Color = "Dark stone grey"}},
        {"M4A1", {Damage = 22, Speed = 320, Color = "Really black"}},
        {"AWP", {Damage = 90, Speed = 500, Color = "Dark green"}},
        {"Desert Eagle", {Damage = 50, Speed = 350, Color = "Dark stone grey"}},
        {"P90", {Damage = 15, Speed = 350, Color = "Really black", BulletSize = Vector3.new(0.2, 0.2, 1)}},
        {"Remington 870", {Damage = 35, Speed = 200, Color = "Brown", BulletSize = Vector3.new(0.5, 0.5, 1), BulletColor = "Bright orange"}},
        {"M249 SAW", {Damage = 20, Speed = 350, Color = "Really black", BulletSize = Vector3.new(0.3, 0.3, 2)}},
        {"Barrett M82", {Damage = 100, Speed = 600, Color = "Dark stone grey", BulletSize = Vector3.new(0.5, 0.5, 3)}}
    }
    
    for _, weapon in pairs(StandardWeapons) do
        GUI:CreateButton(Tab, weapon[1], function()
            Functions.CurrentWeapon = weapon[1]
            Functions.CreateWeapon(weapon[1], weapon[2])
            Functions.Ammo = Functions.MaxAmmo
            GUI:Notify("Оружие", "Выбрано: " .. weapon[1], 3)
        end)
    end
    
    -- Half-Life оружие
    GUI:CreateSection(Tab, "🧪 HALF-LIFE ОРУЖИЕ")
    
    local HLWeapons = {
        {"Gauss Gun", {Damage = 50, Speed = 500, Color = "Really black", BulletColor = "Cyan", BulletMaterial = Enum.Material.Neon}},
        {"Shock Roach", {Damage = 15, Speed = 200, Color = "Bright orange", BulletColor = "Bright yellow"}},
        {"Spore Launcher", {Damage = 30, Speed = 100, Color = "Earth green", BulletColor = "Lime green", BulletMaterial = Enum.Material.Slime, Explosive = true, BlastRadius = 5}},
        {"Displacer Cannon", {Damage = 100, Speed = 400, Color = "Bright blue", BulletSize = Vector3.new(0.5, 0.5, 3), BulletColor = "Bright blue", BulletMaterial = Enum.Material.Neon, Explosive = true, BlastRadius = 10}},
        {"Barnacle Grapple", {Damage = 10, Speed = 300, Color = "Dark orange", BulletColor = "Bright red", BulletMaterial = Enum.Material.Slime}}
    }
    
    for _, weapon in pairs(HLWeapons) do
        GUI:CreateButton(Tab, weapon[1], function()
            Functions.CurrentWeapon = weapon[1]
            Functions.CreateWeapon(weapon[1], weapon[2])
            Functions.Ammo = Functions.MaxAmmo
            GUI:Notify("Half-Life", "Выбрано: " .. weapon[1], 3)
        end)
    end
    
    -- Пулемёты
    GUI:CreateSection(Tab, "💥 ПУЛЕМЁТЫ")
    
    local MGWeapons = {
        {"M60", {Damage = 30, Speed = 380, Color = "Really black", BulletSize = Vector3.new(0.3, 0.3, 2.5), BulletColor = "Bright orange"}},
        {"PKM", {Damage = 28, Speed = 370, Color = "Dark stone grey", BulletSize = Vector3.new(0.3, 0.3, 2.5)}},
        {"MG42", {Damage = 25, Speed = 400, Color = "Really black", BulletSize = Vector3.new(0.3, 0.3, 2)}},
        {"M134 Minigun", {Damage = 20, Speed = 450, Color = "Dark stone grey", BulletSize = Vector3.new(0.2, 0.2, 2), BulletColor = "Bright yellow", BulletMaterial = Enum.Material.Neon}}
    }
    
    for _, weapon in pairs(MGWeapons) do
        GUI:CreateButton(Tab, weapon[1], function()
            Functions.CurrentWeapon = weapon[1]
            Functions.CreateWeapon(weapon[1], weapon[2])
            Functions.Ammo = 200
            Functions.MaxAmmo = 200
            GUI:Notify("Пулемёт", "Выбрано: " .. weapon[1], 3)
        end)
    end
end

-- ==================== КНОПКА ВЫСТРЕЛА ====================
function Functions.SetupShootButton()
    local ShootButton = Instance.new("TextButton")
    ShootButton.Size = UDim2.new(0, 100, 0, 100)
    ShootButton.Position = UDim2.new(1, -120, 1, -220)
    ShootButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ShootButton.Text = "ОГОНЬ"
    ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShootButton.Font = Enum.Font.SourceSansBold
    ShootButton.TextSize = 18
    ShootButton.ZIndex = 10
    ShootButton.Parent = game.CoreGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = ShootButton
    
    ShootButton.MouseButton1Click:Connect(function()
        if Functions.CurrentWeapon and Functions.Ammo > 0 then
            if Functions.Ammo <= 0 then
                ShootButton.Text = "ПЕРЕЗАРЯДКА"
                wait(2)
                Functions.Ammo = Functions.MaxAmmo
                ShootButton.Text = "ОГОНЬ"
            end
        end
    end)
end

-- ==================== БРОНЯ ====================
function Functions.SetupArmor(Tab)
    GUI:CreateSection(Tab, "🛡 ТИПЫ БРОНИ")
    
    GUI:CreateButton(Tab, "Тяжёлая броня (150 HP)", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.MaxHealth = 150
            Humanoid.Health = 150
        end
        
        -- Бронежилет
        local Vest = Instance.new("Part")
        Vest.Name = "ArmorVest"
        Vest.Size = Vector3.new(2.5, 3, 1.2)
        Vest.BrickColor = BrickColor.new("Dark stone grey")
        Vest.Material = Enum.Material.Metal
        Vest.CanCollide = false
        Vest.Parent = Char
        
        local Torso = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
        if Torso then
            local Weld = Instance.new("Weld")
            Weld.Part0 = Torso
            Weld.Part1 = Vest
            Weld.Parent = Vest
        end
        
        GUI:Notify("Броня", "Тяжёлая броня надета!", 3)
    end)
    
    GUI:CreateButton(Tab, "Лёгкая броня (125 HP)", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.MaxHealth = 125
            Humanoid.Health = 125
        end
        GUI:Notify("Броня", "Лёгкая броня надета!", 3)
    end)
    
    GUI:CreateButton(Tab, "Снять броню (100 HP)", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.MaxHealth = 100
            Humanoid.Health = 100
        end
        
        for _, v in pairs(Char:GetChildren()) do
            if v.Name == "ArmorVest" or v.Name == "ArmorHelmet" then
                v:Destroy()
            end
        end
        GUI:Notify("Броня", "Броня снята!", 3)
    end)
end

-- ==================== ФОРМА ====================
function Functions.SetupUniform(Tab)
    GUI:CreateSection(Tab, "👕 ТЕЛЬНЯШКИ")
    
    local TelnyashkaTypes = {
        {"Голубая (ВДВ)", "White", "Bright blue"},
        {"Черная (Морская пехота)", "White", "Really black"},
        {"Краповая (Спецназ)", "White", "Bright red"},
        {"Зеленая (Погранцы)", "White", "Dark green"},
        {"Оранжевая (МЧС)", "White", "Bright orange"}
    }
    
    for _, tel in pairs(TelnyashkaTypes) do
        GUI:CreateButton(Tab, tel[1], function()
            local Char = Player.Character or Player.CharacterAdded:Wait()
            
            -- Удаляем старую
            for _, v in pairs(Char:GetChildren()) do
                if v.Name == "Telnyashka" then
                    v:Destroy()
                end
            end
            
            -- Создаём новую
            local Telnyashka = Instance.new("Part")
            Telnyashka.Name = "Telnyashka"
            Telnyashka.Size = Vector3.new(2.3, 1.5, 1.1)
            Telnyashka.BrickColor = BrickColor.new(tel[2])
            Telnyashka.Material = Enum.Material.Fabric
            Telnyashka.CanCollide = false
            Telnyashka.Parent = Char
            
            -- Полоски
            for i = -3, 3 do
                local Stripe = Instance.new("Part")
                Stripe.Size = Vector3.new(2.4, 0.15, 1.2)
                Stripe.BrickColor = BrickColor.new(tel[3])
                Stripe.Material = Enum.Material.Fabric
                Stripe.CanCollide = false
                Stripe.Parent = Telnyashka
                
                local Weld = Instance.new("Weld")
                Weld.Part0 = Telnyashka
                Weld.Part1 = Stripe
                Weld.C0 = CFrame.new(0, i * 0.2, 0)
                Weld.Parent = Stripe
            end
            
            local Torso = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
            if Torso then
                local Weld = Instance.new("Weld")
                Weld.Part0 = Torso
                Weld.Part1 = Telnyashka
                Weld.Parent = Telnyashka
            end
            
            GUI:Notify("Тельняшка", "Надета: " .. tel[1], 3)
        end)
    end
end

-- ==================== ГОЛОВНЫЕ УБОРЫ ====================
function Functions.SetupHeadgear(Tab)
    GUI:CreateSection(Tab, "🎨 БЕРЕТЫ")
    
    local BeretColors = {
        {"Краповый (Спецназ/СОБР)", "Bright red"},
        {"Черный (Морская пехота)", "Black"},
        {"Зеленый (ВВ/Пограничники)", "Dark green"},
        {"Голубой (ВДВ/Десант)", "Cyan"},
        {"Синий (ОМОН)", "Bright blue"},
        {"Оливковый (Спецназ ГРУ)", "Olive"},
        {"Коричневый (Спецназ)", "Brown"},
        {"Белый (Спецназ)", "White"}
    }
    
    for _, color in pairs(BeretColors) do
        GUI:CreateButton(Tab, color[1], function()
            local Char = Player.Character or Player.CharacterAdded:Wait()
            
            -- Удаляем старые
            for _, v in pairs(Char:GetChildren()) do
                if v.Name == "MilitaryHat" or v.Name == "Balaclava" or v.Name == "GasMask" then
                    v:Destroy()
                end
            end
            
            -- Создаём берет
            local Beret = Instance.new("Part")
            Beret.Name = "MilitaryHat"
            Beret.Size = Vector3.new(2.2, 0.8, 2.2)
            Beret.BrickColor = BrickColor.new(color[2])
            Beret.Material = Enum.Material.SmoothPlastic
            Beret.CanCollide = false
            Beret.Shape = Enum.PartType.Cylinder
            Beret.Parent = Char
            
            local Head = Char:FindFirstChild("Head")
            if Head then
                local Weld = Instance.new("Weld")
                Weld.Part0 = Head
                Weld.Part1 = Beret
                Weld.C0 = CFrame.new(0, 1.5, 0)
                Weld.Parent = Beret
            end
            
            GUI:Notify("Берет", "Надет: " .. color[1], 3)
        end)
    end
    
    GUI:CreateSection(Tab, "😷 БАЛАКЛАВА")
    
    local BalaclavaColors = {
        {"Черная", "Really black"},
        {"Оливковая", "Olive"},
        {"Темно-синяя", "Navy blue"},
        {"Серая", "Dark stone grey"},
        {"Зеленая", "Dark green"},
        {"Белая", "White"}
    }
    
    for _, color in pairs(BalaclavaColors) do
        GUI:CreateButton(Tab, color[1], function()
            local Char = Player.Character or Player.CharacterAdded:Wait()
            
            for _, v in pairs(Char:GetChildren()) do
                if v.Name == "MilitaryHat" or v.Name == "Balaclava" or v.Name == "GasMask" then
                    v:Destroy()
                end
            end
            
            local Balaclava = Instance.new("Part")
            Balaclava.Name = "Balaclava"
            Balaclava.Size = Vector3.new(1.8, 1.8, 1.8)
            Balaclava.BrickColor = BrickColor.new(color[2])
            Balaclava.Material = Enum.Material.Fabric
            Balaclava.CanCollide = false
            Balaclava.Parent = Char
            
            local Head = Char:FindFirstChild("Head")
            if Head then
                local Weld = Instance.new("Weld")
                Weld.Part0 = Head
                Weld.Part1 = Balaclava
                Weld.Parent = Balaclava
            end
            
            GUI:Notify("Балаклава", "Надета: " .. color[1], 3)
        end)
    end
    
    GUI:CreateSection(Tab, "🦠 ПРОТИВОГАЗ")
    
    GUI:CreateButton(Tab, "Противогаз (ХЛ стиль)", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        
        for _, v in pairs(Char:GetChildren()) do
            if v.Name == "MilitaryHat" or v.Name == "Balaclava" or v.Name == "GasMask" then
                v:Destroy()
            end
        end
        
        local GasMask = Instance.new("Model")
        GasMask.Name = "GasMask"
        GasMask.Parent = Char
        
        local Mask = Instance.new("Part")
        Mask.Size = Vector3.new(1.6, 1.4, 1.2)
        Mask.BrickColor = BrickColor.new("Olive")
        Mask.Material = Enum.Material.Metal
        Mask.CanCollide = false
        Mask.Parent = GasMask
        
        local Filter = Instance.new("Part")
        Filter.Size = Vector3.new(0.6, 1, 0.6)
        Filter.BrickColor = BrickColor.new("Dark green")
        Filter.Material = Enum.Material.Metal
        Filter.CanCollide = false
        Filter.Parent = GasMask
        
        local Head = Char:FindFirstChild("Head")
        if Head then
            local Weld = Instance.new("Weld")
            Weld.Part0 = Head
            Weld.Part1 = Mask
            Weld.C0 = CFrame.new(0, 0.2, 0.3)
            Weld.Parent = Mask
            
            local FilterWeld = Instance.new("Weld")
            FilterWeld.Part0 = Mask
            FilterWeld.Part1 = Filter
            FilterWeld.C0 = CFrame.new(0, -0.6, 0.4) * CFrame.Angles(math.rad(90), 0, 0)
            FilterWeld.Parent = Filter
        end
        
        GUI:Notify("Противогаз", "Надет!", 3)
    end)
end

-- ==================== ВЕРТОЛЁТЫ ====================
Functions.CurrentHelicopter = nil

function Functions.SetupVehicles(Tab)
    GUI:CreateSection(Tab, "🚁 ВЕРТОЛЁТЫ")
    
    local HelicopterList = {
        {"V-22 Osprey (10 мест)", "V-22_Osprey"},
        {"MI-24 Hind (6 мест + стрелок)", "MI-24_Hind"},
        {"MI-8 Hip (12 мест)", "MI-8_Hip"},
        {"UH-60 Black Hawk (8 мест + 2 стрелка)", "UH-60_BlackHawk"},
        {"UH-1 Huey (6 мест)", "UH-1_Huey"}
    }
    
    for _, heli in pairs(HelicopterList) do
        GUI:CreateButton(Tab, heli[1], function()
            if Functions.CurrentHelicopter then
                Functions.CurrentHelicopter:Destroy()
            end
            
            Functions.CreateHelicopter(heli[2])
            GUI:Notify("Вертолёт", "Вызван: " .. heli[1], 3)
        end)
    end
    
    GUI:CreateButton(Tab, "🚁 Взлететь", function()
        if Functions.CurrentHelicopter then
            local Primary = Functions.CurrentHelicopter:FindFirstChild("Body") or Functions.CurrentHelicopter.PrimaryPart
            if Primary then
                local BV = Instance.new("BodyVelocity")
                BV.Velocity = Vector3.new(0, 50, 0)
                BV.MaxForce = Vector3.new(0, 4000, 0)
                BV.Parent = Primary
                game.Debris:AddItem(BV, 2)
                GUI:Notify("Вертолёт", "Взлетаем!", 3)
            end
        end
    end)
    
    GUI:CreateButton(Tab, "⬇️ Посадить", function()
        if Functions.CurrentHelicopter then
            local Primary = Functions.CurrentHelicopter:FindFirstChild("Body") or Functions.CurrentHelicopter.PrimaryPart
            if Primary then
                local BV = Instance.new("BodyVelocity")
                BV.Velocity = Vector3.new(0, -20, 0)
                BV.MaxForce = Vector3.new(0, 4000, 0)
                BV.Parent = Primary
                game.Debris:AddItem(BV, 3)
                GUI:Notify("Вертолёт", "Садимся!", 3)
            end
        end
    end)
    
    GUI:CreateButton(Tab, "💥 Уничтожить", function()
        if Functions.CurrentHelicopter then
            local Explosion = Instance.new("Explosion")
            Explosion.Position = Functions.CurrentHelicopter:FindFirstChild("Body") and Functions.CurrentHelicopter.Body.Position or Vector3.new(0, 0, 0)
            Explosion.BlastRadius = 15
            Explosion.BlastPressure = 500
            Explosion.Parent = workspace
            
            Functions.CurrentHelicopter:Destroy()
            Functions.CurrentHelicopter = nil
            GUI:Notify("Вертолёт", "Уничтожен!", 3)
        end
    end)
end

function Functions.CreateHelicopter(Type)
    local Heli = Instance.new("Model")
    Heli.Name = Type
    Heli.Parent = workspace
    
    local Body = Instance.new("Part")
    Body.Name = "Body"
    Body.Size = Vector3.new(4, 2, 8)
    Body.BrickColor = BrickColor.new("Dark stone grey")
    Body.Material = Enum.Material.Metal
    Body.Anchored = false
    Body.CanCollide = true
    Body.Parent = Heli
    
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if Root then
        Body.Position = Root.Position + Vector3.new(0, 15, 0)
    end
    
    Heli.PrimaryPart = Body
    Functions.CurrentHelicopter = Heli
    
    -- Добавляем пилотское место
    local Seat = Instance.new("Seat")
    Seat.Size = Vector3.new(2, 1, 2)
    Seat.Parent = Heli
    
    local SeatWeld = Instance.new("Weld")
    SeatWeld.Part0 = Body
    SeatWeld.Part1 = Seat
    SeatWeld.C0 = CFrame.new(0, 0, 2)
    SeatWeld.Parent = Seat
end

-- ==================== РАДИО ====================
function Functions.SetupRadio(Tab)
    GUI:CreateSection(Tab, "🎵 ПЛЕЕР")
    
    GUI:CreateButton(Tab, "▶️ Включить радио", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        
        local Radio = Instance.new("Part")
        Radio.Name = "MilitaryRadio"
        Radio.Size = Vector3.new(0.6, 0.8, 0.4)
        Radio.BrickColor = BrickColor.new("Really black")
        Radio.Material = Enum.Material.Metal
        Radio.CanCollide = false
        Radio.Parent = Char
        
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://1845551945" -- Гимн СССР
        Sound.Volume = 0.8
        Sound.MaxDistance = 50
        Sound.Parent = Radio
        Sound:Play()
        
        local Torso = Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
        if Torso then
            local Weld = Instance.new("Weld")
            Weld.Part0 = Torso
            Weld.Part1 = Radio
            Weld.C0 = CFrame.new(0.5, 0.5, 0)
            Weld.Parent = Radio
        end
        
        GUI:Notify("Радио", "Играет: Гимн СССР", 3)
    end)
    
    GUI:CreateButton(Tab, "⏹️ Выключить радио", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Radio = Char:FindFirstChild("MilitaryRadio")
        if Radio then
            Radio:Destroy()
            GUI:Notify("Радио", "Выключено", 3)
        end
    end)
end

-- ==================== ДВИЖЕНИЕ ====================
function Functions.SetupMovement(Tab)
    GUI:CreateSection(Tab, "🏃 СТОЙКИ")
    
    GUI:CreateButton(Tab, "Присесть", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.HipHeight = 1
            Humanoid.WalkSpeed = 8
            GUI:Notify("Движение", "Присед", 2)
        end
    end)
    
    GUI:CreateButton(Tab, "Лечь", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.HipHeight = 0.5
            Humanoid.WalkSpeed = 3
            GUI:Notify("Движение", "Положение лёжа", 2)
        end
    end)
    
    GUI:CreateButton(Tab, "Встать", function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.HipHeight = 2
            Humanoid.WalkSpeed = 16
            GUI:Notify("Движение", "Стойка", 2)
        end
    end)
    
    GUI:CreateSection(Tab, "⚡ СКОРОСТЬ")
    
    GUI:CreateSlider(Tab, "Скорость ходьбы", 16, 100, 16, function(Value)
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end)
    
    GUI:CreateSlider(Tab, "Высота прыжка", 50, 200, 50, function(Value)
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end)
end

-- ==================== НАСТРОЙКИ ====================
function Functions.SetupSettings(Tab)
    GUI:CreateSection(Tab, "⚙ ОСНОВНЫЕ")
    
    GUI:CreateButton(Tab, "🔄 Перезагрузить скрипт", function()
        _G.GunsScriptMenuLoaded = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SovietIlyaGG/GunsScriptMenu/main/Main.lua"))()
    end)
    
    GUI:CreateButton(Tab, "❌ Закрыть меню", function()
        GUI.Window:Hide()
        GUI.FloatingButton.Text = "⭐"
        GUI.FloatingButton.StatusLabel.Text = "ЗАКРЫТО"
    end)
    
    GUI:CreateButton(Tab, "ℹ️ О скрипте", function()
        GUI:Notify("Guns Script Menu", "Версия 4.0 By IlyaHacker", 5)
    end)
end

return Functions