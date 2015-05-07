local MenuButton = Class("MenuButton", Entity)

local lg = love.graphics

function MenuButton:initialize(x, y, label, scene)
	Entity.initialize(self, x, y, scene)
	self.label = label
	self.width = lg.getFont():getWidth(label)
	self.height = lg.getFont():getHeight(label)
	self.action = nil
end

function MenuButton:draw()
	lg.rectangle("line", self.x, self.y, self.width, self.height)
	lg.print(self.label, self.x, self.y)
end

function MenuButton:setAction(action)
	self.action = action
end

function MenuButton:update(dt)
	if self.mouse.button["l"] then
		
	end
end

return MenuButton
