
#ifndef __GAME_PAYMENT_H__
#define __GAME_PAYMENT_H__


#include "cocos2d.h"
USING_NS_CC;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "IOSiAP_Bridge.h"
#else // (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#endif

class GamePayment
{
public:
    static GamePayment *getInstance();
    
protected:
    GamePayment();
    
public:
    
    // 获取商品回调
    void iapProduct(IOSProduct *product, int code);
    
    // 支付结果回调
    void iapPayment(bool succeed, const std::string &identifier, int quantity);
    
    //恢复购买回调（每个商品回调一次）
    void iapRestore(const std::string &identifier, int quantity);
    
    // 恢复购买完成回调
    void iapRestoreFinish(bool succeed);
    
public:

    // 请求商品信息
    void req_iap(std::string &identifier,int iapProductScriptHandler);
    
    // 购买请求
    void pay_iap(int quantity,int iapPaymentScriptHandler);
    
    // 恢复购买
    void restore_iap( int iapRestoreScriptHandler, int iapRestoreFinishScriptHandler);
    
private:
    IOSiAP_Bridge _iap;
    
    int _iapProductScriptHandler;
    
    int _iapPaymentScriptHandler;
    
    int _iapRestoreScriptHandler;
    
    int _iapRestoreFinishScriptHandler;
    
};

#endif

