strGlobal =
[[
--Global--
return {
-- browser status --
Status = {ONTEXT = 1,GETTING = 2,LOADED = 3,TEST = 4,PARSING = 5,INPUTBOX = 6,
        FULLSCR = 7,ONMESSAGE = 8,MENU = 9,FULLSCR_SAVE=10},
StatusName = {"ONTEXT","GETTING","LOADED","TEST","PARSING","INPUTBOX",
            "FULLSCREEN","MESSAGE","MENU","FULLSCREEN_SAVE"},
state = nil,
-- item kind --
PLAINTEXT = 1,LINKTEXT = 2,TITLE = 3,INPUTBOX = 4,GO = 5,IMAGEBOX = 6,LINKIMAGE = 7,IMAGEFILE = 8,
ItemKind = {"PLAINTEXT","LINKTEXT","TITLE","INPUTBOX","GO","IMAGEBOX","LINKIMAGE","IMAGEFILE"},
-- screen components --
tb = nil,textBtn = nil,codeBtn = nil,reBtn = nil,backBtn = nil,nextBtn = nil,homeBtn = nil,
title = nil,ImgOnOffBtn = nil,mainarea = nil,ring = nil,source = nil,home = nil,AddBtn = nil,
MenuBtn = nil,message = nil,menu = nil,
test = nil,comm = nil,
-- url data --
history = nil,currenturl = "",
bookmark= nil,
-- status property --
imageon = true,
--dispMode = STANDARD,
dispMode = FULLSCREEN_NO_BUTTONS,
currentDispWidth = 0,
currentDispHeight = 0,
-- tap property --
tt = nil,
moved = nil,
clickw = nil,
-- debug property --
showmethods = nil, -- true or nil
showmethods_tag = nil,
showState = nil, -- true or nil
showItem = nil,
showRawData = nil,
showUrl = nil,
showLoadingImage = nil,
-- coroutine --
co = nil,

-- methods --
dispmethods = function(self,classname,funcname)
    if self.showmethods then
        if not self.showmethods_tag and classname == "Tag" then return end
        print("Class<"..classname..">:"..funcname)
    end
end,
dispitems = function(self,itemkind,itemtext)
    if self.showItem then
        print("Item:"..Global.ItemKind[itemkind]..',Value="'..itemtext..'"')
    end
end,
init = function(this)
    Global:dispmethods("Global","init")
    displayMode(this.dispMode)
    this.tb = TextBox(100,HEIGHT-30,WIDTH - 220, "http://www.google.com/")
    this.textBtn = TextButton(100,HEIGHT-30,WIDTH - 220, "http://www.google.com/")
    this.codeBtn = TextButton(WIDTH-100,HEIGHT-30,80, "Source")
    this.reBtn = TextButton(10,HEIGHT-30,70, "Reload")
    this.backBtn = TextButton(7,HEIGHT-60,47, "Back")
    this.nextBtn = TextButton(60,HEIGHT-60,47, "Next")
    this.homeBtn = TextButton(115,HEIGHT-60,55, "Home")
    this.title = TextButton(180,HEIGHT-60,WIDTH - 400, "blank")
    this.ImgOnOffBtn = TextButton(WIDTH-100,HEIGHT-60,95, "Image On")
    this.AddBtn = TextButton(WIDTH-140,HEIGHT-60,30," +")
    this.MenuBtn = TextButton(WIDTH-210,HEIGHT-60,55,"Menu")
    this.mainarea = MainArea(0,0,WIDTH, HEIGHT-65,"test")
    this.message = MessageBox("test")
    this.menu = Menu()
    this.menu:addItem("page top",
        function () this.mainarea:goPageTop() 
            Global:setState(Global.Status.LOADED)end)
    this.menu:addItem("page bottom",
        function () this.mainarea:goPageBottom() 
            Global:setState(Global.Status.LOADED)end)
    this.menu:addItem("bookmark",function () this:goBookmark() end)
    this.menu:addItem("history",function () this:goHistory() end)
    this.menu:addItem("show large image list",function () 
        this:goLargeImageList() end)
    this.menu:addItem("save all images",
        function () this.mainarea:saveAllImages() 
            Global.message:setText("Images saved.")
            Global:setState(Global.Status.ONMESSAGE)end)
    this.menu:addItem("toggle displayMode",function() this:toggleDispMode() end)
    this.menu:addItem("clear bookmark",
        function() Global.bookmark:clear()
            if(this.currenturl == "Bookmark:") then 
                Global:goBookmark() end
            Global.message:setText("bookmark cleared.")
            Global:setState(Global.Status.ONMESSAGE)end)
    this.menu:addItem("clear history",
        function() Global.history:clear()
            if(this.currenturl == "History:") then 
                Global:goHistory() end
            Global.message:setText("history cleared.")
            Global:setState(Global.Status.ONMESSAGE)end)
    this.menu:addItem("show global member",function () this:goMember() end)
    this.menu:addItem("open Safari",
        function() openURL(Global.currenturl)
         Global:setState(Global.Status.LOADED)end)
    this.menu:addItem("exit",function() close() end)
    this.history = History()
    this.history:restore()
    this.test = Test()
    this.comm = Comm()
    this.bookmark= Bookmark()
    this.bookmark:restore() 
    
    this.ring = Ring(WIDTH/2,HEIGHT/2)
    this.tb.fontSize = 12
    this.textBtn.fontSize = 12
    this.mainarea.openurl = function () this:clickUrl() end
    this.mainarea.clickgo = function () this:clickGo() end
    this:setState(this.Status.ONTEXT)
    this.home = this.test:teststr2()
    --if(this.history.index>0) then
        --Global:setPage()
    --else
        this.source = this.home
        this:goHome()
    --end
    --print("init end")
end,
resetLayout = function(this)
    this.tb.w = WIDTH - 220
    this.tb.y = HEIGHT-30
    this.textBtn.w = WIDTH - 220
    this.textBtn.y = HEIGHT-30
    this.textBtn:resetFrame()
    this.codeBtn.x = WIDTH - 100
    this.codeBtn.y = HEIGHT-30
    this.codeBtn:resetFrame()
    this.reBtn.y = HEIGHT-30
    this.reBtn:resetFrame()
    this.backBtn.y = HEIGHT-60
    this.backBtn:resetFrame()
    this.nextBtn.y = HEIGHT-60
    this.nextBtn:resetFrame()
    this.homeBtn.y = HEIGHT-60
    this.homeBtn:resetFrame()
    this.title.w = WIDTH - 400
    this.title.y = HEIGHT-60
    this.title:resetFrame()
    this.ImgOnOffBtn.x = WIDTH -100
    this.ImgOnOffBtn.y = HEIGHT-60
    this.ImgOnOffBtn:resetFrame()
    this.AddBtn.x = WIDTH -140
    this.AddBtn.y = HEIGHT-60
    this.AddBtn:resetFrame()
    this.MenuBtn.x = WIDTH -210
    this.MenuBtn.y = HEIGHT-60
    this.MenuBtn:resetFrame()
    this.mainarea.w = WIDTH
    this.mainarea.h = HEIGHT-65
    this.mainarea:resetLayout()
    this.ring.x = WIDTH/2
    this.ring.y = HEIGHT/2
end,
toggleDispMode = function(Global)
    if Global.dispMode ==STANDARD then Global.dispMode = FULLSCREEN
    elseif Global.dispMode ==FULLSCREEN then Global.dispMode = FULLSCREEN_NO_BUTTONS
    else Global.dispMode = STANDARD end
    displayMode(Global.dispMode)
    --Global:resetLayout()
end,
setState = function(Global,state)
    Global.state = state
    if Global.showState then print("State:"..Global.StatusName[Global.state]) end
end,

enterUrl = function(Global)
    Global:dispmethods("Global","enterUrl")
    Global.history:setPos(Global.currenturl,Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    hideKeyboard()
    Global:doUrl(Global.tb.text,true)
end,

reload = function(Global)
    Global:dispmethods("Global","reload")
    if Global.currenturl ~= "" then
        Global:doUrl(Global.currenturl,true)
    end
end,
enterInputBoxText = function(Global)
    Global:dispmethods("Global","enterInputBoxText")
    Global.mainarea.inputting = false
    Global.mainarea.focusedItem.focused = false
    Global.mainarea.focusedItem = nil
    hideKeyboard()
end,

clickUrl = function(Global)
    Global:dispmethods("Global","clickUrl")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    Global:doUrl(HtmlParse():makeUrltoJump(Global.currenturl,
        Global.mainarea.targeturl))
end,
clickGo = function(Global)
    Global:dispmethods("Global","clickGo")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = HtmlParse():makeUrltoJump(Global.currenturl,
        Global.mainarea.targeturl)
    if Global.mainarea.targetmethod == "get" then
        url = url.."?"
        local next = false
        for key,value in pairs( Global.mainarea.targetparam ) do
            if next == true then
                url = url.."&"
            else
                next = true
            end
            url = url..key.."="..value
        end
        url = url:gsub("%s","%%20")
    end
    Global:doUrl(url,true)
end,

viewSource = function(Global)
    Global:dispmethods("Global","viewSource")
    if Global.source then
    Global.mainarea:clearItems()
    Global.co = coroutine.create(HtmlParse().parseDataToRawHtmlCo)
    Global.ring.clr = color(96, 113, 185, 255)
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
    end
end,


setPage = function(Global)
    Global:dispmethods("Global","setPage")
    Global:doUrl(Global.history:getUrlByIndex(),nil,true)
end,
doUrl = function(Global,url,nocache,nohistory)
    Global:setState(Global.Status.GETTING)
    if(url == "Home:") then Global.goHome() return end
    if(url == "History:") then Global:goHistory() return end
    if(url == "Bookmark:") then Global:goBookmark() return end
    if(url == "ImageList:") then Global:goLargeImageList() return end
    Global:setUrl(url)
    if not nohistory then Global.history:add(url,0,0) end
    Global.comm.getUrlData(url,nocache)
end,
goHome = function(Global)
    Global:dispmethods("Global","goHome")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = "Home:"
    Global:convertSource(Global.home)
    Global:setState(Global.Status.LOADED)
    Global:setUrl(url)
end,
goLargeImageList = function(Global)
    Global:dispmethods("Global","goLargeImageList")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = "ImageList:"
    local source = "<html><head><title>Large Image List</title></head>"
    for i,v in ipairs(Global.mainarea.items) do
        if(v.type == Global.LINKIMAGE) then
            local suffix = v.param.href:sub(-4):lower()
            --print(suffix)
            if suffix == ".gif" or suffix == ".png" or suffix == ".jpg" or suffix == "jpeg" then
                source = source..'<img src="'..v.param.href..'">'
            end
        end
    end
    Global:convertSource(source)
    Global:setState(Global.Status.LOADED)
    Global:setUrl(url)
end,
goBookmark = function(Global)
    Global:dispmethods("Global","goBookmark")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = "Bookmark:"
    local source = "<html><head><title>Bookmark</title></head>"
    for i,v in ipairs(Global.bookmark.items) do
        source = source..'<a href="'..v.url..'">'..v.name.."</a><br>"
    end
    Global:convertSource(source)
    Global:setState(Global.Status.LOADED)
    Global:setUrl(url)
end,
goHistory = function(Global)
    Global:dispmethods("Global","goHistory")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = "History:"
    local source = ""
    for i,v in ipairs(Global.history.items) do
        source = '<a href="'..v.url..'">'..v.url.."</a><br>" .. source
    end
    source = "<html><head><title>History</title></head>" .. source
    Global:convertSource(source)
    Global:setState(Global.Status.LOADED)
    Global:setUrl(url)
end,
goMember = function(Global)
    Global:dispmethods("Global","goMember")
    Global.history:setPos(Global.currenturl,
        Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
    local url = "Member:"
    local source = "<html><head><title>Global Member List</title></head>"
    source = source .. Global.test.showmember(Global.test.showmember,_G)
    Global:convertSource(source)
    --print(source)
    Global:setState(Global.Status.LOADED)
    Global:setUrl(url)
end,
convertSource = function(Global,source)
    Global.source = source
    --local items = {}
    --HtmlParse():parseData(Global.source,items)
    --Global.mainarea:setItemsToEntity(items,Global.imageon)
    Global.mainarea:clearItems()
    --print "co start"
    Global.co = coroutine.create(HtmlParse().parseDataCo)
    --print "co started"
    --Global.title.text = Global.mainarea.title
    Global.ring.clr = color(96, 113, 185, 255)
end,
setUrl = function(Global,url)
    Global.textBtn.text = url
    Global.tb.text = url
    Global.currenturl = url
end,
pageNext = function(Global)
    Global:dispmethods("Global","pageNext")
    if Global.history.index > 0 and Global.history.index < Global.history.max then
        if(Global.currenturl ~= "Home:" and Global.currenturl ~= "History:" and 
           Global.currenturl ~= "ImageList:" and 
           Global.currenturl ~= "Bookmark:" ) then 
            Global.history:setPos(Global.currenturl,
                Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
            Global.history:addIndex()
        end
        Global:setPage()
    end
end,

pageBack = function(Global)
    Global:dispmethods("Global","pageBack")
    if Global.history.index > 1 then
        if(Global.currenturl ~= "Home:" and Global.currenturl ~= "History:" and 
           Global.currenturl ~= "ImageList:" and 
           Global.currenturl ~= "Bookmark:" ) then 
            Global.history:setPos(Global.currenturl,
                Global.mainarea.scrollpos,Global.mainarea.wscrollpos)
            Global.history:subIndex()
        end
        Global:setPage()
    end
end,

touched = function(Global,touch)
    if(not Global.tt) then Global.tt = Ttouch(touch) end
    Global.tt.state = touch.state
    --Global:dispmethods("Global","touched")
    if(Global.state == Global.Status.FULLSCR ) then
        if(touch.state == BEGAN)then
            Global.moved = nil
            Global.clickw = touch.x
        elseif(touch.state == MOVING) then Global.moved = true
        elseif(touch.state == ENDED)then
            if(Global.moved) then
                if Global.clickw > touch.x then 
                    Global.mainarea:selectBackFullScreenItem()
                else
                    Global.mainarea:selectNextFullScreenItem()
                end
            else
                Global.mainarea.fullscreen = false
                Global:setState(Global.Status.LOADED)
            end
            return
        end
    end
    if(Global.state == Global.Status.FULLSCR_SAVE and touch.state == ENDED) then
        if(Global.message:touched(touch)) then Global:setState(Global.Status.FULLSCR) end
        return
    end
    if(Global.state == Global.Status.ONMESSAGE and touch.state == BEGAN) then
        if(Global.message:touched(touch)) then Global:setState(Global.Status.LOADED) end
        return
    end
    if(Global.state == Global.Status.MENU and touch.state == BEGAN) then
        if(not Global.menu:touched(touch)) then Global:setState(Global.Status.LOADED) end
        return
    end
    if(Global.state == Global.Status.ONTEXT and Global.textBtn:touched(touch) == false) then
        hideKeyboard()
        Global:setState(Global.Status.LOADED)
    end
    if(Global.state == Global.Status.LOADED and touch.state == BEGAN) then
        if(Global.codeBtn:touched(touch)) then Global:viewSource() end
        if(Global.reBtn:touched(touch)) then Global:reload() end
        if(Global.ImgOnOffBtn:touched(touch)) then 
            if(Global.imageon == true) then Global.ImgOnOffBtn.text = "Image Off"
            else Global.ImgOnOffBtn.text = "Image On"
            end
            Global.imageon = not Global.imageon
        end
        if(Global.backBtn:touched(touch)) then Global:pageBack() end
        if(Global.nextBtn:touched(touch)) then Global:pageNext() end
        if(Global.AddBtn:touched(touch)) then
            if(Global.currenturl ~= "Home:" and Global.currenturl ~= "History:" and 
               Global.currenturl ~= "ImageList:" and 
               Global.currenturl ~= "Bookmark:" ) then 
                Global.bookmark:add(Global.currenturl,Global.title.text)
                Global.message:setText("URL added.")
                Global:setState(Global.Status.ONMESSAGE)
            end
        end
        if(Global.MenuBtn:touched(touch)) then
            Global:setState(Global.Status.MENU)
        end
        if(Global.homeBtn:touched(touch)) then
            if Global.currenturl ~= "Home:" then
                local url = "Home:"
                table.insert(Global.history,url)
                Global.historyindex = table.maxn(Global.history)
                Global:goHome()
            end
        end
    end
    
    if(Global.mainarea:touched(touch) == false) then
        if(Global.textBtn:touched(touch)) then
            Global.tb.text = Global.textBtn.text
            Global:setState(Global.Status.ONTEXT)
        end
    else
        if(Global.mainarea.inputting == true) then Global:setState(Global.Status.INPUTBOX)
        elseif(Global.state == Global.Status.INPUTBOX) then Global:setState(Global.Status.LOADED)
        elseif(Global.mainarea.fullscreen == true and
             Global.state ~= Global.Status.FULLSCR) then 
            Global:setState(Global.Status.FULLSCR)
        end
    end
end,
keyboard = function(Global,key)
    Global:dispmethods("Global","keyboard")
    --print(string.format("%d",key))
    if Global.mainItem == nil and
        Global.tb  ~= nil then
        if key ~= nil then
            --print(string.byte(key))
            if string.byte(key) == 10 then
                if(Global.state == Global.Status.ONTEXT) then
                    Global:setState(Global.Status.GETTING)
                    Global:enterUrl()
                elseif(Global.state == Global.Status.INPUTBOX) then
                    Global:setState(Global.Status.LOADED)
                    Global:enterInputBoxText()
                end
            else 
                if string.byte(key) ~= 44 then -- filter out commas
                    if(Global.state == Global.Status.ONTEXT) then
                        Global.tb:acceptKey(key)
                    elseif(Global.state == Global.Status.INPUTBOX and 
                        Global.mainarea.focusedItem) then
                        Global.mainarea.focusedItem:acceptKey(key)
                    end
                end
            end
        else
        end
    end
end,
draw = function(Global)
    if(Global.currentDispWidth ~= WIDTH or Global.currentDispHeight ~= HEIGHT) then
        Global.currentDispWidth = WIDTH; Global.currentDispHeight = HEIGHT
        Global:resetLayout()
    end
    if Global.co then
        if coroutine.status(Global.co) ~= 'dead' then 
            --print "co run"
            for i = 1,10 do
                local ok,item = 
                    coroutine.resume(Global.co,HtmlParse(),Global.source,Global.imageon) 
                if ok and item then 
                    --print(item.type..","..(item.text or ""))
                    Global.mainarea:addItem(item,Global.imageon) 
                    Global.title.text = Global.mainarea.title
                else
                    break
                end
            end
        else
            Global.ring.clr = color(185, 96, 163, 255)
        end
    end
    pushStyle()
    --print("draw")
    -- This sets a dark background color 
    background(40, 40, 50)
    if(Global.state == Global.Status.FULLSCR) or
        (Global.state == Global.Status.FULLSCR_SAVE) then
        if(Global.state == Global.Status.FULLSCR) then
            if Global.tt then
                if Global.tt.state == BEGAN then
                    Global.tt.timer = Global.tt.timer + 1
                    --print(Global.tt.timer)
                    if Global.tt.timer > 20 then
                        Global:setState(Global.Status.FULLSCR_SAVE)
                        saveImage( "Dropbox:"..Global.mainarea.fullscreenentity.name,
                           Global.mainarea.fullscreenentity.image  )
                        Global.message:setText("Image ".. 
                            Global.mainarea.fullscreenentity.name.." saved.")
                    end
                else
                    Global.tt.timer = 0
                end
            end
        end
        if not Global.mainarea.fullscreenentity.image then return end
        local dispaspect = WIDTH / HEIGHT
        local w,h = spriteSize(Global.mainarea.fullscreenentity.image)
        local imageaspect = w/h
        spriteMode(CENTER)
        if imageaspect > 1 then
            if dispaspect > 1 then
            sprite(Global.mainarea.fullscreenentity.image,
                WIDTH/2,HEIGHT/2,WIDTH,HEIGHT/imageaspect*dispaspect)
            else
            sprite(Global.mainarea.fullscreenentity.image,
                WIDTH/2,HEIGHT/2,WIDTH,HEIGHT/imageaspect*dispaspect)
            end
        else
            if dispaspect > 1 then
            sprite(Global.mainarea.fullscreenentity.image,
                WIDTH/2,HEIGHT/2,WIDTH*imageaspect/dispaspect,HEIGHT)
            else
            sprite(Global.mainarea.fullscreenentity.image,
                WIDTH/2,HEIGHT/2,WIDTH*imageaspect/dispaspect,HEIGHT)
            end
        end
        if (Global.state == Global.Status.FULLSCR_SAVE) then
            fill(0, 0, 0, 156)
            strokeWidth(0)
            rect(0,0,WIDTH,HEIGHT)
            Global.message:draw()
        end
        return
    end
    Global.mainarea:draw()
        
    -- This sets the line thickness
    strokeWidth(5)
    
    -- Do your drawing here
    if(Global.state == Global.Status.GETTING) then Global.ring:draw() end
    if Global.co and coroutine.status(Global.co) ~= 'dead' then Global.ring:draw() end
    if(Global.state ~= Global.Status.ONTEXT) then Global.textBtn:draw() end
    Global.title:draw()
    Global.AddBtn:draw()
    Global.codeBtn:draw()
    Global.reBtn:draw()
    Global.ImgOnOffBtn:draw()
    Global.MenuBtn:draw()
    if(Global.history.index > 1) then
        Global.backBtn.clr = color(255, 255, 255, 255)
    else
        Global.backBtn.clr = color(142, 142, 142, 255)
    end
    Global.backBtn:draw()
    if(Global.history.index > 0 and 
        Global.history.index < Global.history.max) then
        Global.nextBtn.clr = color(255, 255, 255, 255)
    else
        Global.nextBtn.clr = color(142, 142, 142, 255)
    end
    Global.nextBtn:draw()
    Global.homeBtn:draw()
    if(Global.state == Global.Status.ONTEXT) then Global.tb:draw() end
    if(Global.state == Global.Status.ONMESSAGE) then
        fill(0, 0, 0, 156)
        strokeWidth(0)
        rect(0,0,WIDTH,HEIGHT)
        Global.message:draw()
    end
    if(Global.state == Global.Status.MENU) then
        Global.menu:draw()
    end
    if(Global.state == Global.Status.INPUTBOX or
        Global.state == Global.Status.ONTEXT) then showKeyboard() end

    fontSize(6)
    textMode(CENTER)
    text(os.date("%k:%M:%S"),WIDTH/2,HEIGHT-9)
    popStyle()
end,

}
]]


Global = loadstring(strGlobal)()
strGlobal = nil