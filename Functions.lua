-- Guns Script Menu By IlyaHacker
-- Functions.lua - Все механики

local Functions = {}
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local animator = hum:WaitForChild("Animator")
local curWep, curHeli, ammo, maxAmmo = nil, nil, 30, 30

-- ==================== ОРУЖИЕ ====================
local function createWep(name, dmg, spd, col, bcol)
    local t = Instance.new("Tool"); t.Name = name; t.CanBeDropped = false
    local h = Instance.new("Part"); h.Size = Vector3.new(0.5,2,0.5)
    h.BrickColor = BrickColor.new(col or "Really black"); h.Material = Enum.Material.Metal; h.Parent = t
    t.Parent = plr.Backpack
    t.Activated:Connect(function()
        if ammo <= 0 then return end; ammo -= 1
        local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
        local b = Instance.new("Part"); b.Size = Vector3.new(0.3,0.3,1.5)
        b.BrickColor = BrickColor.new(bcol or "Bright yellow"); b.Material = Enum.Material.Neon
        b.Anchored = true; b.CanCollide = false; b.Position = r.Position + Vector3.new(0,2,0)
        b.CFrame = CFrame.new(b.Position, r.Position + r.CFrame.LookVector * 100); b.Parent = workspace
        local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(1,1,1)*99999
        bv.Velocity = b.CFrame.LookVector * (spd or 300); bv.Parent = b
        b.Touched:Connect(function(hit)
            if hit.Parent and hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= c then
                hit.Parent.Humanoid:TakeDamage(dmg or 25)
            end; b:Destroy()
        end)
        game.Debris:AddItem(b, 3)
    end)
    return t
end

-- ==================== БРОНЯ ====================
local function equipArmor()
    local c = plr.Character; if not c then return end
    for _, v in pairs(c:GetChildren()) do
        if v.Name == "ArmorVest" then v:Destroy() end
    end
    local v = Instance.new("Part"); v.Name = "ArmorVest"; v.Size = Vector3.new(2.5,3,1.2)
    v.BrickColor = BrickColor.new("Dark stone grey"); v.Material = Enum.Material.Metal
    v.CanCollide = false; v.Parent = c
    local torso = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    if torso then
        local w = Instance.new("Weld"); w.Part0 = torso; w.Part1 = v; w.Parent = v
    end
    hum.MaxHealth = 150; hum.Health = 150
end

local function removeArmor()
    local c = plr.Character; if not c then return end
    for _, v in pairs(c:GetChildren()) do
        if v.Name == "ArmorVest" then v:Destroy() end
    end
    hum.MaxHealth = 100; hum.Health = 100
end

-- ==================== ФОРМА (ТЕЛЬНЯШКИ) ====================
local function createTelnyashka(color, stripeColor)
    local c = plr.Character; if not c then return end
    for _, v in pairs(c:GetChildren()) do
        if v.Name == "Telnyashka" then v:Destroy() end
    end
    local tel = Instance.new("Part"); tel.Name = "Telnyashka"
    tel.Size = Vector3.new(2.3, 1.5, 1.1); tel.BrickColor = BrickColor.new(color)
    tel.Material = Enum.Material.Fabric; tel.CanCollide = false; tel.Parent = c
    for i = -3, 3 do
        local stripe = Instance.new("Part")
        stripe.Size = Vector3.new(2.4, 0.15, 1.2); stripe.BrickColor = BrickColor.new(stripeColor)
        stripe.Material = Enum.Material.Fabric; stripe.CanCollide = false; stripe.Parent = tel
        local w = Instance.new("Weld"); w.Part0 = tel; w.Part1 = stripe
        w.C0 = CFrame.new(0, i * 0.2, 0); w.Parent = stripe
    end
    local torso = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    if torso then
        local w = Instance.new("Weld"); w.Part0 = torso; w.Part1 = tel; w.Parent = tel
    end
end

-- ==================== ГОЛОВНЫЕ УБОРЫ ====================
local function createBeret(color)
    local c = plr.Character; if not c then return end
    for _, v in pairs(c:GetChildren()) do
        if v.Name == "Beret" or v.Name == "Balaclava" then v:Destroy() end
    end
    local b = Instance.new("Part"); b.Name = "Beret"
    b.Size = Vector3.new(2.2, 0.8, 2.2); b.BrickColor = BrickColor.new(color)
    b.Material = Enum.Material.SmoothPlastic; b.CanCollide = false
    b.Shape = Enum.PartType.Cylinder; b.Parent = c
    local head = c:FindFirstChild("Head")
    if head then
        local w = Instance.new("Weld"); w.Part0 = head; w.Part1 = b
        w.C0 = CFrame.new(0, 1.5, 0); w.Parent = b
    end
end

local function createBalaclava(color)
    local c = plr.Character; if not c then return end
    for _, v in pairs(c:GetChildren()) do
        if v.Name == "Beret" or v.Name == "Balaclava" then v:Destroy() end
    end
    local b = Instance.new("Part"); b.Name = "Balaclava"
    b.Size = Vector3.new(1.8, 1.8, 1.8); b.BrickColor = BrickColor.new(color)
    b.Material = Enum.Material.Fabric; b.CanCollide = false; b.Parent = c
    local head = c:FindFirstChild("Head")
    if head then
        local w = Instance.new("Weld"); w.Part0 = head; w.Part1 = b; w.Parent = b
    end
end

-- ==================== ВЕРТОЛЁТ ====================
local function createHeli()
    if curHeli then curHeli:Destroy() end
    local c = plr.Character; local r = c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
    local heli = Instance.new("Model"); heli.Name = "Helicopter"; heli.Parent = workspace
    local body = Instance.new("Part"); body.Name = "Body"; body.Size = Vector3.new(4,2,8)
    body.BrickColor = BrickColor.new("Dark stone grey"); body.Material = Enum.Material.Metal
    body.Anchored = false; body.CanCollide = true; body.Parent = heli
    local rotor = Instance.new("Part"); rotor.Size = Vector3.new(12,0.3,0.8)
    rotor.BrickColor = BrickColor.new("Really black"); rotor.Material = Enum.Material.Metal
    rotor.Anchored = false; rotor.CanCollide = false; rotor.Parent = heli
    local rw = Instance.new("Weld"); rw.Part0 = body; rw.Part1 = rotor
    rw.C0 = CFrame.new(0, 1.5, 0); rw.Parent = rotor
    local seat = Instance.new("Seat"); seat.Size = Vector3.new(2,1,2)
    seat.Anchored = false; seat.CanCollide = true; seat.Parent = heli
    local sw = Instance.new("Weld"); sw.Part0 = body; sw.Part1 = seat
    sw.C0 = CFrame.new(0, 0, 2); sw.Parent = seat
    body.Position = r.Position + Vector3.new(0, 15, 0)
    heli.PrimaryPart = body; curHeli = heli
    spawn(function()
        while curHeli == heli do
            rotor.CFrame = rotor.CFrame * CFrame.Angles(0, math.rad(15), 0)
            wait(0.01)
        end
    end)
end

-- ==================== РАДИО ====================
local function playRadio()
    local c = plr.Character; if not c then return end
    local radio = c:FindFirstChild("Radio")
    if radio then radio:Destroy() end
    radio = Instance.new("Part"); radio.Name = "Radio"
    radio.Size = Vector3.new(0.6, 0.8, 0.4); radio.BrickColor = BrickColor.new("Really black")
    radio.Material = Enum.Material.Metal; radio.CanCollide = false; radio.Parent = c
    local sound = Instance.new("Sound"); sound.SoundId = "rbxassetid://1845551945"
    sound.Volume = 0.8; sound.MaxDistance = 50; sound.Parent = radio; sound:Play()
    local torso = c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    if torso then
        local w = Instance.new("Weld"); w.Part0 = torso; w.Part1 = radio
        w.C0 = CFrame.new(0.5, 0.5, 0); w.Parent = radio
    end
end

-- ==================== АНИМАЦИИ ДВИЖЕНИЯ (ОРИГИНАЛЬНЫЕ) ====================
local function playAnim(id)
    local c = plr.Character; if not c then return end
    local hum = c:FindFirstChild("Humanoid"); if not hum then return end
    local animator = hum:FindFirstChild("Animator"); if not animator then return end
    
    -- Останавливаем все текущие анимации
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        track:Stop(0.1)
    end
    
    if id == 0 then return end -- Стойка (сброс)
    
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    local track = animator:LoadAnimation(anim)
    track:Play()
end

local function setStance(stance)
    local c = plr.Character; if not c then return end
    local hum = c:FindFirstChild("Humanoid"); if not hum then return end
    
    if stance == "Crouch" then
        hum.HipHeight = 1
        hum.WalkSpeed = 8
        playAnim(507765000) -- Присед анимация
    elseif stance == "Prone" then
        hum.HipHeight = 0.5
        hum.WalkSpeed = 3
        playAnim(507770000) -- Лёжа анимация
    else
        hum.HipHeight = 2
        hum.WalkSpeed = 16
        playAnim(0) -- Сброс анимаций (стойка)
    end
end

-- ==================== ИНИЦИАЛИЗАЦИЯ ====================
function Functions.Init(GUI)
    -- Вкладка 1: Оружие
    local weapons = {
        {"AK-47", 25, 300, "Dark stone grey", "Bright yellow"},
        {"M4A1", 22, 320, "Really black", "Bright yellow"},
        {"AWP", 90, 500, "Dark green", "Bright yellow"},
        {"Desert Eagle", 50, 350, "Dark stone grey", "Bright orange"},
        {"P90", 15, 350, "Really black", "Bright yellow"},
        {"M249 SAW", 20, 350, "Really black", "Bright orange"},
        {"СВД", 70, 450, "Brown", "Bright yellow"},
        {"FGM-148 Javelin", 100, 200, "Dark green", "Bright red"}
    }
    
    for _, w in pairs(weapons) do
        GUI:AddButton(1, w[1], function()
            curWep = w[1]; createWep(w[1], w[2], w[3], w[4], w[5])
            if w[1] == "M249 SAW" then ammo = 200; maxAmmo = 200
            elseif w[1] == "FGM-148 Javelin" then ammo = 1; maxAmmo = 1
            else ammo = 30; maxAmmo = 30 end
        end)
    end
    
    GUI:AddButton(1, "Перезарядка", function()
        ammo = maxAmmo
    end)
    
    -- Вкладка 2: Броня/Форма/Головные
    GUI:AddButton(2, "Тяжёлая броня (150 HP)", equipArmor)
    GUI:AddButton(2, "Снять броню", removeArmor)
    
    GUI:AddButton(2, "--- ТЕЛЬНЯШКИ ---", function() end)
    
    local telnyashki = {
        {"Голубая (ВДВ)", "White", "Bright blue"},
        {"Черная (Морпех)", "White", "Really black"},
        {"Краповая (Спецназ)", "White", "Bright red"},
        {"Зеленая (Погранцы)", "White", "Dark green"}
    }
    
    for _, t in pairs(telnyashki) do
        GUI:AddButton(2, t[1], function() createTelnyashka(t[2], t[3]) end)
    end
    
    GUI:AddButton(2, "--- БЕРЕТЫ ---", function() end)
    
    local berets = {
        {"Краповый (Спецназ)", "Bright red"},
        {"Черный (Морпех)", "Black"},
        {"Зеленый (ВВ)", "Dark green"},
        {"Голубой (ВДВ)", "Cyan"},
        {"Синий (ОМОН)", "Bright blue"},
        {"Оливковый (ГРУ)", "Olive"}
    }
    
    for _, b in pairs(berets) do
        GUI:AddButton(2, b[1], function() createBeret(b[2]) end)
    end
    
    GUI:AddButton(2, "--- БАЛАКЛАВЫ ---", function() end)
    
    local balaclavas = {
        {"Черная", "Really black"},
        {"Оливковая", "Olive"},
        {"Темно-синяя", "Navy blue"},
        {"Белая", "White"}
    }
    
    for _, b in pairs(balaclavas) do
        GUI:AddButton(2, b[1], function() createBalaclava(b[2]) end)
    end
    
    -- Вкладка 3: Вертолёт
    GUI:AddButton(3, "Вызвать вертолёт", createHeli)
    GUI:AddButton(3, "Взлететь", function()
        if curHeli then
            local body = curHeli:FindFirstChild("Body")
            if body then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 50, 0)
                bv.MaxForce = Vector3.new(0, 4000, 0)
                bv.Parent = body
                game.Debris:AddItem(bv, 2)
            end
        end
    end)
    GUI:AddButton(3, "Уничтожить", function()
        if curHeli then curHeli:Destroy(); curHeli = nil end
    end)
    
    -- Вкладка 4: Радио
    GUI:AddButton(4, "Включить радио", playRadio)
    GUI:AddButton(4, "Выключить радио", function()
        local c = plr.Character
        if c then
            local radio = c:FindFirstChild("Radio")
            if radio then radio:Destroy() end
        end
    end)
    
    -- Кнопки движения на экране
    GUI.MoveBtns["ПРИСЕД"].MouseButton1Click:Connect(function()
        setStance("Crouch")
    end)
    
    GUI.MoveBtns["ЛЁЖА"].MouseButton1Click:Connect(function()
        setStance("Prone")
    end)
    
    GUI.MoveBtns["СТОЙКА"].MouseButton1Click:Connect(function()
        setStance("Stand")
    end)
    
    -- Обновление кнопки выстрела
    GUI.ShootBtn.MouseButton1Click:Connect(function()
        if ammo <= 0 then
            GUI.ShootBtn.Text = "ПЕРЕЗАРЯДКА"
            wait(2)
            ammo = maxAmmo
            GUI.ShootBtn.Text = "ОГОНЬ"
        end
    end)
end

return Functions
