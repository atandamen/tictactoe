Board = require "board"
Player = require "player"
PlayerAI = require "playerai"

local Game = {}
Game.__index = Game
setmetatable(Game, {
	__call = function (self, ...)
		local obj = setmetatable({}, Game)
		obj:__init(...)
		return obj
	end
})

--/ mode 0-PvA, 1-PvP, 2-AvA
--/ P-player, A-AI(Computer)
function Game:__init(mode, size)
	assert(mode ~= nil and mode > 0 and mode < 3, "Game: mode isn't correct!")
	
	self.mode = mode
	self.win = false
	self.board = Board(size)
	
	if mode == 0 then
		self.players = { 
			[0] = Player(self.board, 'x'), 
			[1] = PlayerAI(self.board, 'o') 
		}
	elseif mode == 1 then
		self.players = { 
			[0] = Player(self.board, 'x'), 
			[1] = Player(self.board, 'o') 
		}
	elseif mode == 2 then
		self.players = { 
			[0] = PlayerAI(self.board, 'x'), 
			[1] = PlayerAI(self.board, 'o') 
		}
	end
end

function Game:run()
	self.step = 0
	repeat 
		self.step = self.step + 1
		self.who = self.step % 2
	
		self.board:draw()
		
		local who = self.players[self.who]
		local i, j = who:move()
		self.board:setCell(i, j, who.mark)
		
		self.win = self:checkWin()
	until self.win
	
	
	self.board:draw()
	
	local who = self.players[self.who]
	if self.mode == 0 then
	elseif self.mode == 1 then 
		io.write(string.format("Player %s won!\n", who.mark))
	elseif self.mode == 2 then 
	end
end


function Game:checkWin() 
	--/ check three possible states
	local result = true
	local size = self.board.size
	
	--/ check all vertical lines
	for i=1, size do
		result = true
		--/ remember first element
		local mark = self.board:getCell(i, 1)
		if mark then 
			for j=2, size do 
				local tested = self.board:getCell(i, j)
				if mark ~= tested then
					result = false
					break
				end
			end
		else 
			result = false
		end
		
		if result then return true end
	end
	
	--/ check all horizontal lines
	for i=1, size do
		result = true
		--/ remember first element
		local mark = self.board:getCell(1, i)
		if mark then 
			for j=2, size do 
				local tested = self.board:getCell(j, i)
				if mark ~= tested then
					result = false
					break
				end
			end
		else 
			result = false
		end
		
		if result then return true end
	end
	
	--/ check all possible (only two) crosses
	result = true
	
	local mark = self.board:getCell(1, 1)
	if mark then
		for i=2, size do 
			local tested = self.board:getCell(i, i)
			if mark ~= tested then
				result = false
				break
			end
		end
	else 
		result = false
	end
		
	if result then return true end
		
	
	result = true
	
	local mark = self.board:getCell(1, size)
	if mark then
		for i=2, size do 
			local tested = self.board:getCell(i, size-i+1)
			if mark ~= tested then
				result = false
				break
			end
		end
	else 
		result = false
	end
		
	if result then return true end
	
	return result
end

return Game