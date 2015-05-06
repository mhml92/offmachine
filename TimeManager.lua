local TimeManager = Class('CameraManager')

function TimeManager:initialize(scene)
   self.scene = scene
	self.key = self.scene.key
	self.timeScalar = 1	
	self.tweenTime = 0.2
	self.tweenHandle = nil
end

function TimeManager:update(dt)
	if self.key["1"] then
		self:tweenTimeScalar(1)
	end
	if self.key["2"] then
		self:tweenTimeScalar(1/2)
	end
	if self.key["3"] then
		self:tweenTimeScalar(1/3)
	end
	if self.key["4"] then
		self:tweenTimeScalar(1/4)
	end
	if self.key["5"] then
		self:tweenTimeScalar(1/5)
	end

	return dt*self.timeScalar
end

function TimeManager:tweenTimeScalar(t)
	if self.tweenHandle then
		Timer.cancel(self.tweenHandle)
	end
	self.tweenHandle = Timer.tween(self.tweenTime, self,{timeScalar = t})
end


return TimeManager
