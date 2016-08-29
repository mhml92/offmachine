local TestScene = Class("TestScene", Scene)
local Player = require 'entities/Player'
local StaticObject = require 'entities/StaticObject'
local CameraManager = require 'managers/CameraManager'
local TimeManager = require 'managers/TimeManager'
local SoundManager = require 'managers/SoundManager'

-- levels
--local TestLevel = require 'levels/wallsTest'
local TestLevel = require 'levels/wallsTest'



---------------------------------------------------------------------
--										INITIALIZE
---------------------------------------------------------------------
function TestScene:initialize()
	Scene:initialize(resmgr)
	self.cammgr = CameraManager:new(self)
	self.timemgr = TimeManager:new(self)
	self.soundmgr = SoundManager:new(self)

	self:defineLayers()
	--[[
	self.world = love.physics.newWorld(0,0,true)
	love.physics.setMeter(32)
   self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	]]



	self:addEntity(StaticObject:new(0, 0, self))
	self:addEntity(Player:new(100,100,self))
	
	self.bgmusic = self.soundmgr:addSound("hyperfun.mp3", true, 0.8)
	self.soundmgr:playSound(self.bgmusic)
end

function Scene:defineLayers()

end
---------------------------------------------------------------------
--										UPDATE
---------------------------------------------------------------------
function Scene:update(dt)
	dt = self.timemgr:update(dt)
	self.soundmgr:update(dt)
	--self.world:update(dt)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:update(dt)
		end
	end
	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
         self.entities[i]:exit()
         if self.entities[i].body then
            self.entities[i].body:destroy()
         end
			table.remove(self.entities, i);
		end
	end
end

---------------------------------------------------------------------
--										DRAW
---------------------------------------------------------------------
function Scene:draw()
	
	table.sort(self.entities,
		function(a,b) 
			if a.layer < b.layer then 
				return true 
			elseif a.layer == b.layer then 
				if a.id < b.id then 
					return true 
				else 
					return false 
				end 
			else 
				return false 
			end 
		end)
	self.cammgr:attach()	
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:draw()
		end
	end
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), self.cammgr.cam:worldCoords(10, 10)) 
	self.cammgr:detach()
end

return TestScene
