strItemInputBox = 
[[
--ItemInputBox--
return function(s,w)
return {
    text = s,
    w = w,
    h = 24,
    x = WIDTH,
    y = HEIGHT,
    focused = false,
    blink = ElapsedTime,
    blinkstate = true,

touched = function(self,touch)
    if touch.x >= self.x and touch.x <= self.x+self.w then
        if touch.y >= self.y and touch.y <= self.y+self.h then
            return true
        end
    end
    return false
end,

draw = function(self,xx,y)
    self.x = xx
    self.y = y
    local x, w, h
    pushStyle()
    pushMatrix()
    font("Futura-Medium")
    textMode(CORNER)
    fontSize(18)
    rectMode(CORNER)
    strokeWidth(1)
    stroke(0, 0, 0, 255)
    fill(228, 228, 228, 255)
    translate(self.x, self.y)
    rect(0, 0, self.w, self.h)
    stroke(255, 255, 255, 255)
    --noFill()
    rect(2, 2, self.w - 4, self.h-4)
    fill(22, 22, 22, 255)
    textAlign(LEFT)
    textWrapWidth(0)
    --text(self.text, self.w / 2, 12)
    text(self.text, 5, 0)
    if self.focused == true then
        w, h = textSize(self.text)
        if self.blink < ElapsedTime - 0.3 then
            self.blink = ElapsedTime
            self.blinkstate = not self.blinkstate
        end
        if self.blinkstate then
            strokeWidth(5)
            stroke(45, 45, 45, 255)
            
            --x = self.w / 2 + w / 2 + 2
            x = 8 + w
            line(x, 3, x, self.h-3)
        end
    end
    popMatrix()
    popStyle()
end,

acceptKey = function(self,k)
    if k ~= nil then
        if string.byte(k) == nil then
            if string.len(self.text) > 0 then
                self.text = string.sub(self.text, 
                1, string.len(self.text) - 1)
            end
        end
        self.text = self.text..k
    end
end
};
end
]]

ItemInputBox = loadstring(strItemInputBox)()
strItemInputBox = nil