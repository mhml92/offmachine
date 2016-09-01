local TimeManager = Class('TimeManager')

function TimeManager:initialize(scene)
   self.scene = scene
--	self.localTimer = Timer.new()
	self.timeScalar = 1	
	self.tweenTime = 0.5
	self.tweenHandle = nil
end

function TimeManager:update(dt)
	local newDT = dt*self.timeScalar
--	self.localTimer:update(newDT)
	return newDT
end

function TimeManager:setTimeScalar(t)
	self.timeScalar = t
end

function TimeManager:tweenTimeScalar(t)
	if self.tweenHandle then
		--Timer.cancel(self.tweenHandle)
	end
	self.tweenHandle = self.scene.timer:tween(self.tweenTime, self,{timeScalar = t},'in-sine')
end


return TimeManager
