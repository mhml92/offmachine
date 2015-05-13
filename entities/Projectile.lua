local Projectile = Class("Projectile",Entity)

function Projectile:initialize(x,y,scene,speed,dir)
	Entity:initialize(x,y,scene)
	
	local lp = love.physics
	self.body 		= lp.newBody(self.scene.world,self.x,self.y,'dynamic')
	self.shape 		= lp.newCircleShape(4)
	self.fixture 	= lp.newFixture(self.body,self.shape)
	self.fixture:setSensor(true)

	self.body:setLinearVelocity(math.cos(dir)*speed,math.sin(dir)*speed)

	self.debug = {}
	self.debug.time = 0
end

function Projectile:update(dt)
	self.debug.time = self.debug.time + dt
	self.x = self.body:getX()
	self.y = self.body:getY()

	if self.debug.time > 0.2 then
		self:kill()
	end

end

function Projectile:draw()
	local lg = love.graphics
	lg.setColor(255,0,0)
	lg.circle('fill', self.x, self.y, 16, 32)
	lg.setColor(255,255,255)
end

return Projectile
