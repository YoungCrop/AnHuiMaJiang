
#ifndef VoiceManager_hpp
#define VoiceManager_hpp

#include "cocos2d.h"
#include <stdlib.h>
#include <string.h>
#include "YunVaSDK/YVTool.h"
using namespace YVSDK;


class VoiceManager :
    public  YVListern::YVDownLoadFileListern,
    public  YVListern::YVUpLoadFileListern,
    public  YVListern::YVFinishPlayListern,
    public  YVListern::YVFinishSpeechListern,
    public  YVListern::YVStopRecordListern,
    public  YVListern::YVReConnectListern,
    public  YVListern::YVLoginListern,
    public  YVListern::YVRecordVoiceListern,
    public  YVListern::YVDownloadVoiceListern,
    public  YVListern::YVFlowListern
{
    
private:
    std::string url;
    std::string YUNurl;
    std::string audioTime;
    static VoiceManager *m_pInstance;
public:
    VoiceManager();
    virtual ~VoiceManager();
    void addListern(unsigned long appid,std::string audioPath,bool isDebug,bool oversea);//appid 应用appid audioPath文件存储路径，isDebug 游戏上线后一定要切换为 false  oversea false:国内版本
    
    virtual void onLoginListern(CPLoginResponce*) ;
    
    virtual void onReConnectListern(ReconnectionNotify*);
    
    virtual void onStopRecordListern(RecordStopNotify*) ;
    
    virtual void onFinishSpeechListern(SpeechStopRespond*);
    
    virtual void onFinishPlayListern(StartPlayVoiceRespond*);
    
    virtual void onUpLoadFileListern(UpLoadFileRespond*);
    
    virtual void onDownLoadFileListern(DownLoadFileRespond*);
    
    virtual void onRecordVoiceListern(RecordVoiceNotify*);
    
    virtual void onDownloadVoiceListern(DownloadVoiceRespond*);
    virtual void onFlowListern(YunvaflowRespond*);
    
    void loginYayayun(std::string userName,std::string userID);
    
    void startRecord(std::string recodePath);

    void stopRecord();
    
    void playAudio(std::string audioUrl);
    
    std::string getAudioUrl();
    
    void cancelRecord();
    

public:
    static VoiceManager * GetInstance();
    
};

#endif /* VoiceManager_hpp */
