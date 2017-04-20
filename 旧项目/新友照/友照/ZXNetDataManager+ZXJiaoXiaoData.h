//
//  ZXNetDataManager+ZXJiaoXiaoData.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXNetDataManager.h"

@interface ZXNetDataManager (ZXJiaoXiaoData)

//注册 
- (void)zhuCeDataWithPhone:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code andRndstring:(NSString *)rndstring andSourcePhone:(NSString *)sourcePhone success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//获取验证码
- (void)getYanZhengMaDataWithPhone:(NSString *)phone andType:(NSString *)type andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//找回密码
- (void)chongZhiMiMaDataWithPhone:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//登录
- (void)loginDataWithPhone:(NSString *)phone andPassword:(NSString *)password andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//查看学员信息
- (void)chaKanXueYuanXinXiDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//退出登录
- (void)logoutDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//请求轮播图数据
-(void)qingqiulunboushujusuccess:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock;

//主页科目二购买模拟卡详情
- (void)gouMaiMoNiKaDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString*)erid andCardid:(NSString*)cardid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//主页科目二和科目三购买课时卡详情 
- (void)gouMaiKeShiKaDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andGoods_type:(NSString *)goods_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科二买模拟卡考场列表
- (void)gouMaiMoNiKaKaoChangListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//购买学时卡和模拟卡提交订单
- (void)tiJiaoDingDanDataWithRndstring:(NSString *)rndstring andId:(NSString *)productId andIdent_code:(NSString *)ident_code andGoods_type:(NSString *)goods_type andNum:(NSString *)num andDiscount_id:(NSString *)discount_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科三模拟提交订单
- (void)keSanTiJiaoDingDanDataWithRndstring:(NSString *)rndstring andId:(NSString *)productId andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andNum:(NSString *)num success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科二模拟考场列表
-(void)keErYuYueMoNiKaoChangListDataRndstring:(NSString *)rndstring andPage:(NSString *)page  andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科二预约模拟排队详情
- (void)keErYuYueMoNiPaiDuiDetaiDatalWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid andMoni_time:(NSString*)moni_time andStid:(NSString *)stid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//我的卡券列表
- (void)myCardListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科二卡券去排队
- (void)keErKaQuanPaiDuiDataWithaRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid  andDate:(NSString*)date andCouids:(NSString *)couids success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//确认上车信息 
-(void)shangCheXinXiYanZhengDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andercode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//取消排队 
- (void)quXiaoPaiDuiDataWitnRndstring:(NSString *)rndstring andIdentCode:(NSString *)ident_code andid:(NSString*)pid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科三模拟列表
- (void)KeSanMoNiWithTimeStamp:(NSString *)timeStamp andClassify:(NSString *)classify andOrder:(NSString *)order success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//确定支付(支付宝）(测试)
- (void)confirmZFBPayDataWithOrder_id:(NSString *)order_id andRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andPay_type:(NSString *)pay_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//确定支付（微信）
- (void)confirmWXPayDataWithOrder_id:(NSString *)order_id andRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andPayType:(NSString *)pay_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//订单详情
- (void)dingDanDetailWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//我的合同 
-(void)getWoDeHeTongDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock;

//意见反馈
- (void)yongHuFanKuiWithRndstring:(NSString *)rndstring andPhone:(NSString *)phone andContent:(NSString *)content success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//课程列表
- (void)myClassListWithRndstring:(NSString *)rndstring anddate:(NSString *)date andtid:(NSString *)tid  andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//课程余额 
- (void)keChengYuEDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andsubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//预约课程  
- (void)yuYueKeChengDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andTcpid:(NSString *)tcpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//推荐的学员列表 
- (void)tuiJianXueYuanListDataWitnRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//我的课程 
- (void)MyClassDataWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andType:(NSString *)type andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//取消预约课程
-(void)cancelMyClassDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andBcid:(NSString *)bcid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//删除预约课程 
-(void)deleteMyClassDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andBcid:(NSString *)bcid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//考试记录列表
- (void)kaoShiJiLuDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//订单列表 
- (void)orderListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_status:(NSString *)order_status andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//添加课时 
- (void)addKeShiDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//从订单列表付款
- (void)payCoinFromOrderListWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//订单删除 
- (void)deleteOrderDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString*)ident_code andOrder_id:(NSString *)order_id andOp:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//退款 
- (void)tuiKuanDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id andReason:(NSString *)reason success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//优惠券 
- (void)getYouHuiQuanListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andId:(NSString *)order_id andGoods_num:(NSString *)goods_num andGoods_type:(NSString *)goods_type andPage:(NSString *)Page andUse_type:(NSString *)use_type andList:(NSString *)list success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//预约状态的查询
- (void)YuYueStateWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andErid:(NSString *)erid andErpid:(NSString *)erpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//预约驾校 
- (void)yuYueJiaXiaoWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andPhone:(NSString *)phone andName:(NSString *)name andCode:(NSString *)code andId_card:(NSString *)id_card success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科一、科四做题排行榜 m=score_rank rndstring subjects
-(void)recordsPaiHangDataWithRndString:(NSString *)rndstring andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//科一和科四的模拟考试记录
- (void)recordsWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//做题记录保存
- (void)saveRecordDataWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andScore:(NSString *)score andUseTime:(NSString *)use_time andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//评论功能 
- (void)getPingLunDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andScore:(NSString *)score andContent:(NSString *)content  success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//手机扫码 
- (void)saoYiSaoDataWithRndStrng:(NSString *)rndstring andRand_str:(NSString *)rand_str andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//补考缴费
- (void)buKaoJiaoFeiDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

//补考缴费订单
- (void)buKaoJiaoFeiDingdanDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock;

@end
