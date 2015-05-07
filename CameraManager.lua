local humpCamera  = require 'hump/camera'

local Shake = require 'Shake'
local CameraManager = Class('CameraManager')

function CameraManager:initialize(scene)
   self.scene = scene
   self.cam = humpCamera(0,0)


   self.cam:zoomTo(2)
	self.shakes = {}
   -- shake vars
   self.offX = 0
   self.offY = 0
   self.x = nil
   self.y = nil
	
   -- camera loosness multiplyer
   self.clm = 6

	self.debug = {}
	self.debug.shakeWaite = 60
	self.debug.shakeCount = 0
end

function CameraManager:update(x,y,dt)

   if DEBUG then self:debugFunction(x,y,dt) end
	
	if self.x == nil then
      self.x,self.y = x,y
   end
   local dx,dy = x-self.x,y-self.y
	local clm = self.clm*dt
   self.x,self.y = self.x + (dx*clm),self.y + (dy*clm)
	self.offX = 0
	self.offY = 0
	for i = #self.shakes,1,-1 do
		if self.shakes[i]:isDone() == false then
			self.offX = self.offX + self.shakes[i]:getOffX()
			self.offY = self.offX + self.shakes[i]:getOffY()
		else
			table.remove(self.shakes,i)	
		end
	end
   self.cam:lookAt(self.x + self.offX,self.y + self.offY)
end

function CameraManager:attach()
   self.cam:attach()
end

function CameraManager:detach()
   self.cam:detach()
end

function CameraManager:shake(time,strength)
	table.insert(self.shakes,Shake:new(self.scene,time,strength))
end

function CameraManager:debugFunction(x,y,dt)
	local db = self.debug
	if self.scene.key[" "] then
		self:shake(0.5,3)
		--self.scene.key[" "] = false
	end
end


return CameraManager
