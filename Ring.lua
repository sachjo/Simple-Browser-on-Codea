strRing = 
[[
--Ring--
return function(x,y)
return {
    x = x,
    y = y,
    w = 100,
    h = 100,
    r = 0,
    clr = color(185, 96, 163, 255),

draw = function(self)
    -- Codea does not automatically call this method
    pushStyle()
    stroke(self.clr)
    fill(0, 0, 0, 0)
    strokeWidth(10)
    ellipse(self.x,self.y,self.w,self.h)
    local w = math.sin(self.r/180*math.pi)*self.w/3
    local h = math.cos(self.r/180*math.pi)*self.h/3
    line(self.x,self.y,self.x+w,self.y+h)
    ellipseMode()
    popStyle()
    self.r = self.r + 10
    if(self.r >= 360) then self.r = 0 end
end

};
end
]]

Ring = loadstring(strRing)()
strRing = nil