strBookmarkItem = 
[[
--BookmarkItem--
return function(url,name)
return {
    url = url,
    name = name,
};
end
]]

BookmarkItem = loadstring(strBookmarkItem)()
strBookmarkItem = nil