strHistoryItem = 
[[
--HistoryItem--
return function(url,pos,wpos)
    local pos1,wpos1 = 0,0
    if pos then pos1 = pos end
    if wpos then wpos1 = wpos end
return {
    url = url,
    pos = pos1,
    wpos = wpos1,
};
end
]]

HistoryItem = loadstring(strHistoryItem)()
strHistoryItem = nil