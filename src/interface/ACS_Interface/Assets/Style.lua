local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)

local defaultValue = {
    AnchorPoint = Vector2.new(0.5,0.5);
    BackgroundColor3 = Color3.fromRGB(200,200,200);
	BackgroundTransparency = 1;
	BorderColor3 = Color3.fromRGB(0, 0, 0);
	BorderMode = Enum.BorderMode.Inset;
	BorderSizePixel = 0;
	ClipsDescendants = true;
}

return Roact.createContext(defaultValue)