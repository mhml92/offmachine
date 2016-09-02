local SimpleBullet = require 'entities/SimpleBullet'
local EnemyBullet = Class("EnemyBullet", SimpleBullet)


function EnemyBullet:initialize(px,py,x,y,rot,deltaspeed,scene)
	SimpleBullet.initialize(self,px,py,x,y,rot,deltaspeed,scene)

	self.sprite = resmgr:getImg("bullets.png")
	self.quad = love.graphics.newQuad(3,0,3,10,9,10)
end

function EnemyBullet:draw()
	--love.graphics.setColor(255,64,64)
	--lg.draw(resmgr:getImg("normalshot.png"), self.x, self.y, self.rot, 1,1, 10,5)
	--self.shape:draw("fill")
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.sprite, self.quad, self.x, self.y, self.rot+math.pi/2, 2,2)
	love.graphics.setColor(255,255,255)
end

return EnemyBullet
