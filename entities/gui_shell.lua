local GuiShell = Class("GuiShell", Entity)

function GuiShell:initialize(x,y,scene,image,life)
    Entity:initialize(x,y,scene)

    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.life = life
    self.startlife = life
    self.image = image
    self.grav = 400

    self.rot = 0
    self.rotSpeed = math.rad(G_functions.rand(-360,360))
    
    self.speed_vec = Vector.new(G_functions.rand(0,80)-40,-G_functions.rand(45,90)*6)
end


function GuiShell:update(dt)
    self.life = self.life - dt
    self.x,self.y = self.x + self.speed_vec.x*dt,self.y + self.speed_vec.y*dt

    self.speed_vec.y = self.speed_vec.y + self.grav * dt
    
    self.rot = self.rot + self.rotSpeed * dt
    if self.poly then
        self.poly:moveTo(self.x,self.y)
    end

    if self.life < 0 then
         self:kill()
     end
end


function GuiShell:draw()
    local lg = love.graphics
    
    lg.draw(self.image, self.x, self.y, self.rot, 0.5, 0.5, self.image:getWidth()/2, self.image:getHeight()/2)
    lg.setColor(255,255,255,255)
    
end


return GuiShell
