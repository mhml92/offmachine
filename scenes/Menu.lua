local Menu = Class("Menu", Scene)

local Stars = require "entities/Stars"
local Plan = require "entities/Plan"

function Menu:initialize()
	Scene.initialize(self)
	self:defineLayers()
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
	self:addEntity(Plan:new(0,0,self), self.layers.gui)
end

function Menu:defineLayers()
	self:addLayer("bg")
	self:addLayer("gui")
end

local lg = love.graphics
function Menu:draw()
	Scene.draw(self)
end

function Menu:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	StateManager.setScene("Moffeus")
end

return Menu