local MachineGun = Class("MachineGun", Entity)

local SimpleBullet = require 'entities/SimpleBullet'

function MachineGun:initialize(scene)
    Entity.initialize(self,x,y,scene)

    self.ammo = 5
    self.shoot_delay = 1
    self.reload_time = 3
    self.level = 5
    
    self.current_shoot_delay = 0
    self.start_reload_time = self.reload_time
end

function MachineGun:update(dt)
    if self.ammo == 0 then
        if self.reload_time > 0 then
            self.reload_time = self.reload_time - dt
        else
            self.ammo = 20 + 3 * self.level
            self.reload_time = self.start_reload_time 
        end
    end

    self.current_shoot_delay = self.current_shoot_delay - dt
end

function MachineGun:shoot(px,py,x,y,rot,momentum)
    if self.ammo > 0 and self.current_shoot_delay <= 0 then
        self.ammo = self.ammo - 1
        self.current_shoot_delay = self.shoot_delay - (self.level - 1) * 0.01

        local bullets = 5 + 2 * self.level

        for i = 1,bullets do
            local bullet = SimpleBullet:new(px,py,x,y,rot+math.rad(G_functions.rand(0,50)-25),momentum,self.scene)
            bullet:updateRelativeSpeed(G_functions.rand(-20,100))
            self.scene:addEntity(bullet,self.scene.layers.objects)
        end
    end
end


function MachineGun:draw()

end

return MachineGun
