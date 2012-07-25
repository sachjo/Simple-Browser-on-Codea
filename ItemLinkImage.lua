strItemLinkImage = 
[[
--ItemLinkImage--
return function(w,h)
    --print(w,h)
return {
    image = nil,
    w = w,
    h = h,
    x = WIDTH,
    y = HEIGHT,
    name = "",

draw = function(self,x,y)
    -- Codea does not automatically call this method
    if(self.image) then
        spriteMode(CORNER)
        sprite(self.image,x,y,self.w,self.h)
    else
        rect(x,y,self.w,self.h)
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

ItemLinkImage = loadstring(strItemLinkImage)()
strItemLinkImage = nil