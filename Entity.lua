local Entity = Class("Entity")

function Entity:initialize(x, y, scene)
	self.x = x or 0
	self.y = y or 0
	self.id = nil
	self.layer = nil
	self.active = true
	self.alive  = true
	self.scene = scene
	self.localTimer = scene.timemgr and scene.timemgr.localTimer or nil
	self.flags = {}
end

function Entity:update(dt)
end

function Entity:draw()
--[[	local lg = love.graphics
	lg.setColor(255,0,0)
	lg.circle('fill', self.x, self.y, 4, 16)
	lg.setColor(255,255,255)
	]]
end

function Entity:kill()
	self.alive = false
end

function Entity:isAlive()
	return self.alive;
end

function Entity:setActive(value)
	self.active = value
end

function Entity:isActive()
	return self.active
end

function Entity:applyForce(x,y)
   print("implement applyForce")
end

function Entity:setId(id)
	self.id = id
end

function Entity:setLayer(layer)
	self.layer = layer
end

function Entity:beginContact(obj,coll)
	--[[
	local obj_type = obj.class.name
	if obj_type == "Projectile" then
		if obj_type == "wall" then   
			obj:kill()
		end
	elseif obj_type == "din mor" then
		obj:flatten()
	end
	--]]
end

function Entity:gamepadpressed(joystick,button)
end

function Scene:gamepadaxis( joystick, axis, value )
end

function Entity:keypressed(key,scancode,isrepeat)
end

function Entity:keyreleased(key,scancode)
end

function Entity:exit()

end

return Entity
