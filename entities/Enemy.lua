local Enemy = Class("Enemy", Entity)
function Enemy:initialize(x,y,scene)
	Entity:initialize(x,y,scene)
	self.g = G.test_enemy

	self.rect = HC.rectangle(self.x,self.y,self.g.x_size,self.g.y_size)
	self.rect.owner = self

	self:loiter()
end

function Enemy:update(dt)

	self.rect:moveTo(self.x,self.y)

end

function Enemy:getPlayerPos()
	return self.scene.cammgr.cam:worldCoords(love.mouse.getPosition())
end

function Enemy:loiter()
	self.tweenHandle = self.scene.timer.after(self.g.loiter_time,function() self:move()end )
end

function Enemy:move()
	local px,py = self:getPlayerPos()
	local dx,dy = px-self.x,py-self.y
	dx,dy = self.x + dx*0.5,self.y +dy*0.5

	self.tweenHandle = self.scene.timer.tween(self.g.move_time,self,{x = dx,y = dy},'in-out-back',function() self:loiter()end)
end



function Enemy:draw()
	self.rect:draw("fill")
end


return Enemy
