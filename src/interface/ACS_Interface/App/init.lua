local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local Hooks = require(game:GetService('ReplicatedStorage').Packages.Hooks)
local Rodux = require(game:GetService('ReplicatedStorage').Packages.Rodux)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement
--=================================================================
local UI = script.Parent

local Pages = UI.Pages
--=================================================================
local App = Roact.Component:extend("App")

function App:render()
    return e(RoactRodux.StoreProvider,{
        store = require(script.Parent.Util.Store)
    }, {
        e("ScreenGui",{
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false
        }, {
            characterStateFrame = e(require(Pages.CharacterStateFrame)),
        })
    })
end

return App