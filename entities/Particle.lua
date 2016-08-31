local Particle = Class("Particle", Entity)

function Particle:initialize(x,y,scene,w,h,xspeed,yspeed,rot,rotSpeed,life)
    Entity:initialize(x,y,scene)

    --[[
    local lp = love.physics
    self.body       = lp.newBody(self.scene.world,self.x,self.y,'dynamic')
    self.shape      = lp.newCircleShape(G.PLAYER_SIZE)
    self.fixture    = lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
    self.body:setLinearDamping(12)
    --]]
    self.w = w
    self.h = h

    self.life = life
    self.startlife = life

    self.rot = rot or 0
    print("rot in particle",rot)
    self.rotSpeed = rotSpeed or 0
    self.speed_vec = Vector.new(xspeed,yspeed)
end


function Particle:setSpeed(x,y)
    self.speed_vec = Vector.new(x,y)
end

function Particle:setRot(rot,rotSpeed)
    self.rot = rot
    self.rotSpeed = rotSpeed or 0
end

function Particle:setColor(color, endcolor)
    self.color = color
    self.endcolor = endcolor
    print(color,endcolor)
    Timer.tween(self.life, self.color, {[1]=self.endcolor[1], [2]=self.endcolor[2], [3]=self.endcolor[3]})
end

function Particle:update(dt)
    self.life = self.life - dt
    self.x,self.y = self.x + self.speed_vec.x,self.y + self.speed_vec.y
    
    self.rot = self.rot + self.rotSpeed
    if self.poly then
        self.poly:moveTo(self.x,self.y)
    end
end


function Particle:draw()
    local lg = love.graphics
    
    self.color[4] = (self.life/self.startlife) * 255
    lg.setColor(self.color)
    lg.draw(resmgr:getImg("square3x3.png"), self.x, self.y, self.rot, self.w/3, self.h/3, 1.5, 1.5)
    
end


return Particle