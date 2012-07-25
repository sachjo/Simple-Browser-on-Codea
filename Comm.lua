strComm =
[[
--Comm--
return function()
return {
getUrlData = function(url,nocache)
    local cache = Global.mainarea.webimgary:getItemByUrl(url)
    if cache and not nocache then
        local item = Item(Global.IMAGEFILE,nil,nil,nil,cache.image)
        Global.mainarea:setItemsToEntity(nil,item)    
        local pos,wpos = Global.history:getPosByUrl(url)
        Global.mainarea:setPos(pos,wpos)
        Global:setState(Global.Status.LOADED)
    else
        local suffix = url:sub(-4):lower()
        --print(suffix)
        if suffix == ".gif" or suffix == ".png" or suffix == ".jpg" or suffix == "jpeg" then
            http.get(Global.tb.text,Global.comm.didGetImageFile, Global.comm.didntImageFile)
            local startpos = url:len() - url:reverse():find("/",1) + 2
            Global.title.text = url:sub(startpos)
        else
            local cache = Global.mainarea.websrcary:getItemByUrl(url)
            if cache and not nocache then
                Global.comm.didGetData(cache.source,200,nil,true)
            else
                http.get(url,Global.comm.didGetData, Global.comm.didntGetData)
            end
        end
    end
end,
didGetData = function(data,status,headers)
    Global:dispmethods("Global","didGetData")
    local items = {}
    local str = ""
    if headers then
        for key,value in pairs(headers) do
            str = str..key.." : "..value..RETURN
        end
    end
    if(status == 200) then
        --HtmlParse:parseData(data,items)
        --Global:convertSource(str..data)
        Global:convertSource(data)
        if Global.showRawData then print(Global.source) end
        if Global.history:isUrlExistThenGetNo(Global.currenturl) then
            local pos,wpos = Global.history:getPosByUrl(Global.currenturl)
            Global.mainarea:setPos(pos,wpos)
            --print(Global.currenturl..","..pos..","..wpos)
        end            
        local ok,item = coroutine.resume(Global.co,HtmlParse(),Global.source,Global.imageon) 
        if ok and item then 
            --print(item.type..","..(item.text or ""))
            Global.mainarea:addItem(item,Global.imageon) 
        end
        if Global.mainarea.items[1].type == Global.IMAGEFILE then
            Global.mainarea.webimgary:add(Global.tb.text,data)
        else
            Global.mainarea.websrcary:add(Global.tb.text,data)
        end
    elseif(status == 204) then
        Global.source = nil
        local item = Item(1,str)
        Global.mainarea:setItemsToEntity(nil,item)
    else
        print(status)
        Global.source = nil
        local item = Item(1,status..' : '..RETURN..str..data)
        Global.mainarea:setItemsToEntity(nil,item)
    end
    --print(data)
    Global:setState(Global.Status.LOADED)
end,

didntGetData = function(error)
    Global:dispmethods("Global","didntGetData")
    local txt = error
    local item = Item(0,error)
    Global.mainarea:setItemsToEntity(nil,item)
    Global.title.text = "http.get failed"
    Global:setState(Global.Status.LOADED)
end,

didGetImageData = function(data,status,headers)
    Global:dispmethods("Global","didGetImageData")
    local items = {}
    
    if(status == 200) then
        local url = Global.mainarea.loadingimageurl
        local w,h = spriteSize(data)
        --print("Img "..url.." loaded.")
        Global.mainarea.webimgary:add(url,data)
        for i,v in ipairs(Global.mainarea.items) do
            if(v.type == Global.IMAGEBOX or 
                v.type == Global.LINKIMAGE ) and 
                v.param.src == url then
                v.entity.image = data
                v.entity.w = w
                v.entity.h = h
            end
        end
        for i,v in ipairs(Global.mainarea.imageurls) do
            if v == url then
                Global.mainarea.imageloaded[i] = true
                Global.mainarea.imageloadnum = 
                Global.mainarea.imageloadnum + 1
                --print(
                    --Global.mainarea.imageloadnum.."/"..table.maxn(Global.mainarea.imageurls))

            end
        end
        Global.mainarea:calcContentsArea()
    else
    end
    
    if table.maxn(Global.mainarea.imageurls) > 
        Global.mainarea.imageloadnum then
        for i,v in ipairs(Global.mainarea.imageurls) do
            if Global.mainarea.imageloaded[i] == false then
                Global.mainarea.loadingimageurl = v
                break
            end
        end
        http.get(Global.mainarea.loadingimageurl,
            Global.comm.didGetImageData, Global.comm.didntGetImageData)
    else
        Global.mainarea.imageloading = false
    end
end,

didntGetImageData = function(error)
    Global:dispmethods("Global","didntGetImageData")
    local txt = error
        for i,v in ipairs(Global.mainarea.items) do
            if(v.type == Global.IMAGEBOX or v.type == Global.LINKIMAGE ) and 
                v.param.src == Global.mainarea.loadindimageurl then
                v.entity.image = data
                if Global.showLoadingImage then 
                    print("Img "..v.param.src.." was not loaded.")
                    print(
                    Global.mainarea.imageloadnum.."/"..table.maxn(Global.mainarea.imageurls))
                end
            end
        end
end,

didGetImageFile = function(data,status,headers)
    Global:dispmethods("Global","didGetImageFile")
    local items = {}
    if(status == 200) then
        Global.source = nil
        --HtmlParse:parseData(data,items)
        local item = Item(Global.IMAGEFILE,nil,nil,nil,data)
        item.name = Global.tb.text
        Global.mainarea:setItemsToEntity(nil,item)    
        if Global.history:isUrlExistThenGetNo(Global.currenturl) then
            local pos,wpos = Global.history:getPosByIndex()
            Global.mainarea:setPos(pos,wpos)
        end
        Global.mainarea.webimgary:add(Global.tb.text,data)
    else
        Global.source = nil
        local item = Item(0,status..' : '..data)
        Global.mainarea:setItemsToEntity(nil,item)
    end
    --print(data)
    Global:setState(Global.Status.LOADED)
end,

didntGetImageFile = function(error)
    Global:dispmethods("Global","didntGetImageFile")
    local txt = error
    local item = Item(0,error)
    Global.mainarea:setItemsToEntity(nil,item)
    Global.title.text = "http.get failed"
    Global:setState(Global.Status.LOADED)
end,
};
end
]]

Comm = loadstring(strComm)()
strComm = nil