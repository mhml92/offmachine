local PlayerTwo = Class("PlayerTwo", Entity)

local ACC = 0.5
local SPEED = 25
local SPEED_DAMPER = 1.01
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
    self.joystick = love.joystick.getJoysticks( )[1]
    self.shape_dir = Vector.new(0,1)

    self.speed_vec = Vector.new(0,0)
    self.rot = 0
end

function PlayerTwo:getDirection()
    return Vector.rotate(self.rot, self.movevec.x,self.movevec.y)
end

function PlayerTwo:update(dt)
    --print(self.x,self.y)
    --print(I(self.shape))
    local leftx,lefty,reightx,righty,rightt,leftt = self.joystick:getAxes( )

    self.rot = self.rot / ROT_DAMPER
    self.shape:rotate(self.rot)
    self.shape:move(self.speed_vec:unpack())
    self.speed_vec = self.speed_vec / SPEED_DAMPER
    local thrusting = false
    if rightt > 0.2 then
        local rot = self.shape._rotation
        local speed = SPEED * dt
        local rotvec = self.shape_dir:rotated(rot)
        rotvec =  rotvec * speed  
        
        self.speed_vec = self.speed_vec + rotvec

        local px,py = self.shape:center()
        local sx,sy = (self.speed_vec*-1):unpack()
        --local smoke = Particle:new(px,py,self.scene)
        local new_rot = rot+math.rad(G_functions.rand(0,40)-20)
        print("rot in player", new_rot)
        for i =1,5 do
            --+(G_functions.rand(0,40)-20)/10
            local part = Particle:new(px+G_functions.rand(0,4)-2,py+G_functions.rand(0,4)-2,self.scene,5,5,(sx/10)-rotvec.x*10+(G_functions.rand(0,40)-20)/30,(sy/10)-rotvec.y*10+(G_functions.rand(0,40)-20)/30,new_rot,0,G_functions.rand(0,20))
            part:setColor(G_functions.deepcopy(G.fire_colors[G_functions.rand(1,3)]),G_functions.deepcopy(G.fire_colors[G_functions.rand(4,5)]))
            self.scene:addEntity(part)
        end
        thrusting = true
    end
    if leftx < -0.1 then
--      local dtadd = vector.add(self.speed_vec, )
        self.rot = self.rot + ROT_ACC * dt * (leftx / (thrusting and 2 or 1)) 
        self.rot = math.min(MAX_ROOT_SPEED / (thrusting and 2 or 1), self.rot)
--      self.speed_vec = 
    elseif leftx > 0.1 then
        self.rot = self.rot + ROT_ACC * dt * (leftx / (thrusting and 2 or 1))
        self.rot = math.max(-MAX_ROOT_SPEED / (thrusting and 2 or 1), self.rot)
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