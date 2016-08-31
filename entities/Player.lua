local Player = Class("Player", Entity)

local ACC = 0.5
local SPEED = 100
local SPEED_DAMPER = 1.03
local MAX_SPEED = 20
local MAX_ROOT_SPEED = 0.2
local ROT_ACC = 2
local ROT_DAMPER = 1.03
local ROT_DAMPER_MULTIPLIER = 1.25

function Player:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.shape = HC:rectangle(100,100,20,20)
	self.shape.owner = self
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
	love.graphics.setColor(0,0,0)
	self.shape:draw("fill")
end

function Player:gamepadaxis( joystick, axis, value )
	print(axis,value)
end


return Player
