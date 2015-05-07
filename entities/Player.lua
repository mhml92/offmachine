local Player = Class("Player", Entity)
function Player:initialize(x,y,scene)
	Entity:initialize(x,y,scene)

	local lp = love.physics
	self.body = lp.newBody(self.scene.world,self.x,self.y,'dynamic')
	self.shape = lp.newCircleShape(16)
	self.fixture = lp.newFixture(self.body,self.shape)
	
	self.speed = 300	
end

function Player:update(dt)
	local dir = {x = 0,y = 0}
	if self.key["up"] then
		dir.y = dir.y - 1 	
	end

	if self.key["down"] then
		dir.y = dir.y + 1 	
	end

	if self.key["left"] then
		dir.x = dir.x - 1 	
	end

	if self.key["right"] then
		dir.x = dir.x + 1 	
	end
	if Vector.len2(dir.x,dir.y) > 0 then
		
		dir.x,dir.y = Vector.normalize(dir.x,dir.y)
		local r = Vector.angleTo(dir.x,dir.y)
		local mx,my
		mx = math.cos(r) * self.speed
		my = math.sin(r) * self.speed
		print(mx,my)
		self.body:setLinearVelocity(mx,my)
	end

	self.x = self.body:getX()
	self.y = self.body:getY()
	self.scene.cammgr:update(self.x,self.y,dt)
end


function Player:draw()
	local lg = love.graphics
	lg.setColor(255,0,0)
	lg.circle('fill', self.x, self.y, 16, 32)
	lg.setColor(0,0,255)
	lg.line(self.x,self.y,0,0)
	lg.setColor(255,255,255)
end


return Player
