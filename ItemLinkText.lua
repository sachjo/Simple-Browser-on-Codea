strItemLinkText = 
[[
--ItemLinkText--
return function(s,w)
    textWrapWidth(w)
    textMode(CORNER)
    textAlign(LEFT)
    font("Futura-Medium")
    fontSize(20)
    local w1,h1 = textSize(s)
return {
    text = s,
    w = w1,
    h = h1,
    x = WIDTH,
    y = HEIGHT,
    visited = false,

setStyle = function(self)
    -- Codea does not automatically call this method
    textWrapWidth(self.w)
    textMode(CORNER)
    textAlign(LEFT)
    font("Futura-Medium")
    fontSize(20)
end,

setHeight = function(self)
    -- Codea does not automatically call this method
    self:setStyle()
    self.w,self.h = textSize(self.text)
end,

draw = function(self,x,y)
    -- Codea does not automatically call this method
    pushStyle()
    self:setStyle()
    strokeWidth(1)
    stroke(0, 23, 255, 255)
    fill(0, 0, 0, 0)
    rect(x,y,self.w,self.h)
    if(self.visited == false) then
        fill(39, 83, 226, 255)
    else
        fill(255, 0, 238, 255)
    end
    --text("test",x,y)
    text(self.text,x,y)
    popStyle()
    self.x = x
    self.y = y
end,

touched = function(self,touch)
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

ItemLinkText = loadstring(strItemLinkText)()
strItemLinkText = nil