local TimeManager = Class('CameraManager')

function TimeManager:initialize(scene)
   self.scene = scene
	self.key = self.scene.key
	self.timeScalar = 1	
end

function TimeManager:update(dt)
	if self.key["1"] then
		self.timeScalar = 1
	end
	if self.key["2"] then
		self.timeScalar = 1/2
	end
	if self.key["3"] then
		self.timeScalar = 1/3
	end
	if self.key["4"] then
		self.timeScalar = 1/4
	end
	if self.key["5"] then
		self.timeScalar = 1/5
	end

	return dt*self.timeScalar
end

return TimeManager
