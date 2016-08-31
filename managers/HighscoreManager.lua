local HighscoreManager = {}

local fs = love.filesystem
local FILE = "save_off16"

function HighscoreManager.loadScores()
	HighscoreManager.scores = {}
end

function HighscoreManager.commitScores()
end

function HighscoreManager.addScore(name, score)
	table.sort(HighscoreManager.scores,
		function(a, b)
			return a.score < b.score
		end
	)
	table.insert(HighscoreManager.scores, {['name'] = name, ['score'] = score})
end

HighscoreManager.loadScores()

return HighscoreManager