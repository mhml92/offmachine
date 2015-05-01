local TestScene = Class("TestScene", Scene)
local Player = require 'entities/Player'
local Level = require 'Level'
local CameraManager = require 'CameraManager'
local TimeManager = require 'TimeManager'

-- levels
local TestLevel = require 'levels/TestLevel'



---------------------------------------------------------------------
--										INITIALIZE
---------------------------------------------------------------------
function TestScene:initialize(resmgr)
	Scene:initialize(resmgr)
	self.cammgr = CameraManager:new(self)
	self.timemgr = TimeManager:new(self)
	self:defineLayers()

	self:addEntity(Level:new(TestLevel,0,0,self))	
	self:addEntity(Player:new(16,16,self))	
end

function Scene:defineLayers()
end

---------------------------------------------------------------------
--										UPDATE
---------------------------------------------------------------------
function Scene:update(dt)
	dt = self.timemgr:update(dt)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:update(dt)
		end
	end
	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
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
	self.cammgr:detach()
end

return TestScene
