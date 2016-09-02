local EnemyChaser = Class("EnemyChaser", EnemyBase)

local vector = require 'hump/vector-light'

local enemydebris = require 'entities/EnemyDebris'

local deathshader = love.graphics.newShader[[
	extern float percent;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel = Texel(texture, texture_coords);
		return vec4(max(1.0*percent, pixel.r),max(1.0*percent, pixel.g), max(1.0*percent, pixel.b), pixel.a);//red
    }
]]

function EnemyChaser:initialize(x,y,scene)
	EnemyBase.initialize(self,x,y,scene)
	self.aware_radius = 300
	self.radius = 20
	self.player = scene.player
	self.state = LOITERING
	self.destroy_animation = 0
	self.acc = 2
	self:setShape(HC:circle(self.x, self.y, self.radius, self.radius))
	self:addCollisionResponse("SimpleBullet", self.test, self)
	self:addCollisionResponse("EnemyChaser", self.decluster, self)
	self.sprite = resmgr:getImg("chaser.png")
	self.has_been_hit = 0
	self.back = love.graphics.newQuad(0, 0, 40, 40, 120, 40)
	self.eye = love.graphics.newQuad(40, 0, 40, 40, 120, 40)
	self.front = love.graphics.newQuad(80, 0, 40, 40, 120, 40)

	self.debris = {}
	self.xsize,self.ysize,self.numx,self.numy = 40,40,G_functions.rand(4,8),G_functions.rand(4,8)
	for i=0,self.numy-1 do
		self.debris[i] = {}
		for j=0,self.numx-1 do
			self.debris[i][j] = love.graphics.newQuad(j*(self.xsize/self.numx), i*(self.ysize/self.numy), self.xsize/self.numx, self.ysize/self.numx, 120, 40)
		end
	end

	self.eye_offx = 0
	self.eye_offy = 0
	self.drag = 0.995
	self.life = 3
	self.declutter_strenght = 2 
	self.enterSound = self.scene.soundmgr:addSound("chaser.mp3",false,1.0)
end

function EnemyChaser:test(shape,delta)
	if shape.owner.alive and self.alive then
		shape.owner:kill()
		self.life = self.life - 1
		if self.life <= 0 then
			self:destroy()
			shake_screen(G_functions.rand(0,30)/10)
			for i=0,self.numy-1 do
				for j=0,self.numx-1 do
					self.scene:addEntity(enemydebris:new(self.x+j*(self.xsize/self.numx),self.y+i*(self.ysize/self.numy),self.scene,self.debris[i][j],5,self.sprite,(self.xsize/self.numx),(self.ysize/self.numy)), self.scene.layers.objects)
				end
			end

			for i=1,25 do
				--+(G_functions.rand(0,40)-20)/10
				local part = Particle:new(
					self.x+G_functions.rand(-8,8),
					self.y+G_functions.rand(-8,8),
					self.scene,
					G_functions.rand(-25,25),
					G_functions.rand(-25,25),
					G_functions.rand(-25,25),
					G_functions.rand(-25,25),
					math.rad(G_functions.rand(0,360)),
					0,
					G_functions.rand(0,1.5),
					nil)
				part:setColor(G_functions.deepcopy(G.fire_colors[G_functions.rand(1,3)]),G_functions.deepcopy(G.fire_colors[G_functions.rand(4,5)]))
				self.scene:addEntity(part, self.scene.layers.objects)
			end
		end
		self.has_been_hit = 1
	end
end

function EnemyChaser:decluster(shape, delta)
	local dxn, dyn = vector.normalize(shape.owner.x-self.x, shape.owner.y-self.y)
	
	self.dx = self.dx - dxn * self.declutter_strenght
	self.dy = self.dy - dyn * self.declutter_strenght
end

function EnemyChaser:update(dt)
	EnemyBase.update(self,dt)
	local p = self:getClosestPlayer()
	local dxn, dyn = vector.normalize(p.x-self.x, p.y-self.y)
	self.dx = self.dx + (dxn+G_functions.rand(-4,4)) * dt * self.acc
	self.dy = self.dy + (dyn+G_functions.rand(-4,4)) * dt * self.acc
	self.dx,self.dy = self.dx*self.drag,self.dy*self.drag

	self.x = self.x + self.dx
	self.y = self.y + self.dy

	self.has_been_hit = self.has_been_hit - dt
	-- look at player
	
	p.x,p.x = p.x-self.x,p.y-self.y
	local nep = Vectorl.len(p.x,p.y)
	self.eye_offx,self.eye_offy = 6*dxn,6*dyn--p.x/nep,6*p.y/nep

	
	if self.shape then
		self.shape:moveTo(self.x,self.y)
		self:checkCollision()
	end
end

--function EnemyChaser:getClosestPlayer()
--	return self.scene.player.x,self.scene.player.y
--end

local lg = love.graphics
function EnemyChaser:draw()
	lg.setColor(255, 255, 255)
	local scale = 1
	if self.destroyed then
		scale = self.destroy_tween
	elseif self.state == LOITERING then
		lg.setColor(255, 0, 0)
	elseif self.state == CHASING then
		lg.setColor(0, 255, 0)
	end
	lg.setColor(255,255,255)
	local percent = self.has_been_hit
	if percent > 0 then
		deathshader:send("percent", percent)
		lg.setShader(deathshader)
	end

	lg.draw(self.sprite, self.back, self.x-20, self.y-20)
	lg.draw(self.sprite, self.eye, self.x-20+self.eye_offx, self.y-20+self.eye_offy)
	lg.draw(self.sprite, self.front, self.x-20, self.y-20)
	
	if self.has_been_inside then
		lg.draw(self.sprite, self.back, self.x-20+WIDTH, self.y-20)
		lg.draw(self.sprite, self.back, self.x-20-WIDTH, self.y-20)
		lg.draw(self.sprite, self.front, self.x-20+WIDTH, self.y-20)
		lg.draw(self.sprite, self.front, self.x-20-WIDTH, self.y-20)
		lg.draw(self.sprite, self.eye, self.x-20+self.eye_offx+WIDTH, self.y-20+self.eye_offy)
		lg.draw(self.sprite, self.eye, self.x-20+self.eye_offx-WIDTH, self.y-20+self.eye_offy)
	end

	lg.setShader()

end

function EnemyChaser:exit()

	
	self.scene.soundmgr:playSound(self.explodeSound3)
end

return EnemyChaser
