local WeaponInterface = Class("WeaponInterface", Entity)

local MachineGun = require 'entities/MachineGun'
local SimpleBullet = require 'entities/SimpleBullet'


function WeaponInterface:initialize(scene,player)
    Entity.initialize(self,x,y,scene)

    self.weapon = MachineGun:new(scene)
    self.player = player
end

function WeaponInterface:update(dt)
    self.weapon:update(dt)
end

function WeaponInterface:shoot(x,y,rot,momentum)
    self.weapon:shoot(self.player.x,self.player.y,x,y,rot,momentum)
end


function WeaponInterface:draw()
    self.weapon:draw()
end

return WeaponInterface
