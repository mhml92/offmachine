local EnemyDirector = Class("EnemyDirector", Entity)

local EnemyChaser = require 'entities/EnemyChaser'
local EnemyZapper = require 'entities/EnemyZapper'
local Meteorite = require 'entities/Meteorite'
local PowerUp = require 'entities/PowerUp'

local EVENT_HORIZON_Y = 400

function EnemyDirector:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.timer = 0
	self.active_enemies = 0

	self.wawes = {
		-- first wawe
		{
				
				{
					type = "enemy",
					time_a = 5,
					time_b = 30,
					count = 10,
					obj = EnemyChaser,
					placement = "rnd"
				},
				{
					type = "enemy",
					time_a = 5,
					time_b = 30,
					count = 5,
					obj = EnemyZapper,
					placement = "rnd"
				},
				{
					type = "enemy",
					time_a = 35,
					time_b = 60,
					count = 10,
					obj = EnemyChaser,
					placement = "rnd"
				},
				{
					type = "enemy",
					time_a = 35,
					time_b = 60,
					count = 5,
					obj = EnemyZapper,
					placement = "rnd"
				},
				--{"enemy",0,6,EnemyZapper,"rnd"},
				--{"enemy",2,1,EnemyChaser,"rnd"},
				--{"enemy",3,1,EnemyChaser,"rnd"},
				--{"enemy",4,1,EnemyChaser,"rnd"},
				--{"enemy",5,2,EnemyChaser,"rnd"},
				--{"enemy",6,3,EnemyChaser,"rnd"},
				--{"powerup",37.5*1,4,PowerUp,"top"},   
				--{"powerup",37.5*2,4,PowerUp,"top"},
				--{"powerup",37.5*3,2,PowerUp,"top"},
				--{"powerup",37.5*4,4,PowerUp,"top"},
				--{"powerup",37.5*5,4,PowerUp,"top"},
				--{"powerup",37.5*6,3,PowerUp,"top"},
				--{"powerup",37.5*7,4,PowerUp,"top"},
				--{"powerup",37.5*8,4,PowerUp,"top"}
--
--
--				-- powerup
--				--{10,1,???,"top"}
--				--
--				
--				{8,1,EnemyChaser,"top"},
--
--				{10,1,EnemyChaser,"left"},
--				{10,1,EnemyChaser,"right"},
--
--				{15,1,EnemyChaser,"top"},
--				{15,1,EnemyChaser,"left"},
--				{15,1,EnemyChaser,"right"},
		}
	}
	--[[
	for i=1,5 do
		local meteorite = Meteorite:new(WIDTH+32, -50+math.random(120), self.scene)
		meteorite.dx = -math.random(100, 300)
		self.scene:addEntity(meteorite, self.scene.layers.objects)
	end
	for i=1,5 do
		local meteorite = Meteorite:new(-32, -150+math.random(120), self.scene)
		meteorite.dx = math.random(50, 300)
		self.scene:addEntity(meteorite, self.scene.layers.objects)
	end
	--]]
	self.run_next = true
end

function EnemyDirector:update(dt)
	local t = self.scene.timer
	if self:run_next_wawe() then
		local nw = table.remove(self.wawes)

		for k,obj in ipairs(nw) do

			if obj.type == "powerup"then
				print("POWERUP")
				print("type",obj.type)
			else
				for i = 1,obj.count do
					local wait = love.math.random(obj.time_a,time_b)
					t:after(wait,
						function() 
							local placement = ""
							if obj.placement == "rnd" then
								local p = math.floor(love.math.random(1,3))
								print(p)
								assert(p < 4)
								if p == 1 then
									placement = "top"
								elseif p == 2 then
									placement = "left"
								elseif p == 3 then
									placement = "right"
								end
							end
							local px,py = self:getNewPosition(placement)
							self.scene:addEntity(obj.obj:new(px,py,self.scene), self.scene.layers.objects)
						end
						)	
				end
			end
		end

	end

end

function EnemyDirector:getNewPosition(at)
	print(at)
	if at == "top" then
		return math.random()*WIDTH,-100
	elseif at == "left" then
		return -100,math.random()*HEIGHT
	elseif at == "right" then
		return WIDTH+100,math.random()*HEIGHT
	end

end

function EnemyDirector:run_next_wawe()
	local rn = self.run_next
	self.run_next = false
	return rn
end

function EnemyDirector:belowEventHorizon(obj)
	return obj.y > EVENT_HORIZON_Y
end


function EnemyDirector:wawe1()
	for i = 1,6 do
		local x,y = math.random()*WIDTH,-10
		self.scene:addEntity(EnemyZapper:new(x, y, self.scene), self.scene.layers.objects)
	end
end


function EnemyDirector:addEnemy()
	local rx = math.random(300)
	local ry = math.random(300)
	local player = self.scene.player
	local e = EnemyChaser:new(player.x+rx, player.y+ry, self.scene)
	self.scene:addEntity(e, self.scene.layers.objects)
end

function EnemyDirector:draw()

end

return EnemyDirector
