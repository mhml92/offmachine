require 'slam/slam'

local SoundManager = Class("SoundManager")

function SoundManager:initialize(scene)
   self.scene = scene
	self.resmgr = scene.resmgr
	self.timemgr = scene.timemgr
	self.sounds = {}
	self.pitch = 1
end

function SoundManager:addSound(filename, looping, volume)
	local sound = resmgr:getSound(filename)
	sound:setVolume(volume)
	sound:setLooping(looping)
	sound:setPitch(self.pitch)
	table.insert(self.sounds, sound)
	return sound
end

function SoundManager:addSoundGroup(name,volume)
   local resmgr = self.scene.resmgr
   local sg = resmgr.soundGroups[name]
   for k, filename in ipairs(sg) do 
      local sound = resmgr:getSound(filename)
      sound:setVolume(volume)
      sound:setLooping(false)
      sound:setPitch(self.pitch)
      table.insert(self.sounds, sound)
   end
   return name
end

function SoundManager:playSound(sound)
	sound:play()
end

function SoundManager:playSoundGroup(name)
   local resmgr = self.scene.resmgr
   local sg = resmgr.soundGroups[name]

   local i = love.math.random(#sg)
   print(#sg,i)
   self:playSound(resmgr:getSound(sg[i]))
end

function SoundManager:update(dt)
	local pitch = self.timemgr.timeScalar
	pitch = math.max(0.2, math.min(2, pitch))
    print(#self.sounds)
    
	for k, v in pairs(self.sounds) do
		v:setPitch(pitch)
	end
	self.pitch = pitch
end

return SoundManager
