local FontManager = {}

function FontManager.setFont(fontname)
	local font = resmgr:getFont(fontname)
	love.graphics.setFont(font)
end

function FontManager.currentFont()
	return love.graphics.getFont()
end

function FontManager.getCenteringCoordinates(line, ax, ay, aw, ah, offsetX, offsetY)
	local font = love.graphics.getFont()
	local x = (font:getWidth(line)) / 2 + ax + offsetX
	local y = (font:getHeight()) / 2 + ay + offsetY
	return x, y
end

function FontManager.getScreenCenteringCoordinates(line, offsetX, offsetY)
	return FontManager.getCenteringCoordinates(line, 0, 0, G.WIDTH, G.HEIGHT, offsetX, offsetY)
end

return FontManager