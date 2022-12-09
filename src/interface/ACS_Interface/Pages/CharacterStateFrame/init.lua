local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local Hooks = require(game:GetService('ReplicatedStorage').Packages.Hooks)
local Rodux = require(game:GetService('ReplicatedStorage').Packages.Rodux)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages
                               .RoactRodux)
local e = Roact.createElement

-- ===========
local CharacterStateFrame = Roact.PureComponent:extend("CharacterStateFrame")

local stanceComponent = script.Parent.Parent.Assets.Images.CharacterState

-- ===========
function CharacterStateFrame:init() end

function CharacterStateFrame:render(_, state)
    return e("Frame", {
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(150, 150, 150),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.08, 0.87),
        Size = UDim2.fromScale(0.119, 0.216)
    }, {
        standing = require(stanceComponent.Stances.standingStance)(),
        crouching = require(stanceComponent.Stances.crouchingStance)(),
        prone = require(stanceComponent.Stances.proneStance)(),

        leanLeft = require(stanceComponent.Stances.leanLeft)();
        leanRight = require(stanceComponent.Stances.leanRight)();
        
        bleeding = e("ImageLabel", {
            Image = "rbxassetid://11760437224",
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.5, 0.93),
            Size = UDim2.fromScale(0.15, 0.15),
            ZIndex = 10
        }),

        energy = e("ImageLabel", {
            Image = "rbxassetid://11760429762",
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.93, 0.93),
            Size = UDim2.fromScale(0.151, 0.151),
            ZIndex = 10
        }),

        steady = e("ImageLabel", {
            Image = "rbxassetid://11760428112",
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.08, 0.93),
            Size = UDim2.fromScale(0.15, 0.15),
            ZIndex = 10
        })
    })
end

return CharacterStateFrame
