require 'slam/slam'

local SoundManager = Class("SoundManager")

function SoundManager:initialize(scene)
	self.resmgr = scene.resmgr
	self.timemgr = scene.timemgr
	self.sounds = {}
	self.pitch = 1
end

function SoundManager:addSound(filename, looping, volume)
	local sound = self.resmgr:getSound(filename)
	sound:setVolume(volume)
	sound:setLooping(looping)
	sound:setPitch(self.pitch)
	table.insert(self.sounds, sound)
	return sound
end

function SoundManager:playSound(sound)
	sound:play()
end

function SoundManager:update(dt)
	local pitch = self.timemgr.timeScalar*1.2
	pitch = math.max(0.2, math.min(1, pitch))
	for k, v in pairs(self.sounds) do
		v:setPitch(pitch)
	end
	self.pitch = pitch
end

return SoundManager