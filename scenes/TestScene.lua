local TestScene = Class("TestScene", Scene)
local Player = require 'entities/Player'
local Level = require 'Level'


-- levels
local TestLevel = require 'levels/TestLevel'



function TestScene:initialize(resmgr)
	Scene:initialize(resmgr)

	self:addEntity(Level:new(TestLevel,0,0,self))	
	self:addEntity(Player:new(16,16,self))	

end

function Scene:update(dt)
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

return TestScene
