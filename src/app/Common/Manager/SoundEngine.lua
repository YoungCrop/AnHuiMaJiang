
local m = class("SoundEngine")

function m:ctor()

	ccexp.AudioEngine:stopAll()
	ccexp.AudioEngine:lazyInit()

	local soundEftPercent = cc.UserDefault:getInstance():getIntegerForKey("Sound_Eft_Percent", 50)
	self.soundEffectVolume = soundEftPercent

	local musicPercent = cc.UserDefault:getInstance():getIntegerForKey("Music_Percent", 50)
	self.musicVolume = musicPercent

	log(string.format("soundEffectVolume:[%f] musicVolume:[%f]", self.soundEffectVolume, self.musicVolume))
end

-- start --
--------------------------------
-- @class function
-- @description 恢复声音播放
-- end --
function m:resumeAllSound()
	ccexp.AudioEngine:resumeAll()
end

-- start --
--------------------------------
-- @class function
-- @description 暂停声音播放
-- end --
function m:pauseAllSound()
	ccexp.AudioEngine:pauseAll()
end

-- start --
--------------------------------
-- @class function
-- @description 设置特效音量
-- @param 音量值0~1
-- end --
function m:setSoundEffectVolume(soundEffectVolume)
	self.soundEffectVolume = soundEffectVolume

	cc.UserDefault:getInstance():setIntegerForKey("Sound_Eft_Percent", soundEffectVolume)
end

function m:getSoundEffectVolume()
	return self.soundEffectVolume
end

-- start --
--------------------------------
-- @class function
-- @description 播放后背景音乐
-- @param musicVolume 音乐音量
-- end --
function m:setMusicVolume(musicVolume)
	self.musicVolume = musicVolume

	if self.musicAudioID then
		ccexp.AudioEngine:setVolume(self.musicAudioID, musicVolume * 0.01)
	end

	cc.UserDefault:getInstance():setIntegerForKey("Music_Percent", musicVolume)
end

function m:getMusicVolume()
	return self.musicVolume
end

-- start --
--------------------------------
-- @class function
-- @description 播放音效
-- @param fileName 音效名称
-- @param isLoop 是否循环
-- @return 音效id
-- end --
function m:playEffect(fileName, isLoop)
	-- 关闭声音并且非循环
	if not fileName or string.len(fileName) == 0 then
		return
	end
	if string.sub(fileName,-4) ~= ".mp3" then
		fileName = fileName .. ".mp3"
	end
	local filePath = string.format("srcRes/sound/%s", fileName)
	isLoop = isLoop or false
	local audioID = ccexp.AudioEngine:play2d(filePath, isLoop, self.soundEffectVolume * 0.01)

	return audioID
end

-- start --
--------------------------------
-- @class function
-- @description 停止audioID音效
-- end --
function m:stopEffect(audioID)
	if not audioID then
		return
	end

	ccexp.AudioEngine:stop(audioID)
end

function m:playVoice(filePath)
	ccexp.AudioEngine:play2d(filePath)
end

-- start --
--------------------------------
-- @class function
-- @description 暂停音效
-- end --
function m:pauseEffect(audioID)
	if not audioID then
		return
	end

	ccexp.AudioEngine:pause(audioID)
end

-- start --
--------------------------------
-- @class function
-- @description 恢复音效
-- end --
function m:resumeEffect(audioID)
	if not audioID then
		return
	end

	ccexp.AudioEngine:resume(audioID)
end

-- start --
--------------------------------
-- @class function
-- @description 播放背景音
-- @param fileName 音效名称
-- @param isLoop 是否循环
-- end --
function m:playMusic(fileName, isLoop)
	if not fileName or string.len(fileName) == 0 then
		return
	end
	isLoop = isLoop or false
	self:stopMusic()
	self.musicAudioID = ccexp.AudioEngine:play2d(string.format("srcRes/sound/%s.mp3", fileName), isLoop, self.musicVolume * 0.01)
end

-- start --
--------------------------------
-- @class function
-- @description 停止播放背景声音
-- end --
function m:stopMusic()
	if not self.musicAudioID then
		return
	end

	ccexp.AudioEngine:stop(self.musicAudioID)
	self.musicAudioID = nil
end

return m