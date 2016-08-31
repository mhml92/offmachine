local Dilation = Class("Dilation")

function Dilation:initialize()
	self.dilation = 1
	self.max_dilation = 4
	self.timer = Timer.new()
end

function Dilation:dilate(dilation)
	self.dilation = dilation
end

function Dilation:update(dt)
	self.timer = self.timer + dt
end

return Dilation