
--LabelUtils
local m = {}


-- start --
--------------------------------
-- @class function
-- @description 创建ttfLabel
-- @param text 文本内容
-- @param fontSize 字体大小
-- @param font 字体名称
-- @return ttfLabel
-- end --
function m.createTTFLabel(text, fontSize, font)
    text = text or ""
    fontSize = fontSize or 18
    font = font or "fonts/DroidDefault.ttf"

    local ttfConfig = {
        fontFilePath = font,
        fontSize = fontSize,
    }
    local ttfLabel = cc.Label:createWithTTF(ttfConfig, text, cc.TEXT_ALIGNMENT_LEFT)
    ttfLabel:setLineSpacing(8)
    return ttfLabel
end

-- start --
--------------------------------
-- @class function
-- @description 文本描边颜色outline
-- @param ttfLabel 要被设置描边的文本控件
-- @param color cc.c4b颜色
-- @param size int像素Size
-- @return
-- end --
function m.setTTFLabelOutline(ttfLabel, color, size)
    if not ttfLabel then
        return
    end
    color = color or cc.c4b(27, 27, 27, 255)
    size = size or 1

    ttfLabel:enableOutline(color, size)
end

-- start --
--------------------------------
-- @class function
-- @description 文本阴影
-- @param ttfLabel 要被设置阴影的文本控件
-- @param color cc.c4b颜色
-- @param offset Size偏移量cc.size(2, -2)
-- @return
-- end --
function m.setTTFLabelShadow(ttfLabel, color, offset)
    if not ttfLabel then
        return
    end

    ttfLabel:enableShadow(color, offset, 0)
end



return m
