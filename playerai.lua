utils = require 'utils'

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
	self.mark = mark
	self.board = board
end

function PlayerAI:isAi() return true end

function PlayerAI:isGameOver()
	return self.board:isWins('x') or self.board:isWins('o')
end

--/ heuristic evaluation of state
function PlayerAI:evaluate()
	local score = nil
	local ai = self.mark
	local human = ((ai == 'x') and 'o' or 'x')
	if self.board:isWins(ai) then
		score = 1
	elseif self.board:isWins(human) then
		score = -1
	else
		score = 0
	end
	
	return score
end

--/ AI algo that choice the best move
function PlayerAI:minimax(depth, isMax)
	local best = nil
	if isMax then
		best = { -1, -1, -math.huge }
	else 
		best = { -1, -1,  math.huge }
	end
	
	if depth == 0 or self:isGameOver() then
		return { -1, -1, self:evaluate() }
	end
	
	local ai = self.mark
	local human = ((ai == 'x') and 'o' or 'x')
	
	local emptyCells = self.board:emptyCells()
	for _, cell in ipairs(emptyCells) do
		local i, j = cell[1], cell[2]
		self.board:setCell(i, j, isMax and ai or human)

		local mmove = self:minimax(depth - 1, not isMax)
		
		self.board:setCell(i, j, nil)
		
		mmove[1], mmove[2] = i, j 
		
		if isMax then
			if mmove[3] > best[3] then
				best = mmove --/ maximization
			end
		else
			if mmove[3] < best[3] then
				best = mmove --/ minimization
			end
		end
	end
	
	return best
end

function PlayerAI:move()
	local n, m = nil, nil
	
	io.write("> Computer '" .. string.upper(self.mark) .. "' move...\n")

	local emptyCells = self.board:emptyCells()
	local depth = #emptyCells
	
	assert(not (depth == 0), "PlayerAI: why depth is zero???") 
	
	local boardSz = self.board:size()
	local maxDepth = boardSz*boardSz
	
	--/ case then depth == maxDepth is the start of the game
	--/ let's choose random 
	if depth == maxDepth then
		n, m = math.random(boardSz), math.random(boardSz)
	else 
		local move = self:minimax(depth, true)
		n, m = (table.unpack or unpack)(move)
	end
	return n, m
end

return PlayerAI