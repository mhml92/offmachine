local SimpleBullet = Class("SimpleBullet", Entity)


function SimpleBullet:initialize(x,y,rot,deltaspeed,scene)
	Entity.initialize(self,x,y,scene)

	self.rot = rot
	self.speed = 20 + deltaspeed
	self.radius = 10
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
end

function SimpleBullet:update(dt)

	local dx,dy = Vectorl.rotate(self.rot,0,-self.speed) 
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
