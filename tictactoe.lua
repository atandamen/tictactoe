
utils = require "utils"
Game = require "game"

local modes = { ["pva"] = 0, ["pvp"] = 1, ["ava"] = 2 }

repeat
	os.execute("cls")
	
	io.write("Game mode? (PvA, PvP, AvA, exit) >")
	
	local mode = modes[string.lower(io.read())]	
	if mode == nil then break end
	
	io.write("Board size? (3 .. 5 or default(3)) >")
	
	local size = io.read("*n")
	if not utils.inrange({ size }, 3, 5) then size = 3 end
	
	local game = Game(mode, size)
	game:run()
until true

io.write("Thanks for playing!\n")