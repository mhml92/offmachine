local TimeManager = Class('TimeManager')

function TimeManager:initialize(scene)
   self.scene = scene
--	self.localTimer = Timer.new()
	self.timeScalar = 1	
	self.tweenTime = 0.5
	self.tweenHandle = nil

	self.upper = HEIGHT - 300
	self.lower = HEIGHT 
	self.max_slow = 0.4
	self.last_dt = 0
end

function TimeManager:update(dt)
	-- get player y pos
	self.last_dt = dt
 	local py = self.scene.player.y
	if py > self.upper then
		
		local strength = 1-((py-self.upper)/(self.lower-self.upper))
		self.timeScalar = strength * self.max_slow + (1-self.max_slow)

	else
		self.timeScalar = 1
	end

	local newDT = dt*self.timeScalar
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
