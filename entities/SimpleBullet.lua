local SimpleBullet = Class("SimpleBullet", Entity)


function SimpleBullet:initialize(x,y,rot,deltaspeed,scene)
	Entity.initialize(self,x,y,scene)

	self.rot = rot
	self.speed = 500 + deltaspeed
	self.radius = 10
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
	self.timer = Timer.new()
	self.timer:after(20,function() self:kill() end)
end

function SimpleBullet:update(dt)

	self.timer:update(dt)
	local dx,dy = Vectorl.rotate(self.rot,self.speed*dt,0) 
	self.x,self.y = self.x+dx,self.y+dy

	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end


function SimpleBullet:draw()
	love.graphics.setColor(255,255,255)
	self.shape:draw("fill")
end

function SimpleBullet:gamepadaxis( joystick, axis, value )
end


return SimpleBullet
