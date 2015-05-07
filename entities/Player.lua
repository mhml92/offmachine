local Player = Class("Player", Entity)
function Player:initialize(x,y,scene)
	Entity:initialize(x,y,scene)

	local lp = love.physics
	self.body = lp.newBody(self.scene.world,self.x,self.y,'dynamic')
	self.shape = lp.newCircleShape(16)
	self.fixture = lp.newFixture(self.body,self.shape)
	self.body:setLinearDamping(15)
	
	local mx,my = love.mouse.getPosition()
	self.lookr = Vector.angleTo(mx-self.x,my-self.y)
	self.speed = 300	
end

function Player:update(dt)
	local dir = {x = 0,y = 0}
	if self.key["w"] then
		dir.y = dir.y - 1 	
	end

	if self.key["s"] then
		dir.y = dir.y + 1 	
	end

	if self.key["a"] then
		dir.x = dir.x - 1 	
	end

	if self.key["d"] then
		dir.x = dir.x + 1 	
	end
	if Vector.len2(dir.x,dir.y) > 0 then
		
		dir.x,dir.y = Vector.normalize(dir.x,dir.y)
		local r,mx,my
		r = Vector.angleTo(dir.x,dir.y)
		mx = math.cos(r) * self.speed
		my = math.sin(r) * self.speed
		self.body:setLinearVelocity(mx,my)
	end

	self.x = self.body:getX()
	self.y = self.body:getY()
	local mx,my = self.scene.cammgr.cam:worldCoords(love.mouse.getPosition())
	self.lookr = Vector.angleTo(Vector.normalize(mx-self.x,my-self.y))
	self.scene.cammgr:update(self.x,self.y,dt)
end


function Player:draw()
	local lg = love.graphics
	lg.setColor(255,0,0)
	lg.circle('fill', self.x, self.y, 16, 32)
	lg.setColor(0,0,255)
	lg.line(self.x,self.y,self.x+(math.cos(self.lookr)*16),self.y+(math.sin(self.lookr)*16))
	lg.setColor(255,255,255)
end


return Player
