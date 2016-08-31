local EnemyBase = Class("EnemyBase", Entity)

local vector = require 'hump.vector-light'

function EnemyBase:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.dx = 0
	self.dy = 0
	self.destroyed = false
end

function EnemyBase:setShape(shape)
	self.shape = shape
	self.shape.owner = self
end

function EnemyBase:addCollisionResponse(name, func, src)
	if self.collision_responses == nil then
		self.collision_responses = {}
	end
	table.insert(self.collision_responses, {["name"] = name, ["func"] = func, ["src"] = src})
end

function EnemyBase:checkCollision()
	if self.collision_responses then
		for shape, delta in pairs(HC:collisions(self.shape)) do
			for k, v in ipairs(self.collision_responses) do
				if shape.owner.class.name == v.name then
					v.func(v.src, shape, delta)
				end
			end
		end
	end
end

function EnemyBase:distanceTo(obj)
	return vector.len(self.x-obj.x, self.y-obj.y)
end

function EnemyBase:distanceToPlayer()
	return self:distanceTo(self.scene.player)
end

function EnemyBase:destroy()
	if false == self.destroyed then
		self.destroy_tween = 1
		self.destroyed = true
		Timer.tween(1, self, {destroy_tween = 0}, 'in-back', function() self:kill() end)
	end
end

return EnemyBase