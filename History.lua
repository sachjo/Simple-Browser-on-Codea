strHistory = 
[[
--History--
return function()
return {
    items = {},
    index = 0,
    max = 0,
clear = function(self)
    saveGlobalData("history","") 
    self.items = {}
end,
store = function(self)
    local str = ""
    local crlf = string.char(13)..string.char(10)
    for i,v in ipairs(self.items) do
        str = str .. v.url .. crlf
    end
    saveGlobalData("history",str)
end,
restore = function(self)
    local str = readGlobalData("history",nil)
    if str then
        local crlf = string.char(13)..string.char(10)
        for part, pos in string.gfind(str, "([^,"..crlf.."]*)"..crlf) do 
            local item = HistoryItem(part,0,0)
            table.insert(self.items,item)
        end
    end
    self.max = table.maxn(self.items)
    self.index = self.max
end,
addIndex = function(self)
    self.index = self.index + 1
end,
subIndex = function(self)
    self.index = self.index - 1
end,
setPos = function(self,url,pos,wpos)
    local no = self:isUrlExistThenGetNo(url)
    if no then
        self.items[no].pos = pos
        self.items[no].wpos = wpos
    end
end,
add = function(self,url,pos,wpos)
    local ret = nil
    local no = self:isUrlExistThenGetNo(url)
    if no then
        if no > 1 then
            local item = self.items[no-1]
            table.remove(self.items,no-1)
            table.insert(self.items,item)
            item = HistoryItem(url,pos,wpos)
            table.remove(self.items,no-1)
            table.insert(self.items,item)
        else
            local item = HistoryItem(url,pos,wpos)
            table.remove(self.items,no)
            table.insert(self.items,item)
        end
        self.index = table.maxn(self.items)
        --print("["..self.index.."],"..url.." readded in history")
    else
        if self.max > self.index then
            local item = self.items[self.index]
            table.remove(self.items,self.index)
            table.insert(self.items,item)
        end
        local item = HistoryItem(url,pos,wpos)
        table.insert(self.items,item)
        self.index = table.maxn(self.items)
        self.max = self.index
        --print("["..self.index.."],"..url.." added in history")
    end
    self:store()
end,
getUrlByIndex = function(self)
    if self.index > 0 then
        return self.items[self.index].url
    else
        return nil
    end
end,
getPosByIndex = function(self)
    return self.items[self.index].pos,self.items[self.index].wpos
end,
getPosByUrl = function(self,url)
    local pos,wpos = 0
    local no = self:isUrlExistThenGetNo(url)
    if no then 
        pos,wpos = self.items[no].pos,self.items[no].wpos
    end
    return pos,wpos
end,
getUrlByNo = function(self,no)
    local ret = nil
    if no >= 0 and no <= table.maxn(self.items) then
        ret = self.items[i].url
    end
    return ret
end,
isUrlExistThenGetNo = function(self,url)
    local ret = nil
    for i,v in ipairs(self.items) do
        if v.url == url then
            ret = i
            break
        end
    end
    return ret
end
};
end
]]

History = loadstring(strHistory)()
strHistory = nil