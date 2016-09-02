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
<<<<<<< ef229a4279682a75b02e173112028d63a22ceb12
    --[[
    lg.draw(resmgr:getImg("weaponhud.png"),WIDTH/2+60,HEIGHT-30,0,1,1)


    lg.draw(resmgr:getImg("circle.png"),WIDTH/2+60,HEIGHT-30,0,1,1,12.5,12.5)
    lg.setLineWidth( 2 )

    if self.weapon.ammo > 0 then
        lg.setColor(G.color_theme[4])
        lg.line(WIDTH/2+60,HEIGHT-30,WIDTH/2+60,HEIGHT-30-11)
    else
        local ratio = math.pi * 2 * self.weapon.reload_time/self.weapon.start_reload_time

        lg.setColor(G.color_theme[5])
        lg.line(WIDTH/2+60,HEIGHT-30,WIDTH/2+60-math.sin(ratio)*11,HEIGHT-30-math.cos(ratio)*11)
    end
    lg.setColor(255,255,255)
    self.weapon:draw()
<<<<<<< HEAD
    --print(self.weapon)
    lg.print(self.weapon.name,WIDTH/2+80,HEIGHT-45)
=======
    lg.print(self.weapon.name,WIDTH/2+80,HEIGHT-45)]]
=======
>>>>>>> added way too much shit
end

return WeaponInterface
