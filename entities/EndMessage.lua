local EndMessage = Class("EndMessage", Entity)

function EndMessage:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	local s = FINAL_SCORE
	self.line1 = "YOU ORBITED THE BLACK HOLE FOR "..s.." SECONDS!"
	self.line2 = "THAT IS ABOUT "..(s*420).." YEARS ON EARTH!"
end


function EndMessage:update(dt)
end

function EndMessage:draw()
	local font = love.graphics.getFont()
	local lx = (WIDTH - font:getWidth(self.line1)*2) / 2
	local fh = font:getHeight(self.line1)*2
	love.graphics.print(self.line1, lx, HEIGHT/2, 0, 2, 2)
	lx = (WIDTH - font:getWidth(self.line2)*2) / 2
	love.graphics.print(self.line2, lx, HEIGHT/2+fh+10, 0, 2, 2)
end

return EndMessage
