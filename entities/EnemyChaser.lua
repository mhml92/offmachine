local EnemyChaser = Class("EnemyChaser", Entity)

local vector = require 'hump/vector-light'

local LOITERING = 1
local CHASING = 2
local DYING = 3

function EnemyChaser:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)
	self.aware_radius = 300
	self.radius = 20
	self.state = LOITERING
	self.player = self.scene.player
	self.dx = 0
	self.dy = 0
	self.destroy_animation = 0
	self.acc = 500
	
	self.shape = HC:circle(self.x, self.y, self.radius, self.radius)
	self.shape.owner = self
end

function EnemyChaser:update(dt)
	if self.state == LOITERING then
		if self:withinRange(self.player.x, self.player.y) then
			self.state = CHASING
		end
	elseif self.state == CHASING then
		local dxn, dyn = vector.normalize(self.player.x-self.x, self.player.y-self.y)
		self.dx = dxn * dt * self.acc
		self.dy = dyn * dt * self.acc
		self.x = self.x + self.dx
		self.y = self.y + self.dy
	end
	
	self.shape:moveTo(self.x,self.y)
	
	for shape, delta in pairs(HC:collisions(self.shape)) do
		if shape.owner.class.name == "SimpleBullet" then
			print("JESPER LUUUND")
			self:destroy()
		end
	end
end

function EnemyChaser:destroy()
	self.state = DYING
	Timer.tween(1, self, {destroy_animation = 1}, "in-back", function()
		self:kill()
	end)
end

function EnemyChaser:withinRange(x, y)
	return vector.len(self.x-x, self.y-y) <= self.aware_radius
end

local lg = love.graphics
function EnemyChaser:draw()
	local scale = 1
	if self.state == DYING then
		scale = 1 - self.destroy_animation
	end
	if self.state == LOITERING then
		lg.setColor(255, 0, 0)
	elseif self.state == CHASING then
		lg.setColor(0, 255, 0)
	end
	lg.circle("fill", self.x-self.radius/2, self.y-self.radius/2, self.radius*scale)
	--lg.circle("line", self.x-self.radius/2, self.y-self.radius/2, self.aware_radius*scale)
	--lg.line(self.x, self.y, self.player.x, self.player.y)
end

return EnemyChaser