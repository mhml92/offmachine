local EnemyBase = Class("EnemyBase", Entity)

local vector = require 'hump.vector-light'

function EnemyBase:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.dx = 0
	self.dy = 0
	self.destroyed = false
	self.has_been_inside = false
	self.playedEnterSound = false
end

function EnemyBase:isInside()

	self.has_been_inside = self.has_been_inside or (self.x > 0 and self.x < WIDTH and self.y > 0 and self.y < HEIGHT)
	if self.has_been_inside then
		if self.enterSound and not self.playedEnterSound then
			self.playedEnterSound = true
			self.scene.soundmgr:playSound(self.enterSound)
		end
	end
end

function EnemyBase:update(dt)
	self:isInside()
	if self.has_been_inside then
		if self.x < 0 then
			self.x = self.x + WIDTH
		end
		if self.x > WIDTH then
			self.x = self.x - WIDTH
		end

		--[[
		if self.y < 0 then
			self.y = self.y + HEIGHT
		end
		if self.y > HEIGHT then
			self.y = self.y - HEIGHT
		end]]
	end
end


function EnemyBase:distanceTo(obj)
	return vector.len(self.x-obj.x, self.y-obj.y)
end

function EnemyBase:distanceToPlayer()
	return self:distanceTo(self.scene.player)
end

function EnemyBase:getClosestPlayer()
	local p = self.scene.player
	if math.abs(self.x - p.x) < WIDTH / 2 then
		return {x=p.x, y=p.y}
	else
		if p.x < WIDTH / 2 then
			return {x=p.x+WIDTH, y=p.y}
		else
			return {x=p.x-WIDTH, y=p.y}
		end
	end
end

function EnemyBase:destroy()
	if false == self.destroyed then
		self.destroy_tween = 1
		self.destroyed = true
		self.scene.timer:tween(0, self, {destroy_tween = 0}, 'in-back', function() self:kill() end)
	end
end

return EnemyBase
