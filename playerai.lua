
local PlayerAI = {}
PlayerAI.__index = PlayerAI
setmetatable(PlayerAI, {
	__call = function (self, ...)
		local obj = setmetatable({}, PlayerAI)
		obj:__init(...)
		return obj
	end
})

function PlayerAI:__init(board, mark)

end

function PlayerAI:move()
	return 0, 0
end

return PlayerAI