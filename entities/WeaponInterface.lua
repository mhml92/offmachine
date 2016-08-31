local WeaponInterface = Class("WeaponInterface", Entity)

local MachineGun = require 'entities/MachineGun'
local RocketLauncher = require 'entities/RocketLauncher'
local Shotgun = require 'entities/Shotgun'
local RemoteRocket = require 'entities/RemoteRocket'


function WeaponInterface:initialize(player)
    Entity.initialize(self,x,y,player.scene)

    --self.weapon = MachineGun:new(self.scene)
	 --self.weapon = RocketLauncher:new(self.scene)
    self.weapon = Shotgun:new(self.scene)
    self.player = player
	 self.scene = player.scene
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
