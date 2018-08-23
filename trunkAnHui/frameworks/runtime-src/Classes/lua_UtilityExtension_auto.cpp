#include "lua_UtilityExtension_auto.hpp"
#include "UtilityExtension.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_UtilityExtension_UtilityExtension_destroyInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UtilityExtension",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UtilityExtension_UtilityExtension_destroyInstance'", nullptr);
            return 0;
        }
        UtilityExtension::destroyInstance();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UtilityExtension:destroyInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UtilityExtension_UtilityExtension_destroyInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_UtilityExtension_UtilityExtension_generateMD5(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UtilityExtension",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UtilityExtension:generateMD5"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UtilityExtension:generateMD5");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UtilityExtension_UtilityExtension_generateMD5'", nullptr);
            return 0;
        }
        std::string ret = UtilityExtension::generateMD5(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UtilityExtension:generateMD5",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UtilityExtension_UtilityExtension_generateMD5'.",&tolua_err);
#endif
    return 0;
}
int lua_UtilityExtension_UtilityExtension_httpDownloadImage(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UtilityExtension",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "UtilityExtension:httpDownloadImage"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "UtilityExtension:httpDownloadImage");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UtilityExtension_UtilityExtension_httpDownloadImage'", nullptr);
            return 0;
        }
        UtilityExtension::httpDownloadImage(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UtilityExtension:httpDownloadImage",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UtilityExtension_UtilityExtension_httpDownloadImage'.",&tolua_err);
#endif
    return 0;
}
int lua_UtilityExtension_UtilityExtension_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"UtilityExtension",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UtilityExtension_UtilityExtension_getInstance'", nullptr);
            return 0;
        }
        UtilityExtension* ret = UtilityExtension::getInstance();
        object_to_luaval<UtilityExtension>(tolua_S, "UtilityExtension",(UtilityExtension*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "UtilityExtension:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UtilityExtension_UtilityExtension_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_UtilityExtension_UtilityExtension_constructor(lua_State* tolua_S)
{
    int argc = 0;
    UtilityExtension* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UtilityExtension_UtilityExtension_constructor'", nullptr);
            return 0;
        }
        cobj = new UtilityExtension();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"UtilityExtension");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "UtilityExtension:UtilityExtension",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_UtilityExtension_UtilityExtension_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_UtilityExtension_UtilityExtension_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (UtilityExtension)");
    return 0;
}

int lua_register_UtilityExtension_UtilityExtension(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"UtilityExtension");
    tolua_cclass(tolua_S,"UtilityExtension","UtilityExtension","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"UtilityExtension");
        tolua_function(tolua_S,"new",lua_UtilityExtension_UtilityExtension_constructor);
        tolua_function(tolua_S,"destroyInstance", lua_UtilityExtension_UtilityExtension_destroyInstance);
        tolua_function(tolua_S,"generateMD5", lua_UtilityExtension_UtilityExtension_generateMD5);
        tolua_function(tolua_S,"httpDownloadImage", lua_UtilityExtension_UtilityExtension_httpDownloadImage);
        tolua_function(tolua_S,"getInstance", lua_UtilityExtension_UtilityExtension_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(UtilityExtension).name();
    g_luaType[typeName] = "UtilityExtension";
    g_typeCast["UtilityExtension"] = "UtilityExtension";
    return 1;
}
TOLUA_API int register_all_UtilityExtension(lua_State* tolua_S)
{
//	tolua_open(tolua_S);
//	
//	tolua_module(tolua_S,nullptr,0);
//	tolua_beginmodule(tolua_S,nullptr);
//
//	lua_register_UtilityExtension_UtilityExtension(tolua_S);
//
//	tolua_endmodule(tolua_S);
//	return 1;
    
    lua_getglobal(tolua_S, "_G");
    if (lua_istable(tolua_S,-1))//stack:...,_G,
    {
        tolua_open(tolua_S);
        
        tolua_module(tolua_S,"cc",0);
        tolua_beginmodule(tolua_S,"cc");
        
        lua_register_UtilityExtension_UtilityExtension(tolua_S);
        
        tolua_endmodule(tolua_S);
    }
    lua_pop(tolua_S, 1);
    return 1;
}

