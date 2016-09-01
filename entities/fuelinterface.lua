local FuelInterface = Class("FuelInterface", Entity)

function FuelInterface:initialize(scene)
    Entity.initialize(self,x,y,scene)

    self.time = 300
end

function FuelInterface:update(dt)
    self.time = self.time - 1 * dt * 10
end

function FuelInterface:draw()
    lg.setColor(255,255,255)
    lg.draw(resmgr:getImg("weaponhud.png"),WIDTH/2-60,HEIGHT-30,0,-1,1)
    lg.setScissor(WIDTH/2-166,HEIGHT-40, 93, 25)
    
    local ratio = 1 - (self.time / 300)
    lg.setColor(G.color_theme[6])
    lg.rectangle("fill",WIDTH/2-166+100*ratio,HEIGHT-40,WIDTH/2-166,25)
    lg.setScissor()
    lg.setColor(255,255,255)
    lg.draw(resmgr:getImg("fueltank.png"),WIDTH/2-170,HEIGHT-40,0,1,1)
    lg.setColor(G.color_theme[4])
    lg.print("Fuel",WIDTH/2-133,HEIGHT-35)
   
    lg.setColor(G.color_theme[3])
    lg.rectangle("fill",WIDTH/2-40,HEIGHT-40,40*2,40)
    lg.setColor(255,255,255)
    lg.rectangle("fill",WIDTH/2-38,HEIGHT-38,38*2,38)

    lg.setColor(G.color_theme[6])
    local num = math.floor(self.time%60)
    if num < 10 then
        num = "0" ..tostring(num)
    end
    lg.print(math.floor(self.time/60) .. ":" .. tostring(num),WIDTH/2-30,HEIGHT-35)
end

return FuelInterface
