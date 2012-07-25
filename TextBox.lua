strTextBox = 
[[
--TextBox--
return function(x,y,w,s)
return {
    x = x,
    y = y,
    w = w,
    fontSize = 18,
    text = s,
    blink = ElapsedTime,
    blinkstate = true,

draw = function(self)
    local x, w, h
    pushStyle()
    pushMatrix()
    font("Futura-Medium")
    textMode(CORNER)
    fontSize(self.fontSize)
    rectMode(CORNER)
    strokeWidth(1)
    stroke(0, 0, 0, 255)
    fill(228, 228, 228, 255)
    textAlign(LEFT)
    textWrapWidth(self.w - 10)
    w, h = textSize(self.text)
    local _,h1 = textSize("1")
    if h==0 then h = h1 end
    translate(self.x, self.y)
    rect(0, h1-h, self.w, h+4)
    stroke(255, 255, 255, 255)
    --noFill()
    rect(2, 2+h1-h, self.w - 4, h)
    fill(22, 22, 22, 255)
    --text(self.text, self.w / 2, 12)
    text(self.text, 5, h1-h)
    if self.blink < ElapsedTime - 0.3 then
        self.blink = ElapsedTime
        self.blinkstate = not self.blinkstate
    end
    if self.blinkstate then
        strokeWidth(5)
        stroke(45, 45, 45, 255)
        
        --x = self.w / 2 + w / 2 + 2
        x = 8 + w
        line(x, 3+h1-h, x, 1+h1)
    end
    popMatrix()
    popStyle()
end,

touched = function(self,touch)
    -- move cursor? For the moment, touching a textbox has no function
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

TextBox = loadstring(strTextBox)()
strTextBox = nil