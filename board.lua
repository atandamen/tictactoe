
local Board = {}
Board.__index = Board
setmetatable(Board, {
	__call = function (self, ...)
		local obj = setmetatable({}, Board)
		obj:__init(...)
		return obj
	end
})

function Board:__init(size)
	assert(size > 2 and size < 6, "Board: size isn't correct!")

	self.size = size
	self.matrix = {} --/ ij = 'x' or 'o' or nil
end

function Board:setCell(x, y, mark)
	assert(mark ~= 'x' or mark ~= 'o')
	
	x = x - 1
	y = y - 1
	self.matrix[y + self.size*x] = mark
end

function Board:getCell(x, y)
	x = x - 1
	y = y - 1
	return self.matrix[y + self.size*x]
end

function Board:isSetted(x, y)
	return self:getCell(x, y) ~= nil
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

function Board:draw() 
	--/ clear screen
	os.execute("cls")
	
	local sep = string.rep("+-", self.size) .. "+\n"	
	--/ draw top border
	io.write('\32')
	for i=0, self.size-1 do io.write("\32", i+1) end
	io.write("\n\32", sep)
	
	--/ draw board itself
	for y=0, self.size-1 do
		io.write(y+1, '|')
		for x=0, self.size-1 do
			io.write(self.matrix[y+self.size*x] or '\32', '|')
		end
		io.write("\n\32", sep)
	end
end


return Board