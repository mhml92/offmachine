local NewPlayer = Class("NewPlayer", Entity)
local SimpleBullet = require 'entities/SimpleBullet'


function NewPlayer:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 10
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 600 
	self.weight = 20
	self.maxspeed = 15000
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.95

	self.rot = 0
end

function NewPlayer:update(dt)

	local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	
	if Vectorl.len(rightx,righty)> 0.9 then
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
	self.scene:addEntity(SimpleBullet:new(self.x,self.y,rot,Vectorl.len(self.momentum.x,self.momentum.y),self.scene), self.scene.layers.objects)
end


function NewPlayer:draw()
	love.graphics.setColor(255,255,255)
	self.shape:draw("fill")
	love.graphics.setColor(0,255,255)

	local px,py = self.radius,0
	px,py = Vectorl.rotate(self.rot,px,py)
	love.graphics.circle( "fill", self.x+px, self.y+py, 10, 10 )
	--love.graphics.line(self.left_motor_pos.x,self.left_motor_pos.y,self.right_motor_pos.x,self.right_motor_pos.y)
end

function NewPlayer:gamepadpressed( joystick,button)
end


return NewPlayer
