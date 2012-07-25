strTtouch =
[[
--Ttouch--
return function(touch)
return {
    x = touch.x,
    y = touch.y,
    state = touch.state,
    prevX = touch.prevX,
    prevY = touch.prevY,
    deltaX = touch.deltaX,
    deltaY = touch.deltaY,
    id = touch.id,
    tapCount = touch.tapCount,
    timer = 0,

translate = function(self,x, y)
    self.x = self.x - x
    self.y = self.y - y
end
};
end
]]

Ttouch = loadstring(strTtouch)()
strTtouch = nil