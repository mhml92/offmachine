local Player = Class("Player", Entity)
function Player:initialize(x,y,scene)
	Entity:initialize(x,y,scene)

	self.shape = HC.rectangle(100,100,20,20)
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 10
	self.weight = 10
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.9

	

	
end

function Player:update(dt)
	local leftx,lefty,leftt,reightx,righty,rightt = self.joystick:getAxes( )
	print(leftx, lefty)
	
	leftt,rightt = ((leftt+1)/2),((rightt+1)/2)



	if math.abs(leftx) > 0.2 then
		self.momentum.x = self.momentum.x + (leftx*self.force/self.weight)
	end
	if math.abs(lefty) > 0.2 then
		self.momentum.y = self.momentum.y + (lefty*self.force/self.weight)
	end

	self.y = self.y + self.momentum.y
	self.x = self.x + self.momentum.x
	self.momentum.x = self.momentum.x*self.drag
	self.momentum.y = self.momentum.y*self.drag


	
	self.shape:moveTo(self.x,self.y)
end


function Player:draw()
	self.shape:draw("fill")
end

function Player:gamepadaxis( joystick, axis, value )
	print(axis,value)
end


return Player
