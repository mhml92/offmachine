local TestScene = Class("TestScene", Scene)
local NewPlayer = require 'entities/NewPlayer'

local SimpleBullet = require 'entities/SimpleBullet'
local EnemyBullet = require 'entities/EnemyBullet'

local EnemyZapper = require 'entities/EnemyZapper'
local EnemyChaser = require 'entities/EnemyChaser'
local EnemyDirector = require 'entities/EnemyDirector'


function TestScene:initialize()
	Scene:initialize()

	self:defineLayers()

	self.player = NewPlayer:new(100,100,self)
	self:addEntity(self.player, self.layers.objects)
	
	self:addEntity(EnemyChaser:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	self:addEntity(EnemyZapper:new(300, 300, self), self.layers.objects)
	
	self:addEntity(EnemyDirector:new(0,0,self), self.layers.objects)
end

function TestScene:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function TestScene:update(dt)
	Scene.update(self,dt)
end

function TestScene:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255)
	Scene.draw(self)
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
end

function TestScene:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return TestScene
