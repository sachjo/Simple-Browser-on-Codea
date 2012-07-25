strWebImageArray = 
[[
--WebImageArray--
return function()
return {
    items = {},

add = function(self,url,data)
    local ret = nil
    local no = self:isUrlExistThenGetNo(url)
    if no then
        ret = no
        self.items[no].image = data
        --print("["..ret.."],"..url.." is already exists..")
    else
        local item = WebImage(url,data)
        table.insert(self.items,item)
        ret = table.maxn(self.items)
        --print("["..ret.."],"..url.." added")
    end
end,
addItem = function(self,webimage)
    table.insert(self.items,webimage)
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

WebImageArray = loadstring(strWebImageArray)()
strWebImageArray = nil