local Scene = Class("Scene")

function Scene:initialize()
	self.entitiesId = 0
	self.entities = {}
	self.layers = {}
	self.layers.default = 0
	self.layercanvases = {}
	self.layercanvases[0] = lg.newCanvas(WIDTH, HEIGHT)
	self.layerId = 1
	self.timer = Timer:new()
end

function Scene:update(dt)
	self.timer:update(dt)
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
			if a.layer > b.layer then 
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

		local current_layer = self.entities[1].layer
		lg.setCanvas(self.layercanvases[current_layer])
		--print("drawing to", current_layer)
		love.graphics.clear( )

		for i, v in ipairs(self.entities) do
			if v:isActive() then
				if current_layer ~= v.layer then
					current_layer = v.layer
					lg.setCanvas(self.layercanvases[current_layer])
					love.graphics.clear( )
			--		print("drawing to", current_layer)
				end
				v:draw()
			end
		end
		lg.setCanvas()
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

	function Scene:addLayer(name)

		self.layers[name] = self:getNewLayerId()
		self.layercanvases[self.layers[name]] = lg.newCanvas(WIDTH, HEIGHT)
		--print(name, self.layers[name])
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
		local av = a:getUserData()
		local bv = b:getUserData()
		if av ~= nil and bv~= nil then
			av.beginContact(bv,coll)
			bv.beginContact(av,coll)
		end
	end

	function Scene:endContact(a,b,coll)
		local av = a:getUserData()
		local bv = b:getUserData()
		if av ~= nil and bv~= nil then
			av.beginContact(bv,coll)
			bv.beginContact(av,coll)
		end
	end

	function Scene:gamepadpressed(joystick,button)
		for k,v in ipairs(self.entities) do
			v:gamepadpressed(joystick,button)
		end
	end

	function Scene:gamepadaxis( joystick, axis, value )
		for k,v in ipairs(self.entities) do
			v:gamepadaxis( joystick, axis, value )
		end
	end

	function Scene:keypressed( key,scancode,isrepeat )
		for k,v in ipairs(self.entities) do
			v:keypressed( key,scancode,isrepeat )
		end
	end

	function Scene:keyreleased(key,scancode)
		for k,v in ipairs(self.entities) do
			v:keyreleased( key,scancode )
		end
	end
	
	function Scene:preSolve(a,b,coll)
	end

	function Scene:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
	end

	return Scene
