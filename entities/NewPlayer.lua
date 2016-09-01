local NewPlayer = Class("NewPlayer", Entity)

local RemoteRocket = require 'entities/RemoteRocket'
local WeaponInterface = require 'entities/WeaponInterface'

local vector = require 'hump.vector-light'

function NewPlayer:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 16
	self:setShape(HC:rectangle(100,100,2*self.radius,2*self.radius))
	self.joystick = love.joystick.getJoysticks( )[1]
	
	self.force = 200 
	self.weight = 20
	self.maxspeed = 15000
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.99
	
	self.back = resmgr:getImg("ship.png")
	self.front = resmgr:getImg("spaceship_front.png")

	self.rot = 0

	self.weapon = WeaponInterface:new(self)
	self.scene:addEntity(self.weapon, scene.layers.gui)

	self:addCollisionResponse("PowerUp",self.handlePowerUp,self)
end

function NewPlayer:update(dt)

	-- JERES MOVEMENT
	local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	--leftx,lefty,leftt,rightx,righty,rightt = 0,0,0,0,0,0
	
	-- JESPERS MOVEMENT
	--local leftx,lefty,rightx,righty,leftt,rightt = self.joystick:getAxes( )

	self.weapon:update(dt)
	if Vectorl.len(rightx,righty) > 0.9 then
	--	self.weapon:update(dt)	
	end

	if math.abs(rightx) > 0.5 or math.abs(righty) > 0.5 then
		--self:shoot(rightx,righty)
		self:shoot(self.momentum.x,self.momentum.y)
	end
	if math.abs(leftx) < 0.2 then
		leftx = 0
	end

	if math.abs(lefty) < 0.2 then
		lefty = 0
	end

	

	-- normalize gamepad triggers
	leftt,rightt = ((leftt+1)/2),((rightt+1)/2)

	self.rot = Vectorl.angleTo(self.momentum.x,self.momentum.y)

	self.momentum.x = self.momentum.x + (leftx*self.force /self.weight)
	self.momentum.y = self.momentum.y + (lefty*self.force /self.weight)
	if self.recoil then
		self.momentum.x = self.momentum.x + math.cos(self.recoil_dir)*((self.recoil and -self.recoil or 1)/self.weight)
		self.momentum.y = self.momentum.y + math.sin(self.recoil_dir)*((self.recoil and -self.recoil or 1)/self.weight)
	end
	self.recoil = nil

	self.y = self.y + self.momentum.y * dt
	self.x = self.x + self.momentum.x *dt
	self.momentum.x = self.momentum.x*self.drag
	self.momentum.y = self.momentum.y*self.drag
	if self.x < 0 then self.x = self.x+WIDTH end
	if self.y < 0 then self.y = 0 end
	if self.x > WIDTH then self.x = self.x -WIDTH end
	if self.y > HEIGHT then self.y = HEIGHT end
	self.shape:moveTo(self.x,self.y)
	self.shape:setRotation(self.rot)

	
	local ndx, ndy = math.cos(self.rot), math.sin(self.rot)
	local pndx, pndy = vector.perpendicular(ndx, ndy)
	for i=1,5 do
        --+(G_functions.rand(0,40)-20)/10
        local part = Particle:new(
				self.x+G_functions.rand(-8,8)*pndx +30*(-ndx),
				self.y+G_functions.rand(-8,8)*pndy +30*(-ndy),
				self.scene,
				G_functions.rand(3,7),
				G_functions.rand(3,7),
				0,
				(G_functions.rand(3,15)),
				math.rad(G_functions.rand(0,360)),
				0,
				G_functions.rand(0,0.5),
				self)
        part:setColor(G_functions.deepcopy(G.fire_colors[G_functions.rand(1,3)]),G_functions.deepcopy(G.fire_colors[G_functions.rand(4,5)]))
        self.scene:addEntity(part, self.scene.layers.objects)
    end
	 
	 self:checkCollision()
	 
end

function NewPlayer:handlePowerUp(shape,delta)
	print(shape, delta)
	local powerup = shape.owner
	if powerup.type == 4 then
		self.weapon:gainLevel()
	else
		self.weapon:changeType(powerup.type)
	end
	powerup:kill()
end

function NewPlayer:shoot(x,y)
	local rot = Vectorl.angleTo(x,y)
	local recoil = self.weapon:shoot(x,y,rot,Vectorl.len(self.momentum.x,self.momentum.y))

	self.recoil = recoil
	self.recoil_dir = rot
end


function NewPlayer:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.back, self.x, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16, self.y-16)
	love.graphics.draw(self.back, self.x+WIDTH, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16+WIDTH, self.y-16)
	love.graphics.draw(self.back, self.x-WIDTH, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16-WIDTH, self.y-16)
		

	--love.graphics.setColor(0,255,0, 50)
	--love.graphics.rectangle("fill", self.x-7, self.y+3, 14, 40)
	love.graphics.setColor(255,255,255,255)
end

function NewPlayer:gamepadpressed( joystick,button)
end


return NewPlayer
