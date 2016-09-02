local EnemyDebris = Class("EnemyDebris", Entity)

function EnemyDebris:initialize(x,y,scene,image,life,sprites,w,h,quad)
    Entity:initialize(x,y,scene)

    self.sprites = sprites

    self.x = x
    self.y = y
    self.quad = quad
    self.w = w
    self.h = h
    self.life = life
    self.startlife = life
    self.sprites = sprites
    self.image = image
    self.grav = 100 + G_functions.rand(0,300) 

    

    self.rot = 0
    self.rotSpeed = math.rad(G_functions.rand(-70,70))
    
    self.speed_vec = Vector.new(G_functions.rand(-40,40),G_functions.rand(-40,40))
end

function EnemyDebris:setMoveVec(x,y)
    self.speed_vec = Vector.new(x,y)
end


function EnemyDebris:update(dt)
    self.life = self.life - dt
    self.x,self.y = self.x + self.speed_vec.x*dt,self.y + self.speed_vec.y*dt

    self.speed_vec.y = self.speed_vec.y + self.grav * dt
    
    self.rot = self.rot + self.rotSpeed * dt
    
    if self.life < 0 then
         self:kill()
     end
end


function EnemyDebris:draw()
    local lg = love.graphics
    
    lg.setColor(255,255,255,255)
    lg.draw(self.sprites,self.image, self.x, self.y, self.rot, 1, 1, 5,5)
    
end


return EnemyDebris
