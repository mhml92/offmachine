local EnemyChaser = Class("EnemyChaser", EnemyBase)

local vector = require 'hump/vector-light'

local LOITERING = 1
local CHASING = 2
local DYING = 3

function EnemyChaser:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.aware_radius = 300
	self.radius = 20
	self.player = scene.player
	self.state = LOITERING
	self.destroy_animation = 0
	self.acc = 500
	self:setShape(HC:circle(self.x, self.y, self.radius, self.radius))
	self:addCollisionResponse("SimpleBullet", self.test, self)
	self.val = 42
end

function EnemyChaser:test()
	self:destroy()
end

function EnemyChaser:update(dt)
	if self.state == LOITERING then
		if self:distanceToPlayer() < self.aware_radius then
			self.state = CHASING
		end
	elseif self.state == CHASING then
		local dxn, dyn = vector.normalize(self.player.x-self.x, self.player.y-self.y)
		self.dx = dxn * dt * self.acc
		self.dy = dyn * dt * self.acc
		self.x = self.x + self.dx
		self.y = self.y + self.dy
	end
	
	if self.shape then
		self.shape:moveTo(self.x,self.y)
		self:checkCollision()
	end
end

local lg = love.graphics
function EnemyChaser:draw()
	local scale = 1
	if self.destroyed then
		scale = self.destroy_tween
	end
	if self.state == LOITERING then
		lg.setColor(255, 0, 0)
	elseif self.state == CHASING then
		lg.setColor(0, 255, 0)
	end
	lg.circle("fill", self.x-self.radius/2, self.y-self.radius/2, self.radius*scale)
	lg.circle("line", self.x-self.radius/2, self.y-self.radius/2, self.aware_radius*scale)
	lg.line(self.x, self.y, self.player.x, self.player.y)
end

return EnemyChaser
