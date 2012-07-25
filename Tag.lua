strTag = 
[[
--Tag--
return function()
return {
    tag = "",
    param = {},
    len = 0,

findNextTagFromString = function(self,data,pos)
    Global:dispmethods("Tag","findNextTagFromString")
    local startpos = nil
    local endpos = nil
    startpos,endpos = string.find(data,"<[^>]*>",pos)
    if startpos then
        self:parseTag(string.sub(data,startpos,endpos))
    else
    end
    return startpos,endpos
end,

findAllTagFromString = function(self,data,pos)
    Global:dispmethods("Tag","findAllTagFromString")
    local startpos = nil
    local endpos = nil
    local pos = 1
    local taglist = {}
    local len = string.len(data)
    

    while pos < len do
        startpos,endpos = string.find(data,"<[^>]*>",pos)
        if startpos then
            local tagtmp = Tag()
            tagtmp:parseTag(string.sub(data,startpos,endpos))
            table.insert(taglist,tagtmp)
            pos = endpos + 1
        else
            pos = len
            --print("not found")
        end
    end
    return taglist
end,

getSelectedTag = function(self,data,pos,tag)
    Global:dispmethods("Tag","getSelectedTag")
    local startpos = nil
    local endpos = nil
    local innerelements = ""

    if tag then
        startpos,endpos = 
            string.find(data,"<%s*"..tag:lower().."[^>]*>",pos)
        if startpos == nil then
            startpos,endpos = 
                string.find(data,"<%s*"..tag:upper().."[^>]*>",pos)
        end
        if startpos then
            self:parseTag(string.sub(data,startpos,endpos))
            local endstartpos,endendpos =
                string.find(data,"</%s*"..tag:lower().."[^>]*>",endpos+1)
            if endstartpos == nil then
                endstartpos,endendpos =
                string.find(data,"</%s*"..tag:upper().."[^>]*>",endpos+1)
            end
            --print("hello2")    
            if endstartpos then
                innerelements = string.sub(data,endpos+1,endstartpos -1)
            end
        end        
    end
    return startpos,endendpos,innerelements
end,

findEndTag = function(self,data,pos,tag)
    Global:dispmethods("Tag","findEndTag")
    local startpos = nil
    local endpos = nil
    local innerelements = ""

    if tag then
        startpos,endpos = string.find(data,"</"..tag..">",pos)
        if startpos then
            self:parseTag(string.sub(data,startpos,endpos))
            innerelements = string.sub(data,pos,startpos -1)
        end
    end
    return startpos,endpos,innerelements
end,

parseTag = function(self,data)
    Global:dispmethods("Tag","parseTag")
    local START = -1
    local TAG = 0
    local PARA = 1
    local PARAVAL = 2
    local END = 3
    data = String().trimEnd(String().trim(data))
    --print("parse before:"..data)
    local pos = 1
    local len = string.len(data)
    local tag = ""
    local param = {}
    local state = START
    local inquote = false
    --print("len="..len)
    
    tag = string.match(data,"[^<>%s=]+")
    for k,v in string.gmatch(data,'([^<>%s=]+)%s*=%s*["'.."'"..']*([^<>%s"'.."'"..']+)["'.."'"..']*') do
        --print(k.."="..v)
        param[k:lower()]=v
    end
    
    --if tag:lower() == "a" then print("a="..data) end

    self.len = len
    self.tag = tag
    self.param = param   
end
};
end
]]

Tag = loadstring(strTag)()
strTag = nil