Gamestate = require "hump.gamestate"

local StateManager = {}

local scenes = {}
scenes["Splash"] = require "scenes/Splash"
scenes["Menu"] = require "scenes/Menu"
scenes["Highscore"] = require "scenes/Highscore"
scenes["TestScene"] = require "scenes/TestScene"


function StateManager.init(start)
	Gamestate.registerEvents()
	StateManager.setScene(start)
end

function StateManager.setScene(name)
	local scene = scenes[name]:new()
	Gamestate.switch(scene)
end

function StateManager.getScene()
	return Gamestate.current()
end

return StateManager