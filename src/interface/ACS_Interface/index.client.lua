local LocalPlayer = game:GetService("Players").LocalPlayer
local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement

local newUITree = Roact.mount(
    e(
    RoactRodux.StoreProvider,
    {
        store = require(script.Parent.Util.Store)
    }, {
        
    app = e(require(script.Parent.App))
    }
    ),
    LocalPlayer.PlayerGui,
    "ACS HUD"
)
