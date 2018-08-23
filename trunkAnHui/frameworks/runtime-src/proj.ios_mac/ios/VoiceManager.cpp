
#include "VoiceManager.hpp"


VoiceManager* VoiceManager::m_pInstance = NULL;
VoiceManager* VoiceManager::GetInstance()
{
    if(m_pInstance == NULL)
        m_pInstance = new VoiceManager();
    return m_pInstance;
}

VoiceManager::VoiceManager()
{
    YUNurl = "";
    url = "";
    audioTime = "";
}

VoiceManager::~VoiceManager()
{
    
}

void VoiceManager::addListern(unsigned long appid,std::string audioPath,bool isDebug,bool oversea)
{
    
    YVTool::getInstance()->addDownLoadFileListern(this);
    YVTool::getInstance()->addFinishPlayListern(this);
    YVTool::getInstance()->addFinishSpeechListern(this);
    YVTool::getInstance()->addLoginListern(this);
    YVTool::getInstance()->addReConnectListern(this);
    YVTool::getInstance()->addStopRecordListern(this);
    YVTool::getInstance()->addUpLoadFileListern(this);
    YVTool::getInstance()->addRecordVoiceListern(this);
    YVTool::getInstance()->addDownloadVoiceListern(this);
    YVTool::getInstance()->addFlowListern(this);
    
    YVTool::getInstance()->initSDK(appid, audioPath, isDebug, oversea);
    
}


void VoiceManager::onLoginListern(CPLoginResponce* r )
{
    std::string str;
    if (r->result != 0)
    {
        str.append("login Error:");
        str.append(r->msg);
        CCLOG("onLoginListern %s",str.c_str());
    }
    else
    {
        YVTool::getInstance()->setRecord(60, true);
        std::stringstream ss;
        ss << "login succeed" << "UId:";
        ss << r->userid;
        str.append(ss.str());
        CCLOG("onLoginListern %s",str.c_str());
    }

}


void VoiceManager::onReConnectListern(ReconnectionNotify* r)
{
    std::stringstream ss;
    ss << "ReConnect, UI:";
    ss << r->userid;
    CCLOG("onLoginListern %s",ss.str().c_str());
}

void VoiceManager::onStopRecordListern(RecordStopNotify* r)
{
    std::stringstream ss;
    ss << " time:" << r->time << " \npath:" << r->strfilepath;
    
    CCLOG("onStopRecordListern-time = %d \n", r->time);
    char a[32];
    sprintf(a,"%f",( 1.0f* r->time )/1000 );
    audioTime.clear();
    audioTime.append(a);
}

void VoiceManager::onFinishSpeechListern(SpeechStopRespond* r)
{
    std::stringstream ss;

    ss << "<FinishSpeech>" << "\n err_id:" << r->err_id << "\n Erro msg:" << r->err_msg
    << "\n result:" << r->result;
    
    CCLOG("onFinishSpeechListern %s",ss.str().c_str());
}

void VoiceManager::onFinishPlayListern(StartPlayVoiceRespond* r)
{
    std::stringstream ss;
    ss << "<Finish Play>";
    CCLOG("onFinishPlayListern %s",ss.str().c_str());
}

void VoiceManager::onUpLoadFileListern(UpLoadFileRespond* r)
{
    std::stringstream ss;
    ss << "<UpLoad File>" << " result id:" << r->result
    << " erro Msg:" << r->msg << " url:"
    << r->fileurl << " \n percent:" << r->percent;
    if (r->result == 0)
    {
        url.clear();
        url.append(r->fileurl);
        YUNurl.clear();
        YUNurl.append(r->fileurl);
    }
    
    CCLOG("onUpLoadFileListern %s",ss.str().c_str());
}

void VoiceManager::onDownLoadFileListern(DownLoadFileRespond* r)
{
    std::stringstream ss;
    ss << "<DownLoad File>" << " result id:" << r->result
    << "  erro Msg:" << r->msg << " \npath:"
    << r->filename << "\n percent:" << r->percent;
    
    CCLOG("onDownLoadFileListern %s",ss.str().c_str());
}

void VoiceManager::onRecordVoiceListern(RecordVoiceNotify* r)
{
    
}

void VoiceManager::onDownloadVoiceListern(DownloadVoiceRespond* r)
{
    if (r)
    {
        CCLOG("onDownloadVoiceListern percent = %d \n", r->percent);
    }
}

void VoiceManager::onFlowListern(YunvaflowRespond* r)
{
    if (r->result == 0)
    {
        std::stringstream ss;
        ss << "<Flow File>" << " upflow:" << r->upflow
        << "  downflow:" << r->downflow << " \allflow:"
        << r->allflow << "\n";
        CCLOG("onFlowListern %s",ss.str().c_str());
    }
}



void VoiceManager::loginYayayun(std::string userName,std::string userID)
{
    YVTool::getInstance()->cpLogin(userName, userID);
}

void VoiceManager::startRecord(std::string recodePath)
{
    YUNurl.clear();
    YVTool::getInstance()->startRecord(recodePath,2);
}

void VoiceManager::stopRecord()
{
    YVTool::getInstance()->stopRecord();
}

void VoiceManager::playAudio(std::string audioUrl)
{
    YVTool::getInstance()->playRecord(audioUrl, "", "");
}


std::string VoiceManager::getAudioUrl()
{
    if (YUNurl != "")
    {
        //加上时间的拼接
        YUNurl.append("\\");
        YUNurl.append(audioTime);
        return YUNurl;
    }
    return "";
}


void VoiceManager::cancelRecord()
{
    YVTool::getInstance()->stopRecord();
    YUNurl.clear();
    url.clear();
}

