local Level = Class('Level',Entity)

function Level:initialize(lvl,x,y,scene)
	Entity:initialize(x,y,scene)
	self.levelCanvas = love.graphics.newCanvas(lvl.width*lvl.tilewidth,lvl.height*lvl.tileheight)

	self.resmgr = scene.resmgr	

	self.quads = {}
	for k,v in ipairs(lvl.tilesets) do
		-- fix image name
		local img = self.scene.resmgr:split(v.image,"/")	
		v.image = self.scene.resmgr:getImg(img[#img])
		-- quads for tile map
		local numXtiles = v.imagewidth/v.tilewidth
		local numYtiles = v.imageheight/v.tileheight
		local numTotaltiles = numXtiles*numYtiles 
		
		local ypos = 0
		local tile = v.firstgid
		for i = 1,numYtiles do
			for j = 1,numXtiles do
				local xpos = j-1
				self.quads[tile] = love.graphics.newQuad(xpos*v.tilewidth,ypos*v.tileheight,v.tilewidth,v.tileheight,v.image:getDimensions())	
				tile = tile + 1
			end
			ypos = ypos + 1
		end
	end

	love.graphics.setCanvas(self.levelCanvas)
	local tilelayer = lvl.layers[1]
	for i = 1,tilelayer.height do

		for j = 1,tilelayer.width do
			-- data val
			local dataval = tilelayer.data[((i-1)*tilelayer.width)+j]
			if dataval ~= 0 then
				
				
				-- tileset number
				local tilesetval = 0
				if #lvl.tilesets > 1 then
					for k,v in ipairs(lvl.tilesets) do
						local first = v.firstgid
						local last = (v.firstgid-1) + ((v.imagewidth/v.tilewidth) * (v.imageheight/v.tileheight))
						if first <= dataval and dataval <= last then
							tilesetval = k
							break
						end
					end
				else
					tilesetval = 1
				end

				-- draw dat sjiiit
				local imgsrc = lvl.tilesets[tilesetval].image
				love.graphics.draw(imgsrc, self.quads[dataval], (j-1)*lvl.tilewidth, (i-1)*lvl.tileheight)
			end
		end
	end
	love.graphics.setCanvas()

end

function Level:getQuads()
end


function Level:draw()
	love.graphics.draw(self.levelCanvas, 0, 0, 0, 1, 1)	
end

return Level

