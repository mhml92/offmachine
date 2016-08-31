local RemoteRocket = Class("SimpleBullet", Entity)


function RemoteRocket:initialize(x,y,rot,owner,deltaspeed,scene)
	Entity.initialize(self,x,y,scene)

	self.rot = rot
	self.owner = owner
	self.speed = 500 + deltaspeed
	self.radius = 10
	self.shape = HC:rectangle(100,100,4*self.radius,2*self.radius)
	self.shape.owner = self
	self.joystick = love.joystick.getJoysticks( )[1]
	self.ready = true

	self.timer = Timer.new()
	self.timer:after(5,function() self:kill() end)
end

function RemoteRocket:update(dt)

	self.timer:update(dt)
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
	 self.owner.rocket = nil
end

function RemoteRocket:gamepadaxis( joystick, axis, value )
end


return RemoteRocket
