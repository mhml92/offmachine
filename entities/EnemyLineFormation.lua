local EnemyLineFormation = Class("EnemyLineFormation", Entity)

local vector = require 'hump/vector-light'
local EnemyChaser = require 'entities/EnemyChaser'

local LOITERING = 1
local UNFOLDING = 2
local ATTACKING = 3

function EnemyLineFormation:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)
	self.aware_radius = 200
	self.player = scene.player
	self.state = LOITERING
	self.n = 5
	self.w = 0
	self.line_out = 0
	self.pop_out = 0
	self.dist = {}
	for i =1,self.n do
		self.dist[i] = 100 - (i-1) * (200 / (self.n - 1))
	end
	self.dx = 0
	self.dy = 0
	self.acc = 300
end

function EnemyLineFormation:update(dt)
	if self.state == LOITERING then
		if self:withinRange(self.player.x, self.player.y) then
			self.state = UNFOLDING
			self:startFormation()
		end
	elseif self.state == UNFOLDING then
	elseif self.state == ATTACKING then
	end
	local dxn, dyn = vector.normalize(self.player.x-self.x, self.player.y-self.y)
	self.dx = dxn * dt * self.acc
	self.dy = dyn * dt * self.acc
	self.x = self.x + self.dx
	self.y = self.y + self.dy
end

function EnemyLineFormation:startFormation()
	Timer.tween(.5, self, {w = 100}, "out-back", function()
		Timer.tween(.5, self, {pop_out = 1}, "out-back", function()
			local dxn, dyn = vector.normalize(self.x-self.player.x, self.y-self.player.y)
			dxn, dyn = vector.perpendicular(dxn, dyn)
			for i = 1,self.n do
				local e = EnemyChaser:new(self.x+self.dist[i]*dxn, self.y+self.dist[i]*dyn, self.scene)
				e.aware_radius = 10000
				self.scene:addEntity(e, self.scene.layers.objects)
			end
			self.state = ATTACKING
		end)
	end)
end

function EnemyLineFormation:withinRange(x, y)
	return vector.len(self.x-x, self.y-y) <= self.aware_radius
end

local lg = love.graphics
function EnemyLineFormation:draw()
	if self.state == LOITERING then
		lg.setColor(255, 0, 0)
	elseif self.state == CHASING then
		lg.setColor(0, 255, 0)
	end
	lg.rectangle("fill", self.x-5, self.y-5, 10, 10)
	lg.circle("line", self.x-5, self.y-5, self.aware_radius)
	lg.line(self.x, self.y, self.player.x, self.player.y)
	if self.state == UNFOLDING then
		local dxn, dyn = vector.normalize(self.x-self.player.x, self.y-self.player.y)
		dxn, dyn = vector.perpendicular(dxn, dyn)
		lg.line(self.x-dxn*self.w, self.y-dyn*self.w, self.x+dxn*self.w, self.y+dyn*self.w)
		for i = 1,self.n do
			lg.circle("fill", self.x+self.dist[i]*dxn, self.y+self.dist[i]*dyn, self.pop_out*10)
		end
	end
end

return EnemyLineFormation