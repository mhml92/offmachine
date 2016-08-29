local Projectile = Class("Projectile",Entity)

function Projectile:initialize(x,y,scene,speed,dir)
	Entity:initialize(x,y,scene)
	local lp = love.physics
   self.radius = 3
   self.hitRadius = self.radius
   self.hitx = self.x
   self.hity = self.y

	self.body 		= lp.newBody(self.scene.world,self.x,self.y,'dynamic')
	self.shape 		= lp.newCircleShape(self.radius)
	self.fixture 	= lp.newFixture(self.body,self.shape)
  
   self.fixture:setSensor(true)
   self.body:setBullet(true)
   self.fixture:setUserData(self)
	self.body:setLinearVelocity(math.cos(dir)*speed,math.sin(dir)*speed)

   self.sound = scene.soundmgr:addSound("bullet_impact.mp3", false, 1)
	self.debug = {}
	self.debug.time = 0
end

function Projectile:update(dt)
	self.debug.time = self.debug.time + dt
	self.x = self.body:getX()
	self.y = self.body:getY()

   local lvx,lvy = self.body:getLinearVelocity() 
   lvx,lvy = lvx*dt,lvy*dt
   self.hitRadius = math.max(Vector.len(lvx,lvy)/2,self.radius)
   self.shape:setRadius(self.hitRadius)
   
   self.hitx = self.x + (lvx/2)
   self.hity = self.y + (lvy/2)
   

	if self.debug.time > 0.2 then
		self:kill()
	end

end

function Projectile:draw()
	local lg = love.graphics
	lg.setColor(255,128,0)
	lg.circle('fill', self.x, self.y, self.shape:getRadius(), 16)
	lg.setColor(255,0,255)
	lg.circle('line', self.hitx, self.hity, self.hitRadius, 16)
	lg.setColor(255,255,255)
end

function Projectile:exit()
   self.scene.soundmgr:playSound(self.sound)
end

return Projectile
