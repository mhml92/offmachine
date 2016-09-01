local EnemyChaser = Class("EnemyChaser", EnemyBase)

local vector = require 'hump/vector-light'

function EnemyChaser:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.aware_radius = 300
	self.radius = 20
	self.player = scene.player
	self.state = LOITERING
	self.destroy_animation = 0
	self.acc = 300
	self:setShape(HC:circle(self.x, self.y, self.radius, self.radius))
	self:addCollisionResponse("SimpleBullet", self.test, self)
	self.val = 42
	self.sprite = resmgr:getImg("chaser.png")
	self.back = love.graphics.newQuad(0, 0, 40, 40, 120, 40)
	self.eye = love.graphics.newQuad(40, 0, 40, 40, 120, 40)
	self.front = love.graphics.newQuad(80, 0, 40, 40, 120, 40)
	self.eye_offx = 0
	self.eye_offy = 0
end

function EnemyChaser:test()
	self:destroy()
end

function EnemyChaser:update(dt)
	local dxn, dyn = vector.normalize(self.player.x-self.x, self.player.y-self.y)
	self.dx = dxn * dt * self.acc
	self.dy = dyn * dt * self.acc
	self.x = self.x + self.dx
	self.y = self.y + self.dy
	
	if self.shape then
		self.shape:moveTo(self.x,self.y)
		self:checkCollision()
	end
end

local lg = love.graphics
function EnemyChaser:draw()
	lg.setColor(255, 255, 255)
	local scale = 1
	if self.destroyed then
		scale = self.destroy_tween
	elseif self.state == LOITERING then
		lg.setColor(255, 0, 0)
	elseif self.state == CHASING then
		lg.setColor(0, 255, 0)
	end
	lg.setColor(255,255,255)
	lg.draw(self.sprite, self.back, self.x-20, self.y-20)
	lg.draw(self.sprite, self.eye, self.x-20+self.eye_offx, self.y-20+self.eye_offy)
	lg.draw(self.sprite, self.front, self.x-20, self.y-20)
end

return EnemyChaser
