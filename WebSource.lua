strWebSource = 
[[
--WebSource--
return function(url,source)
return {
    source = source,
    url = url,
};
end
]]

WebSource = loadstring(strWebSource)()
strWebSource = nil