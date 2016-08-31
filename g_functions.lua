local rng = love.math.newRandomGenerator()
rng:setSeed(os.time())

G.rand = function(starti, endi)
    if endi then
        return rng:random(starti, endi)
    end
    return rng:random(1, starti)
end

G.deepcopy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[G.deepcopy(orig_key)] = G.deepcopy(orig_value)
        end
        setmetatable(copy, G.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return G