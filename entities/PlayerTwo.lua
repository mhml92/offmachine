local PlayerTwo = Class("PlayerTwo", Entity)

local ACC = 0.5
local SPEED = 100
local SPEED_DAMPER = 1.03
local MAX_SPEED = 20
local MAX_ROOT_SPEED = 0.2
local ROT_ACC = 2
local ROT_DAMPER = 1.03
local ROT_DAMPER_MULTIPLIER = 1.25

function PlayerTwo:initialize(x,y,scene)
    Entity:initialize(x,y,scene)

    --[[
    local lp = love.physics
    self.body       = lp.newBody(self.scene.world,self.x,self.y,'dynamic')
    self.shape      = lp.newCircleShape(G.PLAYER_SIZE)
    self.fixture    = lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
    self.body:setLinearDamping(12)
    --]]

    self.shape = HC:polygon(0,0, 20,0, 10,30)
    self.shape_dir = Vector.new(0,1)

    self.speed_vec = Vector.new(0,0)
    self.rot_vec = Vector.new(1,0)
    self.rot = 0
end

function PlayerTwo:getDirection()
    return Vector.rotate(self.rot, self.movevec.x,self.movevec.y)
end

function PlayerTwo:update(dt)
    --print(self.x,self.y)
    --print(I(self.shape))


    self.rot = self.rot / ROT_DAMPER
    self.shape:rotate(self.rot)
    self.shape:move(self.speed_vec:unpack())
    self.speed_vec = self.speed_vec / SPEED_DAMPER
    if lk.isDown("up") then
        local rot = self.shape._rotation
        local speed = SPEED * dt
        local rotvec = self.shape_dir:rotated(rot)
        rotvec =  rotvec * speed  
        
        self.speed_vec = self.speed_vec + rotvec 
        
--      self.speed_vec = 
    end
    if lk.isDown("right") then
--      local dtadd = vector.add(self.speed_vec, )
        self.rot = self.rot + ROT_ACC * dt
        self.rot = math.min(MAX_ROOT_SPEED, self.rot)
--      self.speed_vec = 
    elseif lk.isDown("left") then
        self.rot = self.rot - ROT_ACC * dt
        self.rot = math.max(-MAX_ROOT_SPEED, self.rot)
    else
        self.rot = self.rot / (ROT_DAMPER*ROT_DAMPER_MULTIPLIER)
    end
end


function PlayerTwo:draw()
    local lg = love.graphics
    
    lg.setColor(255,0,0)
    self.shape:draw("fill")
    lg.setColor(0,0,255)
    --lg.line(self.x,self.y,self.x+(math.cos(self.lookr)*16),self.y+(math.sin(self.lookr)*16))
    lg.setColor(255,255,255)

end


return PlayerTwo
