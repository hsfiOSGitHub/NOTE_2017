//
//  GlobalConfig.h
//  HSFKitDemo
//
//  Created by JuZhenBaoiMac on 2017/8/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#ifndef GlobalConfig_h
#define GlobalConfig_h


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>  基础配置 ： 颜色 字体大小  >>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#define k_themeColor kRGBColor(248, 248, 248) //kRGBColor(110, 110, 110)
#define k_bgViewColor_normal [UIColor whiteColor] //UIColorHex(0xf5f5f5)
#define k_fontColor_normal kRGBColor(42, 42, 42)

#define k_fontSize_1Class [UIFont systemFontOfSize:20]  //> 注释
#define k_fontSize_2Class [UIFont systemFontOfSize:17]
#define k_fontSize_3Class [UIFont systemFontOfSize:15]



//>>>>>>>>>>>>>>>>>>>>
//>>>   网络请求     >>>
//>>>>>>>>>>>>>>>>>>>>
/* 请求 域名地址  */
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
//>>>     URL      >>>
//>>>>>>>>>>>>>>>>>>>>
#define kURL_web @"http://lxls.jzbwlkj.com/api/"
#define kURL_local @"http://zhaiwushuo.jzbwlkj.com"



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






#endif /* GlobalConfig_h */
