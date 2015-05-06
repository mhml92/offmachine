local Player = Class("Player", Entity)
function Player:initialize(x,y,scene)
	
	Entity:initialize(x,y,scene)

	self.animation = Animation:new("legs.png", 18, true, scene)
	self.animation:setCoordinateSource(self)
	self.animation:setFPS(6.5)

	self.speed = 300	
end

function Player:update(dt)
	if self.key["up"] then
		self.y = self.y - self.speed * dt
	end
		
	if self.key["down"] then
		self.y = self.y + self.speed * dt
	end

	if self.key["left"] then
		self.x = self.x - self.speed * dt
	end
		
	if self.key["right"] then
		self.x = self.x + self.speed * dt
	end

	self.scene.cammgr:update(self.x,self.y,dt)
end

function Player:draw()
	love.graphics.draw(self.scene.resmgr:getImg("player.png"),self.x,self.y,0,1,1,16,16)
end


return Player
