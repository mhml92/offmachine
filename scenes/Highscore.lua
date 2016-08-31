local Highscore = Class("Highscore", Scene)

function Highscore:initialize()
	Scene:initialize()
	self.manager = HighscoreManager
end

local lg = love.graphics
function Highscore:draw()
	Scene.draw(self)
	local hm = HighscoreManager
	lg.print("Highscore", 20, 20)
	for k, v in ipairs(self.manager.scores) do
		lg.print(v['name'], 20, 40+k*25)
		lg.print(v['score'], 140, 40+k*25)
	end
end

function Highscore:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	StateManager.setScene("Menu")
end

return Highscore