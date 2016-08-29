require 'slam/slam'
print(math)
math.random = love.math.random

G = require 'Globals'
Class = require 'middleclass/middleclass'
Scene = require 'Scene'
Entity = require 'Entity'
Vector = require 'hump/vector-light'
Timer = require 'hump/timer'
ResourceManager = require 'managers/ResourceManager'
Animation = require 'entities/Animation'

MouseController = require 'controllers/MouseController'
ControllerController = require 'controllers/ControllerController'
KeyboardController = require 'controllers/KeyboardController'

FontManager = require 'managers/FontManager'

local TestScene = require 'scenes/TestScene'

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0


local self = {}


function love.load()
   --love.mouse.setVisible(false)
   local w,h = love.graphics.getDimensions()
   love.graphics.setScissor( 0, 0, w, h)
   resmgr = ResourceManager:new()
   self.scene = TestScene:new()
   love.graphics.setBackgroundColor(255/5,255/5,255/2)
   --	self.scene = MenuScene:new()
	fontmgr = FontManager:new()
	
	
end

function love.update(dt)
   Timer.update(dt)
   time.accum = time.accum + dt 
   if time.accum >= time.fdt then
      self.scene:update(time.fdt)
      time.accum = 0--time.accum - time.fdt
   end
end

function love.draw()
   self.scene:draw()
	fontmgr:setFont("coders_crux.ttf")
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) 
end 

function love.keypressed( key, isrepeat )
   if key == "escape" then
      love.event.quit()
   end
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
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end

end

function beginContact(a,b,coll)
   self.scene:beginContact(a,b,coll)
end

function endContact(a,b,coll)
   self.scene:endContact(a,b,coll)
end

function preSolve(a,b,coll)
   self.scene:preSolve(a,b,coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
   self.scene:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
