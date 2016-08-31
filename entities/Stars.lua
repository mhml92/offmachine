local Stars = Class("Stars", Entity)

function Stars:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)
	self.layers = {}
	self:addLayers(resmgr:getImg("stars_small.png"), 30)
	self:addLayers(resmgr:getImg("stars_big.png"), 40)
end

function Stars:addLayers(img, speed)
	local t = {}
	table.insert(self.layers, {["img"] = img, ["x"] = 0, ["speed"] = speed})
end

function Stars:update(dt)
	for k, v in pairs(self.layers) do
		v.x = v.x - v.speed * dt
	end
end

local lg = love.graphics
function Stars:draw()
	love.graphics.setColor(39, 35, 35)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255)
	for k, v in pairs(self.layers) do
		lg.draw(v.img, v.x, 0)
		lg.draw(v.img, v.x+WIDTH, 0)
	end
end

return Stars
