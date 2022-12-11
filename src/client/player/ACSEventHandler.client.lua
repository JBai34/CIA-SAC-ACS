local Player = game.Players.LocalPlayer
local mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local User = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local Run = game:GetService("RunService")
local TS = game:GetService('TweenService')
local Debris = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")

local RS = game:GetService("ReplicatedStorage")
local ACS_Workspace = workspace:WaitForChild("ACS_WorkSpace")
local Engine = RS:WaitForChild("ACS_Engine")
local Evt = Engine:WaitForChild("Events")
local Mods = Engine:WaitForChild("Modules")
local HUDs = Engine:WaitForChild("HUD")
local ArmModel = Engine:WaitForChild("ArmModel")
local GunModels = Engine:WaitForChild("GunModels")
local AttModels = Engine:WaitForChild("AttModels")
local AttModules = Engine:WaitForChild("AttModules")
local Rules = Engine:WaitForChild("GameRules")
local PastaFx = Engine:WaitForChild("FX")

local gameRules = require(Rules:WaitForChild("Config"))
local SpringMod = require(Mods:WaitForChild("Spring"))
local HitMod = require(Mods:WaitForChild("Hitmarker"))
local Ultil = require(Mods:WaitForChild("Utilities"))

local WhizzSound = {
    "4872110675",
    "5303773495",
    "5303772965",
    "5303773495",
    "5303772257",
    "342190005",
    "342190012",
    "342190017",
    "342190024"
}
local Ignore_Model = {
    Camera,
    Player.Character,
    ACS_Workspace.Client,
    ACS_Workspace.Server
}

local NVG = false
----------//Local Events\\----------
Evt.NVG.Event:Connect(function(Value) NVG = Value end)
-------------//Events\\-------------
Evt.HitEffect.OnClientEvent:Connect(function(player, Position, HitPart, Normal,
                                             Material, Settings)
    if Player ~= Player then
        HitMod.HitEffect(Ignore_Model, Position, HitPart, Normal, Material,
                         Settings)
    end
end)

Evt.Atirar.OnClientEvent:Connect(function(player, Arma, Suppressor, FlashHider)
    if player ~= Player and Arma then
        if player.Character:FindFirstChild("S" .. Arma.Name) and
            player.Character:FindFirstChild('S' .. Arma.Name).Handle:FindFirstChild(
                "Muzzle") then
            local Muzzle = player.Character:FindFirstChild("S" .. Arma.Name)
                               .Handle.Muzzle

            if Suppressor then
                Muzzle.Supressor:Play()
            else
                Muzzle.Fire:Play()
            end

            if FlashHider then
                Muzzle["Smoke"]:Emit(10)
            else
                Muzzle["FlashFX[Flash]"]:Emit(10)
                Muzzle["Smoke"]:Emit(10)
            end
        end

        if player.Character:FindFirstChild("AnimBase") ~= nil and
            player.Character.AnimBase:FindFirstChild("AnimBaseW") then
            local AnimBase = player.Character:WaitForChild("AnimBase")
                                 :WaitForChild("AnimBaseW")
            TS:Create(AnimBase,
                      TweenInfo.new(0.05, Enum.EasingStyle.Sine,
                                    Enum.EasingDirection.InOut, 0, false, 0),
                      {C1 = CFrame.new(0, 0, 0.15):Inverse()}):Play()
            task.delay(.1, function()
                TS:Create(AnimBase,
                          TweenInfo.new(.05, Enum.EasingStyle.Sine,
                                        Enum.EasingDirection.InOut, 0, false, 0),
                          {C1 = CFrame.new():Inverse()}):Play()
            end)
        end
    end
end)

Evt.SVLaser.OnClientEvent:Connect(
    function(player, Position, Modo, Cor, IR, Arma)

        if player ~= Player and player.Character and Arma then

            if ACS_Workspace.Server:FindFirstChild(player.Name .. "_Laser") ==
                nil then
                local Dot = Instance.new('Part', ACS_Workspace.Server)
                local Att0 = Instance.new('Attachment', Dot)
                Att0.Name = "Att0"
                Dot.Name = player.Name .. "_Laser"
                Dot.Transparency = 1

                if player.Character:FindFirstChild("S" .. Arma.Name) and
                    player.Character:FindFirstChild('S' .. Arma.Name).Handle:FindFirstChild(
                        "Muzzle") then
                    local Muzzle =
                        player.Character:FindFirstChild("S" .. Arma.Name).Handle
                            .Muzzle

                    local Laser = Instance.new('Beam', Dot)
                    Laser.Transparency = NumberSequence.new(0)
                    Laser.LightEmission = 1
                    Laser.LightInfluence = 0
                    Laser.Attachment0 = Att0
                    Laser.Attachment1 = Muzzle
                    Laser.Color = ColorSequence.new(Cor)
                    Laser.FaceCamera = true
                    Laser.Width0 = 0.01
                    Laser.Width1 = 0.01
                    if not NVG then Laser.Enabled = false end
                end
            end

            if Modo == 1 then
                if ACS_Workspace.Server:FindFirstChild(Player.Name .. "_Laser") then
                    local LA =
                        ACS_Workspace.Server:FindFirstChild(Player.Name ..
                                                                "_Laser")
                    LA.Shape = 'Ball'
                    LA.Size = Vector3.new(0.2, 0.2, 0.2)
                    LA.CanCollide = false
                    LA.Anchored = true
                    LA.Color = Cor
                    LA.Material = Enum.Material.Neon
                    LA.Position = Position
                    if NVG then
                        LA.Transparency = 0

                        if LA:FindFirstChild("Beam") then
                            LA.Beam.Enabled = true
                        end
                    else
                        if IR then
                            LA.Transparency = 1
                        else
                            LA.Transparency = 0
                        end

                        if LA:FindFirstChild("Beam") then
                            LA.Beam.Enabled = false
                        end
                    end
                end

            elseif Modo == 2 then
                if ACS_Workspace.Server:FindFirstChild(Player.Name .. "_Laser") then
                    ACS_Workspace.Server:FindFirstChild(Player.Name .. "_Laser")
                        :Destroy()
                end
            end
        end
    end)

Evt.SVFlash.OnClientEvent:Connect(function(player, Arma, Mode)

    if player ~= Player and player.Character and Arma then
        local Weapon = player.Character:FindFirstChild("S" .. Arma.Name)
        if Weapon then
            if Mode then
                for _, Key in pairs(Weapon:GetDescendants()) do
                    if Key:IsA("BasePart") and Key.Name == "FlashPoint" then
                        Key.Light.Enabled = true
                    end
                end
            else
                for _, Key in pairs(Weapon:GetDescendants()) do
                    if Key:IsA("BasePart") and Key.Name == "FlashPoint" then
                        Key.Light.Enabled = false
                    end
                end
            end
        end
    end
end)

Evt.Whizz.OnClientEvent:Connect(function()

    local Som = Instance.new('Sound')
    Som.Parent = Player.PlayerGui
    Som.SoundId = "rbxassetid://" .. WhizzSound[math.random(1, #WhizzSound)]
    Som.Volume = 2
    Som.PlayOnRemove = true
    Som:Destroy()

end)

Evt.MedSys.MedHandler.OnClientEvent:Connect(function(Mode)

    if Mode == 4 then
        local FX = Instance.new('ColorCorrectionEffect')
        FX.Parent = Camera

        TS:Create(FX, TweenInfo.new(.15, Enum.EasingStyle.Linear),
                  {Contrast = -.25}):Play()
        task.delay(.15, function()
            TS:Create(FX,
                      TweenInfo.new(1.5, Enum.EasingStyle.Sine,
                                    Enum.EasingDirection.In, 0, false, 0.15),
                      {Contrast = 0}):Play()
            Debris:AddItem(FX, 1.5)
        end)

    elseif Mode == 5 then
        local FX = Instance.new('ColorCorrectionEffect')
        FX.Parent = Camera

        TS:Create(FX, TweenInfo.new(.15, Enum.EasingStyle.Linear),
                  {Contrast = .5}):Play()
        task.delay(.15, function()
            TS:Create(FX,
                      TweenInfo.new(1.5, Enum.EasingStyle.Sine,
                                    Enum.EasingDirection.In, 0, false, 0.15),
                      {Contrast = 0}):Play()
            Debris:AddItem(FX, 1.5)
        end)

    elseif Mode == 6 then
        local FX = Instance.new('ColorCorrectionEffect')
        FX.Parent = Camera

        TS:Create(FX, TweenInfo.new(.15, Enum.EasingStyle.Linear),
                  {Contrast = -.25}):Play()
        task.delay(.15, function()
            TS:Create(FX,
                      TweenInfo.new(60, Enum.EasingStyle.Sine,
                                    Enum.EasingDirection.In, 0, false, 0.15),
                      {Contrast = 0}):Play()
            Debris:AddItem(FX, 60)
        end)

    elseif Mode == 7 then
        local FX = Instance.new('ColorCorrectionEffect')
        FX.Parent = Camera

        TS:Create(FX, TweenInfo.new(.15, Enum.EasingStyle.Linear),
                  {Contrast = .5}):Play()
        task.delay(.15, function()
            TS:Create(FX,
                      TweenInfo.new(30, Enum.EasingStyle.Sine,
                                    Enum.EasingDirection.In, 0, false, 0.15),
                      {Contrast = 0}):Play()
            Debris:AddItem(FX, 30)
        end)
    end

end)

Evt.Suppression.OnClientEvent:Connect(function(Mode, Intensity, Tempo)
    local SE_GUI = Player.PlayerGui:FindFirstChild("StatusUI")
    if Player.Character and Player.Character.Humanoid.Health > 0 and SE_GUI then
        if Mode == 1 then

            TS:Create(SE_GUI.Efeitos.Suppress, TweenInfo.new(.1),
                      {ImageTransparency = 0, Size = UDim2.fromScale(1, 1.15)})
                :Play()
            task.delay(.1, function()
                TS:Create(SE_GUI.Efeitos.Suppress,
                          TweenInfo.new(1, Enum.EasingStyle.Exponential,
                                        Enum.EasingDirection.InOut, 0, false,
                                        0.15),
                          {ImageTransparency = 1, Size = UDim2.fromScale(2, 2)})
                    :Play()
            end)
        elseif Mode == 2 then

            local ring = PastaFx.EarRing:Clone()
            ring.Parent = Player.PlayerGui
            ring.Volume = 0
            ring:Play()
            Debris:AddItem(ring, Tempo)

            TS:Create(ring, TweenInfo.new(.1), {Volume = 2}):Play()
            task.delay(.1, function()
                TS:Create(ring,
                          TweenInfo.new(Tempo, Enum.EasingStyle.Linear,
                                        Enum.EasingDirection.InOut, 0, false,
                                        0.15), {Volume = 0}):Play()
            end)

            TS:Create(SE_GUI.Efeitos.Dirty, TweenInfo.new(.1),
                      {ImageTransparency = 0, Size = UDim2.fromScale(1, 1.15)})
                :Play()
            task.delay(.1, function()
                TS:Create(SE_GUI.Efeitos.Dirty,
                          TweenInfo.new(Tempo, Enum.EasingStyle.Exponential,
                                        Enum.EasingDirection.InOut, 0, false,
                                        0.15),
                          {ImageTransparency = 1, Size = UDim2.fromScale(2, 2)})
                    :Play()
            end)

        else

            local ring = PastaFx.EarRing:Clone()
            ring.Parent = Player.PlayerGui
            ring.Volume = 0
            ring:Play()
            Debris:AddItem(ring, Tempo)

            TS:Create(ring, TweenInfo.new(.1), {Volume = 2}):Play()
            task.delay(.1, function()
                TS:Create(ring,
                          TweenInfo.new(Tempo, Enum.EasingStyle.Linear,
                                        Enum.EasingDirection.InOut, 0, false,
                                        0.15), {Volume = 0}):Play()
            end)
        end
    end
end)

Evt.GunStance.OnClientEvent:Connect(function(player, stance, Data)
    if player.Character.Humanoid.Health > 0 and
        player.Character:FindFirstChild("AnimBase") ~= nil and
        player.Character.AnimBase:FindFirstChild("RAW") ~= nil and
        player.Character.AnimBase:FindFirstChild("LAW") ~= nil then

        local rightArmWeld = player.Character.AnimBase:WaitForChild("RAW")
        local leftArmWeld = player.Character.AnimBase:WaitForChild("LAW")

        local rightElbowWeld = player.Character.AnimBase:WaitForChild("RLAW")
        local leftElbowWeld = player.Character.AnimBase:WaitForChild("LLAW")

        local rightHandWeld = player.Character.AnimBase:WaitForChild("RHW")
        local leftHandWeld = player.Character.AnimBase:WaitForChild("LHW")

        local RECFrame = CFrame.new(0,
                                    player.Character.RightUpperArm.Size.Y / 2, 0)
        local RWCFrame = CFrame.new(0, player.Character.RightLowerArm.Size.Y /
                                        1.9, 0)

        local LECFrame = CFrame.new(0, player.Character.LeftUpperArm.Size.Y / 2,
                                    0)
        local LWCFrame = CFrame.new(0,
                                    player.Character.LeftLowerArm.Size.Y / 1.9,
                                    0)

        if stance == 0 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.SV_RightArmPos}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.SV_rightElbowWeldPos}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.SV_rightHandWeldPos}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.SV_LeftArmPos}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.SV_leftElbowWeldPos}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.SV_leftHandWeldPos}):Play()

        elseif stance == 2 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.RightAim}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.rightElbowWeldAim}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.rightHandWeldAim}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.LeftAim}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.leftElbowWeldAim}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.leftHandWeldAim}):Play()

        elseif stance == 1 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.RightHighReady}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.rightElbowWeldHighReady}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.rightHandWeldHighReady}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.LeftHighReady}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.leftElbowWeldHighReady}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.leftHandWeldHighReady}):Play()

        elseif stance == -1 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.RightLowReady}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.rightElbowWeldLowReady}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.rightHandWeldLowReady}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.LeftLowReady}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.leftElbowWeldLowReady}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.leftHandWeldLowReady}):Play()

        elseif stance == -2 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.RightPatrol}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.rightElbowWeldPatrol}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.rightHandWeldPatrol}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.LeftPatrol}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.leftElbowWeldPatrol}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.leftHandWeldPatrol}):Play()

        elseif stance == 3 then

            TS:Create(rightArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.RightSprint}):Play()
            TS:Create(rightElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RECFrame * Data.rightElbowWeldSprint}):Play()
            TS:Create(rightHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = RWCFrame * Data.rightHandWeldSprint}):Play()

            TS:Create(leftArmWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = Data.LeftSprint}):Play()
            TS:Create(leftElbowWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LECFrame * Data.leftElbowWeldSprint}):Play()
            TS:Create(leftHandWeld, TweenInfo.new(.25, Enum.EasingStyle.Sine),
                      {C0 = LWCFrame * Data.leftHandWeldSprint}):Play()

        end
    end
end)

Evt.HeadRot.OnClientEvent:Connect(function(player, CF)
    if player ~= Player and player.Character and
        player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
        local Neck = player.Character.Head:FindFirstChild("Neck")
        if Neck then
            TS:Create(Neck, TweenInfo.new(.2, Enum.EasingStyle.Sine,
                                          Enum.EasingDirection.Out, 0, false, 0),
                      {C0 = CF}):Play()
        end
    end
end)

function CastRay(Bullet)
    if Bullet then

        local Bpos = Bullet.Position
        local Bpos2 = Bpos
        local recast = false
        local raycastResult

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = Ignore_Model
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true

        while Bullet do
            Run.Heartbeat:Wait()
            if Bullet.Parent ~= nil then
                Bpos = Bullet.Position

                -- Set an origin and directional vector
                raycastResult = workspace:Raycast(Bpos2, (Bpos - Bpos2) * 1,
                                                  raycastParams)

                recast = false

                if raycastResult then
                    local Hit2 = raycastResult.Instance

                    if Hit2 and
                        (Hit2.Parent:IsA('Accessory') or Hit2.Parent:IsA('Hat') or
                            Hit2.Transparency >= 1 or Hit2.CanCollide == false or
                            Hit2.Name == "Ignorable" or Hit2.Name == "Glass" or
                            Hit2.Name == "Ignore" or Hit2.Parent.Name == "Top" or
                            Hit2.Parent.Name == "Helmet" or Hit2.Parent.Name ==
                            "Up" or Hit2.Parent.Name == "Down" or
                            Hit2.Parent.Name == "Face" or Hit2.Parent.Name ==
                            "Olho" or Hit2.Parent.Name == "Headset" or
                            Hit2.Parent.Name == "Numero" or Hit2.Parent.Name ==
                            "Vest" or Hit2.Parent.Name == "Chest" or
                            Hit2.Parent.Name == "Waist" or Hit2.Parent.Name ==
                            "Back" or Hit2.Parent.Name == "Belt" or
                            Hit2.Parent.Name == "Leg1" or Hit2.Parent.Name ==
                            "Leg2" or Hit2.Parent.Name == "Arm1" or
                            Hit2.Parent.Name == "Arm2") and Hit2.Name ~=
                        'Right Arm' and Hit2.Name ~= 'Left Arm' and Hit2.Name ~=
                        'Right Leg' and Hit2.Name ~= 'Left Leg' and Hit2.Name ~=
                        "UpperTorso" and Hit2.Name ~= "LowerTorso" and Hit2.Name ~=
                        "RightUpperArm" and Hit2.Name ~= "RightLowerArm" and
                        Hit2.Name ~= "RightHand" and Hit2.Name ~= "LeftUpperArm" and
                        Hit2.Name ~= "LeftLowerArm" and Hit2.Name ~= "LeftHand" and
                        Hit2.Name ~= "RightUpperLeg" and Hit2.Name ~=
                        "RightLowerLeg" and Hit2.Name ~= "RightFoot" and
                        Hit2.Name ~= "LeftUpperLeg" and Hit2.Name ~=
                        "LeftLowerLeg" and Hit2.Name ~= "LeftFoot" and Hit2.Name ~=
                        'Armor' and Hit2.Name ~= 'EShield' then
                        table.insert(Ignore_Model, Hit2)
                        recast = true
                        CastRay(Bullet)
                        break
                    end
                end

                if raycastResult and not recast then

                    Bullet:Destroy()
                    break
                end

                Bpos2 = Bpos
            else
                break
            end
        end
    end
end

Evt.ServerBullet.OnClientEvent:Connect(function(player, Origin, Direction,
                                                WeaponData, ModTable)
    if player ~= Player and player.Character then
        local Bullet = Instance.new("Part", ACS_Workspace.Server)
        Bullet.Name = player.Name .. "_Bullet"
        Bullet.CanCollide = false
        Bullet.Shape = Enum.PartType.Ball
        Bullet.Transparency = 1
        Bullet.Size = Vector3.new(1, 1, 1)

        local BulletCF = CFrame.new(Origin, Direction)
        local WalkMul = WeaponData.WalkMult * ModTable.WalkMult
        local BColor = Color3.fromRGB(255, 255, 255)

        if WeaponData.RainbowMode then
            BColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255),
                                    math.random(0, 255))
        else
            BColor = WeaponData.TracerColor
        end

        if WeaponData.Tracer == true then

            local At1 = Instance.new("Attachment")
            At1.Name = "At1"
            At1.Position = Vector3.new(-(.05), 0, 0)
            At1.Parent = Bullet

            local At2 = Instance.new("Attachment")
            At2.Name = "At2"
            At2.Position = Vector3.new((.05), 0, 0)
            At2.Parent = Bullet

            local Particles = Instance.new("Trail")
            Particles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            Particles.WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2, 0),
                NumberSequenceKeypoint.new(1, 1)
            })

            Particles.Color = ColorSequence.new(BColor)
            Particles.Texture = "rbxassetid://232918622"
            Particles.TextureMode = Enum.TextureMode.Stretch

            Particles.FaceCamera = true
            Particles.LightEmission = 1
            Particles.LightInfluence = 0
            Particles.Lifetime = .25
            Particles.Attachment0 = At1
            Particles.Attachment1 = At2
            Particles.Parent = Bullet
        end

        if WeaponData.BulletFlare == true then
            local bg = Instance.new("BillboardGui", Bullet)
            bg.Adornee = Bullet
            local flashsize = math.random(275, 375) / 10
            bg.Size = UDim2.new(flashsize, 0, flashsize, 0)
            bg.LightInfluence = 0
            local flash = Instance.new("ImageLabel", bg)
            flash.BackgroundTransparency = 1
            flash.Size = UDim2.new(1, 0, 1, 0)
            flash.Position = UDim2.new(0, 0, 0, 0)
            flash.Image = "http://www.roblox.com/asset/?id=1047066405"
            flash.ImageTransparency = math.random(2, 5) / 15
            flash.ImageColor3 = BColor
        end

        local BulletMass = Bullet:GetMass()
        local Force = Vector3.new(0, BulletMass * (196.2) -
                                      (WeaponData.BulletDrop) * (196.2), 0)
        local BF = Instance.new("BodyForce", Bullet)

        Bullet.CFrame = BulletCF
        Bullet:ApplyImpulse(Direction * WeaponData.MuzzleVelocity *
                                ModTable.MuzzleVelocity)
        BF.Force = Force

        game.Debris:AddItem(Bullet, 5)
        CastRay(Bullet)
    end
end)

----------//Events\\----------

------------------------------------------------------------
-- \Doors Update
------------------------------------------------------------
local DoorsFolder = ACS_Workspace:FindFirstChild("Doors")

local mDistance = 5
local Key = nil

function getNearest()
    local nearest = nil
    local minDistance = mDistance
    local Character = Player.Character or Player.CharacterAdded:Wait()

    for I, Door in pairs(DoorsFolder:GetChildren()) do
        if Door.Door:FindFirstChild("Knob") ~= nil then
            local distance = (Door.Door.Knob.Position -
                                 Character.UpperTorso.Position).magnitude

            if distance < minDistance then
                nearest = Door
                minDistance = distance
            end
        end
    end
    -- print(nearest)
    return nearest
end

function Interact(actionName, inputState, inputObj)
    if inputState ~= Enum.UserInputState.Begin then return end

    local nearestDoor = getNearest()
    local Character = Player.Character or Player.CharacterAdded:Wait()

    if nearestDoor == nil then return end

    if (nearestDoor.Door.Knob.Position - Character.UpperTorso.Position).magnitude <=
        mDistance then
        if nearestDoor ~= nil then
            if nearestDoor:FindFirstChild("RequiresKey") then
                Key = nearestDoor.RequiresKey.Value
            else
                Key = nil
            end
            Evt.DoorEvent:FireServer(nearestDoor, 1, Key)
        end
    end
end

function GetNearest(parts, maxDistance, Part)
    local closestPart
    local minDistance = maxDistance
    for _, partToFace in ipairs(parts) do
        local distance = (Part.Position - partToFace.Position).magnitude
        if distance < minDistance then
            closestPart = partToFace
            minDistance = distance
        end
    end
    return closestPart
end

CAS:BindAction("Interact", Interact, false, Enum.KeyCode.G)

if gameRules.WaterMark then
    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "Advanced Combat System",
        Color = Color3.fromRGB(255, 175, 0),
        Font = Enum.Font.Roboto,
        TextSize = 14
    })

    Player.Chatted:Connect(function(Message)
        if string.lower(Message) == "/acs" then
            local StarterGui = game:GetService("StarterGui")

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "------------------------------------------------",
                Color = Color3.fromRGB(0, 0, 35),
                Font = Enum.Font.RobotoCondensed,
                TextSize = 20
            })

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Advanced Combat System",
                Color = Color3.fromRGB(255, 175, 0),
                Font = Enum.Font.RobotoCondensed,
                TextSize = 20
            })

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Made By: 00Scorpion00",
                Color = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.RobotoCondensed,
                TextSize = 14
            })

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Version: " .. gameRules.Version,
                Color = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.RobotoCondensed,
                TextSize = 14
            })

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "------------------------------------------------",
                Color = Color3.fromRGB(0, 0, 35),
                Font = Enum.Font.RobotoCondensed,
                TextSize = 20
            })
        end
    end)
end

Evt.CombatLog.OnClientEvent:Connect(function(CombatLog)
    local CL = Player.PlayerGui:FindFirstChild("CombatLog")
    if CL then
        CL.Refresh:Fire(CombatLog)
    else
        local CL = HUDs.CombatLog:Clone()
        CL.Parent = Player.PlayerGui
        CL.CLS.Disabled = false
        CL.Refresh:Fire(CombatLog)
    end
end)
