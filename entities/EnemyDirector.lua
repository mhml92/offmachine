local EnemyDirector = Class("EnemyDirector", Entity)

local EnemyChaser = require 'entities/EnemyChaser'
local EnemyLineFormation = require 'entities/EnemyLineFormation'

function EnemyDirector:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.timer = 0
end

function EnemyDirector:update(dt)
	self.timer = self.timer + dt
	if self.timer > 5 then
		self:addEnemy()
		self.timer = 0
	end
end

function EnemyDirector:addEnemy()
	local rx = math.random(300)
	local ry = math.random(300)
	local player = self.scene.player
	local e = EnemyChaser:new(player.x+rx, player.y+ry, self.scene)
	self.scene:addEntity(e, self.scene.layers.objects)
end

function EnemyDirector:draw()

end

return EnemyDirector