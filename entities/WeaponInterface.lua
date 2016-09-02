local WeaponInterface = Class("WeaponInterface", Entity)

local MachineGun = require 'entities/MachineGun'
local RocketLauncher = require 'entities/RocketLauncher'
local Shotgun = require 'entities/Shotgun'
local RemoteRocket = require 'entities/RemoteRocket'


function WeaponInterface:initialize(player)
    Entity.initialize(self,x,y,player.scene)

    --self.weapon = MachineGun:new(self.scene)
	 --self.weapon = RocketLauncher:new(self.scene)
    self.player = player
    self.scene = player.scene
    
    self.quads = {}
    for i=1,5 do
        self.quads[i] = love.graphics.newQuad((i-1)*10, 0, 10, 10, 50, 10)
    end

    --self.weapon = Shotgun:new(self.scene,self.quads[2])
	 self:changeType(1)

end

function WeaponInterface:update(dt)
    self.weapon:update(dt)
end

function WeaponInterface:changeType(type)
    if type == 1 then
        self.weapon = MachineGun:new(self.scene, self.quads[1])
    end
    if type == 2 then
        self.weapon = Shotgun:new(self.scene, self.quads[2])
    end
    if type == 3 then
        self.weapon = RemoteRocket:new(self.scene, self.quads[3])
    end
end

function WeaponInterface:gainLevel()
    self.weapon:levelUp()
end

function WeaponInterface:shoot(x,y,rot,momentum)
    return self.weapon:shoot(self.player.x,self.player.y,x,y,rot,momentum)
end


function WeaponInterface:draw()
end

return WeaponInterface
