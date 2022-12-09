local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local e = Roact.createElement

return function(props)
    return e(
        "ImageLabel", 
        {
            Name = "standing",
            Image = "http://www.roblox.com/asset/?id=5427505195",
            
            ScaleType =  Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency =  1,
            BorderSizePixel = 0,
            Position = if props ~= nil and props.Position ~= nil then props.Position else UDim2.fromScale(0.5, 0.5),
            Size = if props ~= nil and props.Size ~= nil then props.Size else UDim2.fromScale(.7,.7),
            ZIndex =  2,
        }
    )
end