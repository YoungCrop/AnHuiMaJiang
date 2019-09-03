
--DefineTile
local m = {}
----------------top[2]---------------
---------|               |
---------|               |
---------|               |
--left[3]|               |right[1]
---------|               |
---------|               |
---------|               |
---------------bottom[4]--------------

m.Direction = {
    RIGHT   = 1,
    TOP     = 2,
    LEFT    = 3,
    BOTTOM  = 4,
}

-- OperateType操作类型
m.OpeType = {
    CHI       = 1,--吃，3张亮牌
    PENG      = 2,--碰，3张亮牌
    GANG_MING = 3,--明杠，4张亮牌，碰转杠叫补杠，是明杠的一种
    GANG_AN   = 4,--暗杠，4张盖下
    GANG_AN_SHOW = 5,--暗杠结算展示，下面3张盖下，上面1张亮牌
}

m.TILE_BG_GANG = {
--key--{bg1,bg2}
    [m.Direction.RIGHT ] = {"Image/CardsMJNew/tdbgs_1.png", "Image/CardsMJNew/tdbgs_1.png"},
    [m.Direction.TOP   ] = {"Image/CardsMJNew/tdbgs_2.png", "Image/CardsMJNew/tdbgs_2.png"},
    [m.Direction.LEFT  ] = {"Image/CardsMJNew/tdbgs_3.png", "Image/CardsMJNew/tdbgs_3.png"},
    [m.Direction.BOTTOM] = {"Image/CardsMJNew/tdbgs_4.png", "Image/CardsMJNew/tdbgs_4.png"},
}

--包含打出的牌，手中亮的牌堆
m.TILE_BG_OUT_ITEM = {
--key--{bg1,bg2}
    [m.Direction.RIGHT ] = {"Image/CardsMJNew/p1s0_0.png", "Image/CardsMJNew/p1s0_0.png"},
    [m.Direction.TOP   ] = {"Image/CardsMJNew/p2s0_0.png", "Image/CardsMJNew/p2s0_0.png"},
    [m.Direction.LEFT  ] = {"Image/CardsMJNew/p3s0_0.png", "Image/CardsMJNew/p3s0_0.png"},
    [m.Direction.BOTTOM] = {"Image/CardsMJNew/p4s0_0.png", "Image/CardsMJNew/p4s0_0.png"},
}

-- 游戏牌数麻将牌总共144张，分为6大类，分别为：
-- 1：万牌：1，2，3，4，5，6，7，8，9
-- 2：筒牌：1，2，3，4，5，6，7，8，9
-- 3：索牌[条]：1，2，3，4，5，6，7，8，9
-- 4：风牌：东，南，西，北
-- 5：箭牌：中，发，白
-- 6：花牌：春，夏，秋，冬，梅，兰，竹，菊

m.TILE_TYPE = {
    BG    = 0,
    WAN   = 1,
    TONG  = 2,
    TIAO  = 3,
    FENG  = 4,
    JIAN  = 5,
    HUA   = 6,
}

m.TILE_OUT = {
    [m.Direction.RIGHT ] = {
        [m.TILE_TYPE.WAN ] = {
            [1] = {"Image/CardsMJNew/p1s1_1.png",},
            [2] = {"Image/CardsMJNew/p1s1_2.png",},
            [3] = {"Image/CardsMJNew/p1s1_3.png",},
            [4] = {"Image/CardsMJNew/p1s1_4.png",},
            [5] = {"Image/CardsMJNew/p1s1_5.png",},
            [6] = {"Image/CardsMJNew/p1s1_6.png",},
            [7] = {"Image/CardsMJNew/p1s1_7.png",},
            [8] = {"Image/CardsMJNew/p1s1_8.png",},
            [9] = {"Image/CardsMJNew/p1s1_9.png",},
        }, 
        [m.TILE_TYPE.TONG] = {
            [1] = {"Image/CardsMJNew/p1s2_1.png",},
            [2] = {"Image/CardsMJNew/p1s2_2.png",},
            [3] = {"Image/CardsMJNew/p1s2_3.png",},
            [4] = {"Image/CardsMJNew/p1s2_4.png",},
            [5] = {"Image/CardsMJNew/p1s2_5.png",},
            [6] = {"Image/CardsMJNew/p1s2_6.png",},
            [7] = {"Image/CardsMJNew/p1s2_7.png",},
            [8] = {"Image/CardsMJNew/p1s2_8.png",},
            [9] = {"Image/CardsMJNew/p1s2_9.png",},
        },   
        [m.TILE_TYPE.TIAO] = {
            [1] = {"Image/CardsMJNew/p1s3_1.png",},
            [2] = {"Image/CardsMJNew/p1s3_2.png",},
            [3] = {"Image/CardsMJNew/p1s3_3.png",},
            [4] = {"Image/CardsMJNew/p1s3_4.png",},
            [5] = {"Image/CardsMJNew/p1s3_5.png",},
            [6] = {"Image/CardsMJNew/p1s3_6.png",},
            [7] = {"Image/CardsMJNew/p1s3_7.png",},
            [8] = {"Image/CardsMJNew/p1s3_8.png",},
            [9] = {"Image/CardsMJNew/p1s3_9.png",},
        },   
        [m.TILE_TYPE.FENG] = {
            [1] = {"Image/CardsMJNew/p1s4_1.png",},
            [2] = {"Image/CardsMJNew/p1s4_2.png",},
            [3] = {"Image/CardsMJNew/p1s4_3.png",},
            [4] = {"Image/CardsMJNew/p1s4_4.png",},
        },   
        [m.TILE_TYPE.JIAN] = {
            [1] = {"Image/CardsMJNew/p1s5_1.png",},
            [2] = {"Image/CardsMJNew/p1s5_2.png",},
            [3] = {"Image/CardsMJNew/p1s5_3.png",},
            [4] = {"Image/CardsMJNew/p1s5_4.png",},
        },   
        [m.TILE_TYPE.HUA ] = {
            [1] = {"Image/CardsMJNew/p1s6_1.png",},
            [2] = {"Image/CardsMJNew/p1s6_2.png",},
            [3] = {"Image/CardsMJNew/p1s6_3.png",},
            [4] = {"Image/CardsMJNew/p1s6_4.png",},
            [5] = {"Image/CardsMJNew/p1s6_5.png",},
            [6] = {"Image/CardsMJNew/p1s6_6.png",},
            [7] = {"Image/CardsMJNew/p1s6_7.png",},
            [8] = {"Image/CardsMJNew/p1s6_8.png",},
        },
    },
    [m.Direction.TOP   ] = {
        [m.TILE_TYPE.WAN ] = {
            [1] = {"Image/CardsMJNew/p2s1_1.png",},
            [2] = {"Image/CardsMJNew/p2s1_2.png",},
            [3] = {"Image/CardsMJNew/p2s1_3.png",},
            [4] = {"Image/CardsMJNew/p2s1_4.png",},
            [5] = {"Image/CardsMJNew/p2s1_5.png",},
            [6] = {"Image/CardsMJNew/p2s1_6.png",},
            [7] = {"Image/CardsMJNew/p2s1_7.png",},
            [8] = {"Image/CardsMJNew/p2s1_8.png",},
            [9] = {"Image/CardsMJNew/p2s1_9.png",},
        }, 
        [m.TILE_TYPE.TONG] = {
            [1] = {"Image/CardsMJNew/p2s2_1.png",},
            [2] = {"Image/CardsMJNew/p2s2_2.png",},
            [3] = {"Image/CardsMJNew/p2s2_3.png",},
            [4] = {"Image/CardsMJNew/p2s2_4.png",},
            [5] = {"Image/CardsMJNew/p2s2_5.png",},
            [6] = {"Image/CardsMJNew/p2s2_6.png",},
            [7] = {"Image/CardsMJNew/p2s2_7.png",},
            [8] = {"Image/CardsMJNew/p2s2_8.png",},
            [9] = {"Image/CardsMJNew/p2s2_9.png",},
        },   
        [m.TILE_TYPE.TIAO] = {
            [1] = {"Image/CardsMJNew/p2s3_1.png",},
            [2] = {"Image/CardsMJNew/p2s3_2.png",},
            [3] = {"Image/CardsMJNew/p2s3_3.png",},
            [4] = {"Image/CardsMJNew/p2s3_4.png",},
            [5] = {"Image/CardsMJNew/p2s3_5.png",},
            [6] = {"Image/CardsMJNew/p2s3_6.png",},
            [7] = {"Image/CardsMJNew/p2s3_7.png",},
            [8] = {"Image/CardsMJNew/p2s3_8.png",},
            [9] = {"Image/CardsMJNew/p2s3_9.png",},
        },   
        [m.TILE_TYPE.FENG] = {
            [1] = {"Image/CardsMJNew/p2s4_1.png",},
            [2] = {"Image/CardsMJNew/p2s4_2.png",},
            [3] = {"Image/CardsMJNew/p2s4_3.png",},
            [4] = {"Image/CardsMJNew/p2s4_4.png",},
        },   
        [m.TILE_TYPE.JIAN] = {
            [1] = {"Image/CardsMJNew/p2s5_1.png",},
            [2] = {"Image/CardsMJNew/p2s5_2.png",},
            [3] = {"Image/CardsMJNew/p2s5_3.png",},
            [4] = {"Image/CardsMJNew/p2s5_4.png",},
        },   
        [m.TILE_TYPE.HUA ] = {
            [1] = {"Image/CardsMJNew/p2s6_1.png",},
            [2] = {"Image/CardsMJNew/p2s6_2.png",},
            [3] = {"Image/CardsMJNew/p2s6_3.png",},
            [4] = {"Image/CardsMJNew/p2s6_4.png",},
            [5] = {"Image/CardsMJNew/p2s6_5.png",},
            [6] = {"Image/CardsMJNew/p2s6_6.png",},
            [7] = {"Image/CardsMJNew/p2s6_7.png",},
            [8] = {"Image/CardsMJNew/p2s6_8.png",},
        },
    },
    [m.Direction.LEFT  ] = {
        [m.TILE_TYPE.WAN ] = {
            [1] = {"Image/CardsMJNew/p3s1_1.png",},
            [2] = {"Image/CardsMJNew/p3s1_2.png",},
            [3] = {"Image/CardsMJNew/p3s1_3.png",},
            [4] = {"Image/CardsMJNew/p3s1_4.png",},
            [5] = {"Image/CardsMJNew/p3s1_5.png",},
            [6] = {"Image/CardsMJNew/p3s1_6.png",},
            [7] = {"Image/CardsMJNew/p3s1_7.png",},
            [8] = {"Image/CardsMJNew/p3s1_8.png",},
            [9] = {"Image/CardsMJNew/p3s1_9.png",},
        }, 
        [m.TILE_TYPE.TONG] = {
            [1] = {"Image/CardsMJNew/p3s2_1.png",},
            [2] = {"Image/CardsMJNew/p3s2_2.png",},
            [3] = {"Image/CardsMJNew/p3s2_3.png",},
            [4] = {"Image/CardsMJNew/p3s2_4.png",},
            [5] = {"Image/CardsMJNew/p3s2_5.png",},
            [6] = {"Image/CardsMJNew/p3s2_6.png",},
            [7] = {"Image/CardsMJNew/p3s2_7.png",},
            [8] = {"Image/CardsMJNew/p3s2_8.png",},
            [9] = {"Image/CardsMJNew/p3s2_9.png",},
        },   
        [m.TILE_TYPE.TIAO] = {
            [1] = {"Image/CardsMJNew/p3s3_1.png",},
            [2] = {"Image/CardsMJNew/p3s3_2.png",},
            [3] = {"Image/CardsMJNew/p3s3_3.png",},
            [4] = {"Image/CardsMJNew/p3s3_4.png",},
            [5] = {"Image/CardsMJNew/p3s3_5.png",},
            [6] = {"Image/CardsMJNew/p3s3_6.png",},
            [7] = {"Image/CardsMJNew/p3s3_7.png",},
            [8] = {"Image/CardsMJNew/p3s3_8.png",},
            [9] = {"Image/CardsMJNew/p3s3_9.png",},
        },   
        [m.TILE_TYPE.FENG] = {
            [1] = {"Image/CardsMJNew/p3s4_1.png",},
            [2] = {"Image/CardsMJNew/p3s4_2.png",},
            [3] = {"Image/CardsMJNew/p3s4_3.png",},
            [4] = {"Image/CardsMJNew/p3s4_4.png",},
        },   
        [m.TILE_TYPE.JIAN] = {
            [1] = {"Image/CardsMJNew/p3s5_1.png",},
            [2] = {"Image/CardsMJNew/p3s5_2.png",},
            [3] = {"Image/CardsMJNew/p3s5_3.png",},
            [4] = {"Image/CardsMJNew/p3s5_4.png",},
        },   
        [m.TILE_TYPE.HUA ] = {
            [1] = {"Image/CardsMJNew/p3s6_1.png",},
            [2] = {"Image/CardsMJNew/p3s6_2.png",},
            [3] = {"Image/CardsMJNew/p3s6_3.png",},
            [4] = {"Image/CardsMJNew/p3s6_4.png",},
            [5] = {"Image/CardsMJNew/p3s6_5.png",},
            [6] = {"Image/CardsMJNew/p3s6_6.png",},
            [7] = {"Image/CardsMJNew/p3s6_7.png",},
            [8] = {"Image/CardsMJNew/p3s6_8.png",},
        },
    },
    [m.Direction.BOTTOM] = {
        [m.TILE_TYPE.BG  ] = {
            [0] = {"Image/CardsMJNew/p4s0_0.png",},
        },
        [m.TILE_TYPE.WAN ] = {
            [1] = {"Image/CardsMJNew/p4s1_1.png",},
            [2] = {"Image/CardsMJNew/p4s1_2.png",},
            [3] = {"Image/CardsMJNew/p4s1_3.png",},
            [4] = {"Image/CardsMJNew/p4s1_4.png",},
            [5] = {"Image/CardsMJNew/p4s1_5.png",},
            [6] = {"Image/CardsMJNew/p4s1_6.png",},
            [7] = {"Image/CardsMJNew/p4s1_7.png",},
            [8] = {"Image/CardsMJNew/p4s1_8.png",},
            [9] = {"Image/CardsMJNew/p4s1_9.png",},
        }, 
        [m.TILE_TYPE.TONG] = {
            [1] = {"Image/CardsMJNew/p4s2_1.png",},
            [2] = {"Image/CardsMJNew/p4s2_2.png",},
            [3] = {"Image/CardsMJNew/p4s2_3.png",},
            [4] = {"Image/CardsMJNew/p4s2_4.png",},
            [5] = {"Image/CardsMJNew/p4s2_5.png",},
            [6] = {"Image/CardsMJNew/p4s2_6.png",},
            [7] = {"Image/CardsMJNew/p4s2_7.png",},
            [8] = {"Image/CardsMJNew/p4s2_8.png",},
            [9] = {"Image/CardsMJNew/p4s2_9.png",},
        },   
        [m.TILE_TYPE.TIAO] = {
            [1] = {"Image/CardsMJNew/p4s3_1.png",},
            [2] = {"Image/CardsMJNew/p4s3_2.png",},
            [3] = {"Image/CardsMJNew/p4s3_3.png",},
            [4] = {"Image/CardsMJNew/p4s3_4.png",},
            [5] = {"Image/CardsMJNew/p4s3_5.png",},
            [6] = {"Image/CardsMJNew/p4s3_6.png",},
            [7] = {"Image/CardsMJNew/p4s3_7.png",},
            [8] = {"Image/CardsMJNew/p4s3_8.png",},
            [9] = {"Image/CardsMJNew/p4s3_9.png",},
        },   
        [m.TILE_TYPE.FENG] = {
            [1] = {"Image/CardsMJNew/p4s4_1.png",},
            [2] = {"Image/CardsMJNew/p4s4_2.png",},
            [3] = {"Image/CardsMJNew/p4s4_3.png",},
            [4] = {"Image/CardsMJNew/p4s4_4.png",},
        },   
        [m.TILE_TYPE.JIAN] = {
            [1] = {"Image/CardsMJNew/p4s5_1.png",},
            [2] = {"Image/CardsMJNew/p4s5_2.png",},
            [3] = {"Image/CardsMJNew/p4s5_3.png",},
            [4] = {"Image/CardsMJNew/p4s5_4.png",},
        },   
        [m.TILE_TYPE.HUA ] = {
            [1] = {"Image/CardsMJNew/p4s6_1.png",},
            [2] = {"Image/CardsMJNew/p4s6_2.png",},
            [3] = {"Image/CardsMJNew/p4s6_3.png",},
            [4] = {"Image/CardsMJNew/p4s6_4.png",},
            [5] = {"Image/CardsMJNew/p4s6_5.png",},
            [6] = {"Image/CardsMJNew/p4s6_6.png",},
            [7] = {"Image/CardsMJNew/p4s6_7.png",},
            [8] = {"Image/CardsMJNew/p4s6_8.png",},
        },
    },
}

m.TILE_STAND = {
    [m.Direction.RIGHT ] = {"Image/CardsMJNew/tbgs_1.png", "Image/CardsMJNew/tbgs_1.png"},
    [m.Direction.TOP   ] = {"Image/CardsMJNew/tbgs_2.png", "Image/CardsMJNew/tbgs_2.png"},
    [m.Direction.LEFT  ] = {"Image/CardsMJNew/tbgs_3.png", "Image/CardsMJNew/tbgs_3.png"},
    [m.Direction.BOTTOM] = {
        [m.TILE_TYPE.WAN ] = {
            [1] = {"Image/CardsMJNew/p4b1_1.png",},
            [2] = {"Image/CardsMJNew/p4b1_2.png",},
            [3] = {"Image/CardsMJNew/p4b1_3.png",},
            [4] = {"Image/CardsMJNew/p4b1_4.png",},
            [5] = {"Image/CardsMJNew/p4b1_5.png",},
            [6] = {"Image/CardsMJNew/p4b1_6.png",},
            [7] = {"Image/CardsMJNew/p4b1_7.png",},
            [8] = {"Image/CardsMJNew/p4b1_8.png",},
            [9] = {"Image/CardsMJNew/p4b1_9.png",},
        }, 
        [m.TILE_TYPE.TONG] = {
            [1] = {"Image/CardsMJNew/p4b2_1.png",},
            [2] = {"Image/CardsMJNew/p4b2_2.png",},
            [3] = {"Image/CardsMJNew/p4b2_3.png",},
            [4] = {"Image/CardsMJNew/p4b2_4.png",},
            [5] = {"Image/CardsMJNew/p4b2_5.png",},
            [6] = {"Image/CardsMJNew/p4b2_6.png",},
            [7] = {"Image/CardsMJNew/p4b2_7.png",},
            [8] = {"Image/CardsMJNew/p4b2_8.png",},
            [9] = {"Image/CardsMJNew/p4b2_9.png",},
        },   
        [m.TILE_TYPE.TIAO] = {
            [1] = {"Image/CardsMJNew/p4b3_1.png",},
            [2] = {"Image/CardsMJNew/p4b3_2.png",},
            [3] = {"Image/CardsMJNew/p4b3_3.png",},
            [4] = {"Image/CardsMJNew/p4b3_4.png",},
            [5] = {"Image/CardsMJNew/p4b3_5.png",},
            [6] = {"Image/CardsMJNew/p4b3_6.png",},
            [7] = {"Image/CardsMJNew/p4b3_7.png",},
            [8] = {"Image/CardsMJNew/p4b3_8.png",},
            [9] = {"Image/CardsMJNew/p4b3_9.png",},
        },   
        [m.TILE_TYPE.FENG] = {
            [1] = {"Image/CardsMJNew/p4b4_1.png",},
            [2] = {"Image/CardsMJNew/p4b4_2.png",},
            [3] = {"Image/CardsMJNew/p4b4_3.png",},
            [4] = {"Image/CardsMJNew/p4b4_4.png",},
        },   
        [m.TILE_TYPE.JIAN] = {
            [1] = {"Image/CardsMJNew/p4b5_1.png",},
            [2] = {"Image/CardsMJNew/p4b5_2.png",},
            [3] = {"Image/CardsMJNew/p4b5_3.png",},
            [4] = {"Image/CardsMJNew/p4b5_4.png",},
        },   
        [m.TILE_TYPE.HUA ] = {
            [1] = {"Image/CardsMJNew/p4b6_1.png",},
            [2] = {"Image/CardsMJNew/p4b6_2.png",},
            [3] = {"Image/CardsMJNew/p4b6_3.png",},
            [4] = {"Image/CardsMJNew/p4b6_4.png",},
            [5] = {"Image/CardsMJNew/p4b6_5.png",},
            [6] = {"Image/CardsMJNew/p4b6_6.png",},
            [7] = {"Image/CardsMJNew/p4b6_7.png",},
            [8] = {"Image/CardsMJNew/p4b6_8.png",},
        },
    },
}

m.getTileBGGang = function(uiPos)
    local selectTileBGIndex = 1
    return m.TILE_BG_GANG[uiPos][selectTileBGIndex]
end

m.getBottomOpenTile = function(_color,_value)
    local selectTileIndex = 1
    return m.TILE_OUT[m.Direction.BOTTOM][_color][_value][selectTileIndex]
end

m.getOpenTile = function(uiPos,_color,_value)
    local selectTileIndex = 1
    return m.TILE_OUT[uiPos][_color][_value][selectTileIndex]
end

m.getTileStandBG = function(uiPos)
    local selectTileBGIndex = 1
    return m.TILE_STAND[uiPos][selectTileBGIndex]
end


return m