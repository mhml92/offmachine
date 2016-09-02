Gamestate = require "hump.gamestate"

local StateManager = {}

local scenes = {}
scenes["Splash"] = require "scenes/Splash"
scenes["Menu"] = require "scenes/Menu"
scenes["Highscore"] = require "scenes/Highscore"
scenes["TestScene"] = require "scenes/TestScene"
scenes["Moffeus"] = require "scenes/Moffeus"

StateManager.timer = Timer.new()
StateManager.animating =  false
StateManager.opacity = 0

function StateManager.init(start)
	Gamestate.registerEvents()
	--StateManager.setScene(start)
	Gamestate.switch(scenes[start]:new())
end

function StateManager.setScene(name)
	StateManager.next = scenes[name]:new()
	StateManager.animating = true
	StateManager.timer:tween(0.25, StateManager, {opacity = 255}, "linear", function()
		Gamestate.switch(StateManager.next)
		StateManager.timer:tween(0.25, StateManager, {opacity = 0}, "linear", function()
			animating = false
		end)
	end)
end

function StateManager.getScene()
	return Gamestate.current()
end

function StateManager.draw()
	if StateManager.animating then
		love.graphics.setColor(0,0,0,StateManager.opacity)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		love.graphics.setColor(255,255,255,255)
	end
end

function StateManager.update(dt)
	StateManager.timer:update(dt)
end

return StateManager
