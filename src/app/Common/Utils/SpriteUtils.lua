

--SpriteUtils

local m = {}


function m.setSpriteFrameEx(spriteCtl,spriteFrameImg,dataFilename)--dataFilename:xx.plist
    if not spriteCtl then
        return
    end
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFrameImg)
    if frame then
        spriteCtl:setSpriteFrame(frame)
    else
        log("----setSpriteFrame----",spriteCtl,spriteFrameImg,dataFilename)
        
        cc.SpriteFrameCache:getInstance():addSpriteFrames(dataFilename)
        spriteCtl:setSpriteFrame(spriteFrameImg)
    end
end

function m.createSpriteWithSpriteFrameNameEx(spriteFrameImg,dataFilename)--dataFilename:xx.plist
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(spriteFrameImg)
    if not frame then--return cc.Sprite:createWithSpriteFrame(frame)
        log("----createSpriteWithSpriteFrameNameEx----",spriteFrameImg,dataFilename)
        cc.SpriteFrameCache:getInstance():addSpriteFrames(dataFilename)
    end
    return cc.Sprite:createWithSpriteFrameName(spriteFrameImg)
end



return m