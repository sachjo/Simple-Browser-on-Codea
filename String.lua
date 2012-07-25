strString = 
[[
--String--
return function(x)
return {
    x = x,
trim = function(str)
    local out = nil; local len = string.len(str)
    for i = 1,len do
        if string.sub(str,i,i) ~= " " then out = string.sub(str,i,len) break end
    end
    return out
end,

trimEnd = function(str)
    local out = nil; local len = string.len(str)
    for i = len,1,-1 do
        if string.sub(str,i,i) ~= " " then out = string.sub(str,1,i) break end
    end
    return out
end

};
end
]]

String = loadstring(strString)()
strString = nil