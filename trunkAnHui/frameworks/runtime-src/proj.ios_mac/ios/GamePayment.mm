#include "GamePayment.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"


GamePayment *GamePayment::getInstance()
{
	static GamePayment _instance;
	return &_instance;
}

GamePayment::GamePayment()
    :_iapProductScriptHandler(0)
    ,_iapPaymentScriptHandler(0)
    ,_iapRestoreScriptHandler(0)
    ,_iapRestoreFinishScriptHandler(0)
{
}


// 获取商品回调
void GamePayment::iapProduct(IOSProduct *product, int code)
{
    if ( _iapProductScriptHandler  )
    {
        LuaBridge::pushLuaFunctionById(_iapProductScriptHandler);
        LuaStack *stack = LuaBridge::getStack();
        
        stack->pushInt(code);
        
        int numArgs = 1 ;

        if ( product )
        {
            LuaValueDict dict;
            dict["productIdentifier"] = LuaValue::stringValue(product->productIdentifier.c_str());
            dict["localizedTitle"] = LuaValue::stringValue(product->localizedTitle.c_str());
            dict["localizedDescription"] = LuaValue::stringValue(product->localizedDescription.c_str());
            dict["localizedPrice"] = LuaValue::stringValue(product->localizedPrice.c_str());
            dict["isValid"] = LuaValue::booleanValue(product->isValid);
            dict["index"] = LuaValue::intValue(product->index);
            
            stack->pushLuaValueDict(dict);
            
            numArgs = 2;
        }
    
        stack->executeFunction(numArgs);
        
        LuaBridge::releaseLuaFunctionById(_iapProductScriptHandler);
        _iapProductScriptHandler = 0;
    }
}


// 支付结果回调
void GamePayment::iapPayment(bool succeed, const std::string &identifier, int quantity)
{
    if ( _iapPaymentScriptHandler )
    {
        LuaBridge::pushLuaFunctionById(_iapPaymentScriptHandler);
        LuaStack *stack = LuaBridge::getStack();
        
        stack->pushBoolean(succeed);
        stack->pushString(identifier.c_str());
        stack->pushInt(quantity);
        
        stack->executeFunction(3);
        
        LuaBridge::releaseLuaFunctionById(_iapPaymentScriptHandler);
        _iapPaymentScriptHandler = 0;
    }
}

//恢复购买回调（每个商品回调一次）
void GamePayment::iapRestore(const std::string &identifier, int quantity)
{
    if ( _iapRestoreScriptHandler )
    {
        LuaBridge::pushLuaFunctionById(_iapRestoreScriptHandler);
        LuaStack *stack = LuaBridge::getStack();
        
        stack->pushString(identifier.c_str());
        stack->pushInt(quantity);
        
        stack->executeFunction(2);
        
        LuaBridge::releaseLuaFunctionById(_iapRestoreScriptHandler);
        _iapRestoreScriptHandler = 0;
    }
}

// 恢复购买完成回调
void GamePayment::iapRestoreFinish(bool succeed)
{
    if ( _iapRestoreFinishScriptHandler )
    {
        LuaBridge::pushLuaFunctionById(_iapRestoreFinishScriptHandler);
        
        LuaStack *stack = LuaBridge::getStack();
        
        stack->pushBoolean(succeed);
        stack->executeFunction(1);
        
        LuaBridge::releaseLuaFunctionById(_iapRestoreFinishScriptHandler);
        _iapRestoreFinishScriptHandler = 0;
    }
}


// 初始化（获取商品信息）
void GamePayment::req_iap(std::string &identifier,int iapProductScriptHandler)
{
    _iapProductScriptHandler = iapProductScriptHandler ;
    
    iapProductCallback callback = std::bind(&GamePayment::iapProduct,this,std::placeholders::_1,std::placeholders::_2);
    
    _iap.requestProducts(identifier, callback);
}

// 付款
void GamePayment::pay_iap(int quantity,int iapPaymentScriptHandler)
{
    _iapPaymentScriptHandler = iapPaymentScriptHandler ;
    
    iapPaymentCallback callback = std::bind(&GamePayment::iapPayment,this,std::placeholders::_1,std::placeholders::_2,std::placeholders::_3);
    
    _iap.requestPayment(quantity, callback);
}

// 恢复购买
void GamePayment::restore_iap( int iapRestoreScriptHandler, int iapRestoreFinishScriptHandler)
{
    _iapRestoreScriptHandler = iapRestoreScriptHandler ;
    _iapRestoreFinishScriptHandler = iapRestoreFinishScriptHandler ;
    
    iapRestoreCallback restoreCallback = std::bind(&GamePayment::iapRestore,this,std::placeholders::_1,std::placeholders::_2);
    
    iapRestoreFinishCallback finishCallback = std::bind(&GamePayment::iapRestoreFinish,this,std::placeholders::_1);
    
    _iap.requestRestore(restoreCallback, finishCallback);
}


