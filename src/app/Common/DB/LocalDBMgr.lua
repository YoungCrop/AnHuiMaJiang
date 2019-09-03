
local LocalDBMgr = class( "LocalDBMgr" )
local GameStateDB = require("app.Common.DB.GameStateDB").new() --换成GameStateDB的真实路径


--构造函数
function LocalDBMgr:ctor()
    self:init()
    local function GameStateCallBackHandle(params)
      return params
    end
    GameStateDB:init( GameStateCallBackHandle, "LocalDBMgr")

    local path = GameStateDB:getGameStateDBPath()
    if not io.exists( path ) then
       print("[[ 创建LocalDBMgr ]]")
       GameStateDB:save( self.db )
    else
        self:load()
    end
end

--初始化config表
function LocalDBMgr:init()
  -- FZ_JiangMa0 = 150,       --抚州不奖马
  -- FZ_JiangMa1 = 151,       --抚州奖马1  
  -- FZ_JiangMa2 = 152,       --抚州奖马2
  -- FZ_JiangMa3 = 153,       --抚州奖马3
  -- FZ_JiangMa4 = 154,       --抚州奖马4
  -- FZ_NotFengDing  = 155,   --抚州不封顶
  -- FZ_FengDing21   = 156,   --抚州封顶21炮
  -- FZ_DaiTianDiHu  = 157,   --抚州带天地胡
  -- FZ_GPS          = 158,   --抚州GPS定位，相同IP提示
  -- FZ_Person3      = 159,   --抚州3人
  -- FZ_Person4      = 160,   --抚州4人

     self.db = {
        FZMJ = { --抚州麻将
            JiangMa = 150,
            PersonNum   = 160,
            FengDingVar = 155,
            DaiTianDiHu = 0,--没选
            GPS  = 0,--没选
        }, 
    }
end

--数据存储
function LocalDBMgr:save(_key , _value)
    if not _key or not _value then
        assert( nil, "LocalDBMgr save key or value is nil! ")
        return
    end
    self.db[ _key .. '' ] = _value

    print( "LocalDBMgr save:",_key,_value )
    GameStateDB:save( self.db )
end

--数据读取
function LocalDBMgr:read(_key)
    if not _key then
        assert( nil, "LocalDBMgr read key is nil!" )
        return
    end
    return self.db[ _key .. '' ]
end

--数据加载
function LocalDBMgr:load()
    self:init()--只维护self.db中的数据
    local data = GameStateDB:load().values.values

    
    -- log("-----data--")
    -- dump(data)
    -- log("-----data--end")

    for k,v in pairs(self.db) do
        if data[k] then
           self.db[k] = data[k] --本地数据重置到缓存数据，
        end
    end
    
    -- log("-----self.db--")
    -- dump(self.db)
    -- log("-----self.db--end")
    GameStateDB:save( self.db )
end

return LocalDBMgr