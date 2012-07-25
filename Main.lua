--Main
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    --displayMode(FULLSCREEN)
    Global:init()
    --watch("Global.tt.timer")
    spriteSize()
    globalinhibit()
    --globalpermit()
    --a = 1
end

function globalinhibit()
    global = {}
    global.__index = function(table, index)
        --print("null : __index")
        --assert(false,"index")
    end
    global.__newindex = function(table, index, value)
        --print("null : __newindex")
        assert(false,"global cannot defined: "..index)
    end
    global.__indexorg = _G.__index
    global.__newindexorg = _G.__newindex
    setmetatable(_G, global)
end

function globalpermit()
    global = {}
    global.__index = _G[__indexorg]
    global.__newindex = _G[__newindexorg]
    setmetatable(_G, global)
end

-- This function gets called once every frame
function draw()
    Global:draw()
end

function touched(touch)
    Global:touched(touch)
    --print(touch.state)
end


function keyboard(key)
    Global:keyboard(key)
end