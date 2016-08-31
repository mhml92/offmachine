local NewPlayer = Class("NewPlayer", Entity)

local RemoteRocket = require 'entities/RemoteRocket'
local WeaponInterface = require 'entities/WeaponInterface'

function NewPlayer:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 16
	self:setShape(HC:rectangle(100,100,2*self.radius,2*self.radius))
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 600 
	self.weight = 20
	self.maxspeed = 15000
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.95
	
	self.back = resmgr:getImg("spaceship_back.png")
	self.front = resmgr:getImg("spaceship_front.png")

	self.rot = 0

	self.weapon = WeaponInterface:new(self)

end

function NewPlayer:update(dt)

	-- JERES MOVEMENT
	--local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	
	-- JESPERS MOVEMENT
	local leftx,lefty,rightx,righty,leftt,rightt = self.joystick:getAxes( )

	if Vectorl.len(rightx,righty)> 0.9 then
		self.weapon:update(dt)	
	end

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
	self.momentum.x = self.momentum.x + (dt*leftx*self.force/self.weight)
	self.momentum.y = self.momentum.y + (dt*lefty*self.force/self.weight)

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
	love.graphics.setColor(255,255,255,255)
end

function NewPlayer:gamepadpressed( joystick,button)
end


return NewPlayer
