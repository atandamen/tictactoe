utils = require "utils"

local Player = {}
Player.__index = Player
setmetatable(Player, {
	__call = function (self, ...)
		local obj = setmetatable({}, Player)
		obj:__init(...)
		return obj
	end
})

function Player:__init(board, mark)
	self.mark = mark
	self.board = board
	
	assert(
		self.mark ~= nil and type(self.mark) == "string" and 
		(self.mark ~= 'x' or self.mark ~= 'o')
	)
	
	assert(self.board ~= nil and type(self.board) == "table")
end

function Player:move()
	local pattern = "*n"
	local n, m = nil, nil
	
	local result = true
	local range = { n = 1, m = self.board.size }
	repeat
		io.write("> Player " .. string.upper(self.mark) .. " move, enter n & m: ")
		
		n, m = io.read(pattern), io.read(pattern)
		if not utils.inrange({ n, m }, range.n, range.m) then
			io.write("> Cell is out of range!\n")
			result = false
		else 
			if self.board:isSetted(n, m) then
				io.write("> Cell is already setted!\n")
				result = false
			else
				result = true
			end
		end
	until result
	
	return n, m
end

return Player