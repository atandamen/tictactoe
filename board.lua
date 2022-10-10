
local Board = {}
Board.__index = Board
setmetatable(Board, {
	__call = function (self, ...)
		local obj = setmetatable({}, Board)
		obj:__init(...)
		return obj
	end
})

function Board:__init(size, mat)
	assert(size > 2 and size < 6, "Board: size isn't correct!")

	self.size_ = size
	self.matrix_ = {} --/ ij = 'x' or 'o' or nil
	
	--/ initial init
	if mat ~= nil then
		for j=1, size do
			for i=1, size do
				self.matrix_[(j-1) + (i-1)*size] = 
					(mat[j][i] ~= '_') and mat[j][i] or nil
			end
		end
	end
end

function Board:size() return self.size_ end

function Board:setCell(x, y, mark)
	assert(mark ~= 'x' or mark ~= 'o' or mark ~= nil)
	
	x = x - 1
	y = y - 1
	self.matrix_[y + self.size_*x] = mark
end

function Board:getCell(x, y)
	x = x - 1
	y = y - 1
	return self.matrix_[y + self.size_*x]
end

function Board:isSetted(x, y)
	return self:getCell(x, y) ~= nil
end

function Board:isMovesLeft()
	for i=1, self.size_ do
		for j=1, self.size_ do
			if not self:isSetted(i, j) then 
				return true 
			end
		end
	end
	--/ THINK: return #emptyCells()
end

function Board:emptyCells()
	local cells = {}
	local size = self:size()
	for i=1, size do
		for j=1, size do
			if not self:isSetted(i, j) then 
				table.insert(cells, { i, j })
			end
		end
	end
	return cells
end

function Board:isWins(player)
	local result = false
	local size = self:size()
	
	--/ checking for rows for win
	for row=1, size do
		local eq = true
		for col=1, size do
			if self:getCell(row, col) ~= player then 
				eq = false
				break
			end
		end
		if eq then 
			result = true
			break
		end
	end
	
	--/ checking for columns for win
	if not result then
		for col=1, size do
			local eq = true
			for row=1, size do
				if self:getCell(row, col) ~= player then 
					eq = false
					break
				end
			end
			if eq then 
				result = true
				break
			end
		end
	end
	
	--/ checking for diagonals for win
	if not result then 
		local eq = true
		for i=1, size do
			if self:getCell(i, i) ~= player then 
				eq = false
				break
			end
		end	
		if eq then
			result = true
		end
	end
	
	if not result then 
		local eq = true
		for i=1, size do
			if self:getCell(i, size-i+1) ~= player then 
				eq = false
				break
			end
		end	
		if eq then
			result = true
		end
	end	
	
	--/ check for draw
	if not (result or self:isMovesLeft()) then
		return nil
	end
	return result
end


--/ Example of board view
--/   1 2 3
--/  +-+-+-+
--/ 1|x| | |
--/  +-+-+-+
--/ 2|o|x|o|
--/  +-+-+-+
--/ 3| | |o|
--/  +-+-+-+
utils = require "utils"
function Board:draw() 
	--/ clear screen
	utils.cls()
	
	local sep = string.rep("+-", self.size_) .. "+\n"	
	--/ draw top border
	io.write('\32')
	for i=0, self.size_-1 do io.write("\32", i+1) end
	io.write("\n\32", sep)
	
	--/ draw board itself
	for y=0, self.size_-1 do
		io.write(y+1, '|')
		for x=0, self.size_-1 do
			io.write(self.matrix_[y+self.size_*x] or '\32', '|')
		end
		io.write("\n\32", sep)
	end
end


return Board