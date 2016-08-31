local SimpleBullet = require 'entities/SimpleBullet'
local EnemyBullet = Class("EnemyBullet", SimpleBullet)


function EnemyBullet:initialize(px,py,x,y,rot,deltaspeed,scene)
	SimpleBullet.initialize(self,px,py,x,y,rot,deltaspeed,scene)

end

function EnemyBullet:draw()
	love.graphics.setColor(255,64,64)
	--lg.draw(resmgr:getImg("normalshot.png"), self.x, self.y, self.rot, 1,1, 10,5)
	self.shape:draw("fill")
end

return EnemyBullet
