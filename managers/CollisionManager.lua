local Collision = Class("Collision")

function Collision:initialize(scene)
   self.scene = scene

end

function Collision:resolve(a,b,coll)
   local av = a:getUserData()
   local bv = b:getUserData()
   if av ~= nil and bv~= nil then
      self:handleCollision(av,bv,coll)
      self:handleCollision(bv,av,coll)
   end

end


function Collision:handleCollision(a,b,coll)
   local at = a.class.name
   local bt = b.class.name
   if at == "Projectile" then
      if bt == "wall" then   
         a:kill()
      end
   end
end

return Collision

