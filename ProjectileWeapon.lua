local Projectile = require 'entities/Projectile'

local ProjectileWeapon = Class("ProjectileWeapon")

function ProjectileWeapon:initialize(scene)
   self.scene = scene
   --self.sound = scene.soundmgr:addSound("gunshot.mp3", false, 1)
   self.soundGroup = scene.soundmgr:addSoundGroup("test",1)
   self.cooldown = 0
end

function ProjectileWeapon:shoot(x,y,dir)
   if self.cooldown == 0 then
      self.scene:addEntity(Projectile:new(x,y,self.scene,G.TEST_GUN_PROJECTILE_SPEED,dir))
      --self.scene.soundmgr:playSound(self.sound)
      self.scene.soundmgr:playSoundGroup(self.soundGroup)
      self.cooldown = G.TEST_GUN_COOLDOWN
   else
      self.cooldown = self.cooldown -1
   end

end

function ProjectileWeapon:reload()
end

return ProjectileWeapon
