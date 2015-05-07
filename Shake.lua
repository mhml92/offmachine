local Shake = Class('Shake')

function Shake:initialize(scene,time,strength)
	self.scene = scene 
	self.time = time
	self.strength = strength
	self.localTimer = scene.timemgr.localTimer
	self.offX = 0
	self.offY = 0
	self.done = false
	self.localTimer.tween(time,self,{strength = 0},'out-quint')
	self:newShake()
end

function Shake:newShake()
	if self.time > 0 then

		self.time = self.time-(1/60)
		local sdir = math.random()*2*math.pi
		local loffX,loffY = math.cos(sdir)*self.strength,math.sin(sdir)*self.strength
		self.localTimer.tween(1/60,self,{offX = loffX,offY = loffY},'in-out-quad',function() self:newShake() end)
	else
		self.done = true
	end
end


function Shake:isDone()
	return self.done
end

function Shake:getOffX()
	return self.offX
end
function Shake:getOffY()
	return self.offY
end

return Shake
