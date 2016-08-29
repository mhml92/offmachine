local Level = Class('Level',Entity)

local Line = require 'util/Line'
local Point = require 'util/Point'

function Level:initialize(lvl,x,y,scene)
   Entity:initialize(x,y,scene)
   self.lvl = lvl
   self.width = lvl.width * lvl.tilewidth
   self.height = lvl.height * lvl.tileheight
   self.levelCanvas = love.graphics.newCanvas(lvl.width*lvl.tilewidth,lvl.height*lvl.tileheight)
   self.levelCanvas:setFilter("nearest","nearest")
   self.resmgr = scene.resmgr	

   self.quads = {}
   self:loadTileSets()

   self.layers = {}
   self:loadLayers()
   -- load wall collisions
   --vertical,horizontal = self:loadWallColliders()
   self.wall_rects = {}
   self:loadRects()


   love.graphics.setCanvas(self.levelCanvas)
   self:drawLayer("walls")
   --[[
   love.graphics.setColor(0,255,255)
   for k,v in pairs(vertical) do
      love.graphics.line(v,0,v,5000)
   end
   for k,v in pairs(horizontal) do
      love.graphics.line(0,v,5000,v)
   end
   ]]
   love.graphics.setColor(255,255,255)

   love.graphics.setCanvas()
end

function Level:stupidColliders()
   local l = self.layers["walls"]
   for i = 1, l.height do
      for j = 1,l.width do
         local index = ((i-1)*l.width) + j
      end
   end
end

function Level:loadTileSets()
   for k,v in ipairs(self.lvl.tilesets) do
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
end

function Level:loadLayers()
   for k,v in ipairs(self.lvl.layers) do
      self.layers[v.name] = v
   end
end


function Level:drawLayer(name)
   local tilelayer = self.layers[name]
   for i = 1,tilelayer.height do

      for j = 1,tilelayer.width do
         -- data val
         local dataval = tilelayer.data[((i-1)*tilelayer.width)+j]
         if dataval ~= 0 then

            -- tileset number
            local tilesetval = 0
            if #self.lvl.tilesets > 1 then
               for k,v in ipairs(self.lvl.tilesets) do
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
            local imgsrc = self.lvl.tilesets[tilesetval].image
            love.graphics.draw(imgsrc, self.quads[dataval], (j-1)*self.lvl.tilewidth, (i-1)*self.lvl.tileheight)
         end
      end
   end
end


function Level:is_wall_f(x,y)
   local layer =  self.layers["walls"]
   local index = ((y*layer.width) + x)+1
   return layer.data[index] > 0
end

function Level:loadRects()
   -- map_width and map_height are the dimensions of the map
   -- is_wall_f checks if a tile is a wall

   local rectangles = {} -- Each rectangle covers a grid of wall tiles
   local map_width,map_height = self.lvl.width,self.lvl.height

   for x = 0, map_width - 1 do
      local start_y
      local end_y

      for y = 0, map_height - 1 do
         if self:is_wall_f(x, y) then
            if not start_y then
               start_y = y
            end
            end_y = y
            elseif start_y then
               local overlaps = {}
               for _, r in ipairs(rectangles) do
               if (r.end_x == x - 1) and (start_y <= r.start_y) and (end_y >= r.end_y) then
                  table.insert(overlaps, r)
               end
            end
            table.sort(overlaps,function (a, b)
               return a.start_y < b.start_y
            end)

            for _, r in ipairs(overlaps) do
               if start_y < r.start_y then
                  local new_rect = {start_x = x,start_y = start_y,end_x = x,end_y = r.start_y - 1}
                  table.insert(rectangles, new_rect)
                  start_y = r.start_y
               end

               if start_y == r.start_y then
                  r.end_x = r.end_x + 1

                  if end_y == r.end_y then
                     start_y = nil
                     end_y = nil
                  elseif end_y > r.end_y then
                     start_y = r.end_y + 1
                  end
               end
            end

            if start_y then
               local new_rect = {start_x = x,start_y = start_y,end_x = x,end_y = end_y}
               table.insert(rectangles, new_rect)

               start_y = nil
               end_y = nil
            end
         end
      end

      if start_y then
         local new_rect = {start_x = x,start_y = start_y,end_x = x,end_y = end_y}
         table.insert(rectangles, new_rect)

         start_y = nil
         end_y = nil
      end
   end
   
   -- Use contents of rectangles to create physics bodies
   -- phys_world is the world, wall_rects is the list of...
   -- wall rectangles

   for _, r in ipairs(rectangles) do
      local TILE_SIZE = self.lvl.tilewidth
      local start_x = r.start_x * TILE_SIZE
      local start_y = r.start_y * TILE_SIZE
      local width = (r.end_x - r.start_x + 1) * TILE_SIZE
      local height = (r.end_y - r.start_y + 1) * TILE_SIZE

      local x = start_x + (width / 2)
      local y = start_y + (height / 2)

      local body = love.physics.newBody(self.scene.world, x, y,"static")
      local shape = love.physics.newRectangleShape(0, 0,width, height)
      local fixture = love.physics.newFixture(body,shape)   

      fixture:setFriction(0)
      local o = {class = {name = "wall"},fixture = fixture}
      fixture:setUserData(o)
      table.insert(self.wall_rects, {body = body, shape = shape,fixture = fixture})
   end
end


function Level:draw()
   love.graphics.draw(self.levelCanvas, 0, 0, 0, 1, 1)	
end

return Level

