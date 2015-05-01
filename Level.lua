local Level = Class('Level',Entity)

function Level:initialize(lvl,x,y,scene)
	Entity:initialize(x,y,scene)
	self.levelCanvas = love.graphics.newCanvas(lvl.width*lvl.tilewidth,lvl.height*lvl.tileheight)

	local tileimg = self.scene.resmgr:split(lvl.tilesets[1].image,"/")	
	self.tileScr = self.scene.resmgr:getImg(tileimg[#tileimg])
	self.quads = {}
	local tset = lvl.tilesets[1]
	local numXtiles = tset.imagewidth/tset.tilewidth
	local numYtiles = tset.imageheight/tset.tileheight
	local numTotaltiles = numXtiles*numYtiles 
	local ypos = 0
	local tile = 1
	for i = 1,numYtiles do
		for j = 1,numXtiles do
			local xpos = j-1
			self.quads[tile] = love.graphics.newQuad(xpos,ypos,lvl.tilewidth,lvl.tileheight,self.tileScr:getDimensions())	
			tile = tile + 1
		end
		ypos = ypos + 1
	end

	love.graphics.setCanvas(self.levelCanvas)

	love.graphics.setCanvas()

end

function Level:getQuads()
end


function Level:draw()
	love.graphics.draw(self.levelCanvas, 0, 0, 0, 1, 1)	
end

return Level

