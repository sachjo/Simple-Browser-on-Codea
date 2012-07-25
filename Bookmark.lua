strBookmark = 
[[
--Bookmark--
return function()
return {
    items = {},
clear = function(self)
    saveGlobalData("bookmark","") 
    self.items = {}
end,
store = function(self)
    local str = ""
    local crlf = string.char(13)..string.char(10)
    for i,v in ipairs(self.items) do
        str = str .. v.url .. crlf .. v.name .. crlf
    end
    saveGlobalData("bookmark",str)
end,
restore = function(self)
    local str = readGlobalData("bookmark",nil)
    if str then
        local crlf = string.char(13)..string.char(10)
        local url,name = nil,nil
        for part, pos in string.gfind(str, "([^,"..crlf.."]*)"..crlf) do 
            if not url then url = part
            else 
                name = part
                local item = BookmarkItem(url,name)
                table.insert(self.items,item)
                url = nil
            end
        end
    end
end,
remove = function(self,url)
    local ret = nil
    local no = self:isUrlExistThenGetNo(url)
    if no then
        ret = no
        table.remove(self.items,no)
    end
    return ret
end,
add = function(self,url,name)
    local ret = nil
    local no = self:isUrlExistThenGetNo(url)
    if no then
        ret = no
        self.items[no].name = name
        --print("["..ret.."],"..url.." is already exists..")
    else
        local item = BookmarkItem(url,name)
        table.insert(self.items,item)
        ret = table.maxn(self.items)
        --print("["..ret.."],"..url.." added")
        self:store()
    end
end,
getItemByNo = function(self,no)
    local ret = nil
    if no >= 0 and no <= table.maxn(self.items) then
        ret = self.items[i]
    end
    return ret
end,
getItemByUrl = function(self,url)
    local ret = nil
    local no = self:isUrlExistThenGetNo(url)
    if no then 
        ret = self.items[no]
        --print("["..no.."],"..url.." matched")
    else
        --print(url.."is no matched")
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

Bookmark = loadstring(strBookmark)()
strBookmark = nil