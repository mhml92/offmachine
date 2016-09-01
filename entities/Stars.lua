local Stars = Class("Stars", Entity)


function Stars:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)
	self.layers = {}
	self:addLayers(resmgr:getImg("stars_small.png"), 300)
	self:addLayers(resmgr:getImg("stars_big.png"), 350)
end

function Stars:addLayers(img, speed)
	local t = {}
	table.insert(self.layers, {["img"] = img, ["x"] = 0, ["speed"] = speed})
end

function Stars:update(dt)
	for k, v in pairs(self.layers) do
		v.x = v.x - v.speed * dt
		if v.x <= - WIDTH then
			v.x = 0
		end
	end
end

local lg = love.graphics
function Stars:draw()
	--love.graphics.setColor(39, 35, 35)
	local s = 10
	--love.graphics.setColor(42/s,164/s,168/s)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255)
	for k, v in pairs(self.layers) do
		lg.draw(v.img, v.x, 0)
		lg.draw(v.img, v.x+WIDTH, 0)
	end
	lg.setColor(255, 255, 255)
	lg.line(0,HEIGHT-1, WIDTH, HEIGHT-1)
	lg.setColor(0,0,0)
	lg.line(0,HEIGHT, WIDTH, HEIGHT)
	lg.setColor(255, 255, 255)
end

return Stars
