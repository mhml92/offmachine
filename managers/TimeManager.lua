local TimeManager = Class('CameraManager')

function TimeManager:initialize(scene)
   self.scene = scene
	self.localTimer = Timer.new()
	self.keyDown = self.scene.keyDown
	self.timeScalar = 1	
	self.tweenTime = 0.5
	self.tweenHandle = nil
end

function TimeManager:update(dt)
	if self.keyDown["1"] then
		self:tweenTimeScalar(1)
	end
	if self.keyDown["2"] then
		self:tweenTimeScalar(1/2)
	end
	if self.keyDown["3"] then
		self:tweenTimeScalar(1/3)
	end
	if self.keyDown["4"] then
		self:tweenTimeScalar(2)
	end
	if self.keyDown["5"] then
		self:tweenTimeScalar(1/60)
	end

	local newDT = dt*self.timeScalar
	self.localTimer.update(newDT)
	return newDT
end

function TimeManager:tweenTimeScalar(t)
	if self.tweenHandle then
		Timer.cancel(self.tweenHandle)
	end
	self.tweenHandle = Timer.tween(self.tweenTime, self,{timeScalar = t},'in-sine')
end


return TimeManager
