local NewPlayer = Class("NewPlayer", Entity)

local RemoteRocket = require 'entities/RemoteRocket'
local WeaponInterface = require 'entities/WeaponInterface'

local vector = require 'hump.vector-light'

local deathshader = love.graphics.newShader[[
	extern float percent;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords);
		return vec4(max(1.0*percent, pixel.r),max(1.0*percent, pixel.g), max(1.0*percent, pixel.b), pixel.a);//red
    }
]]

function NewPlayer:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)

	self.radius = 16
	self:setShape(HC:rectangle(100,100,2*self.radius,2*self.radius))
	--print(#love.joystick.getJoysticks( ),"here")
	self.joystick = love.joystick.getJoysticks( )[1]
	self.force = 20
	self.maxspeed = 200
	self.dash_force = 750
	self.dash_time = 0.15
	self.momentum = {}
	self.momentum.x = 0
	self.momentum.y = 0
	self.drag = 0.995

	self.dashing = 0
	self.dash_dir = "left"

	self.back = resmgr:getImg("ship.png")
	self.front = resmgr:getImg("spaceship_front.png")

	self.rot = 0
	self.has_been_hit = 0
	self.declutter_strenght = 250

	self.weapon = WeaponInterface:new(self)
	self.scene:addEntity(self.weapon, scene.layers.gui)	

	self:addCollisionResponse("PowerUp",self.handlePowerUp,self)
	self:addCollisionResponse("EnemyChaser",self.hitEnemyShip,self)
	self:addCollisionResponse("EnemyZapper",self.hitEnemyShip,self)
	self:addCollisionResponse("EnemyBullet",self.hitEnemyBullet,self)
end

function NewPlayer:hitEnemyShip(shape,delta)
	if shape.owner.alive then
		local dxn, dyn = vector.normalize(shape.owner.x-self.x, shape.owner.y-self.y)
		
		self.momentum.x = self.momentum.x - dxn * self.declutter_strenght
		self.momentum.y = self.momentum.y - dyn * self.declutter_strenght
		
		shake_screen(3)
		if self.has_been_hit <= 0 then
			self.scene.hud:loseTime(5)
			self.has_been_hit = 0.5
		end
	end
end

function NewPlayer:hitEnemyBullet(shape,delta)
	if shape.owner.alive then
		if self.has_been_hit < 0 then
			shake_screen(5)
			self.scene.hud:loseTime(10)
			self.has_been_hit = 1
			shape.owner:kill()
		else
			if self.has_been_hit < 0.1 then
				self.has_been_hit = 0.2
			end
		end
	end
end


function NewPlayer:update(dt)

	-- JERES MOVEMENT
	--local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	--	leftx,lefty,leftt,rightx,righty,rightt = 0,0,0,0,0,0
	--	local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	local leftx,lefty,leftt,rightx,righty,rightt = self.joystick:getAxes( )
	--leftx,lefty,leftt,rightx,righty,rightt = 0,0,0,0,0,0

	-- JESPERS MOVEMENT
	--local leftx,lefty,rightx,righty,leftt,rightt = self.joystick:getAxes( )

	self.weapon:update(dt)

	--if math.abs(rightx) > 0.5 or math.abs(righty) > 0.5 then
	--	--self:shoot(rightx,righty)
	--	self:shoot(self.momentum.x,self.momentum.y)
	--end
	if math.abs(leftx) < 0.2 then
		leftx = 0
	end
	if self.dashing <= 0 then

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


		self.momentum.x = self.momentum.x + (leftx*(self.force))
		self.momentum.y = self.momentum.y + (lefty*(self.force))

		if self.recoil then
			self.x = self.x+ (math.cos(self.recoil_dir)+math.rad(G_functions.rand(1,20)-10))*((self.recoil and -self.recoil or 0))
			--self.momentum.x = self.momentum.x + (math.cos(self.recoil_dir)+math.rad(G_functions.rand(1,20)-10))*((self.recoil and -self.recoil or 0))
			self.y = self.y+ (math.sin(self.recoil_dir)+math.rad(G_functions.rand(1,20)-10))*((self.recoil and -self.recoil or 0))
			--self.momentum.y = self.momentum.y + (math.sin(self.recoil_dir)+math.rad(G_functions.rand(1,20)-10))*((self.recoil and -self.recoil or 0))
		end
		self.recoil = nil

		self.rot = Vectorl.angleTo(self.momentum.x,self.momentum.y)

		local lenght = Vectorl.len(self.momentum.x,self.momentum.y)


		if self.has_been_hit > 0 then
			self.maxspeed = 1500
			self.force = math.min(1/(self.has_been_hit*self.has_been_hit),20)
		else
			self.maxspeed = 200
			self.force = 20
		end
		self.x = self.x + math.cos(self.rot)*math.min(lenght,self.maxspeed) * dt
		self.y = self.y + math.sin(self.rot)*math.min(lenght,self.maxspeed) * dt

		self.momentum.x = self.momentum.x*(self.drag)
		self.momentum.y = self.momentum.y*(self.drag)

		local lenght = Vectorl.len(self.momentum.x,self.momentum.y)

		if lenght > self.maxspeed then
			local fac = lenght/self.maxspeed
			self.momentum.x = self.momentum.x / fac
			self.momentum.y = self.momentum.y / fac

		end 




	else
		if self.dash_dir == "right" then
			local px,py = vector.perpendicular(self.momentum.x,self.momentum.y)

			local rot = Vectorl.angleTo(px,py)

			self.x = self.x + math.cos(rot)*self.dash_force*dt
			self.y = self.y + math.sin(rot)*self.dash_force*dt 
		end
		if self.dash_dir == "left" then
			local px,py = vector.perpendicular(self.momentum.x,self.momentum.y)

			local rot = Vectorl.angleTo(px,py)

			rot = rot + math.rad(180)
			self.x = self.x + math.cos(rot)*self.dash_force*dt
			self.y = self.y + math.sin(rot)*self.dash_force*dt 
		end
		self.dashing = self.dashing - dt
	end

	self.has_been_hit = self.has_been_hit - dt
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
	--print(shape, delta)
	local powerup = shape.owner
	if powerup.alive then
		if powerup.type == 4 then
			self.weapon:gainLevel()
			self.scene.hud:juiceLevel()
		else
			self.weapon:changeType(powerup.type)
			self.scene.hud:juiceWeapon()
		end
		powerup:kill()
	end
end

function NewPlayer:shoot(x,y)
	local rot = Vectorl.angleTo(x,y)
	local recoil = self.weapon:shoot(x,y,rot,Vectorl.len(self.momentum.x,self.momentum.y))

	self.recoil = recoil
	self.recoil_dir = rot
end


function NewPlayer:draw()
	love.graphics.setColor(255,255,255,255)
	local percent = self.has_been_hit*2
	if percent > 0 then
		deathshader:send("percent", percent)
		lg.setShader(deathshader)
	end

	love.graphics.draw(self.back, self.x, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16, self.y-16)
	love.graphics.draw(self.back, self.x+WIDTH, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16+WIDTH, self.y-16)
	love.graphics.draw(self.back, self.x-WIDTH, self.y, self.rot+math.pi/2, 1, 1, 16, 16)
	--love.graphics.draw(self.front, self.x-16-WIDTH, self.y-16)

	lg.setShader()

	--love.graphics.setColor(0,255,0, 50)
	--love.graphics.rectangle("fill", self.x-7, self.y+3, 14, 40)
	love.graphics.setColor(255,255,255,255)
end

function NewPlayer:gamepadpressed( joystick,button)
	if button == "a" then

		self:shoot(self.momentum.x,self.momentum.y)
		if button == "rightshoulder" then
			self.dashing = 0.10
			self.dash_dir = "right"
		end

		if button == "leftshoulder" then
			self.dashing = 0.10
			self.dash_dir = "left"
		end
	end
end


	return NewPlayer
