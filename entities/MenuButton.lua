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
	if self.mouse["l"] then
		local mx, my = love.mouse.getPosition()
		if mx < self.x or mx > self.x+self.width or my < self.y or my > self.y+self.height then
			return
		end
		self.mouse["l"] = false
		self.action()
	end
end

return MenuButton
