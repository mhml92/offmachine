local EnemyZapper = Class("EnemyZapper", EnemyBase)
local EnemyBullet = require 'entities/EnemyBullet'

local vector = require 'hump/vector-light'


function EnemyZapper:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.radius = 15
	self.loiter_time = 2
	self.move_speed = 2
	self:setShape(HC:circle(self.x, self.y, self.radius))
	self:addCollisionResponse("SimpleBullet", self.test, self)
	self:loiter()
	self.sprite = resmgr:getImg("zapper.png")
	self.back = love.graphics.newQuad(0,0,30,30,60,30)
	self.front = love.graphics.newQuad(30,0,30,30,60,30)
	self.back_rot = 0
	self.front_rot = 0
	self.back_dr = math.pi
	self.front_dr = -math.pi
end

function EnemyZapper:test()
	self:destroy()
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

	self.tweenHandle = self.scene.timer:tween(self.move_speed,self,{x = dx,y = dy, back_dr = -self.back_dr, front_dr = -self.front_dr},'in-out-back',function() self:loiter()end)
end

function EnemyZapper:update(dt)
	if self.shape then
		self.shape:moveTo(self.x,self.y)
		self:checkCollision()
	end
	self.back_rot = self.back_rot + self.back_dr * dt
	self.front_rot = self.front_rot + self.front_dr * dt
end

local lg = love.graphics
function EnemyZapper:draw()
	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, self.back, self.x-15, self.y-15, self.back_rot, 1,1,15, 15)
	lg.draw(self.sprite, self.front, self.x-15, self.y-15, self.front_rot, 1,1,15, 15)
	--self.shape:draw("fill")
end

return EnemyZapper
