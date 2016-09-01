local EnemyZapper = Class("EnemyZapper", EnemyBase)
local EnemyBullet = require 'entities/EnemyBullet'

local vector = require 'hump/vector-light'


function EnemyZapper:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.radius = 10
	self.loiter_time = 2
	self.move_speed = 2
	self:setShape(HC:circle(self.x, self.y, self.radius))
	self:addCollisionResponse("SimpleBullet", self.test, self)
	self:loiter()

end

function EnemyZapper:test(shape,delta)
	if shape.owner.alive then
		shape.owner:kill()
		self:destroy()
	end
end

function EnemyZapper:getPlayerPos()
	return self.scene.player.x,self.scene.player.y
end

function EnemyZapper:loiter()
	self.tweenHandle = self.scene.timer:after(self.loiter_time,function()if self.alive then self:move()end end )
	local shoot_time = (self.loiter_time/2) + (math.random()-0.5)/5
	self.scene.timer:after(shoot_time,function() if self.alive then self:shoot()end end)
end

function EnemyZapper:shoot()
	local dx,dy = self:getPlayerPos()
	dx,dy = dx-self.x,dy-self.y
	local rot = Vectorl.angleTo(dx,dy)
	self.scene:addEntity(EnemyBullet:new(self.x,self.y,0,0,rot,0,self.scene))
end

function EnemyZapper:getRandPos()
	return math.random()*WIDTH,math.random()*HEIGHT
end

function EnemyZapper:move()
	local dx,dy = self:getRandPos()

	self.tweenHandle = self.scene.timer:tween(self.move_speed,self,{x = dx,y = dy},'in-out-back',function() self:loiter()end)
end

function EnemyZapper:update(dt)
	if self.shape then
		self.shape:moveTo(self.x,self.y)
		self:checkCollision()
	end
end

local lg = love.graphics
function EnemyZapper:draw()
	lg.setColor(255, 255, 255)
	self.shape:draw("fill")
end

return EnemyZapper
