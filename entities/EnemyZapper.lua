local EnemyZapper = Class("EnemyZapper", EnemyBase)
local EnemyBullet = require 'entities/EnemyBullet'

local vector = require 'hump/vector-light'

local enemydebris = require 'entities/EnemyDebris'

function EnemyZapper:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.radius = 15
	self.loiter_time = 2
	self.move_speed = 4
	self.first = true
	self.first_move = 8
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

	self.debris = {}
	self.xsize,self.ysize,self.numx,self.numy = 30,30,3,3
	for i=0,self.numy-1 do
		self.debris[i] = {}
		for j=0,self.numx-1 do
			self.debris[i][j] = love.graphics.newQuad(j*(self.xsize/self.numx), i*(self.ysize/self.numy), self.xsize/self.numx, self.ysize/self.numx, 120, 40)
		end
	end
end

function EnemyZapper:test(shape,delta)
	if shape.owner.alive then
		shape.owner:kill()
		if self.alive then
			shake_screen(G_functions.rand(10,20)/10)
			self:destroy()
			for i=0,self.numy-1 do
				for j=0,self.numx-1 do
					deb = enemydebris:new(self.x+j*(self.xsize/self.numx),self.y+i*(self.ysize/self.numy),self.scene,self.debris[i][j],5,self.sprite,(self.xsize/self.numx),(self.ysize/self.numy))
					deb:setMoveVec(G_functions.rand(-400,400),G_functions.rand(-400,400))
					self.scene:addEntity(deb, self.scene.layers.objects)
				end
			end
			for i=1,25 do
				--+(G_functions.rand(0,40)-20)/10
				local part = Particle:new(
					self.x+G_functions.rand(-8,8),
					self.y+G_functions.rand(-8,8),
					self.scene,
					G_functions.rand(-100,100),
					G_functions.rand(-100,100),
					0,
					(G_functions.rand(3,15)),
					math.rad(G_functions.rand(0,360)),
					0,
					G_functions.rand(0,0.5),
					nil)
				part:setColor(G_functions.deepcopy(G.fire_colors[G_functions.rand(1,3)]),G_functions.deepcopy(G.fire_colors[G_functions.rand(4,5)]))
				self.scene:addEntity(part, self.scene.layers.objects)
			end
		end
	end
end

function EnemyZapper:getPlayerPos()
	return self.scene.player.x,self.scene.player.y
end

function EnemyZapper:loiter()
	self.tweenHandle = self.scene.timer:after(self.loiter_time,function()if self.alive then self:move()end end )
	if not self.first then 
		local shoot_time = (self.loiter_time/2) + (math.random()-0.5)/5
		self.scene.timer:after(shoot_time,function() if self.alive then self:shoot()end end)
	end
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
	if self.first then
		self.first = false
		self.tweenHandle = self.scene.timer:tween(self.first_move,self,{x = dx,y = dy},'in-out-back',function() self:loiter()end)
	else

		self.tweenHandle = self.scene.timer:tween(self.move_speed,self,{x = dx,y = dy},'in-out-back',function() self:loiter()end)
	end
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
	--lg.draw(self.sprite, self.back, self.x-15, self.y-15, self.back_rot, 1,1,15, 15)
	--lg.draw(self.sprite, self.front, self.x-15, self.y-15, self.front_rot, 1,1,15, 15)
	lg.draw(self.sprite, self.back, self.x, self.y, self.back_rot, 1,1,15, 15)
	lg.draw(self.sprite, self.front, self.x, self.y, self.front_rot, 1,1,15, 15)
	--self.shape:draw("fill")
end

return EnemyZapper
