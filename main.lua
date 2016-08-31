require 'slam/slam'
require ("loveshortcuts")
print(math)
math.random = love.math.random

I = require 'inspect.inspect'
G = require 'Globals'
G_functions = require 'g_functions'
Class = require 'middleclass/middleclass'
Scene = require 'Scene'
Entity = require 'Entity'
EnemyBase = require 'entities/EnemyBase'
Vector = require 'hump/vector'
Vectorl = require 'hump/vector-light'
Timer = require 'hump/timer'
ResourceManager = require 'managers/ResourceManager'
Animation = require 'entities/Animation'
HC = require 'HC'

--hardon collider
hc = require 'HC'
HC = hc.new()
Polygon = require 'HC.polygon'
Shapes = require 'HC.shapes'

Particle = require("entities/Particle")

FontManager = require 'managers/FontManager'


local TestScene = require 'scenes/TestScene'

StateManager = require "managers/StateManager"
HighscoreManager = require "managers/HighscoreManager"

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0


local self = {}

function love.load()
   resmgr = ResourceManager:new()
   love.graphics.setBackgroundColor(255,100,100)
	StateManager.init("TestScene")
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
 
		-- Call update and draw
		Timer.update(dt)
		time.accum = time.accum + dt 
		if time.accum >= time.fdt then
			love.update(time.fdt)
			time.accum = 0--time.accum - time.fdt
		end	
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
 
end

function love.keypressed( key,scancode,isrepeat )
   if key == "escape" then
      love.event.quit()
   end
end
