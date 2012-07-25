strItemPlainText = 
[[
--ItemPlainText--
return function(s,w)
    textWrapWidth(w)
    font("Futura-Medium")
    fontSize(20)
    local _,h1 = textSize(s)
return {
    text = s,
    w = w,
    h = h1,

setStyle = function(self)
    -- Codea does not automatically call this method
    textWrapWidth(self.w)
    textMode(CORNER)
    textAlign(LEFT)
    font("Futura-Medium")
    fontSize(20)
    fill(0, 0, 0, 255)
end,

setHeight = function(self)
    -- Codea does not automatically call this method
    self:setStyle()
    local _ = nil
    _,self.h = textSize(self.text)
end,

draw = function(self,x,y)
    -- Codea does not automatically call this method
    pushStyle()
    self:setStyle()
    text(self.text,x,y)
    popStyle()
end,

touched = function(self,touch)
    -- Codea does not automatically call this method
    return false
end
};
end
]]

ItemPlainText = loadstring(strItemPlainText)()
strItemPlainText = nil