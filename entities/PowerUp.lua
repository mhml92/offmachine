local PowerUp = Class("PowerUp", Entity)

function PowerUp:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 10
	self:setShape(HC:rectangle(100,100,2*self.radius,2*self.radius))
	--self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	--self.shape.owner = self
	self.move_speed = 3
	self.loiter_speed = 0.5
	self.type = 1
	local dx,dy = WIDTH/2,HEIGHT/2
	
	
	self.sprites = resmgr:getImg("boxes.png")
	self.quads = {}
	for i=1,4 do
		self.quads[i] = love.graphics.newQuad(0, (i-1)*20, 20, 20, 20, 80)
	end

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
	self:checkCollision()
end

function PowerUp:draw()
	love.graphics.setColor(255,255,255)
	--self.shape:draw("fill")
	love.graphics.draw(self.sprites, self.quads[self.type], self.x, self.y)
end

function PowerUp:keypressed(key)
	if key == "a" then
		self.type = (self.type%4)+1
	end
end

return PowerUp
