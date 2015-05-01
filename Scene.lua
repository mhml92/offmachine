local Scene = Class("Scene")

function Scene:initialize(resmgr)
	self.resmgr = resmgr
	self.key = {}
	self.entitiesId = 0
	self.entities = {}
	self.layers = {}
	self.layers.default = 0
	self.layerId = 0
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
	
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:draw()
		end
	end
end

function Scene:addEntity(e,layer)
	if not layer then
		layer = self.layers.default
	end

	e:setId(self:getNewId())
	e:setLayer(layer)	
	table.insert(self.entities, e)
	return e
end

function Scene:keypressed(key, isrepeat)
	self.key[key] = true
end

function Scene:keyreleased(key, isrepeat)
	self.key[key] = false
end

function Scene:addLayer(name)
	self.layers[name] = self:getNewLayerId()
end

function Scene:getNewLayerId()
	local nid = self.layerId
	self.layerId = self.layerId + 1
	return nid
end

function Scene:getNewId()
	local nid = self.entitiesId
	self.entitiesId = self.entitiesId + 1
	return nid
end


function Scene:beginContact(a,b,coll)
end

function Scene:endContact(a,b,coll)
end


function Scene:preSolve(a,b,coll)
end

function Scene:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

return Scene
