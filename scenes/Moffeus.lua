local Moffeus = Class("Moffeus", Scene)
local NewPlayer = require 'entities/NewPlayer'
--local EnemyZapper = require 'entities/EnemyZapper'
local Stars = require "entities/Stars"
local TimeManager = require 'managers/TimeManager'
local SoundManager = require 'managers/SoundManager'
local EnemyDirector = require 'entities/EnemyDirector'

local FuelInterface = require 'entities/fuelinterface'
local Hud = require 'entities/hud'

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
	self.player = NewPlayer:new(WIDTH/2,HEIGHT/2,self)
	self:addEntity(self.player, self.layers.objects)
	
	self:addEntity(Hud:new(0,0,self), self.layers.gui)

	--self.fuelinterface = FuelInterface:new(self)
	--self:addEntity(self.fuelinterface, self.layers.gui)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	--[[
	for i=1,5 do
		local meteorite = Meteorite:new(WIDTH+32, -50+math.random(120), self)
		meteorite.dx = -math.random(100, 300)
		self:addEntity(meteorite, self.layers.objects)
	end
	for i=1,5 do
		local meteorite = Meteorite:new(-32, -150+math.random(120), self)
		meteorite.dx = math.random(50, 300)
		self:addEntity(meteorite, self.layers.objects)
	]]
	
end

function Moffeus:defineLayers()
	self:addLayer("objects")
	self:addLayer("gui")
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
