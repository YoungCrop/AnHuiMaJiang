
--SoundMng
local gComm = cc.exports.gComm
local DefineSound = require("app.Common.Config.DefineSound")

local m = {}

function m.playEffect(nameIndex,sex)--1男，非1女
	local index = (sex == 1 and 1 or 2)
	local fileName = DefineSound.SoundOprEnum[nameIndex][index]
	gComm.SoundEngine:playEffect(fileName)
end

function m.playCardEffect(color,value,sex)--1男，非1女
	local index = (sex == 1 and 2 or 3)
    local fileName = DefineSound.TILE_SOUND_EFFECT[color][value][index]
	gComm.SoundEngine:playEffect(fileName)
end

function m.PlayCardSound(sex, color, number)--1男，非1女
	local index = (sex == 1 and 2 or 3)
    local fileName = DefineSound.TILE_SOUND_EFFECT[color][number][index]
	gComm.SoundEngine:playEffect(fileName)
end

function m.PlayCardOut()
	gComm.SoundEngine:playEffect(DefineSound.EffectSound.CardOut)
end

return m
