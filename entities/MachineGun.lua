local MachineGun = Class("MachineGun", Entity)

local SimpleBullet = require 'entities/SimpleBullet'

function MachineGun:initialize(scene)
    Entity.initialize(self,x,y,scene)

    self.ammo = 20
    self.shoot_delay = 0.1
    self.reload_time = 2
    self.level = 1
    self.name = "Pea shooter"
    self.splits = 1
    self.recoil = 25

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

        self.splits = 1 + math.floor((self.level - 1)/2)

        print(self.splits)
        if self.splits == 1 then 
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot,momentum,self.scene),self.scene.layers.objects)
        end
        if self.splits == 2 then
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot-math.rad(15),momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot,momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot+math.rad(15),momentum,self.scene),self.scene.layers.objects)
        end
        if self.splits == 3 then
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot-math.rad(30),momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot-math.rad(15),momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot,momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot+math.rad(15),momentum,self.scene),self.scene.layers.objects)
            self.scene:addEntity(SimpleBullet:new(px,py,x,y,rot+math.rad(30),momentum,self.scene),self.scene.layers.objects)
        end

        return self.recoil
    end
end


function MachineGun:draw()
    local img = resmgr:getImg("shotgun_shell.png")
    for i=1,self.ammo do
        lg.draw(img,WIDTH/2+65+i*5,HEIGHT-18, 0, 0.5, 0.5, img:getWidth()/2, img:getHeight()/2)
    end
end

return MachineGun
