local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
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
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:draw()
		end
	end
end

function Scene:addEntity(e)
	table.insert(self.entities, e)
	return e
end

function Scene:keypressed(key, isrepeat)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:keypressed(key, isrepeat)
		end
	end
end

function Scene:keyreleased(key, isrepeat)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:keyreleased(key, isrepeat)
		end
	end
end

function Scene:mousepressed(x, y, button)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:mousepressed(x, y, button)
		end
	end
end

function Scene:mousereleased(x, y, button)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:mousereleased(x, y, button)
		end
	end
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
