strWScrollBar = 
[[
--WScrollBar--
return function(x,y,w,h)
return {
    x = x,
    y = y,
    w = w,
    h = h,
    pos = 0,
    wlen = w,
    pagewlen = w,
    image = nil,
reset = function(this,x,y,w,h)
    this.x = x
    this.y = y
    this.w = w
    this.h = h
    this:calcLength(this.pagewlen)
end,
calcLength = function(this,pagewLen)
    this.wlen = this.w * this.w / pagewLen
    this.pagewlen = pagewLen
end,
setPos = function(this,pagewpos)
    if this.image then this.pos = (-this.w) * pagewpos / this.pagewlen
    else this.pos = (this.wlen-this.w) * pagewpos / this.pagewlen end
end,
draw = function(this)
    -- Codea does not automatically call this method
    stroke(168, 27, 27, 101)
    strokeWidth(5)
    pushStyle()
    rectMode(CORNERS)
    rect(this.x+this.pos,this.y,this.x+this.pos+this.wlen,this.y+this.h)
end
};
end
]]

WScrollBar = loadstring(strWScrollBar)()
strWScrollBar = nil