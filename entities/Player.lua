local Player = Class("Player", Entity)
function Player:initialize(x,y,scene)
	Entity:initialize(x,y,scene)

	--[[
	local lp = love.physics
	self.body 		= lp.newBody(self.scene.world,self.x,self.y,'dynamic')
	self.shape 		= lp.newCircleShape(G.PLAYER_SIZE)
	self.fixture 	= lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
	self.body:setLinearDamping(12)
	--]]
	
end

function Player:update(dt)

end


function Player:draw()
	local lg = love.graphics
	lg.setColor(255,0,0)
	lg.circle('fill', self.x, self.y, 16, 32)
	lg.setColor(0,0,255)
	--lg.line(self.x,self.y,self.x+(math.cos(self.lookr)*16),self.y+(math.sin(self.lookr)*16))
	lg.setColor(255,255,255)
end


return Player
