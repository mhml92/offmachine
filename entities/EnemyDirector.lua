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
				{0,1,PowerUp,"top"}
				-- subwawe 1	
				-- {time,#,Enemy,dir}
--				{0,1,EnemyChaser,"top"},
--
--				{2,1,EnemyChaser,"left"},
--				{2,1,EnemyChaser,"right"},
--
--				{6,1,EnemyChaser,"top"},
--				{6,1,EnemyChaser,"left"},
--				{6,1,EnemyChaser,"right"},
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

			print(obj[2])
			for i = 1,obj[2] do
				t:after(obj[1],
					function() 
						local px,py = self:getNewPosition(obj[4])
						self.scene:addEntity(obj[3]:new(px,py,self.scene))
					end
					)	
			end
		end

	end

end

function EnemyDirector:getNewPosition(at)
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
