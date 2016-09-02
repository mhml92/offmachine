local Hud = Class("Hud", Entity)

local W = 360
local H = 60

local blue = {
{10,104,107},
{4,164,168},
{163,236,239}
}

local red = {
{189,28,24},
{231,58,52},
{255,155,153}
}

function Hud:initialize(x,y,scene)
	Entity.initialize(self,x,y,scene)
	self.lines = resmgr:getImg("hud.png")
	self.icons = resmgr:getImg("weapon_icons.png")
	self.icons_q = {}
	for i = 1,7 do
		self.icons_q[i] = love.graphics.newQuad((i-1)*20, 0, 20, 20, 140, 20)
	end
	self.cx = WIDTH/2
	self.cy = HEIGHT-10-(H/2)
	self.x = self.cx - (W/2)
	self.y = self.cy - (H/2)
	self.blue_ratio = 1.0
	self.red_ratio = 1.0
	self.weapon_i = self.scene.player.weapon
	
	self.start_time = 300
	self.local_timer = 0
	self.real_timer = 0
	
	self.level_juice = 1
	self.weapon_juice = 1
	self.time_juice = 1
	self.red_juice = 0
	self.blue_juice = 0
end

function Hud:update(dt)
	
	local weapon = self.weapon_i.weapon
	if weapon.ammo > 0 then
		self.red_ratio = weapon.ammo / weapon.max_ammo
	else
		self.red_ratio = 1 - weapon.reload_time / weapon.start_reload_time
	end
	
	self.real_timer = self.real_timer + dt
	local dt_diff = self.scene.timemgr.last_dt - dt
	--print(dt_diff)
	self.local_timer = self.local_timer + dt + dt_diff*10

	self.blue_ratio = 1 - self.local_timer / self.start_time
	if self.blue_ratio < 0 then self.blue_ratio = 0 end
end

function Hud:loseTime(lost)
	self.local_timer = self.local_timer + lost
	self:juiceBlue()
end

local lg = love.graphics
function Hud:draw()
	self:drawBlueMeter()
	self:drawRedMeter()
	lg.setColor(255,255,255,255)
	lg.draw(self.lines, self.x, self.y)
	self:drawWeapon()
	self:drawTimer()
	lg.draw(self.icons, self.icons_q[7], self.cx-76, self.cy-10, 0, self.time_juice, self.time_juice)
	love.graphics.setColor(255,255,255, 255)
end

function Hud:drawBlueMeter()
	local w = 102*self.blue_ratio
	local x,y = self.cx-76-w, self.cy-10
	lg.setColor(blue[2])
	lg.rectangle("fill", x, y-self.blue_juice/2, w, 20+self.blue_juice)
	lg.setColor(blue[1])
	lg.rectangle("fill", x, y+15, w, 5+self.blue_juice/2)
	lg.setColor(blue[3])
	lg.rectangle("fill", x, y-self.blue_juice/2, w, 5+self.blue_juice/2)
end

function Hud:drawRedMeter()
	local x,y = self.cx+96, self.cy-10
	local w = 81*self.red_ratio
	if self.weapon_i.weapon.ammo <= 0 then
		lg.setColor(255,255,255)
		lg.rectangle("fill", x, y, w, 20)
	else
		lg.setColor(red[2])
		lg.rectangle("fill", x, y-self.red_juice/2, w, 20+self.red_juice)
		lg.setColor(red[1])
		lg.rectangle("fill", x, y+15, w, 5+self.red_juice/2)
		lg.setColor(red[3])
		lg.rectangle("fill", x, y-self.red_juice/2, w, 5+self.red_juice/2)
	end
end

function Hud:drawWeapon()
	local name = self.weapon_i.weapon.name
	local level = self.weapon_i.weapon.level
	local quad = nil
	if name == "Pea shooter" then
		quad = 1
	end
	if name == "Shotgun" then
		quad = 2
	end
	if quad then
		lg.draw(self.icons, self.icons_q[level+3], self.cx+75, self.cy-10, 0, self.level_juice, self.level_juice)
		lg.draw(self.icons, self.icons_q[quad], self.cx+55, self.cy-10, 0, self.weapon_juice, self.weapon_juice)
	end
end

function Hud:juiceWeapon()
	self.scene.timer:tween(0.2, self, {weapon_juice = 1.5}, "out-back", function()
		self.scene.timer:tween(0.2, self, {weapon_juice = 1}, "out-back")
	end)
end

function Hud:juiceLevel()
	self.scene.timer:tween(0.2, self, {level_juice = 1.5}, "out-back", function()
		self.scene.timer:tween(0.2, self, {level_juice = 1}, "out-back")
	end)
end

function Hud:juiceTime()
	self.scene.timer:tween(0.2, self, {time_juice = 1.5}, "out-back", function()
		self.scene.timer:tween(0.2, self, {time_juice = 1}, "out-back")
	end)
end

function Hud:juiceRed()
	self.scene.timer:tween(0.2, self, {red_juice = 10}, "out-back", function()
		self.scene.timer:tween(0.2, self, {red_juice = 0}, "out-back")
	end)
end

function Hud:juiceBlue()
	self.scene.timer:tween(0.2, self, {blue_juice = 10}, "out-back", function()
		self.scene.timer:tween(0.2, self, {blue_juice = 0}, "out-back")
	end)
end

function Hud:drawTimer()
	local time_remaining = math.floor(self.start_time - self.local_timer)
	if time_remaining < 0 then time_remaining = 0 end
	local minutes = math.floor(time_remaining / 60)
	local seconds = math.floor(time_remaining % 60)
	
	local s = seconds
	if seconds < 10 then
		s = "0"..seconds
	end
	
	local text = "0"..minutes..":"..s
	local font = love.graphics.getFont()
	local lx = (WIDTH-font:getWidth(text)*2) / 2
	
	lg.print(text, lx, self.cy-8, 0, 2, 2)
end

function Hud:keypressed(key)
	if key == "b" then
		self:juiceRed()
	elseif key == "r" then
		self:juiceBlue()
		
	end
end

return Hud
