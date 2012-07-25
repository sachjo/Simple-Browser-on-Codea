str = 
[[
return function(s,x,y)
return {
    text = s or "default",
    x = x or 100,
    y = y or 100,

    setpos = function(self,x,y)
        self.x = x
        self.y = y
    end
};
end
]]

TestClass = loadstring(str)()
str = nil