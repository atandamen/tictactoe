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
	assert(mode ~= nil and mode >= 0 and mode <= 2, ("Game: mode %d isn't correct!"):format(mode))
	
	self.mode = mode
	self.win = false
	self.who = 0
	self.step = 0
	
	do 
		assert(io.write("Board size? (3 .. 5 or default(3)) > "))
	
		local size = io.read("*n")
		if not utils.inrange({ size }, 3, 5) then size = 3 end
		
		if not (self.mode == 1) and size > 3 then
			io.write("Sorry, but board size greater than 3 isn't currently supported for PvA and AvA modes\nMore research is needed in this area :(\n")
			os.exit(1)
		end
		
		self.board = Board(size)
	end
	
	if self.mode == 0 then
		--/ setup who'll play first
		assert(io.write("New game for... (X or O or default(X)) > "))
		
		local who = nil
		repeat who = io.read() until who:match "[xo]"
		if (who ~= "x") and (who ~= "o") then who = "x" end
		
		self.players = {}
		if who == 'x' then
			self.players[0] = Player(self.board, 'x')
			self.players[1] = PlayerAI(self.board, 'o')
		else 
			self.players[0] = PlayerAI(self.board, 'x')
			self.players[1] = Player(self.board, 'o')
		end
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

function Game:move()
	local player = self.players[self.who]
	local i, j = player:move()
	self.board:setCell(i, j, player.mark)
	self.win = self.board:isWins(player.mark)
end

function Game:run()
	repeat
		self.who = self.step % 2
		self.board:draw()
		
		self:move()
	
		--/ wait a little bit in AvA mode
		if not self.win and self.mode == 2 then utils.wait(0.7) end
		
		self.step = self.step + 1
	until self.win or self.win == nil
	
	
	--/ draw results
	self.board:draw()
	
	local who = self.players[self.who]
	local isAi = who:isAi()
	if self.win then
		io.write(string.format("%s '%s' won!\n", 
			isAi and "Computer" or "Player", who.mark))
	elseif self.win == nil then 
		io.write("It's draw!\n")
	end
end

return Game