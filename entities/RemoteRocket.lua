local RemoteRocket = Class("SimpleBullet", Entity)


function RemoteRocket:initialize(px,py,x,y,rot,deltaspeed,scene)
	Entity.initialize(self,x,y,scene)

	self.x = px
	self.y = py
	self.rot = rot
	self.owner = owner
	self.speed = 150 
	self.radius = 10
	self.shape = HC:rectangle(100,100,4*self.radius,2*self.radius)
	self.shape.owner = self
	self.joystick = love.joystick.getJoysticks( )[1]

	self.scene.timer:after(5,function() self:kill() end)
end

function RemoteRocket:update(dt)

	local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	self.rot = Vectorl.angleTo(rightx,righty)


	local dx,dy = Vectorl.rotate(self.rot,self.speed*dt,0) 
	self.x,self.y = self.x+dx,self.y+dy

	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end


function RemoteRocket:draw()
	love.graphics.setColor(255,255,255)
	self.shape:draw("fill")
end

function RemoteRocket:exit()
end

function RemoteRocket:gamepadaxis( joystick, axis, value )
end


return RemoteRocket
