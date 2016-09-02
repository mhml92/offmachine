local Plan = Class("Plan", Entity)

function Plan:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.notes = resmgr:getImg("plan.png")
end


function Plan:update(dt)
end

function Plan:draw()
	love.graphics.draw(self.notes, 0, 0)
end

return Plan
