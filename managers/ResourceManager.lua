ResourceManager = Class('ResourceManager')


function ResourceManager:initialize()
	self.images = {}
	self.sounds = {}
	self.fonts = {}
	self.soundGroups = {}
	print(
		[[Loading assets:
	All .mp3 files in sounds/ and subfolders
	All .png files in images/ and subfolders
	Note that all files of the same type must have unique names]])
	love.graphics.setDefaultFilter("nearest", "nearest")
	self:loadAssets("resources")
end

function ResourceManager:loadAssets(dir)
	local files = love.filesystem.getDirectoryItems(dir)
	for k,v in ipairs(files) do
		if love.filesystem.isDirectory(dir.."/"..v) then
			if string.lower(string.sub(v,1,11)) == "soundgroup_" then
				local soundGroupName = string.sub(v,12)
				self:loadSoundGroup(dir,v,soundGroupName)
			end
			self:loadAssets(dir .."/"..v)
		elseif love.filesystem.isFile(dir.."/"..v) then
			local tokens = self:split(v,"\\.")
			for i,token in ipairs(tokens) do
				if token == "mp3" then
					self:loadSound(dir,v)
				elseif token == "png" then
					self:loadImage(dir,v)
				elseif token == "ttf" then
					self:loadFont(dir,v)
				end
			end
		else
			print("Unknown folder element: " .. v)
		end
	end
end

function ResourceManager:loadSoundGroup(dir,v,name)
	local sgdir = dir .."/"..v
	local files = love.filesystem.getDirectoryItems(sgdir)

	self.soundGroups[name] = {}
	for k,f in ipairs(files) do
		self.sounds[f] = love.audio.newSource(sgdir .. "/" .. f)
		table.insert(self.soundGroups[name],f) 
	end
end

function ResourceManager:loadSound(dir,name)
	self.sounds[name] = love.audio.newSource(dir .. "/".. name)
end

function ResourceManager:loadImage(dir,name)
	self.images[name] = love.graphics.newImage( dir .. "/" .. name )
end

function ResourceManager:loadFont(dir,name)
	self.fonts[name] = love.graphics.newFont(dir .. "/" .. name, 40)
end

function ResourceManager:getImg(name)
	if self.images[name] then
		return self.images[name]
	end
end

function ResourceManager:getSound(name)
	if self.sounds[name] then
		return self.sounds[name]
	end
end

function ResourceManager:getFont(name)
	if self.fonts[name] then
		return self.fonts[name]
	end
end

function ResourceManager:split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t

end

return ResourceManager


