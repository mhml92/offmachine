local PowerUp = Class("PowerUp", Entity)

function PowerUp:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 10
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
	self.move_speed = 3
	self.loiter_speed = 0.5
	local dx,dy = WIDTH/2,HEIGHT/2

	self.scene.timer:tween(self.move_speed,self,{x = dx,y = dy},'in-out-sine',function() self:loiter()end)
end

function PowerUp:loiter()
	local dist = 10
	local dx,dy = self.x,self.y
	if self.y < HEIGHT/2 then
		dy = (HEIGHT/2)+10
	else
		dy = (HEIGHT/2)-10
	end
	self.scene.timer:tween(self.loiter_speed,self,{x = self.x,y = dy},'in-out-sine',function() self:loiter()end)
end

function PowerUp:update(dt)
	self.shape:moveTo(self.x,self.y)

end

function PowerUp:draw()
	love.graphics.setColor(255,255,255)
	self.shape:draw("fill")
end

return PowerUp
