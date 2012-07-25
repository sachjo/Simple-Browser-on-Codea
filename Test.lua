strTest =
[[
--Test--
return function()
return {
teststr1 = function(self)
    Global:dispmethods("Global","teststr1")
    local parsestr = "<html><head><title>test page</title></head>"
    for i =1,52 do parsestr = parsestr..'<A href="http://www.google.com/">'..i..":"
        for j=1,26 do parsestr = parsestr..j.."," end parsestr = parsestr.."</A><br>" end
    return parsestr
end,

teststr2 = function(self)
    Global:dispmethods("Global","teststr2")
    local parsestr = "<html><head><title>Home</title></head>"
    local bookmark = {  Google = "http://www.google.com/",
                     Wikipedia = "http://ja.wikipedia.org/",
                    erosimple = "http://blog.livedoor.jp/eroanimenogazou/",
                    animegazou = "http://anime-gazou.blogstation.jp/",
                    moekoma ="http://blog.livedoor.jp/moekomasoku/",
                    nijis = "http://nijissoku.livedoor.biz/",
                    kabu = "http://kabumatome.doorblog.jp/",
                    ch = "http://www.2ch.net/",
                    fs = "http://www.peeep.us/39d7a31e",
                    repos = "https://github.com/sachjo/Simple-Browser-on-Codea.git",
                    api = "https://api.github.com/",
                    ebay = "http://www.ebay.com/itm/BIGGEST-COLLECTION-EVER-22-SEGA-NINTENDO-PC-ENGINE-FULLSETS-FACTORY-SEALED-/300736846867#ht_180323wt_714",
                    iosbug = "http://japan.cnet.com/news/service/35019260/"
                    }
    for key,value in pairs(bookmark) do
        parsestr = parsestr..'<A href="'..value..'">'..key.."</A><BR><br>"
    end
    parsestr = parsestr.."TODO:<br>bookmark(hurry)<br>image scaling<br>image save<br>"
    parsestr = parsestr.."redirect URL<BR>sjis<br>"
    parsestr = parsestr.."japanese input<br>form<br>frame<br>css<br>style<br>"
    parsestr = parsestr.."link border<br>offset(mainarea)<br>"
    parsestr = parsestr.."<br>Bug:<br>image link differents"
    return parsestr
end,
showmember = function(self,tablename,indent)
    if not indent then indent = 0 end
    local ind = ""
    for i=1,indent do ind=ind.."___" end
    local str = ""
    local functionlist,numberlist,stringlist,tablelist,otherlist,userdatalist,booleanlist
        = {},{},{},{},{},{},{}
    for key,value in pairs(tablename) do
        if(type(value) == "function") then table.insert(functionlist,key)
        elseif(type(value) == "number") then
            table.insert(numberlist,{name = key,value = value})
        elseif(type(value) == "string") then
            table.insert(stringlist,{name = key,value = value})
        elseif(type(value) == "table" and key ~= "_G" and key ~= "Global") then
            table.insert(tablelist,{name=key,value= self(self,tablename[key],indent+1)})
        elseif(type(value) == "userdata") then table.insert(userdatalist,key)
        elseif(type(value) == "boolean") then 
            table.insert(booleanlist,{name = key,value = value})
        else str = str .. key..","..type(value) .."<br>"
        end
    end

    if #userdatalist > 0 then
        table.sort(userdatalist)
        for i,v in pairs(userdatalist) do str = str.."<br>"..ind..v.."(userdata)" end
        str = str.."<br>"
    end
    if #tablelist > 0 then
        table.sort(tablelist,function(a,b) return (a.name < b.name)end)
        --str = str
        for i,v in pairs(tablelist) do
            str = str.."<br>"..ind..v.name.."="..'{'.." "..v.value..'}'
        end
        --str = str.."<br>"
    end
    if #functionlist > 0 then
        table.sort(functionlist)
        --str = str
        for i,v in pairs(functionlist) do str = str.."<br>"..ind..v.."()" end
        --str = str.."<br>"
    end
    if #stringlist > 0 then
        table.sort(stringlist,function(a,b) return (a.name < b.name)end)
        --str = str.."<br>"..ind
        for i,v in pairs(stringlist) do
            if v.value:len() < 10 then
                str = str.."<br>"..ind..v.name.."="..'"'..v.value..'"'
            else
                str = str.."<br>"..ind..v.name.."="..'"'..v.value:sub(1,10)..'..."'
            end
        end
        --str = str.."<br>"
    end
    if #numberlist > 0 then
        table.sort(numberlist,function(a,b) return (a.name < b.name)end)
        table.sort(numberlist,function(a,b) return (a.value < b.value)end)
        --str = str.."<br>"..ind
        for i,v in pairs(numberlist) do
            str = str.."<br>"..ind..v.name.."="..v.value
        end
        --str = str.."<br>"
    end
    if #booleanlist > 0 then
        table.sort(booleanlist,function(a,b) return (a.name < b.name)end)
        --str = str.."<br>"..ind
        for i,v in pairs(booleanlist) do
            if v.value == true then
                str = str.."<br>"..ind..v.name.."=true"
            else
                str = str.."<br>"..ind..v.name.."=false"
            end
        end
        --str = str.."<br>"
    end
    return str
end
};
end
]]

Test = loadstring(strTest)()
strTest = nil