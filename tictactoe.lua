#!/usr/bin/env lua

utils = require "utils"
Game = require "game"

local modes = { ["pva"] = 0, ["pvp"] = 1, ["ava"] = 2 }

do
	--/ setup random seed
	math.randomseed(os.time())
	
	utils.cls()
	
	io.write("Game mode? (PvA, PvP, AvA, exit) >")
	
	local mode = modes[string.lower(io.read())]	
	if not mode then return end
	
	Game(mode):run()
end

io.write("Thanks for playing!\n")