strWebImage = 
[[
--WebImage--
return function(url,data,w,h)
    local image = data
    local w1 = 0
    local h1 = 0,0
    if image then
        w1,h1 = spriteSize(image)
    else
        w1,h1 = w,h
    end
    --print(w1,h1)
return {
    image = image,
    w = w1,
    h = h1,
    url = url,
    name = "",
calcSize = function(self)
    if self.image then
        self.w,self.h = spriteSize(self.image)
    end
end,
};
end
]]

WebImage = loadstring(strWebImage)()
strWebImage = nil