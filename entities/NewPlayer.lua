local NewPlayer = Class("NewPlayer", Entity)
local SimpleBullet = require 'entities/SimpleBullet'
local WeaponInterface = require 'entities/WeaponInterface'

function NewPlayer:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 16
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 10
	self.weight = 10
	self.maxspeed = 15000
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.95
	
	self.back = resmgr:getImg("spaceship_back.png")
	self.front = resmgr:getImg("spaceship_front.png")

	self.rot = 0

	self.weapon = WeaponInterface:new(scene, self)

end

function NewPlayer:update(dt)
	local leftx,lefty,rightx,righty,leftt,rightt = self.joystick:getAxes( )
	self.weapon:update(dt)	
	--print(leftx,lefty,rightx,righty,leftt,rightt)

	if math.abs(rightx) > 0.5 or math.abs(righty) > 0.5 then
		self:shoot(rightx,righty)
	end
	if math.abs(leftx) < 0.2 then
		leftx = 0
	end

	if math.abs(lefty) < 0.2 then
		lefty = 0
	end

	-- normalize gamepad triggers
	leftt,rightt = ((leftt+1)/2),((rightt+1)/2)

	self.rot = Vectorl.angleTo(self.momentum.x,self.momentum.y)
	self.momentum.x = self.momentum.x + (leftx*self.force/self.weight)
	self.momentum.y = self.momentum.y + (lefty*self.force/self.weight)
	--if Vectorl.len(self.momentum.x,self.momentum.y) > self.maxspeed then 
	--	self.momentum.x = self.maxspeed*self.momentum.x/Vectorl.len(self.momentum.x,self.momentum.y)
	--	self.momentum.y = self.maxspeed*self.momentum.y/Vectorl.len(self.momentum.x,self.momentum.y)
	--end

	self.y = self.y + self.momentum.y
	self.x = self.x + self.momentum.x
	self.momentum.x = self.momentum.x*self.drag
	self.momentum.y = self.momentum.y*self.drag
	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end

function NewPlayer:shoot(x,y)
	local rot = Vectorl.angleTo(x,y)
	self.weapon:shoot(x,y,rot,Vectorl.len(self.momentum.x,self.momentum.y))
end


function NewPlayer:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.back, self.x, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	love.graphics.draw(self.front, self.x-16, self.y-16)
	love.graphics.setColor(0,255,0, 50)
	love.graphics.rectangle("fill", self.x-7, self.y+3, 14, 40)
	--love.graphics.circle("fill", self.x, self.y, 10)
end

function NewPlayer:gamepadpressed( joystick,button)
	if button== "rightshoulder" then
		--self:shoot()
	end
end


return NewPlayer
