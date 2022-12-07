local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local Hooks = require(game:GetService('ReplicatedStorage').Packages.Hooks)
local Rodux = require(game:GetService('ReplicatedStorage').Packages.Rodux)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement

--===========
local CharacterStateFrame = Roact.PureComponent:extend("Stance")

local Image = script.Parent.Parent.Assets.Images.CharacterState

--===========
function CharacterStateFrame:init()

end

function CharacterStateFrame:render()
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
            Position = UDim2.fromScale(0.08, 0.87);
        },
        {
            stamina = require(Image.Stamina)();
            
            leanLeft = require(Image.Stances.leanLeft)();
            leanRight = require(Image.Stances.leanRight)();
            
            standingStance = require(Image.Stances.standingStance)();
            crouchingStance = require(Image.Stances.crouchingStance)();
            proneStance = require(Image.Stances.proneStance)();
        }
    )
end