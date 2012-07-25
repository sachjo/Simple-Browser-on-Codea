strItem = 
[[
--Item--
return function(type,text,param,intag,data)
    local name = nil
    if param then name = param.name end
    if not intag then intag = {} end
    Global:dispitems(type,text)
return {
    type = type,
    text = text,
    param = param,
    name = name,
    entity = nil,
    focusedItem = nil,
    innertaglist = intag,
    data = data
};
end
]]

Item = loadstring(strItem)()
strItem = nil