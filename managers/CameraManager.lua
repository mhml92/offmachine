local humpCamera  = require 'hump/camera'

local Shake = require 'managers/Shake'
local CameraManager = Class('CameraManager')

function CameraManager:initialize(scene)
   self.scene = scene
   self.cam = humpCamera(0,0)
	self.smoother = humpCamera.smooth.damped(10)

   self.cam:zoomTo(1)
	self.zoom = 1
	self.shakes = {}
   -- shake vars
   self.offX = 0
   self.offY = 0
   self.x = nil
   self.y = nil
	
   -- camera loosness multiplyer
   self.clm = 6/60

	self.debug = {}
	self.debug.shakeWaite = 60
	self.debug.shakeCount = 0
end

function CameraManager:update(dt)

   --if DEBUG then self:debugFunction(x,y,dt) end
	
	-- Set new cam coords
	--[[
	if self.x == nil then
      self.x,self.y = x,y
   end
   local dx,dy = x-self.x,y-self.y
   self.x,self.y = self.x + (self.clm*dx),self.y + (self.clm*dy)
	]]
		self.cam:zoomTo(self.zoom)

	
	--print(self.cam)
	-- Update cam shake
	self.offX = 0
	self.offY = 0
	for i = #self.shakes,1,-1 do
		if self.shakes[i]:isDone() == false then
			self.offX = self.offX + self.shakes[i]:getOffX()
			self.offY = self.offY + self.shakes[i]:getOffY()
		else
			table.remove(self.shakes,i)	
		end
	end

	-- Update camera
   --self.cam:lookAt(self.x + self.offX,self.y + self.offY)
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
	if self.scene.keyDown[" "] then
		--time,strength
		self:shake(0.5,2)
		--self.scene.key[" "] = false
	end
end


return CameraManager
