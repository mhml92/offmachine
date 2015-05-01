local StaticObject = Class("StaticObject", Entity)
function StaticObject:initialize(x,y,scene)
	
	Entity:initialize(x,y,scene)
	self.animation = Animation:new("conveyor_belt.png", 4, false, scene)
	self.animation:setPosition(x, y)
	self.animation:setFPS(10)
end

return StaticObject