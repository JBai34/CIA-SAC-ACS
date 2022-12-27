local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local Controllers = script.Parent.Parent:FindFirstChild("character").Controllers

Knit.AddControllers(Controllers)

Knit.Start()
    :andThen(function()
        print("Knit started!")
    end)
    :catch(warn)