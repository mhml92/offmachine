local Shaders = Class("Shaders", Entity)

function Shaders:initialize(x,y,scene)

    self.shaders = {
       blackhole = love.graphics.newShader[[
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
                vec2 lol = vec2(escapeR, eventH);
                vec2 guide = vec2(pos.xy-texture_coords.xy);
                float e = 1-((length(guide) - eventH)/escapeR);
                return Texel(texture,texture_coords.xy + guide.xy*e);

                //return vec4(1,0,0,1);
            }

            return Texel(texture,texture_coords.xy).rgba;
        }
    ]]
    }

    esr = 1000
    esh = 1000

    local width = math.max(love.graphics.getWidth(),love.graphics.getHeight())
    self.shaders.blackhole:send('size',{width,width})
    self.shaders.blackhole:send('eventH',esh)
    self.shaders.blackhole:send('escapeR',esr*1.5)
    self.shaders.blackhole:send('holeColor',{0,0,0})
    self.shaders.blackhole:send('pos',{1920/2,love.graphics.getHeight()+200})
end


function Shaders:update(dt)
    print(lm.getX(),lm.getY())
    --self.shaders.blackhole:send('pos',{lm.getX(),lm.getY()})
end

function Shaders:bind(name)
    love.graphics.setShader(self.shaders[name])
end

function Shaders:release()
    love.graphics.setShader()
end


function Shaders:draw()
end


return Shaders