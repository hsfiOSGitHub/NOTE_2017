//
//  HSFGlobal_Config.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/18.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#ifndef HSFGlobal_Config_h
#define HSFGlobal_Config_h


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>  基础配置 ： 颜色 字体大小  >>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#define k_ThemeColor kRGBColor(248, 248, 248) //kRGBColor(110, 110, 110)
#define k_BgViewColor_normal [UIColor whiteColor] //UIColorHex(0xf5f5f5)
#define k_FontColor_normal kRGBColor(42, 42, 42)

#define k_FirstClassFont [UIFont systemFontOfSize:20]  //> 注释
#define k_SecondClassFont [UIFont systemFontOfSize:17]
#define k_ThirdClassFont [UIFont systemFontOfSize:15]
#define k_FourthClassFont [UIFont systemFontOfSize:12]



//>>>>>>>>>>>>>>>>>>>>
//>>>   网络请求     >>>
//>>>>>>>>>>>>>>>>>>>>
/* 请求 域名地址  */
#define kBaseUrl @""
#define kRequestHeaderUrl @"http://schoolps.jzbwlkj.com"
#define kRequsetBasePath @"/api/service/carAdvert?"
#define KIMAGEURLPathHost @"http://192.168.1.20/cupboard/Uploads/"

/* 数据基本key */
#define kRequsetDataKey @"data"
#define kRequsetStateKey @"state"

#define kRequsetCode @"code"
#define kRequsetMessage @"msg"



//>>>>>>>>>>>>>>>>>>>>
//>>>    用户信息    >>>
//>>>>>>>>>>>>>>>>>>>>
#define k_user_uid [kUserDefaults objectForKey:@"user_uid"]
#define k_user_phone [kUserDefaults objectForKey:@"user_phone"]
#define k_user_nickname [kUserDefaults objectForKey:@"user_nickname"]
#define k_user_headsmall [kUserDefaults objectForKey:@"user_headsmall"]
#define k_user_money [kUserDefaults objectForKey:@"user_money"]
#define k_user_gender [kUserDefaults objectForKey:@"user_gender"]
#define k_user_gender_text [kUserDefaults objectForKey:@"user_gender_text"]
#define k_user_stauts [kUserDefaults objectForKey:@"user_stauts"]
#define k_user_stauts_text [kUserDefaults objectForKey:@"user_stauts_text"]
#define k_user_token [kUserDefaults objectForKey:@"user_token"]
#define k_user_pwd [kUserDefaults objectForKey:@"user_pwd"]







//>>>>>>>>>>>>>>>>>>>>
//>>>  第三方平台key >>>
//>>>>>>>>>>>>>>>>>>>>
/* UM */
#define kUMAppKey @""

/* 微信 */
#define kWechatAppKey @""
#define kWechatSecret @""

/* 微博 */
#define kWeiBoAppKey @""
#define kWeiBoSecret @""

/* QQ */
#define kQQAppKey @""

/* JPush */
#define kJpushAppKey @""
#define kJpushSecret @""

/* 支付宝 */
#define kAliPayAppKey @""
#define kAliPaySecret @""
//支付宝私钥（用户自主生成，使用pkcs8格式的私钥）
#define kAlipayPrivateKey  @""
//支付宝公钥
#define kAlipayPublicKey  @""

/* 百度地图 */
#define kBaiDuMapKey @""

/* 高德地图 */
#define kGaoDeMapKey @""


#endif /* HSFGlobal_Config_h */
