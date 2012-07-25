strMenu = 
[[
--Menu--
return function()
return {
    items = {},
    w = 0,
addItem = function(this,name,func)
    local item = MenuItem(name,func)
    table.insert(this.items,item)
    local w = textSize(name)
    if this.w < w then this.w = w end
end,
draw = function(this)
    -- Codea does not automatically call this method
    
    strokeWidth(5)
    textMode(CENTER)
    pushStyle()
    fontSize(30)
    rectMode(CORNERS)
    if table.maxn(this.items) == 0 then
        local str = "menu not found"
        local w,h = textSize(str)
        this.w = w + 40
        this.h = h + 20
        stroke(168, 27, 27, 101)
        fill(255, 255, 255, 255)
        rect(WIDTH/2-this.w/2-5, HEIGHT/2-this.h/2,WIDTH/2+this.w/2+5,HEIGHT/2+this.h/2)
        fill(0, 0, 0, 255)
        text(str,WIDTH/2,HEIGHT/2)
    else
        local _,h = textSize("1")
        this.h = h + 20
        stroke(168, 27, 27, 101)
        for i,v in ipairs(this.items) do
            fill(209, 255, 0, 255)
            rect(WIDTH/2-this.w/2-50, 
                 HEIGHT/2-this.h/2-this.h*(i-1)+(table.maxn(this.items)-1)*this.h/2,
                 WIDTH/2+this.w/2+50, 
                 HEIGHT/2+this.h/2-this.h*(i-1)+(table.maxn(this.items)-1)*this.h/2)
            fill(0, 0, 0, 255)
            text(v.name,WIDTH/2,HEIGHT/2-this.h*(i-1)+(table.maxn(this.items)-1)*this.h/2)
        end
    end
    popStyle()
end,
touched = function(this,touch)
    for i,v in ipairs(this.items) do
        if touch.x >= WIDTH/2-this.w/2-50 and touch.x <= WIDTH/2+this.w/2+50 then
            if touch.y >= HEIGHT/2-this.h/2-this.h*(i-1)+(table.maxn(this.items)-1)*this.h/2 and
                touch.y <= HEIGHT/2+this.h/2-this.h*(i-1)+(table.maxn(this.items)-1)*this.h/2 then
                --print(v.name.." clicked")
                v:func()
                return true
            end
        end
    end
    return false
end,
};
end
]]

Menu = loadstring(strMenu)()
strMenu = nil