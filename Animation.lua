local Animation = Class("Animation", Entity)

function Animation:initialize(filename, frames, horizontal, scene)
	Entity.initialize(self, 0, 0, scene)
	self.src = scene.resmgr:getImg(filename)
	self.frames = frames
	self.step = 0;
	self.fps = 1;
	self:computeQuads(horizontal)
	scene:addEntity(self)
end

function Animation:computeQuads(horizontal)
	self.quads = {}
	local w, h = self.src:getDimensions()
	for i=0,self.frames-1 do
		if horizontal then
			local step = math.floor(w/self.frames)
			self.quads[i] = love.graphics.newQuad(i*step, 0, step, h, w, h)
		else
			local step = math.floor(h/self.frames)
			self.quads[i] = love.graphics.newQuad(0, i*step, w, step, w, h)
		end
	end
end

function Animation:setCoordinateSource(src)
	self.coord = src
end

function Animation:setPosition(x, y)
	self.x, self.y = x, y
end

function Animation:setFPS(fps)
	self.fps = fps
end

function Animation:update(dt)
	self.step = self.step + self.fps*dt
end

function Animation:draw()
	local x, y
	if self.coord then
		x, y = self.coord.x, self.coord.y
	else
		x, y = self.x, self.y
	end
	local frame = math.floor(self.step%self.frames)
	love.graphics.draw(self.src, self.quads[frame], x, y)
end


return Animation