local MachineGun = Class("MachineGun", Entity)

local SimpleBullet = require 'entities/SimpleBullet'

function MachineGun:initialize(scene)
    Entity.initialize(self,x,y,scene)

    self.ammo = 20
    self.shoot_delay = 0.1
    self.reload_time = 2
    self.level = 1

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
        self.current_shoot_delay = self.shoot_delay
        self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot,momentum,self.scene),self.scene.layers.objects)
    end
end


function MachineGun:draw()

end

return MachineGun
