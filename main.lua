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
   --love.graphics.setScissor( 0, 0, w, h)
   resmgr = ResourceManager:new()
   self.scene = TestScene:new()
   love.graphics.setBackgroundColor(255,100,100)
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
	--love.graphics.setColor(0,0,0)
	--love.graphics.rectangle( "fill", 0, 0, G.WIDTH, G.HEIGHT )
	--love.graphics.setColor(255,255,255)
   self.scene:draw()
end 

function love.keypressed( key,scancode,isrepeat )
   if key == "escape" then
      love.event.quit()
   end
	self.scene:keypressed(key,scancode ,isrepeat)
end

function love.keyreleased(key,scancode)
	self.scene:keyreleased(key,scancode)
end


function love.gamepadpressed(joystick, button)
	self.scene.gamepadpressed(joystick,button)
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
