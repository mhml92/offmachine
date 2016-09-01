require 'slam/slam'
require ("loveshortcuts")
print(math)
math.random = love.math.random

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


local canvas

function love.load()
lol1 = math.max(love.graphics.getWidth(),love.graphics.getHeight())
lol2 = lol1
	local winwidth, winheight = love.window.getDesktopDimensions()
	toggleFullscreen()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	
   resmgr = ResourceManager:new()
   love.graphics.setBackgroundColor(255,100,100)
   StateManager.init("Moffeus")
	--StateManager.init("TestScene")
end

function love.run()
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
			for i=0,#scene.layercanvases do
				lg.draw(scene.layercanvases[i])
			end
			
			--for i=#scene.layers,1 do
			--	lg.draw(scene.layercanvases[i])
			--end


			love.graphics.pop()
			
			love.graphics.push()
			love.graphics.scale(SCALE, SCALE)
			love.graphics.setCanvas()
			

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

    		
		    
		    love.graphics.setShader(shaders)
			love.graphics.draw(canvas, 0, 0)
			love.graphics.setShader()
			lg.draw(resmgr:getImg("black_hole.png"), 0, 0)

			love.graphics.pop()

			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
 
end

function love.keypressed( key,scancode,isrepeat )
   if key == "escape" then
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
