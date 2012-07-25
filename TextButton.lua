strTextButton = 
[[
--TextButton--
return function(x,y,w1,s)
return {
    fontSize = 16,
    h = 24,
    frame = Frame(x, y, x+w1, y+24),
    x = x,
    y = y,
    w = w1,
    text = s,
    clr = color(255, 255, 255, 255),
    lineclr = color(0,0,0,255),
    
resetFrame = function(this)
    this.frame:resetFrame(this.x, this.y, this.x+this.w, this.y+24)
end,
draw = function(self)
    pushStyle()
    stroke(self.lineclr)
    font("Futura-Medium")
    textMode(CORNER)
    fontSize(self.fontSize)
    fill(self.clr)
    self.frame:gloss(self.clr, 1)
    fill(5, 5, 5, 255)
    textAlign(LEFT)
    textWrapWidth(self.w - 10)
    local w, h = textSize(self.text)
    local _,h1 = textSize("1")
    if self.text then text(self.text, self.x + 5, self.y-h+h1) end
    popStyle()
end,
touched = function(self,touch)
    return self.frame:touched(touch)
end
};
end
]]

TextButton = loadstring(strTextButton)()

strTextButton = nil

