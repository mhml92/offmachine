local Moffeus = Class("Moffeus", Scene)
local NewPlayer = require 'entities/NewPlayer'
local Stars = require "entities/Stars"
local EnemyZapper = require 'entities/EnemyZapper'
local TimeManager = require 'managers/TimeManager'

function Moffeus:initialize()
	Scene.initialize(self)
	self.timemgr = TimeManager:new(self)
	
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
	self.player = NewPlayer:new(100,100,self)
	self:addEntity(self.player, self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
end

function Moffeus:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function Moffeus:update(dt)
		
	if self.player.y > HEIGHT-200 then
		self.timemgr:setTimeScalar(((HEIGHT)-self.player.y)/600)
	else
		self.timemgr:setTimeScalar(1)
	end


	local ndt = self.timemgr:update(dt)
	Scene.update(self, ndt)

end

function Moffeus:draw()
	Scene.draw(self)
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
