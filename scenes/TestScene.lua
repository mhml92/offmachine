local TestScene = Class("TestScene", Scene)
local Player = require 'entities/Player'
local NewPlayer = require 'entities/NewPlayer'
local PlayerTwo = require 'entities/PlayerTwo'
local BG = require 'entities/GridBackground'
local StaticObject = require 'entities/StaticObject'
local CameraManager = require 'managers/CameraManager'
local TimeManager = require 'managers/TimeManager'
local SoundManager = require 'managers/SoundManager'

local Enemy = require 'entities/Enemy'
local SimpleBullet = require 'entities/SimpleBullet'

local EnemyChaser = require 'entities/EnemyChaser'
local EnemyLineFormation = require 'entities/EnemyLineFormation'

local EnemyDirector = require 'entities/EnemyDirector'

-- levels
--local TestLevel = require 'levels/wallsTest'


---------------------------------------------------------------------
--										INITIALIZE
---------------------------------------------------------------------
function TestScene:initialize()
	Scene:initialize()
	self.cammgr = CameraManager:new(self)
	self.timemgr = TimeManager:new(self)
	self.soundmgr = SoundManager:new(self)

	self:defineLayers()
	--[[
	self.world = love.physics.newWorld(0,0,true)
	love.physics.setMeter(32)
   	self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	]]
	--self:addEntity(Enemy:new(10,10,self))


	--self:addEntity(StaticObject:new(0, 0, self), self.layers.objects)
	self.player = NewPlayer:new(100,100,self)
	self:addEntity(self.player, self.layers.objects)
	
	self:addEntity(EnemyChaser:new(300, 300, self), self.layers.objects)
	
	self:addEntity(BG:new(self), self.layers.bg)
	self:addEntity(SimpleBullet:new(0,0,0,0,self), self.layers.objects)
	
	self.bgmusic = self.soundmgr:addSound("hyperfun.mp3", true, 0.8)
	self.soundmgr:playSound(self.bgmusic)
	
	self:addEntity(EnemyDirector:new(0,0,self), self.layers.objects)


end

function TestScene:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end
---------------------------------------------------------------------
--										UPDATE
---------------------------------------------------------------------
function TestScene:update(dt)
	dt = self.timemgr:update(dt)
	self.soundmgr:update(dt)
	--self.cammgr.cam:lookAt(self.player.shape:center())
	self.cammgr:update(dt)

	--self.world:update(dt)
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:update(dt)
		end
	end
	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
         self.entities[i]:exit()
         if self.entities[i].body then
            self.entities[i].body:destroy()
         end
			table.remove(self.entities, i);
		end
	end
end

---------------------------------------------------------------------
--										DRAW
---------------------------------------------------------------------
function TestScene:draw()
	table.sort(self.entities,
		function(a,b) 
			if a.layer < b.layer then 
				return true 
			elseif a.layer == b.layer then 
				if a.id < b.id then 
					return true 
				else 
					return false 
				end 
			else 
				return false 
			end 
		end)
	self.cammgr:attach()	
	for i, v in ipairs(self.entities) do
		if v:isActive() then
			v:draw()
		end
	end
	self.cammgr:detach()
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )),10, 10) 
end


function TestScene:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	if button == "start" then
		HighscoreManager.addScore("Jesper Luuund", 42)
		StateManager.setScene("Highscore")
	end
end

function TestScene:keypressed( key,scancode,isrepeat )
	Scene.keypressed(self,key,scancode,isrepeat)
	if key == "z" then
		self.cammgr.zoom = (((self.cammgr.zoom ))%4)+1
	end
	if key == "t" then
		self.timemgr:tweenTimeScalar(t)
	end

end

function TestScene:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return TestScene
