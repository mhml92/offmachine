local EndScene = Class("EndScene", Scene)

local Stars = require 'entities/Stars'
local EndMessage = require 'entities/EndMessage'

function EndScene:initialize()
	Scene:initialize()
	on_endscreen = true
	self:defineLayers()
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
	self:addEntity(EndMessage:new(0,0,self), self.layers.gui)
end

function EndScene:defineLayers()
	self:addLayer("bg")
	self:addLayer("gui")
end


local lg = love.graphics
function EndScene:draw()
	Scene.draw(self)
end

function EndScene:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	StateManager.setScene("Moffeus")
	on_endscreen = false
end

return EndScene