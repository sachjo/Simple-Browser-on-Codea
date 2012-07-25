strHtmlParse = 
[[
--HtmlParse--
return function(x)
return {
    x = x,

makeUrltoJump = function(self,past,next)
    Global:dispmethods("HtmlParse","makeUrltoJump")
    local url = ""
    local pos = nil
    if(string.sub(next,1,7) == "http://"  or string.sub(next,1,8) == "https://") then url = next
    elseif next == "History:" then url = next 
    elseif next == "Home:" then url = next 
    elseif(string.sub(next,1,1) == "/") then
        pos = string.find(past,"/",8)
        url = string.sub(past,1,pos-1)..next
    else
        pos = past:len() - past:reverse():find("/") +1
        url = string.sub(past,1,pos)..next
    end
    url = url:gsub("&amp;","&")
    url = url:gsub("&apos;",'"')
    url = url:gsub("&quot;","'")
    --print(url)
    url = url:gsub("%s","%%20")
    --print(past.."+"..next.."="..url)
    return url
end,

parseDataToRawHtml = function(self,data,outitems)
    Global:dispmethods("HtmlParse","parseDataToRawHtml")
    local pos = 1
    local len = string.len(data)
    local outputStr = ""
    local item = Item(Global.TITLE,"Sourse Code")
    table.insert(outitems,item)
    while pos < len do
        enterpos = data:find(string.char(10),pos,true)
        if(enterpos) then
            item = Item(Global.PLAINTEXT,data:sub(pos,enterpos-1))
            table.insert(outitems,item)
            pos = enterpos + 1
        else
            item = Item(Global.PLAINTEXT,data:sub(pos,len))
            table.insert(outitems,item)     
            pos = len       
        end
    end 
end,
parseDataToRawHtmlCo = function(self,data)
    Global:dispmethods("HtmlParse","parseDataToRawHtmlCo")
    local pos = 1
    local len = string.len(data)
    local outputStr = ""
    local item = Item(Global.TITLE,"Sourse Code")
    --print"hello"
    --print(item.type..","..item.text)
    coroutine.yield(item)
    collectgarbage("setstepmul",120)
    while pos < len do
        enterpos = data:find(string.char(10),pos,true)
        if(enterpos) then
            item = Item(Global.PLAINTEXT,data:sub(pos,enterpos-1))
            --print(item.type..","..item.text)
            coroutine.yield(item)
            pos = enterpos + 1
        else
            item = Item(Global.PLAINTEXT,data:sub(pos,len))
            --print(item.type..","..item.text)
            coroutine.yield(item)
            pos = len       
        end
    end 
end,
parseDataCo = function(self,data,imgtgl)
    Global:dispmethods("HtmlParse","parseDataCo")
    local pos = 1
    if type(data) ~= "string" then
        --print(type(data))
        --local item = Item(Global.PLAINTEXT,"not string data...")
        local item = Item(Global.IMAGEFILE,nil,nil,nil,data)
        coroutine.yield(item)
    else
    local len = string.len(data)
    local outputStr = ""
    --print("len="..len)
    local tag = Tag()
    local titlepos,_,innerelements = tag:getSelectedTag(data,pos,"title")
    if titlepos then
        --print(innerelements)
        local item = Item(Global.TITLE,innerelements,param)
        coroutine.yield(item)
    end
    local _,headerendpos,_ = tag:getSelectedTag(data,pos,"head")
    if headerendpos then
        --print(innerelements)
        pos = headerendpos + 1
    end
    while pos < len do
        local tagpos,tagendpos = tag:findNextTagFromString(data,pos)
        if(tagpos ~= nil) then
            if(pos < tagpos) then
                --print(string.sub(data,pos,tagpos-1))
                outputStr = outputStr..string.sub(data,pos,tagpos-1)
            end
            if(tagendpos ~= nil) then
                if(tag.tag:lower() == "a") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    if(endtagpos) then
                        local imgtagpos = tag:getSelectedTag(innerelements,1,"img")
                        if imgtagpos and imgtgl ~= false then
                            for key,value in pairs(tag.param) do
                                param[key] = value
                            end
                            local item = Item(Global.LINKIMAGE,innerelements,param)
                            coroutine.yield(item)
                        else
                            innerelements = string.gsub(innerelements,"%s+"," ")
                            if(innerelements ~= "") then
                                local item = Item(Global.LINKTEXT,innerelements,param)
                                coroutine.yield(item)
                            end
                        end
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "go") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    innerelements = string.gsub(innerelements,"%s+"," ")
                    if(endtagpos and innerelements ~= "") then
                        local taglist = {}
                        taglist = tag:findAllTagFromString(innerelements,1)
                        local item = Item(Global.GO,"Go",param,taglist)
                        coroutine.yield(item)
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "card") then
                    local item = Item(Global.TITLE,tag.param.title,tag.param)
                    --print(outitems)
                    coroutine.yield(item)
                    pos = tagendpos + 1
                    --print(outitems)
                elseif(tag.tag:lower() == "img") then
                    local item = nil
                    if(imgtgl ~= false) then
                        item = Item(Global.IMAGEBOX,"",tag.param)
                    else
                        tag.param.href = tag.param.src
                        item = Item(Global.LINKTEXT,tag.param.src,tag.param)
                    end
                    for key,value in pairs(tag.param) do
                        --print(key..","..value)
                    end
                    coroutine.yield(item)
                    pos = tagendpos + 1
                elseif(tag.tag:lower() == "input") then
                    local item = Item(Global.INPUTBOX,"",tag.param)
                    coroutine.yield(item)
                    pos = tagendpos + 1
                elseif(tag.tag:lower() == "title") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    innerelements = string.gsub(innerelements,"%s+"," ")
                    if(endtagpos) then
                        local item = Item(Global.TITLE,innerelements,param)
                        coroutine.yield(item)
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "script" or tag.tag:lower() == "style") then
                    local param = tag.param
                    local endtagpos,endtagendpos,_ = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    if(endtagpos) then
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "br" or tag.tag:lower() == "br/") then
                    outputStr = self:replaceRefChar(outputStr)
                    if(outputStr~="") then
                        --print(outputStr)
                        local item = Item(Global.PLAINTEXT,outputStr)
                        coroutine.yield(item)
                        outputStr = ""
                    end
                    pos = tagendpos + 1
                else
                    pos = tagendpos + 1
                end
            else
                -- dont closed tag
                pos = len
            end
        else
            -- none tag exists from current position
            --print(pos..","..len)
            outputStr = outputStr..string.sub(data,pos,len)
            outputStr = self:replaceRefChar(outputStr)
            --print(outputStr)
            if(outputStr~="") then
                local item = Item(Global.PLAINTEXT,outputStr)
                coroutine.yield(item)
                outputStr = ""
            end
            --print(outputStr)
            pos = len
        end
    end
    end
    --return outitems
end,
replaceRefChar = function(self,outputStr)
    outputStr = outputStr:gsub("&nbsp;"," ")
    outputStr = outputStr:gsub("&#169;","©")
    outputStr = outputStr:gsub("%s+"," ")
    outputStr = outputStr:gsub("&gt;",">")
    outputStr = outputStr:gsub("&lt;","<")
    outputStr = outputStr:gsub("&nu;","ν")
    outputStr = outputStr:gsub("&darr;","↓")
    outputStr = outputStr:gsub( "&ldquo;" ,"“")
    outputStr = outputStr:gsub("&rdquo;","”")
    outputStr = outputStr:gsub("&omega;","ω")
    outputStr = outputStr:gsub("&acute;","´")
    outputStr = outputStr:gsub("&rarr;","→")
    outputStr = outputStr:gsub("&there4;","∴")
    outputStr = outputStr:gsub("&equiv;","≡")
    outputStr = outputStr:gsub("&hellip;","…")
    return outputStr
end,
parseData = function(self,data,outitems,imgtgl)
    Global:dispmethods("HtmlParse","parseData")
    local pos = 1
    if type(data) ~= "string" then
        --print(type(data))
        --local item = Item(Global.PLAINTEXT,"not string data...")
        local item = Item(Global.IMAGEFILE,nil,nil,nil,data)
        table.insert(outitems,item)
    else
    local len = string.len(data)
    local outputStr = ""
    --print("len="..len)
    local tag = Tag()
    local titlepos,_,innerelements = tag:getSelectedTag(data,pos,"title")
    if titlepos then
        --print(innerelements)
        local item = Item(Global.TITLE,innerelements,param)
        table.insert(outitems,item)
    end
    local _,headerendpos,_ = tag:getSelectedTag(data,pos,"head")
    if headerendpos then
        --print(innerelements)
        pos = headerendpos + 1
    end
    while pos < len do
        local tagpos,tagendpos = tag:findNextTagFromString(data,pos)
        if(tagpos ~= nil) then
            if(pos < tagpos) then
                --print(string.sub(data,pos,tagpos-1))
                outputStr = outputStr..string.sub(data,pos,tagpos-1)
            end
            if(tagendpos ~= nil) then
                if(tag.tag:lower() == "a") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    if(endtagpos) then
                        local imgtagpos = tag:getSelectedTag(innerelements,1,"img")
                        if imgtagpos and imgtgl ~= false then
                            for key,value in pairs(tag.param) do
                                param[key] = value
                            end
                            local item = Item(Global.LINKIMAGE,innerelements,param)
                            table.insert(outitems,item)
                        else
                            innerelements = string.gsub(innerelements,"%s+"," ")
                            if(innerelements ~= "") then
                                local item = Item(Global.LINKTEXT,innerelements,param)
                                table.insert(outitems,item)
                            end
                        end
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "go") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    innerelements = string.gsub(innerelements,"%s+"," ")
                    if(endtagpos and innerelements ~= "") then
                        local taglist = {}
                        taglist = tag:findAllTagFromString(innerelements,1)
                        local item = Item(Global.GO,"Go",param,taglist)
                        table.insert(outitems,item)
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "card") then
                    local item = Item(Global.TITLE,tag.param.title,tag.param)
                    --print(outitems)
                    table.insert(outitems,item)
                    pos = tagendpos + 1
                    --print(outitems)
                elseif(tag.tag:lower() == "img") then
                    local item = nil
                    if(imgtgl ~= false) then
                        item = Item(Global.IMAGEBOX,"",tag.param)
                    else
                        tag.param.href = tag.param.src
                        item = Item(Global.LINKTEXT,tag.param.src,tag.param)
                    end
                    for key,value in pairs(tag.param) do
                        --print(key..","..value)
                    end
                    table.insert(outitems,item)
                    pos = tagendpos + 1
                elseif(tag.tag:lower() == "input") then
                    local item = Item(Global.INPUTBOX,"",tag.param)
                    table.insert(outitems,item)
                    pos = tagendpos + 1
                elseif(tag.tag:lower() == "title") then
                    local param = tag.param
                    local endtagpos,endtagendpos,innerelements = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    innerelements = string.gsub(innerelements,"%s+"," ")
                    if(endtagpos) then
                        local item = Item(Global.TITLE,innerelements,param)
                        table.insert(outitems,item)
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "script") then
                    local param = tag.param
                    local endtagpos,endtagendpos,_ = 
                        tag:findEndTag(data,tagendpos+1,tag.tag)
                    if(endtagpos) then
                        pos = endtagendpos + 1
                    else
                        -- dont closed a link element
                        pos = len
                    end
                elseif(tag.tag:lower() == "br" or tag.tag:lower() == "br/") then
                    outputStr = string.gsub(outputStr,"&nbsp;"," ")
                    outputStr = string.gsub(outputStr,"&#169;","©")
                    outputStr = string.gsub(outputStr,"%s+"," ")
                    if(outputStr~="") then
                        --print(outputStr)
                        local item = Item(Global.PLAINTEXT,outputStr)
                        table.insert(outitems,item)
                        outputStr = ""
                    end
                    pos = tagendpos + 1
                else
                    pos = tagendpos + 1
                end
            else
                -- dont closed tag
                pos = len
            end
        else
            -- none tag exists from current position
            --print(pos..","..len)
            outputStr = outputStr..string.sub(data,pos,len)
            outputStr = string.gsub(outputStr,"&nbsp;"," ")
            outputStr = string.gsub(outputStr,"&#169;","©")
            outputStr = string.gsub(outputStr,"¥s+"," ")
            --print(outputStr)
            if(outputStr~="") then
                local item = Item(Global.PLAINTEXT,outputStr)
                table.insert(outitems,item)
                outputStr = ""
            end
            --print(outputStr)
            pos = len
        end
    end
    end
    --return outitems
end
};
end
]]

HtmlParse = loadstring(strHtmlParse)()
strHtmlParse = nil