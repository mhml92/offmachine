local Projectile = require 'entities/Projectile'

local ProjectileWeapon = Class("ProjectileWeapon")

function ProjectileWeapon:initialize(scene)
	self.scene = scene
	self.sound = scene.soundmgr:addSound("plates1.mp3", false, 0.2)
end

function ProjectileWeapon:shoot(x,y,dir)
	self.scene:addEntity(Projectile:new(x,y,self.scene,1000,dir))
	self.scene.soundmgr:playSound(self.sound)
end

function ProjectileWeapon:reload()
end

return ProjectileWeapon
