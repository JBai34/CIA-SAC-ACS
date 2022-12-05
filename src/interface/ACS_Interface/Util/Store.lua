local Roact = require(game:GetService('ReplicatedStorage').Packages.Roact)
local Hooks = require(game:GetService('ReplicatedStorage').Packages.Hooks)
local Rodux = require(game:GetService('ReplicatedStorage').Packages.Rodux)
local RoactRodux = require(game:GetService('ReplicatedStorage').Packages.RoactRodux)
local e = Roact.createElement

return Rodux.Store.new(
    Rodux.combineReducers({
        
        characterStanceReducer = Rodux.createReducer(nil, {
            UpdateStance = function(_, action)
                return action.newStance
            end
        });
        
        ammoCountReducer = Rodux.createReducer(nil, {
            UpdateAmmo = function(_, action)
                return action.newAmmoCount
            end
        });
        
        magazineCountReducer = Rodux.createReducer(nil, {
            UpdateMagazine = function(_, action)
                return action.newMagazineCount
            end
        });
        
    }), 
    nil, 
    {Rodux.loggerMiddleware}
)