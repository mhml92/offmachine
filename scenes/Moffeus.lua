local Moffeus = Class("Moffeus", Scene)
local NewPlayer = require 'entities/NewPlayer'
local Stars = require "entities/Stars"
--local EnemyZapper = require 'entities/EnemyZapper'
local TimeManager = require 'managers/TimeManager'
local SoundManager = require 'managers/SoundManager'
local EnemyDirector = require 'entities/EnemyDirector'


local EVENT_HORIZON_Y = 400

function Moffeus:initialize()
	Scene.initialize(self)

	self.timemgr = TimeManager:new(self)
	self.soundmgr = SoundManager:new(self)
	self.bgsound = self.soundmgr:addSound("theme.mp3",true,1.0)
	self.soundmgr:playSound(self.bgsound)
	self:addEntity(EnemyDirector:new(x,y,self)) 

	self:defineLayers()	
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
	self.player = NewPlayer:new(100,100,self)
	self:addEntity(self.player, self.layers.objects)
end

function Moffeus:defineLayers()
	self:addLayer("objects")
end

function Moffeus:update(dt)
	local ndt = self.timemgr:update(dt)
	self.soundmgr:update(ndt)
	Scene.update(self, ndt)

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
