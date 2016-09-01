local Meteorite = Class("Meteorite", EnemyBase)

local vector = require 'hump/vector-light'

function Meteorite:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.gravity = 100
	self.radius = 16
	self.tweener = 1
	self.gone = false
	self:setShape(HC:circle(self.x, self.y, self.radius, self.radius))
end

function Meteorite:update(dt)
	self.dy = self.dy + self.gravity * dt
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	if self.scene:belowEventHorizon(self) then
		self.gone = true
		self.scene.timer:tween(0.75, self, {tweener = 0}, "in-linear", function() self:kill() end)
	end
end

local lg = love.graphics
function Meteorite:draw()
	if self.gone then
		lg.setColor(255, 255, 255, 255*self.tweener)
		lg.circle("fill", self.x, self.y, self.radius * self.tweener)
	else
		lg.setColor(255, 255, 255)
		lg.circle("fill", self.x, self.y, self.radius)
	end
	lg.setColor(255, 255, 255, 255)
end

return Meteorite