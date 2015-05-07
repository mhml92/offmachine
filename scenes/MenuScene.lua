local MenuScene = Class("MenuScene", Scene)

local MenuButton = require 'entities/MenuButton'

function MenuScene:initialize()
	Scene.initialize(self)
	local button1 = MenuButton:new(40, 40, "Oh yeah. buttons", self)
	button1:setAction(function() print("clicked") end)
	self:addEntity(button1)
end

return MenuScene
