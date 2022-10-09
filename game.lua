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
function Game:__init(mode)
	assert(mode ~= nil and mode > 0 and mode < 3, "Game: mode isn't correct!")
	
	self.mode = mode
	self.win = false
	self.step = 0
	
	
	io.write("New game for... (X or O or default(X)) >")
	local who = io.read():lower()
	if who ~= "x" and who ~= "o" then who = "x" end
	self.step = (who == "x") and 1 or 0
	
	io.write("Board size? (3 .. 5 or default(3)) >")
	
	local size = io.read("*n")
	if not utils.inrange({ size }, 3, 5) then size = 3 end
	
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
	repeat 	
		self.step = self.step + 1
		self.who = self.step % 2

		self.board:draw()
		
		local who = self.players[self.who]
		local i, j = who:move()
		self.board:setCell(i, j, who.mark)
			
		self.win = self:checkWin()
	until self.win or self.win == nil
	
	
	self.board:draw()
	
	local who = self.players[self.who]
	if self.mode == 0 then
	elseif self.mode == 1 then
		if self.win then
			io.write(string.format("Player '%s' won!\n", who.mark))
		else 
			io.write("It's draw!\n")
		end
	elseif self.mode == 2 then 
	end
end

function Game:isVictory()
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

function Game:checkWin() 
	local size = self.board.size
	local win = self:isVictory()
	if not win and self.step-1 == size*size then
		return nil
	end
	return win
end

return Game