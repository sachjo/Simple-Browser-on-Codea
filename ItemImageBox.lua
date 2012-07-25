strItemImageBox = 
[[
--ItemImageBox--
return function(w,h,data)
    local image = data
    local w1 = 0
    local h1 = 0,0
    if image then
        w1,h1 = spriteSize(image)
    else
        w1,h1 = w,h
    end
    --print(w1,h1)
return {
    image = image,
    w = w1,
    h = h1,
    x = WIDTH,
    y = HEIGHT,
    name = "",

draw = function(self,x,y)
    -- Codea does not automatically call this method
    if(self.image) then
        spriteMode(CORNER)
        sprite(self.image,x,y,self.w,self.h)
    end
    self.x = x
    self.y = y
end,

touched = function(self,touch)
    -- Codea does not automatically call this method
    if touch.x >= self.x and touch.x <= self.x+self.w then
        if touch.y >= self.y and touch.y <= self.y+self.h then
            return true
        end
    end
    return false
end
};
end
]]

ItemImageBox = loadstring(strItemImageBox)()
strItemImageBox = nil