local SimpleBullet = Class("SimpleBullet", Entity)


function SimpleBullet:initialize(px,py,x,y,rot,deltaspeed,scene, color, time)
	Entity.initialize(self,px,py,scene)
	
	self.color = color or 2

	self.rot = rot
	self.speed = 150 + deltaspeed
	self.radius = 10

	self:setShape(HC:rectangle(100,100,20,10))
	--self.color = G.color_theme[G_functions.rand(1,#G.color_theme)]
	self.scene.timer:after(time or 2,function() self:kill() end)
	
	self.sprite = resmgr:getImg("bullets.png")
	self.quad = love.graphics.newQuad((self.color-1)*3,0,3,10,9,10)
end

function SimpleBullet:updateRelativeSpeed(ds)
	self.speed = self.speed + ds
end

function SimpleBullet:update(dt)

	local dx,dy = Vectorl.rotate(self.rot,self.speed*dt,0) 
	self.x,self.y = self.x+dx,self.y+dy

	if self.x > WIDTH then
		self.x = self.x - WIDTH
	end
	if self.x < 0 then
		self.x = self.x + WIDTH
	end

	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end


function SimpleBullet:draw()
	--love.graphics.setColor(self.color)
	--lg.draw(resmgr:getImg("normalshot.png"), self.x, self.y, self.rot, 0.5,0.5, 10,5)
	lg.setColor(255,255,255)
	lg.draw(self.sprite, self.quad, self.x, self.y, self.rot+math.pi/2, 2, 2)
	--self.shape:draw("line")
end

function SimpleBullet:gamepadaxis( joystick, axis, value )
end


return SimpleBullet
