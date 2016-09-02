-- PROFILEING
--ProFi = require 'ProFi'
require 'slam/slam'
require ("loveshortcuts")
--print(math)
math.random = love.math.random


shine = require 'shine'
bloom = shine.glowsimple()
I = require 'inspect.inspect'
G = require 'Globals'
G_functions = require 'g_functions'
Class = require 'middleclass/middleclass'
Scene = require 'Scene'
Entity = require 'Entity'
EnemyBase = require 'entities/EnemyBase'
Vector = require 'hump/vector'
Vectorl = require 'hump/vector-light'
Timer = require 'hump/timer'
ResourceManager = require 'managers/ResourceManager'
Animation = require 'entities/Animation'
HC = require 'HC'
particle = require 'entities/Particle'

Shaders = (require 'shaders'):new()

Shaders = (require 'shaders'):new()

--hardon collider
hc = require 'HC'
HC = hc.new()
Polygon = require 'HC.polygon'
Shapes = require 'HC.shapes'

Particle = require("entities/Particle")

FontManager = require 'managers/FontManager'


local TestScene = require 'scenes/TestScene'

StateManager = require "managers/StateManager"
HighscoreManager = require "managers/HighscoreManager"

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0


local self = {}

WIDTH = 960
HEIGHT = 540
FULLSCREEN = false
SCALE = 1

esr = 400
esh = 400
ess = 400

local canvas, guicanvas

function love.load()
lol1 = math.max(love.graphics.getWidth(),love.graphics.getHeight())
lol2 = lol1
	local winwidth, winheight = love.window.getDesktopDimensions()
	toggleFullscreen()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	guicanvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	
   resmgr = ResourceManager:new()
   --love.graphics.setBackgroundColor(255,100,100)
   --love.graphics.setBackgroundColor(42,164,168)
   StateManager.init("Moffeus")
	--StateManager.init("TestScene")
	shaders = love.graphics.newShader[[
		  extern vec2 size;
		  extern vec2 pos;
		  extern float eventH;
		  extern float escapeR;
		  extern vec3 holeColor;

		  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
				vec2 pos = pos/size;
				float eventH = eventH/size.x;
				float escapeR = escapeR/size.y;

				if(distance(texture_coords.xy,pos.xy) < eventH) {
				// height
				//if( distance(texture_coords.x, pos.x)*distance(texture_coords.x, pos.x) < distance(texture_coords.y, pos.y)) {
					 return vec4(holeColor.rgb,1);
				} else if(distance(texture_coords.xy,pos.xy) <= escapeR+eventH) { //magic
				//} else if(distance(texture_coords.x, pos.x)*distance(texture_coords.x, pos.x) < distance(texture_coords.y, pos.y)) { //magic
					 vec2 guide = vec2(pos.xy-texture_coords.xy);
					 //guide.y += 2;
					 float e = 1-((length(guide) - eventH)/escapeR);
					 return Texel(texture,texture_coords.xy + guide.xy*e);

					 //return vec4(1,0,0,1);
				}

				return Texel(texture,texture_coords.xy).rgba;
		  }
	 ]]
end


local addPixel = G_functions.rand(1,5)
function love.update(dt)
	local scene = StateManager.getScene()

	addPixel = addPixel - dt

	if addPixel <= 0 then
		addPixel = G_functions.rand(1,2)/20

		local part = particle:new(WIDTH,HEIGHT-3-G_functions.rand(1,20),scene,1+G_functions.rand(1,5),1+G_functions.rand(1,5),-200,0,0,0,5,G.color_theme[G_functions.rand(1,#G.color_theme)],nil)
		part:setTrans(false)
		scene:addEntity(part,scene.layers.objects)		
	end
end

function love.run()
	-- PROFILEING
	--ProFi:start()
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 


	-- Main loop time.
	
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
 
		-- Call update and draw
		--time.accum = time.accum + dt 
		--if time.accum >= time.fdt then
			love.update(dt)
			--time.accum = 0--time.accum - time.fdt
		--end	
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			
			love.graphics.origin()
			--if love.draw then love.draw() end
			
			love.graphics.push()

			if love.draw then 
				love.draw() 
			end

			love.graphics.setCanvas(canvas)

			local scene = StateManager.getScene()
		    local no_gui,gui_id = true,0  
		    if scene.layers.gui then
		    	no_gui = false
		    	gui_id = scene.layers.gui
		    end
			for i=0,#scene.layercanvases do
			    if i ~= gui_id or no_gui then
				    if i == 2 then
					    bloom:draw(function()
							lg.draw(scene.layercanvases[i])
					    end)
					else
						lg.draw(scene.layercanvases[i])
					end
				else
					lg.setCanvas(guicanvas)
					lg.clear()
					lg.draw(scene.layercanvases[gui_id])
					lg.setCanvas(canvas)
				end
			end
			
			--for i=#scene.layers,1 do
			--	lg.draw(scene.layercanvases[i])
			--end
			love.graphics.pop()
			
			love.graphics.push()
			love.graphics.scale(SCALE, SCALE)
			love.graphics.setCanvas()
			

			if love.keyboard.isDown("up") then
		        lol1 = lol1 + 1
			end
		    if love.keyboard.isDown("down") then
		        lol1 = lol1 - 1
		    end
			if love.keyboard.isDown("left") then
		        lol2 = lol2 - 1
			end
			if love.keyboard.isDown("right") then
		        lol2 = lol2 + 1
			end
			
			local width = math.max(love.graphics.getWidth(),love.graphics.getHeight())
		    shaders:send('size',{lol1,lol2})
		    shaders:send('eventH',esh)
		    shaders:send('escapeR',esr*1.5)
		    shaders:send('holeColor',{0,0,0})
		    shaders:send('pos',{1920/2, 1080*2})

		    --godsray
		    
		    love.graphics.setShader(shaders)
			love.graphics.draw(canvas, 0, 0)
			love.graphics.setShader()
			
			--gui
			--scene.player.weapon:draw()
			
			lg.draw(guicanvas,0,0)

			--lg.draw(resmgr:getImg("black_hole.png"), 0, 0)

			love.graphics.pop()
			
   			love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )),10, 10) 
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
	-- PROFILER
 
end

function love.keypressed( key,scancode,isrepeat )
   if key == "escape" then

		-- PROFILEING
		--ProFi:stop()
		--ProFi:writeReport( 'MyProfilingReport.txt' )
      love.event.quit()
	elseif key == "f" then
		toggleFullscreen(not FULLSCREEN)
	end
end

function toggleFullscreen()
	FULLSCREEN = not FULLSCREEN
	if FULLSCREEN then
		local winwidth, winheight = love.window.getDesktopDimensions(1)
		SCALE = math.floor(winheight/HEIGHT)
	else
		SCALE = 1
	end
	love.window.setMode(WIDTH*SCALE, HEIGHT*SCALE, {resizable=false, vsync=false, fullscreen = FULLSCREEN})
end
