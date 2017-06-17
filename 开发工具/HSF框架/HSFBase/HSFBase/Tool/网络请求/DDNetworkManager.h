//
//
//  DDNetworkManager.h
//  HttpTool
//
//  Created by Qin on 16/6/7.
//  Copyright © 2016年 qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDNetworkObjSingle.h"

typedef void(^RequestSuccessBlock)(id responseObject);

typedef void(^RequestFailureBlock)(id errorObject);

@interface DDNetworkManager : NSObject

DDNetworkObjSingleH;


// 无缓存
+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure;

// 有缓存
+ (void)GETCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure;

+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure;

+ (void)POSTCache:(NSString *)urlString parameters:(NSDictionary *)parameters success:(RequestSuccessBlock)resposeValue failure:(RequestFailureBlock )failure;
+ (void)POSTs:(NSString *)URLString
   parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray *)formDataArray
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;
// 上传图片,可多张上传
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithFormDataArray:(NSArray *)formDataArray
     success:(void (^)( id responseObject))success
     failure:(void (^)( NSError *error))failure;

@end

/*DDNetworkManager使用POST添加文件时使用的文件类*/
@interface FormData : NSObject
/**请求参数名*/
@property (nonatomic, copy, readwrite) NSString *name;
/**保存到服务器的文件名*/
@property (nonatomic, copy, readwrite) NSString *fileName;
/**文件类型*/
@property (nonatomic, copy, readwrite) NSString *mimeType;
/**二进制数据*/
@property (nonatomic, strong, readwrite) NSData *data;

@end


#pragma mark request_sendModel

@interface  DDNetworkManagerDate: NSObject
-(instancetype)initWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 post请求数据成功结果
 */
-(void)post_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure;

/**
 get请求数据成功结果
 */
-(void)get_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure;

/**
 post请求数据成功结果
 */
-(void)postCache_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure;

/**
 get请求数据成功结果
 */
-(void)getCache_RequestFinshSuccess:(RequestSuccessBlock )success failure:(RequestFailureBlock )failure;




#pragma mark- 我的模块接口 
/*
 1.获取验证码
 URL：  /api/api/sendMsg
 参数：  phone（手机号）
 **/
+(instancetype)makeUrlResult_sendMsg_withPhone:(NSString *)phone;

/*
 2.注册
 URL：  /userapi/user/register
 参数：  nickname（用户名）
        phone(手机号) 
        password（密码）
        repassword（确认密码）
        verifyCode（短信验证码）
 **/
+(instancetype)makeUrlResult_register_withNickname:(NSString *)nickname phone:(NSString *)phone password:(NSString *)password repassword:(NSString *)repassword verifyCode:(NSString *)verifyCode;

/*
 3.登录
 URL：  /userapi/user/login
 参数：  type（密码登录方式 ： 传2）
 phone(手机号)
 password（密码）
 **/
+(instancetype)makeUrlResult_login_withType:(NSString *)type phone:(NSString *)phone password:(NSString *)password;

/*
 5.修改昵称
 URL：  /userapi/user/changeName
 参数：  uid（用户id）
 nickname(用户新的昵称)
 token（用户token）
 **/
+(instancetype)makeUrlResult_changeName_withUid:(NSString *)uid nickname:(NSString *)nickname token:(NSString *)token;

/*
 6.我的帐户信息
 URL：  /userapi/user/getPartInfo
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getPartInfo_withToken:(NSString *)token;

/*
 7.修改密码
 URL：  /userapi/user/changePass
 参数：  password（用户新的密码）
 repassword(重复密码)
 token（用户token）
 **/
+(instancetype)makeUrlResult_changePass_withPassword:(NSString *)password repassword:(NSString *)repassword token:(NSString *)token;

/*
 8.找回密码（step 1）
 URL：  /userapi/user/findStep1
 参数：  phone（手机号码）
 verifyCode(验证码)
 **/
+(instancetype)makeUrlResult_findStep1_withPhone:(NSString *)phone verifyCode:(NSString *)verifyCode;

/*
 9.找回密码（step 2）
 URL：  /userapi/user/findStep2
 参数：  phone（手机号码）
 password(用户新的密码)
 repassword(重复密码)
 **/
+(instancetype)makeUrlResult_findStep2_withPhone:(NSString *)phone password:(NSString *)password repassword:(NSString *)repassword;

/*
 10.个人中心
 URL：  /userapi/user/getMyCount
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyCount_withToken:(NSString *)token;

/*
 11.我的钱包
 URL：  /userapi/user/purse
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_purse_withToken:(NSString *)token;

/*
 12.设置支付密码
 URL：  /userapi/user/paypass
 参数：  token（用户token）
 paypass(密码)
 repaypass(重复密码)
 **/
+(instancetype)makeUrlResult_paypass_withToken:(NSString *)token paypass:(NSString *)paypass repaypass:(NSString *)repaypass;

/*
 13.我的红包信息
 URL：  /userapi/user/getMyRedbag
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyRedbag_withToken:(NSString *)token;

/*
 14.我的代金券信息
 URL：  /userapi/user/getMyCoupon
 参数：  token（用户token）
 uid(用户id)
 **/
+(instancetype)makeUrlResult_getMyCoupon_withToken:(NSString *)token uid:(NSString *)uid;

/*
 15.我的收藏信息
 URL：  /userapi/user/getMyCollect
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyCollect_withToken:(NSString *)token;

/*
 16.我的评论接口
 URL：  /userapi/user/getMyComment
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyComment_withToken:(NSString *)token;

/*
 17.获取我的收货地址
 URL：  /userapi/user/getMyAddress
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_getMyAddress_withToken:(NSString *)token;

/*
 18.设为默认地址
 URL：  /userapi/user/setDefault
 参数：  token（用户token）
 addressId(收货地址Id)
 **/
+(instancetype)makeUrlResult_setDefault_withToken:(NSString *)token addressId:(NSString *)addressId;

/*
 19.新增收货地址
 URL：  /userapi/user/address
 参数：  token（用户token）
 consignee(收货人 2-6位)
 sex(性别 1男 0 女)
 mobile(手机号)
 province(省)
 city(市)
 area(县/区)
 address(地址  2-50位)
 **/
+(instancetype)makeUrlResult_address_withToken:(NSString *)token consignee:(NSString *)consignee sex:(NSString *)sex mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address;

/*
 20.处理帮助和反馈
 URL：  /userapi/user/feedback
 参数：  token（用户token）
 uid(用户id)
 content（反馈内容）
 phone（手机号码）
 **/
+(instancetype)makeUrlResult_feedback_withToken:(NSString *)token uid:(NSString *)uid content:(NSString *)content phone:(NSString *)phone;

/*
 21.余额明细
 URL：  /userapi/user/moneyDetail
 参数：  token（用户token）
 **/
+(instancetype)makeUrlResult_moneyDetail_withToken:(NSString *)token;

/*
 22.上传头像/修改
 URL：  /userapi/user/upload
 参数：  token（用户token）
 file（用户头像）
 **/
+(instancetype)makeUrlResult_upload_withToken:(NSString *)token file:(NSString *)file;

/*
 23.添加支付宝账号
 URL：  /userapi/user/alipay_account
 参数：  token（用户token）
 account（支付宝账号）
 **/
+(instancetype)makeUrlResult_alipay_account_withToken:(NSString *)token account:(NSString *)account;

/*
 24.提现接口
 URL：  /userapi/user/cash
 参数：  token（用户token）
 money（提现金额）
 **/
+(instancetype)makeUrlResult_cash_withToken:(NSString *)token money:(NSString *)money;



#pragma mark -首页模块
/*
 1.首页轮播图
 URL：  /userapi/user/getHomeBanner
 参数：  无
 **/
+(instancetype)makeUrlResult_getHomeBanner;

/*
 2.首页分类
 URL：  /userapi/user/TopCategory
 参数：  无
 **/
+(instancetype)makeUrlResult_TopCategory;

/*
 3.获取公告
 URL：  /userapi/user/getBulletin
 参数：  无
 **/
+(instancetype)makeUrlResult_getBulletin;

/*
 4.首页综合部分
 URL：  /userapi/user/getIntegrated
 参数：  无
 **/
+(instancetype)makeUrlResult_getIntegrated;

/*
 4.2.获取综合区域下的商铺
 URL：  /userapi/user/intShop
 参数：  intId（综合区域id）
 **/
+(instancetype)makeUrlResult_intShop_withIntId:(NSString *)intId;

/*
 5.首页商铺列表信息
 URL：  /userapi/user/getHomeShop
 参数：  无
 **/
+(instancetype)makeUrlResult_getHomeShop;

/*
 6.分类页面
 URL：  /userapi/user/category
 参数：  无
 **/
+(instancetype)makeUrlResult_category;

/*
 7.首页的商家智能排序
 URL：  /userapi/user/ordering
 参数：  category（分类id）
 type（排序类型 1：总销量 2：价格从高到底 3：价格从低到高 4：评分）
 **/
+(instancetype)makeUrlResult_ordering_withCategory:(NSString *)category type:(NSString *)type;

/*
 8.商家自送
 URL：  /userapi/user/shopPs
 参数：  self（ ）
 category（分类id（前面未选择分类传0否则传已选的分类id））
 ordertype(排序类型（如未选择排序类型传0 否则1：总销量 2：价格从高到底 3：价格从低到高）)
 **/
+(instancetype)makeUrlResult_shopPs_withSelf:(NSString *)isSelf category:(NSString *)category ordertype:(NSString *)ordertype;

/*
 9.搜索商家或商品的名称
 URL：  /userapi/user/searchShop
 参数：  content（搜索内容 ）
 **/
+(instancetype)makeUrlResult_searchShop_withContent:(NSString *)content;

/*
 10.商家信息
 URL：  /userapi/user/getShopInfo
 参数：  shop_id（商铺id）
 token
 **/
+(instancetype)makeUrlResult_getShopInfo_withShop_id:(NSString *)shop_id token:(NSString *)token;

/*
 11.显示商家热搜
 URL：  /userapi/user/searchPro
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_searchPro_withShop_id:(NSString *)shop_id;

/*
 12.搜索店内商品
 URL：  /userapi/user/searchProduct
 参数：  shop_id（商铺id）
 content(搜索内容)
 **/
+(instancetype)makeUrlResult_searchProduct_withShop_id:(NSString *)shop_id content:(NSString *)content;

/*
 13.获取店铺下所有的商品
 URL：  /userapi/user/productList
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_productList_withShop_id:(NSString *)shop_id;

/*
 14.获取商品详情
 URL：  /userapi/user/getProduct
 参数：  shop_id（商铺id）
 product_id(商品id)
 **/
+(instancetype)makeUrlResult_getProduct_withShop_id:(NSString *)shop_id product_id:(NSString *)product_id;

/*
 15.获取店铺评论
 URL：  /userapi/user/getShopComment
 参数：  shop_id（商铺id）
 type(评论标签  type 1：物美价廉 2：品类齐全 3：送货上门 4：风雨无阻 5：不准时 6货品错误  7:好评 8：中评 9：差评 10：全部)
 status(评论状态 1为只看有内容的评论的)
 **/
+(instancetype)makeUrlResult_getShopComment_withShop_id:(NSString *)shop_id type:(NSString *)type status:(NSString *)status;

/*
 16.获取店铺评分
 URL：  /userapi/user/getShopScore
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_getShopScore_withShop_id:(NSString *)shop_id;

/*
 17.获取店铺评论相应数量
 URL：  /userapi/user/getShopCount
 参数：  shop_id（商铺id）
 **/
+(instancetype)makeUrlResult_getShopCount_withShop_id:(NSString *)shop_id;

/*
 18.评论接口
 URL：  /userapi/user/comment
 参数：  uid（用户id）
 token(用户token)
 shop_id(商铺id)
 shop_score(商品相符评分)
 shop_server(商铺服务评分)
 shop_content(商铺评论内容)
 shop_type(评论标签)
 img(商品图片)
 pid(派送员id)
 ps_score(派送评价)
 ps_server(派送员评价)
 ps_content(派送评价内容)
 **/
+(instancetype)makeUrlResult_comment_withUid:(NSString *)uid token:(NSString *)token shop_id:(NSString *)shop_id shop_score:(NSString *)shop_score shop_server:(NSString *)shop_server shop_content:(NSString *)shop_content shop_type:(NSString *)shop_type img:(NSString *)img pid:(NSString *)pid ps_score:(NSString *)ps_score ps_server:(NSString *)ps_server ps_content:(NSString *)ps_content;

/*
 19.收藏商家
 URL：  /userapi/user/keepShop
 参数：  shop_id（商铺id）
 uid(用户id)
 token(用户token)
 **/
+(instancetype)makeUrlResult_keepShop_withShop_id:(NSString *)shop_id uid:(NSString *)uid token:(NSString *)token;


#pragma mark -订单模块接口
/*
 1.我的订单
 URL：  /userapi/user/obligations
 参数：  token（用户token）
 type(订单类型    待付款：8 已付款：1 待配送：2 已确认：6)
 **/
+(instancetype)makeUrlResult_obligations_withToken:(NSString *)token type:(NSString *)type;

/*
 2.取消订单
 URL：  /userapi/user/cancel
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_cancel_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 3.购物车结算并且生成未付款订单
 URL：  /userapi/user/dealCart
 参数：  token（用户token）
 shop_id(商铺id)
 price(总价)
 arr(数组里面是每件商品对应的价格)
 
 <-- arr 解释 -->
 arr内部数据[
 product_id => 商品id
 product_title =>商品名称
 price =>商品单价
 num => 所购商品数量
 product_attr => 商品属性值(未选择传空)
 option_id => 商品属性id(未选择传空)
	]
 **/
+(instancetype)makeUrlResult_dealCart_withToken:(NSString *)token shop_id:(NSString *)shop_id price:(NSString *)price arr:(NSString *)arr;

/*
 4.确认订单页面
 URL：  /userapi/user/firmOrder
 参数：  token（用户token）
 orderId( 订单id)
 shopId(商铺id)
 **/
+(instancetype)makeUrlResult_firmOrder_withToken:(NSString *)token orderId:(NSString *)orderId shopId:(NSString *)shopId;

/*
 5.点击确认订单的支付按钮
 URL：  /userapi/user/orderPay
 参数：  token（用户token）
 consignee(收货人)
 mobile(手机号)
 province(省)
 city(市)
 area(县)
 address(补充地址)
 orderId(订单id)
 redbag_id(红包id 没有传空)
 coupon_id(优惠卷id 无传空)
 price(折后价，未打折传原价)
 message(备注(0-20字符))
 send_time(送达时间)
 **/
+(instancetype)makeUrlResult_orderPay_withToken:(NSString *)token consignee:(NSString *)consignee mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city area:(NSString *)area address:(NSString *)address orderId:(NSString *)orderId redbag_id:(NSString *)redbag_id coupon_id:(NSString *)coupon_id price:(NSString *)price message:(NSString *)message send_time:(NSString *)send_time;

/*
 6 订单详情--已完成交易流程显示的订单详情
 URL：  /userapi/user/orderDetail
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_orderDetail_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 7 获取订单详情：已付款
 URL：  /userapi/user/orderStatus
 参数：  token（用户token）
 orderId( 订单id)
 uid(用户id)
 **/
+(instancetype)makeUrlResult_orderStatus_withToken:(NSString *)token orderId:(NSString *)orderId uid:(NSString *)uid;

/*
 8 获取订单详情：配送中
 URL：  /userapi/user/orderPs
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_orderPs_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 9 申请退款
 URL：  /userapi/user/refund
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_refund_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 10.确认收货
 URL：  /userapi/user/confirm
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_confirm_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 11.根据经纬度获取距离
 URL：  /userapi/user/location
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_location_withToken:(NSString *)token orderId:(NSString *)orderId;

/*
 12.余额支付
 URL：  /userapi/user/moneypay
 参数：  token（用户token）
 orderId( 订单id)
 **/
+(instancetype)makeUrlResult_moneypay_withToken:(NSString *)token orderId:(NSString *)orderId;




/**
 5.TN
 order_no	订单号
 txnTime	付款时间
 txnAmt  充值金额
 reqReserved
 token
 */
+(instancetype)getTNorder_no:(NSString *)order_no txnTime:(NSString *)txnTime txnAmt:(NSString *)txnAmt token:(NSString *)token type:(NSNumber *)type;



@end

