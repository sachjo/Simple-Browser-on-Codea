strScrollBar = 
[[
--ScrollBar--
return function(x,y,w,h)
return {
    x = x,
    y = y,
    w = w,
    h = h,
    pos = 0,
    len = h,
    pagelen = h,
    image = nil,
reset = function(this,x,y,w,h)
    this.x = x
    this.y = y
    this.w = w
    this.h = h
    this:calcLength(this.pagelen)
end,
calcLength = function(this,pageLen)
    this.len = this.h * this.h / pageLen
    this.pagelen = pageLen
end,
setPos = function(this,pagepos)
    if this.image then this.pos = this.h * pagepos / this.pagelen
    else this.pos = (this.h - this.len) * pagepos / this.pagelen end
end,
draw = function(this)
    -- Codea does not automatically call this method
    stroke(168, 27, 27, 101)
    strokeWidth(5)
    pushStyle()
    rectMode(CORNERS)
    rect(this.x, this.y + this.h - this.pos, this.x + this.w,
     this.y + this.h - this.pos - this.len)
end
};
end
]]

ScrollBar = loadstring(strScrollBar)()
strScrollBar = nil