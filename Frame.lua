strFrame = 
[[
--Frame--
return function(x1,y1,x2,y2)
return {
    x1 = x1,
    x2 = x2,
    y1 = y1,
    y2 = y2,

resetFrame = function(this,x1,y1,x2,y2)
    this.x1 = x1
    this.x2 = x2
    this.y1 = y1
    this.y2 = y2
end,
inset = function(this,dx, dy)
    this.x1 = this.x1 + dx
    this.x2 = this.x2 - dx
    this.y1 = this.y1 + dy
    this.y2 = this.y2 - dy
end,

offset = function(this,dx, dy)
    this.x1 = this.x1 + dx
    this.x2 = this.x2 + dx
    this.y1 = this.y1 + dy
    this.y2 = this.y2 + dy
end,
    
draw = function(this,baseclr)
    if baseclr == nil then baseclr = color(50, 50, 50, 255) end
    fill(baseclr)
    stroke(113, 113, 113, 255)
    strokeWidth(5)
    pushStyle()
    rectMode(CORNERS)
    rect(this.x1, this.y1, this.x2, this.y2)
    popStyle()
end,

gloss = function(this,baseclr)
    local i, t, r, g, b, y
    pushStyle()
    if baseclr == nil then baseclr = color(50, 50, 50, 255) end
    fill(baseclr)
    rectMode(CORNERS)
    rect(this.x1, this.y1, this.x2, this.y2)
    r = baseclr.r
    g = baseclr.g
    b = baseclr.b
    for i = 1 , this:height() / 2 do
        r = r - 1
        g = g - 1
        b = b - 1
        stroke(r, g, b, 255)
        y = (this.y1 + this.y2) / 2
        line(this.x1, y + i, this.x2, y + i)
        line(this.x1, y - i, this.x2, y - i)
    end
    popStyle()
end,

shade = function(this,base, step)
    pushStyle()
    strokeWidth(1)
    for y = this.y1, this.y2 do
        local i = this.y2 - y
        stroke(base - i * step, base - i * step, base - i * step, 255)
        line(this.x1, y, this.x2, y)
    end
    popStyle()
end,

touched = function(this,touch)
    if touch.x >= this.x1 and touch.x <= this.x2 then
        if touch.y >= this.y1 and touch.y <= this.y2 then
            return true
        end
    end
    return false
end,

ptIn = function(this,x, y)
    if x >= this.x1 and x <= this.x2 then
        if y >= this.y1 and y <= this.y2 then
            return true
        end
    end
    return false
end,

width = function(this)
    return this.x2 - this.x1
end,

height = function(this)
    return this.y2 - this.y1
end,

midx = function(this)
    return (this.x1 + this.x2) / 2
end,
    
midy = function(this)
    return (this.y1 + this.y2) / 2
end
};
end
]]

Frame = loadstring(strFrame)()
strFrame = nil