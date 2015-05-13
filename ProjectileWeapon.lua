local Projectile = require 'entities/Projectile'

local ProjectileWeapon = Class("ProjectileWeapon")

function ProjectileWeapon:initialize(scene)
	self.scene = scene
end

function ProjectileWeapon:shoot(x,y,dir)
	self.scene:addEntity(Projectile:new(x,y,self.scene,1000,dir))
end

function ProjectileWeapon:reload()
end

return ProjectileWeapon
