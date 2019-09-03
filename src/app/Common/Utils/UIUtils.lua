
--UIUtils
local m = {}


function m.screenshot(fileName)
    local size = cc.Director:getInstance():getWinSize()
    local screen = cc.RenderTexture:create(size.width,size.height,cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888,gl.DEPTH24_STENCIL8_OES)
    local scene = cc.Director:getInstance():getRunningScene()
    screen:begin()
    scene:visit()
    screen:endToLua()
    screen:saveToFile(fileName,cc.IMAGE_FORMAT_JPEG,false)


    -- local layerSize = cc.size(display.size.width,display.size.height)
    -- local gl_depth24_stencil8 = 0x88F0
    -- local eFormat = 2
    -- local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height, eFormat, gl_depth24_stencil8)

    -- screenshot:begin()
    -- self.rootNode:visit()
    -- screenshot:endToLua()

    -- local screenshotFileName = string.format("wx-%s.jpg", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
    -- screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_JPEG, false)
end

function m.showLoadingTips(tipsText)
    local runningScene = cc.Director:getInstance():getRunningScene()
    if runningScene then
        local loadingTips = runningScene:getChildByName("LoadingTips")
        if loadingTips then
            loadingTips:setTipsText(tipsText)
            return
        end
    end
    require("app.Game.UI.UICommon.UILoadingTips"):create(tipsText)
end

function m.removeLoadingTips()
    local runningScene = cc.Director:getInstance():getRunningScene()
    if runningScene then
        local loadingTips = runningScene:getChildByName("LoadingTips")
        if loadingTips then
            loadingTips:removeFromParent()
        end
    end
end

local golbalZOrder = 10000000
function m.floatText(content,fontSize,fontColor)
    if not content or content == "" then
        return
    end

    fontColor = fontColor and fontColor or cc.YELLOW
    fontSize = fontSize and fontSize or 30

    local child = cc.Director:getInstance():getRunningScene():getChildByName("floatText")
    if child then 
        child:stopAllActions()
        child:removeFromParent()
    end
    
    local offsetY = 20
    local rootNode = cc.Node:create()
    rootNode:setPosition(cc.p(display.cx, display.cy - offsetY))
    rootNode:setName("floatText")

    local ttfConfig = {}
    ttfConfig.fontFilePath = "fonts/DroidDefault.ttf"
    ttfConfig.fontSize = fontSize
    local ttfLabel = cc.Label:createWithTTF(ttfConfig, content)


    ttfLabel:setGlobalZOrder(golbalZOrder+1)
    ttfLabel:setTextColor(fontColor)
    ttfLabel:setAnchorPoint(cc.p(0.5, 0.5))
    rootNode:addChild(ttfLabel)

    local bg = cc.Scale9Sprite:createWithSpriteFrameName("Image/GComm/comm_bg_float.png")
    local capInsets = cc.size(20, 20)
    local textSize = ttfLabel:getContentSize()

    bg:setScale9Enabled(true)
    bg:setCapInsets(cc.rect(capInsets.width, capInsets.height, 22, 17))

    bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setGlobalZOrder(golbalZOrder)
    rootNode:addChild(bg)

    golbalZOrder = golbalZOrder + 1

    bg:setContentSize(cc.size(capInsets.width*2+textSize.width,capInsets.height*2+textSize.height))

    local action = cc.Sequence:create(
        cc.MoveBy:create(0.8, cc.p(0, 120)),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            rootNode:removeFromParent(true)
        end)
    )
    cc.Director:getInstance():getRunningScene():addChild(rootNode)
    rootNode:runAction(action)
end



-- start --
--------------------------------
-- @class function createCSAnimation
-- @description 创建csb文件编辑的动画
-- @param csbFileName 文件路径名称
-- @return node, action 创建的节点和动画
-- end --
function m.createCSAnimation(csbFileName, isScale)
    local csbNode = cc.CSLoader:createNode(csbFileName)
    local actionTimeline = cc.CSLoader:createTimeline(csbFileName)
    csbNode:runAction(actionTimeline)
    return csbNode, actionTimeline
end

-- start --
--------------------------------
-- @class function seekNodeByName
-- @description 深度遍历查找节点
-- @param rootNode 根节点
-- @param nodeName 查找节点名称
-- @return 查找到的节点
-- end --
function m.seekNodeByName(rootNode, name)
    if not rootNode or not name then
        return nil
    end

    if rootNode:getName() == name then
        return rootNode
    end

    local children = rootNode:getChildren()
    if not children or #children == 0 then
        return nil
    end
    for i, parentNode in ipairs(children) do
        local childNode = m.seekNodeByName(parentNode, name)
        if childNode then
            return childNode
        end
    end

    return nil
end

return m
