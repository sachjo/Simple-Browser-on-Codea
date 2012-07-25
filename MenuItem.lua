strMenuItem = 
[[
--MenuItem--
return function(s,func)
return {
    name = s or "",
    func = func,
};
end
]]

MenuItem = loadstring(strMenuItem)()
strMenuItem = nil