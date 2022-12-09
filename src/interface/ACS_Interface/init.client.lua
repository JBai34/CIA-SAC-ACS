local LocalPlayer = game:GetService("Players").LocalPlayer
local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement

local newUITree = Roact.mount(e(require(script.App)),
    LocalPlayer.PlayerGui,
    "ACS HUD"
)
