local Player = Class("Player", Entity)
local SimpleBullet = require 'entities/SimpleBullet'


function Player:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 10
	self.shape = HC:rectangle(100,100,2*self.radius,2*self.radius)
	self.shape.owner = self
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 10
	self.weight = 20
	self.maxspeed = 15
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0

	self.drag = 0.95

	self.rot = 0
	self.rot_f = 0.5
	self.rotation_momentum = 0
	self.rotation_drag = 0.91
	self.maxrotarion = 0.1
end

function Player:update(dt)
	local leftx,lefty,leftt,reightx,righty,rightt = self.joystick:getAxes( )

	leftt,rightt = ((leftt+1)/2),((rightt+1)/2)

	local f_r,f_x,f_y = 0,0,0
	if math.abs(lefty) > 0.2 or math.abs(righty) > 0.2 then
		lf_x,lf_y = 0,lefty
		--lf_x,lf_y = Vectorl.rotate(self.rot,lf_x,lf_y)
		local rf_x,rf_y = 0,righty
		--rf_x,rf_y = Vectorl.rotate(self.rot,rf_x,rf_y)
		 f_x,f_y = Vectorl.add(lf_x,lf_y,rf_x,rf_y)
		 f_r = -lefty - (-righty)
		f_x,f_y = Vectorl.rotate(self.rot,f_x,f_y)
	end


	self.rotation_momentum = self.rotation_momentum + (self.rot_f*(f_r/(2*self.weight)))
	if self.rotation_momentum > self.maxrotarion then 
		self.rotation_momentum = self.maxrotarion 
	elseif self.rotation_momentum < -self.maxrotarion then
		self.rotation_momentum = -self.maxrotarion 
	end
	self.rot = self.rot + self.rotation_momentum
	self.rotation_momentum = self.rotation_momentum * self.rotation_drag

	--[[
	self.left_motor_pos ={
		x = -self.radius,
		y = 0
	}
	self.right_motor_pos ={
		x = self.radius,
		y = 0
	}
	]]
	--if math.abs(leftx) > 0.2 then
	self.momentum.x = self.momentum.x + (f_x*self.force/self.weight)
	--end
	--if math.abs(lefty) > 0.2 then
	self.momentum.y = self.momentum.y + (f_y*self.force/self.weight)
	--end
	if Vectorl.len(self.momentum.x,self.momentum.y) > self.maxspeed then 
		self.momentum.x = self.maxspeed*self.momentum.x/Vectorl.len(self.momentum.x,self.momentum.y)
		self.momentum.y = self.maxspeed*self.momentum.y/Vectorl.len(self.momentum.x,self.momentum.y)
	end

	self.y = self.y + self.momentum.y
	self.x = self.x + self.momentum.x
	self.momentum.x = self.momentum.x*self.drag
	self.momentum.y = self.momentum.y*self.drag
	
	--self.left_motor_pos.x,self.left_motor_pos.y = Vectorl.rotate(self.rot,self.left_motor_pos.x,self.left_motor_pos.y)
	--self.right_motor_pos.x,self.right_motor_pos.y = Vectorl.rotate(self.rot,self.right_motor_pos.x,self.right_motor_pos.y)
	--self.left_motor_pos.x,self.left_motor_pos.y = self.left_motor_pos.x+self.x,self.left_motor_pos.y+self.y
	--self.right_motor_pos.x,self.right_motor_pos.y = self.right_motor_pos.x+self.x,self.right_motor_pos.y+self.y

	--if Vectorl.len(leftx,lefty) < Vectorl.len(rightx,righty) then
		
	--end



	-- min common vector length
	--local left = Vector.len(leftx,lefty)
	--local right = Vector.len(rightx,righty)
	--if left > right then
	--	local center_vec = self.x-self.radius,self.y-self.radius	
	--else

	--end
	--local min_vec = math.min(left,right)
	--local max_vec = math.max(left,right)
	--local vec_diff = max_vec-min_vec

	--



	
	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)
end

function Player:shoot()
	self.scene:addEntity(SimpleBullet:new(self.x,self.y,self.rot,Vectorl.len(self.momentum.x,self.momentum.y),self.scene), self.scene.layers.objects)
end


function Player:draw()
	love.graphics.setColor(255,255,255)
	self.shape:draw("fill")
	love.graphics.setColor(0,255,255)

	local px,py = 0,-self.radius
	px,py = Vectorl.rotate(self.rot,px,py)
	love.graphics.circle( "fill", self.x+px, self.y+py, 10, 10 )
	--love.graphics.line(self.left_motor_pos.x,self.left_motor_pos.y,self.right_motor_pos.x,self.right_motor_pos.y)
end

function Player:gamepadpressed( joystick,button)
	if button== "rightshoulder" then
		self:shoot()
	end
	print(axis,value)
end


return Player
