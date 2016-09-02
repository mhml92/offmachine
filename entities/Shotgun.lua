local MachineGun = Class("MachineGun", Entity)

local SimpleBullet = require 'entities/SimpleBullet'

local GuiShell = require 'entities/gui_shell'    

function MachineGun:initialize(scene,img)
    Entity.initialize(self,x,y,scene)

    self.sprites = resmgr:getImg("weapon_icons.png")
    self.name = "Shotgun"
    self.ammo = 3
	 
    self.shoot_delay = 0.5
    self.reload_time = 2
    self.level = 1
    self.recoil = 10
    self.spread = 5

	 self.max_ammo = 3 
	 
    self.img = img
    
    self.current_shoot_delay = 0
    self.start_reload_time = self.reload_time
end

function MachineGun:update(dt)
    if self.ammo == 0 then
        if self.reload_time > 0 then
            self.reload_time = self.reload_time - dt
        else
            self.ammo = self.max_ammo
            self.reload_time = self.start_reload_time 
        end
    end

    self.current_shoot_delay = self.current_shoot_delay - dt
end

function MachineGun:levelUp()
    self.level = self.level + 1

    if self.level == 2 then
        self.name = "Powerfun Powergun"
		  self.max_ammo = 5
    end

    if self.level == 3 then
        self.name = "Spreaddy shooter"
		  self.max_ammo = 8
    end
end

function MachineGun:shoot(px,py,x,y,rot,momentum)
    if self.ammo > 0 and self.current_shoot_delay <= 0 then
        self.ammo = self.ammo - 1
        self.current_shoot_delay = self.shoot_delay - (self.level - 1) * 0.01

        local bullets = 4 + 1 * self.level

        for i = 1,bullets do
            local bullet = SimpleBullet:new(px,py,x,y,rot+math.rad(G_functions.rand(0,self.spread*2)-self.spread),momentum,self.scene, 3)
            bullet:updateRelativeSpeed(G_functions.rand(-100,100))
            self.scene:addEntity(bullet,self.scene.layers.objects)
        end

        --print("vibration",self.scene.player.joystick:setVibration( 1, 1, 2 ))

        --self.scene:addEntity(GuiShell:new(WIDTH/2+65+self.ammo*5,HEIGHT-18,self.scene,self.img,30),self.scene.layers.gui)
			self.scene.hud:juiceRed()
        return self.recoil
    end

end


function MachineGun:draw()
    for i=1,self.ammo do
        lg.draw(self.sprites, self.img,WIDTH/2+65+i*5,HEIGHT-18, 0, 1, 1, 5, 5)
    end
end

return MachineGun
