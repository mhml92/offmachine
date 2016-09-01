local Moffeus = Class("Moffeus", Scene)
local NewPlayer = require 'entities/NewPlayer'
local Stars = require "entities/Stars"
local EnemyZapper = require 'entities/EnemyZapper'
local Meteorite = require 'entities/Meteorite'

local EVENT_HORIZON_Y = 400

function Moffeus:initialize()
	Scene.initialize(self)
	
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
	self.player = NewPlayer:new(100,100,self)
	self:addEntity(self.player, self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	for i=1,5 do
		local meteorite = Meteorite:new(WIDTH+32, -50+math.random(120), self)
		meteorite.dx = -math.random(100, 300)
		self:addEntity(meteorite, self.layers.objects)
	end
	for i=1,5 do
		local meteorite = Meteorite:new(-32, -150+math.random(120), self)
		meteorite.dx = math.random(50, 300)
		self:addEntity(meteorite, self.layers.objects)
	end
end

function Moffeus:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function Moffeus:update(dt)
	Scene.update(self, dt)
end

function Moffeus:draw()
	Scene.draw(self)
end

function Moffeus:belowEventHorizon(obj)
	return obj.y > EVENT_HORIZON_Y
end


function Moffeus:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
end

function Moffeus:keypressed( key,scancode,isrepeat )
	Scene.keypressed(self,key,scancode,isrepeat)
end

function Moffeus:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return Moffeus
