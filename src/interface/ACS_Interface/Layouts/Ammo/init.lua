local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local Hooks = require(game:GetService('ReplicatedStorage').Packages.Hooks)
local Rodux = require(game:GetService('ReplicatedStorage').Packages.Rodux)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement

--===========
local Stance = Roact.PureComponent:extend("Stance")

local StanceImage = require(script.Parent.Parent.Assets.Images.stances)

--===========
function Stance:init()

end

function Stance:render()
    return e(
        "Frame", 
        {
            AnchorPoint = Vector2.new(0.5,0.5);
            BackgroundColor3 = Color3.fromRGB(200,200,200);
            BackgroundTransparency = 1;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            ClipsDescendants = true;
            Size = UDim2.fromScale(0.059,0.104);
            Position = UDim2.fromScale(0.95, 0.9);
        },
        {
            stanceImage = e(
                "ImageLabel",
                {
                    Image = StanceImage[1];
                    Position = UDim2.fromScale(0.5, 0.5);
                    Size = UDim2.fromScale(1, 0);
                }
            )
        }
    )
end

--[[
    We are goign to have to bind all of the states into attributes or implement a method that compares the tables
]]