strMainArea = 
[[
--MainArea--
return 
    function(x,y,w,h,s)
return {
    x = x,
    y = y,
    w = w,
    h = h,
    scrollpos = 0,
    wscrollpos = 0,
    textList = {},
    wmargin = 10,
    hmargin = 10,
    frame = Frame(x, y, x+w, y+h),
    clr = color(255, 255, 255, 255),
    touchpos = nil,
    contentheight = 0,
    contentwidth = 0,
    items = {},
    itemsnameentity = {},
    openurl = nil,
    clickgo = nil,
    targeturl = "",
    targetmethod = "",
    targetparam = {},
    title = "",
    inputting = false,
    focusedItem = nil,
    imageloadnum = 0,
    imageurls = {},
    imageloaded = {},
    imageloading = false,
    loadingimageurl = "",
    scrollbar = ScrollBar(x+w-8,y,8,y+h),
    wscrollbar = WScrollBar(x,0,x+w,8),
    webimgary = WebImageArray(),
    fullscreen = false,
    fullscreenentity = nil,
    websrcary = WebSourceArray(),
    moved = nil,

resetLayout = function(this)
    this.frame:resetFrame(this.x, this.y, this.x+this.w, this.y+this.h)
    this.scrollbar:reset(this.x+this.w-8,this.y,8,this.y+this.h)
    this.wscrollbar:reset(this.x,0,this.x+this.w,8)
end,
draw = function(self)
    --print("mainarea draw")
    -- Codea does not automatically call this method
    --self.frame:gloss(self.clr, 1)
    self.frame:draw(color(255,255,255,255))
        
    pushStyle()
    textWrapWidth(self.w - self.wmargin * 2)
    textMode(CORNER)
    textAlign(LEFT)
    font("Futura-Medium")
    fontSize(20)
    fill(0, 0, 0, 255)
    local offset = 0
    --text("test",0,0)
    for i,v in ipairs(self.items) do
        if v.entity then
            --_,contentheight = textSize(v.text)
            offset = offset + v.entity.h
            local bottom = self.y + self.h - offset - self.hmargin + self.scrollpos
            --if(bottom >= 0 and bottom + v.entity.h < self.y + self.h) then
            v.entity:draw(self.x + self.wmargin + self.wscrollpos,
                         bottom)
            --end
        end
    end
    popStyle()
    self.frame:draw(color(0,0,0,0))
    fill(0, 0, 0, 255)
    strokeWidth(0)
    rect(self.x,self.h-1,self.x+self.w,HEIGHT)
    
    if self.touchpos then
        self.scrollbar:draw()
        self.wscrollbar:draw()
    end
end,
selectBackFullScreenItem = function(self)
    local items = {}
    for i,v in ipairs(self.items) do
        if ((v.type == Global.IMAGEFILE) or
            (v.type == Global.IMAGEBOX)) then
                table.insert(items,v.entity)
        end
    end
    for i,v in ipairs(items) do
        if v.image == self.fullscreenentity.image then
            if i >1 then
                self.fullscreenentity = items[i-1]
            else
                self.fullscreenentity = items[table.maxn(items)]
            end
            break
        end
    end
end,
selectNextFullScreenItem = function(self)
    local items = {}
    for i,v in ipairs(self.items) do
        if ((v.type == Global.IMAGEFILE) or
            (v.type == Global.IMAGEBOX)) then
                table.insert(items,v.entity)
        end
    end
    for i,v in ipairs(items) do
        if v.image == self.fullscreenentity.image then
            if i < table.maxn(items) then
                self.fullscreenentity = items[i+1]
            else
                self.fullscreenentity = items[1]
            end
            break
        end
    end
end,
saveAllImages = function(self)
    local items = {}
    for i,v in ipairs(self.items) do
        if ((v.type == Global.IMAGEFILE) or
            (v.type == Global.IMAGEBOX) or
            (v.type == Global.LINKIMAGE)) and v.entity.image then
                --print(v.entity.name)
                saveImage( "Dropbox:"..v.entity.name,
                           v.entity.image  )
        end
    end
end,
touched = function(self,touch)
    --Global:dispmethods("MainArea","touched")
    -- Codea does not automatically call this method
    if(self.frame:touched(touch)) then
        if touch.state == ENDED then
            self.touchpos = nil
            for i,v in ipairs(self.items) do
                if(v.entity and v.entity:touched(touch) == true) then
                    if(v.type == Global.LINKTEXT) then
                        --print(v.param["href"])
                        if self.targeturl == v.param.href then
                            self:openurl()
                            v.entity.visited = true
                            end
                    elseif(v.type == Global.LINKIMAGE) then
                        --print(v.param["href"])
                        if self.targeturl == v.param.href then
                            self:openurl()
                            v.entity.visited = true
                        end
                    elseif ((v.type == Global.IMAGEFILE) or
                            (v.type == Global.IMAGEBOX)) and not self.moved then
                        if(self.fullscreen == false) then 
                            self.fullscreen = true
                            self.fullscreenentity = v.entity
                        end
                    end
                end
            end
            return true
        elseif touch.state == BEGAN then
            self.touchpos = vec2(touch.x,touch.y)
            for i,v in ipairs(self.items) do
                if(v.entity and v.entity:touched(touch) == true) then
                    if(v.type == Global.LINKTEXT) then
                        --v.entity.visited = true
                        --print(v.param["href"])
                        self.targeturl = v.param.href
                        --self:openurl()
                    elseif(v.type == Global.LINKIMAGE) then
                        --v.entity.visited = true
                        --print(v.param["href"])
                        self.targeturl = v.param.href
                        --self:openurl()
                    elseif (v.type == Global.IMAGEFILE) or
                            (v.type == Global.IMAGEBOX) then
                        self.moved = nil
                    elseif(v.type == Global.INPUTBOX) then
                        v.entity.focused = true
                        self.inputting = true
                        self.focusedItem = v.entity
                    elseif(v.type == Global.GO) then
                        v.entity.visited = true
                        print(v.param.href)
                        print(v.param.method)
                        for key,value in pairs(v.innertaglist) do
                            print(key.."="..value.tag)
                            for key2,value2 in pairs(value.param) do
                                print(" "..key2.."="..value2)
                            end
                        end
                        --print(v.innertag.param.value)
                        --print(v.innertag.param.name)
                        self.targeturl = v.param.href
                        self.targetmethod = v.param.method
                        for key,value in pairs(v.innertaglist) do
                            if self.itemsnameentity[value.param.name]
                            then
                                self.targetparam[value.param.name] =
                            self.itemsnameentity[value.param.name].text
                            else
                                self.targetparam[value.param.name] =
                                    value.param.value
                            end
                        end
                        
            --print(v.innertag.param.name)
            --print(self.itemsnameentity[v.innertagparam.name].text)
                        self:clickgo()
                    end
                else
                    if(v.type == Global.INPUTBOX) then
                        v.entity.focused = false
                        self.inputting = false
                        self.focusedItem = nil
                        hideKeyboard()
                    end
                end
            end
            return true
        elseif touch.state == MOVING then
            if self.touchpos ~= nil then
                self:scroll(touch.y- self.touchpos.y)
                self:wscroll(touch.x- self.touchpos.x)
                self.touchpos = vec2(touch.x,touch.y)
                self.targeturl = nil
                self.moved = true
                return true
            end
            return false
        end
    elseif(self.touchpos ~= nil) then
        if touch.state == BEGAN then
            self.touchpos = vec2(touch.x,touch.y)
            return true
        elseif touch.state == MOVING then
            self:scroll(touch.y-self.touchpos.y)
            self.touchpos = vec2(touch.x,touch.y)
            self.moved = true
            return true
        elseif touch.state == ENDED then
            self.touchpos = nil
            return true
        end        
    end
    
    return false
end,

wscroll = function(self,len)
    --Global:dispmethods("MainArea","wscroll")
    if(self.contentwidth > self.w - self.wmargin) then
        self.wscrollpos = self.wscrollpos + len
        if(self.items[1].type == Global.IMAGEFILE) then
            if(self.wscrollpos < - self.contentwidth + self.w) then 
            self.wscrollpos = - self.contentwidth + self.w end
        elseif(self.wscrollpos < - self.contentwidth) then 
            self.wscrollpos = - self.contentwidth end
        if(self.wscrollpos > 0) then
            self.wscrollpos = 0
        end
    end
    self.wscrollbar:setPos(self.wscrollpos)
end,

scroll = function(self,len)
    --Global:dispmethods("MainArea","scroll")
    if(self.contentheight > self.h - self.hmargin) then
        self.scrollpos = self.scrollpos + len
        if(self.scrollpos < 0) then self.scrollpos = 0 end
        if(self.items[1].type == Global.IMAGEFILE) then
            if(self.scrollpos > self.contentheight - self.h) then 
            self.scrollpos = self.contentheight - self.h end
        elseif(self.scrollpos > self.contentheight) then
            self.scrollpos = self.contentheight 
        end
    end
    self.scrollbar:setPos(self.scrollpos)
end,
goPageBottom = function(self)
    if(self.contentheight > self.h - self.hmargin) then 
        if(self.items[1].type == Global.IMAGEFILE) then
            self.scrollpos = self.contentheight - self.h
        else
            self.scrollpos = self.contentheight - self.h + self.hmargin
        end
    end
end,
goPageTop = function(self)
    if(self.contentheight > self.h - self.hmargin) then self.scrollpos = 0 end
end,
clearItems = function(self)
    self.items = {}
    self.imageloadnum = 0
    self.imageloading = false
    self.imageurls = {}
    self.imageloaded = {}
    self.loadingimageurl = ""
    self.scrollpos = 0
    self.wscrollpos = 0    
end,
addItem = function(self,v)
        if(v.type == Global.PLAINTEXT) then
            v.entity = ItemPlainText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.LINKTEXT) then
            v.entity = ItemLinkText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.GO) then
            v.entity = ItemLinkText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.TITLE) then
            self.title = v.text
        elseif(v.type == Global.INPUTBOX) then
            v.entity = ItemInputBox(v.text,self.w - self.wmargin * 2)
            if v.name then self.itemsnameentity[v.name] = v.entity end
        elseif(v.type == Global.IMAGEFILE) then
            local width = 100
            local height = 100
            v.entity = ItemImageBox(nil,nil,v.data)
            v.entity.name = v.name
        elseif(v.type == Global.IMAGEBOX or
             v.type == Global.LINKIMAGE) then
            local width = 100
            local height = 100
            if v.type == Global.IMAGEBOX then
                v.entity = ItemImageBox(width,height)
            else
                v.entity = ItemLinkImage(width,height)
            end
            local url = v.param.src
            local cache = self.webimgary:getItemByUrl(url)
            local startpos = url:len() - url:reverse():find("/",1) + 2
            v.entity.name = url:sub(startpos)
            if cache then
                v.entity.image = cache.image
                local w,h = spriteSize(cache.image)
                v.entity.w = w
                v.entity.h = h
            else
                table.insert(self.imageurls,url)
                table.insert(self.imageloaded,false)
                if(self.imageloading == false) then
                    if Global.showLoadingImage then
                        print("image loading start..."..url)
                    end
                    self.imageloading = true
                    self.loadingimageurl = url
                    http.get(url,Global.comm.didGetImageData, 
                        Global.comm.didntGetImageData)
                end
            end
        end
    table.insert(self.items,v)
    self:calcContentsArea()
end,
setItemsToEntity = function(self,items,item)
    Global:dispmethods("MainArea","setItemsToEntity")
    if items then self.items = items
    elseif item then
        self.items = {}
        table.insert(self.items,item)
    end
    self.imageloadnum = 0
    self.imageloading = false
    self.imageurls = {}
    self.imageloaded = {}
    self.loadingimageurl = ""
    self.scrollpos = 0
    self.wscrollpos = 0
    for i,v in ipairs(self.items) do
        --print(i..","..v.text)
        if(v.type == Global.PLAINTEXT) then
            v.entity = ItemPlainText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.LINKTEXT) then
            v.entity = ItemLinkText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.GO) then
            v.entity = ItemLinkText(v.text,self.w - self.wmargin * 2)
        elseif(v.type == Global.TITLE) then
            self.title = v.text
        elseif(v.type == Global.INPUTBOX) then
            v.entity = ItemInputBox(v.text,self.w - self.wmargin * 2)
            if v.name then self.itemsnameentity[v.name] = v.entity end
        elseif(v.type == Global.IMAGEFILE) then
            local width = 100
            local height = 100
            v.entity = ItemImageBox(nil,nil,v.data)
            v.entity.name = v.name
        elseif(v.type == Global.IMAGEBOX or
             v.type == Global.LINKIMAGE) then
            local width = 100
            local height = 100
            --if v.type == Global.LINKIMAGE then
                --print(v.param.href)
            --for key,value in pairs(v.param) do
                --print(key..","..value)
            --end
            --end
            --if v.param.width then width = v.param.width end
            --if v.param.height then height = v.param.height end
            if v.type == Global.IMAGEBOX then
                v.entity = ItemImageBox(width,height)
            else
                v.entity = ItemLinkImage(width,height)
            end
            local url = v.param.src
            local cache = self.webimgary:getItemByUrl(url)
            local startpos = url:len() - url:reverse():find("/",1) + 2
            v.entity.name = url:sub(startpos)
            if cache then
                v.entity.image = cache.image
                local w,h = spriteSize(cache.image)
                v.entity.w = w
                v.entity.h = h
            else
                table.insert(self.imageurls,url)
                table.insert(self.imageloaded,false)
                if(self.imageloading == false) then
                    if Global.showLoadingImage then
                        print("image loading start..."..url)
                    end
                    self.imageloading = true
                    self.loadingimageurl = url
                    http.get(url,Global.comm.didGetImageData, 
                        Global.comm.didntGetImageData)
                end
            end
        end
    end
    self:calcContentsArea()
end,

calcContentsArea = function(self)
    local height = 0
    local width1 = 0
    for i,v in ipairs(self.items) do
        if v.entity then
            height = height + tonumber(v.entity.h)
            --print(v.entity.w)
            if width1 < tonumber(v.entity.w) then 
                width1 = tonumber(v.entity.w)
            end 
        end
    end
    self.contentheight = height
    self.contentwidth = width1
    if height < self.h then
        self.scrollbar:calcLength(self.h)
    else
        if(self.items[1].type == Global.IMAGEFILE) then
            self.scrollbar.image = true
        end
        self.scrollbar:calcLength(height)
    end
    if width1 < self.w then
        self.wscrollbar:calcLength(self.w)
    else
        if(self.items[1].type == Global.IMAGEFILE) then
            self.wscrollbar.image = true
        end
        self.wscrollbar:calcLength(width1)
    end
end,
setPos = function(self,pos,wpos)
    if pos then self.scrollpos = pos end
    if wpos then self.wscrollpos = wpos end
end
};
end
]]

MainArea = loadstring(strMainArea)()
strMainArea = nil