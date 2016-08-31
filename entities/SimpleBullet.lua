local SimpleBullet = Class("SimpleBullet", Entity)


function SimpleBullet:initialize(px,py,x,y,rot,deltaspeed,scene)
	Entity.initialize(self,px,py,scene)

	self.rot = rot
	self.speed = 500 + deltaspeed
	self.radius = 10

	self:setShape(HC:rectangle(100,100,20,10))
	self.scene.timer:after(2,function() self:kill() end)
end

function SimpleBullet:updateRelativeSpeed(ds)
	self.speed = self.speed + ds
end

function SimpleBullet:update(dt)

	local dx,dy = Vectorl.rotate(self.rot,self.speed*dt,0) 
	self.x,self.y = self.x+dx,self.y+dy

	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end


function SimpleBullet:draw()
	love.graphics.setColor(255,255,255)
	lg.draw(resmgr:getImg("normalshot.png"), self.x, self.y, self.rot, 1,1, 10,5)
	self.shape:draw("line")
end

function SimpleBullet:gamepadaxis( joystick, axis, value )
end


return SimpleBullet
