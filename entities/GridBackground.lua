local GridBackground = Class("GridBackground", Entity)

local GRID_SIZE = 200
local GRID_COLORS = {{92,92,92,255}, {122,122,122,255}}
local CAM_DX = lg.getWidth()/2
local CAM_DY = lg.getHeight()/2 

function GridBackground:initialize(scene)
    Entity:initialize(0,0,scene)

    --[[
    local lp = love.physics
    self.body       = lp.newBody(self.scene.world,self.x,self.y,'dynamic')
    self.shape      = lp.newCircleShape(G.PLAYER_SIZE)
    self.fixture    = lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
    self.body:setLinearDamping(12)
    --]]

    self.x = 0
    self.y = 0
end

function GridBackground:update(dt)
    local cam = self.scene.cammgr.cam
    local cx,cy = cam:worldCoords(cam:position())
    local camposx,camposy = cam:position()

    self.x = cx-GRID_SIZE-camposx
    self.y = cy-GRID_SIZE-camposy
end


function GridBackground:draw()
    local cam = self.scene.cammgr.cam
    local camposx,camposy = cam:position()
    local lg = love.graphics
        
    local count = (math.floor(camposx/GRID_SIZE)+math.floor(camposy/GRID_SIZE)) % 2   
    local gcr = 0

    for i = self.x-(camposx%GRID_SIZE),self.x+lg.getWidth()+GRID_SIZE,GRID_SIZE do
        gcr = count%2+1
        for j = self.y-(camposy%GRID_SIZE),self.y+lg.getHeight()+GRID_SIZE,GRID_SIZE do
            lg.setColor(GRID_COLORS[count%2+1])
            lg.rectangle("fill", i, j, GRID_SIZE, GRID_SIZE)
            count = count + 1
        end
        if gcr == count%2+1 then
            count = count + 1
        end
    end 
end


return GridBackground
