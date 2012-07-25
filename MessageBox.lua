strMessageBox = 
[[
--MessageBox--
return function(s)
    textWrapWidth(WIDTH/2)
    font("Futura-Medium")
    local fontsize  = 40
    fontSize(fontsize)
    local w,h = textSize(s)
    local w = w + 50
    local h = h + 50
    local x = WIDTH /2 - w / 2
    local y = HEIGHT / 2 - h / 2
return {
    frame = Frame(x, y, x+w, y+h),
    x = x,
    y = y,
    w = w,
    h = h,
    text = s,
    clr = color(207, 138, 138, 255),
    lineclr = color(154, 176, 102, 255),
    fontSize = fontsize,
    
setText = function(self,s)
    textWrapWidth(WIDTH/2)
    font("Futura-Medium")
    fontSize(self.fontSize)
    self.w,self.h = textSize(s)
    self.w = self.w + 50
    self.h = self.h + 50
    self.x = WIDTH /2 - self.w/ 2
    self.y = HEIGHT / 2 - self.h / 2
    self.frame.x1 = self.x
    self.frame.y1 = self.y
    self.frame.x2 = self.x+self.w
    self.frame.y2 = self.y+self.h
    self.text = s
end,
draw = function(self)
    pushStyle()
    stroke(self.lineclr)
    font("Futura-Medium")
    textMode(CENTER)
    fontSize(self.fontSize)
    fill(self.clr)
    self.frame:gloss(self.clr,1)
    fill(5, 5, 5, 255)
    if self.text then text(self.text, WIDTH/2, HEIGHT/2) end
    popStyle()
end,
touched = function(self,touch)
    return self.frame:touched(touch)
end
};
end
]]

MessageBox = loadstring(strMessageBox)()

strMessageBox = nil
