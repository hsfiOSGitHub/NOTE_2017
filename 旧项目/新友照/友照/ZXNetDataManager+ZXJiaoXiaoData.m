//
//  ZXNetDataManager+ZXJiaoXiaoData.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXNetDataManager+ZXJiaoXiaoData.h"

@implementation ZXNetDataManager (ZXJiaoXiaoData)

//验证码类型type=0代表注册，type=1代表找回密码，可不传，默认为0
//type=2,预约驾校，type=3,预约教练，type=4,预约考试，type=5,预约模拟，type=6,设置支付密码，type=7,找回支付密码
//请求轮播图数据
-(void)qingqiulunboushujusuccess:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"slide" forKey:@"m"];
    
    NSLog(@"%@?m=slide",ZX_URL);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}


//注册 参数：m=register phone password code rndstring source_phone
- (void)zhuCeDataWithPhone:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code andRndstring:(NSString *)rndstring andSourcePhone:(NSString *)sourcePhone success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"register" forKey:@"m"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:code forKey:@"code"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:sourcePhone forKey:@"source_phone"];
    
    NSLog(@"%@?m=register&phone=%@&password=%@&code=%@&rndstring=%@&source_phone=%@",ZX_URL,phone,password,code,rndstring,sourcePhone);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//获取验证码 参数：m=message phone type rndstring
- (void)getYanZhengMaDataWithPhone:(NSString *)phone andType:(NSString *)type andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"message" forKey:@"m"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:rndstring forKey:@"rndstring"];
    
    NSLog(@"%@?m=message&phone=%@&type=%@&rndstring=%@",ZX_URL,phone,type,rndstring);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//找回密码 m=forget_password phone password code rndstring
- (void)chongZhiMiMaDataWithPhone:(NSString *)phone andPassword:(NSString *)password andCode:(NSString *)code andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"forget_password" forKey:@"m"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:code forKey:@"code"];
    [dic setValue:rndstring forKey:@"rndstring"];
    
    NSLog(@"%@?m=forget_password&phone=%@&password=%@&code=%@&rndstring=%@",ZX_URL,phone,password,code,rndstring);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//登录 参数：m=login phone password rndstring
- (void)loginDataWithPhone:(NSString *)phone andPassword:(NSString *)password andRndstring:(NSString *)rndstring success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"login" forKey:@"m"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:rndstring forKey:@"rndstring"];
    
    NSLog(@"%@?m=login&phone=%@&password=%@&rndstring=%@",ZX_URL,phone,password,rndstring);

    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//查看学员的信息 m=userinfo rndstring ident_code 
- (void)chaKanXueYuanXinXiDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"userinfo" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];;
    
    NSLog(@"%@?m=userinfo&rndstring=%@&ident_code=%@",ZX_URL,rndstring,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
    
}

//退出登录 参数：m=logout rndstring ident_code
- (void)logoutDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.failedBlock = failedBlock;
    self.successBlock = successBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"logout" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=logout&rndstring=%@&ident_code=%@",ZX_URL,rndstring,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//主页科目二购买模拟卡详情 m=book_exam_buycard rndstring ident_code erid cardid
- (void)gouMaiMoNiKaDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid andCardid:(NSString *)cardid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    YZLog(@"%@",ident_code);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_buycard" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:erid forKey:@"erid"];
    [dic setValue:cardid forKey:@"cardid"];
    
     NSLog(@"%@?m=book_exam_buycard&rndstring=%@&ident_code=%@&erid=%@&cardid=%@",ZX_URL,rndstring,ident_code,erid,cardid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//主页科目二和科目三购买课时卡详情 m=course_card rndstring ident_code goods_type
- (void)gouMaiKeShiKaDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andGoods_type:(NSString *)goods_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"course_card" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:goods_type forKey:@"goods_type"];
    
    NSLog(@"%@?m=course_card&rndstring=%@&ident_code=%@&goods_type=%@",ZX_URL,rndstring,ident_code,goods_type);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//科二买模拟卡考场列表 m=examination_list rndstring ident_code page
- (void)gouMaiMoNiKaKaoChangListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"examination_list" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:page forKey:@"page"];
    
    NSLog(@"%@?m=examination_list&rndstring=%@&ident_code=%@&page=%@",ZX_URL,rndstring,ident_code,page);
    
    [self.manager GET:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//购买学时卡和模拟卡提交订单 m=send_order op=submit rndstring id(产品) ident_code goods_type num discount_id client_type=ios
- (void)tiJiaoDingDanDataWithRndstring:(NSString *)rndstring andId:(NSString *)productId andIdent_code:(NSString *)ident_code andGoods_type:(NSString *)goods_type andNum:(NSString *)num andDiscount_id:(NSString *)discount_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"send_order" forKey:@"m"];
    [dic setValue:@"ios" forKey:@"client_type"];
    [dic setValue:@"submit" forKey:@"op"];
    [dic setValue:productId forKey:@"id"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:goods_type forKey:@"goods_type"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:discount_id forKey:@"discount_id"];
    
    NSLog(@"%@?m=send_order&client_type=ios&op=submit&id=%@&rndstring=%@&ident_code=%@&goods_type=%@&num=%@&discount_id=%@",ZX_URL,productId,rndstring,ident_code,goods_type,num,discount_id);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//科三模拟提交订单 m=book_exam_carinfo op=submit client_type=ios rndstring id ident_code froms num
- (void)keSanTiJiaoDingDanDataWithRndstring:(NSString *)rndstring andId:(NSString *)productId andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andNum:(NSString *)num success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_carinfo" forKey:@"m"];
    [dic setValue:@"ios" forKey:@"client_type"];
    [dic setValue:@"submit" forKey:@"op"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:productId forKey:@"id"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:froms forKey:@"froms"];
    [dic setValue:num forKey:@"num"];
    
    NSLog(@"%@?m=send_order&client_type=ios&op=submit&rndstring=%@&id=%@&ident_code=%@&froms=%@&num=%@",ZX_URL,rndstring,productId,ident_code,froms,num);
    
    [self.manager GET:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//科二模拟考场列表 m=book_exam_klist rndstring page ident_code
-(void)keErYuYueMoNiKaoChangListDataRndstring:(NSString *)rndstring andPage:(NSString *)page andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_klist" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=book_exam_klist&rndstring=%@&page=%@&ident_code=%@",ZX_URL,rndstring,page,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock){
            self.failedBlock(task,error);
        }
    }];
}

//科二预约模拟排队详情 m=book_queue rndstring ident_code erid moni_time stid
- (void)keErYuYueMoNiPaiDuiDetaiDatalWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid  andMoni_time:(NSString*)moni_time andStid:(NSString *)stid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_queue" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:erid forKey:@"erid"];
    [dic setValue:stid forKey:@"stid"];
    
    NSLog(@"%@?m=book_queue&rndstring=%@&ident_code=%@&erid=%@&stid=%@",ZX_URL,rndstring,ident_code,erid,stid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//我的卡券 m=book_mycardlist rndstring ident_code erid
- (void)myCardListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_mycardlist" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:erid forKey:@"erid"];
    
    NSLog(@"%@?m=book_mycardlist&rndstring=%@&ident_code=%@&erid=%@",ZX_URL,rndstring,ident_code,erid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//科三模拟列表
- (void)KeSanMoNiWithTimeStamp:(NSString *)timeStamp andClassify:(NSString *)classify andOrder:(NSString *)order success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
  
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_carlist" forKey:@"m"];
    [dic setValue:timeStamp forKey:@"rndstring"];
    [dic setValue:classify forKey:@"ctype"];
    [dic setValue:order forKey:@"order"];
    
    NSLog(@"%@?m=book_exam_carlist&rndstring=%@&ctype=%@&order=%@",ZX_URL,timeStamp,classify,order);
    
    [self.manager POST:ZX_URL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}
//科二卡券去排队 m=book_mycardlist rndstring ident_code erid date couids op=submit
- (void)keErKaQuanPaiDuiDataWithaRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andErid:(NSString *)erid  andDate:(NSString*)date andCouids:(NSString *)couids success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_mycardlist" forKey:@"m"];
    [dic setValue:@"submit" forKey:@"op"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:erid forKey:@"erid"];
    [dic setValue:date forKey:@"date"];
    [dic setValue:couids forKey:@"couids"];
    
    NSLog(@"%@?m=book_mycardlist&op=submit&rndstring=%@&ident_code=%@&erid=%@&date=%@&couids=%@",ZX_URL,rndstring,ident_code,erid,date,couids);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//确认上车信息 m=validate_student rndstring ident_code code
-(void)shangCheXinXiYanZhengDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andercode:(NSString *)code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"validate_student" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:code forKey:@"code"];
    
    NSLog(@"%@?m=validate_student&rndstring=%@&ident_code=%@&code=%@",ZX_URL,rndstring,ident_code,code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//取消排队 m=cancel_queue rndstring ident_code id
- (void)quXiaoPaiDuiDataWitnRndstring:(NSString *)rndstring andIdentCode:(NSString *)ident_code andid:(NSString*)pid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"cancel_queue" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:pid forKey:@"id"];
    
    NSLog(@"%@?m=cancel_queue&rndstring=%@&ident_code=%@&id=%@",ZX_URL,rndstring,ident_code,pid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//确定支付（微信）m=wechatpay order_id rndstring ident_code froms pay_type
- (void)confirmWXPayDataWithOrder_id:(NSString *)order_id andRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andPayType:(NSString *)pay_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"wechatpay" forKey:@"m"];
    [dic setValue:order_id forKey:@"order_id"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:froms forKey:@"froms"];
    [dic setValue:pay_type forKey:@"pay_type"];
    
    NSLog(@"%@?m=wechatpay&order_id=%@&rndstring=%@&ident_code=%@&froms=%@&pay_type=%@",ZX_URL,order_id,rndstring,ident_code,froms,pay_type);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//确定支付(支付宝） m=alipay order_id rndstring ident_code froms pay_type      alipay_code(测试)
- (void)confirmZFBPayDataWithOrder_id:(NSString *)order_id andRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andFroms:(NSString *)froms andPay_type:(NSString *)pay_type success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"alipay" forKey:@"m"];
    [dic setValue:order_id forKey:@"order_id"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:froms forKey:@"froms"];
    [dic setValue:pay_type forKey:@"pay_type"];

    NSLog(@"%@?m=alipay&order_id=%@&rndstring=%@&ident_code=%@&froms=%@&pay_type=%@",ZX_URL,order_id,rndstring,ident_code,froms,pay_type);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.failedBlock)
         {
             self.failedBlock(task,error);
         }
     }];
}

//订单详情 m=book_order_orderinfo rndstring ident_code order_id
- (void)dingDanDetailWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_order_orderinfo" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"order_id"];
    
    NSLog(@"%@?m=book_order_orderinfo&rndstring=%@&ident_code=%@&order_id=%@",ZX_URL,rndstring,ident_code,order_id);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//我的合同 m=agreement rndstring ident_code
-(void)getWoDeHeTongDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType )successBlock Failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"agreement" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=agreement&rndstring=%@&ident_code=%@",ZX_URL,rndstring,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (self.failedBlock)
         {
             self.failedBlock(task,error);
         }
     }];
}

//意见反馈 m=feedback type=2 version=2.1.0 rndstring phone content
- (void)yongHuFanKuiWithRndstring:(NSString *)rndstring andPhone:(NSString *)phone andContent:(NSString *)content success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"feedback" forKey:@"m"];
    [dic setValue:@"2" forKey:@"type"];
    [dic setValue:@"2.1.0" forKey:@"version"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:content forKey:@"content"];
    
    NSLog(@"%@?m=feedback&type=2&version=2.1.0&rndstring=%@&phone=%@&content=%@",ZX_URL,rndstring,phone,content);
    
    [self.manager POST:ZX_URL  parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
    
}

//课程列表 m=class_list rndstring date tid ident_code
- (void)myClassListWithRndstring:(NSString *)rndstring anddate:(NSString *)date andtid:(NSString *)tid  andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"class_list" forKey:@"m"];;
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:date forKey:@"date"];
    [dic setValue:tid forKey:@"tid"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=class_list&rndstring=%@&date=%@&tid=%@&ident_code=%@",ZX_URL,rndstring,date,tid,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.failedBlock(task,error);
    }];
}

//课程余额 m=class_num rndstring ident_code subject
- (void)keChengYuEDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andsubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"class_num" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:subject forKey:@"subject"];
    
    NSLog(@"%@?m=class_num&rndstring=%@&ident_code=%@&subject=%@",ZX_URL,rndstring,ident_code,subject);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         self.failedBlock(task,error);
     }];
}

//预约课程  m=book_class rndstring ident_code tcpid
- (void)yuYueKeChengDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andTcpid:(NSString *)tcpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_class" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:tcpid forKey:@"tcpid"];

    NSLog(@"%@?m=book_class&rndstring=%@&ident_code=%@&tcpid=%@",ZX_URL,rndstring,ident_code,tcpid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        self.failedBlock(task,error);
    }];
}

//推荐的学员列表 m=source_me_list rndstring ident_code
- (void)tuiJianXueYuanListDataWitnRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"source_me_list" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=source_me_list&rndstring=%@&ident_code=%@",ZX_URL,rndstring,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//我的课程 m=my_class rndstring ident_code type page
- (void)MyClassDataWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andType:(NSString *)type andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"my_class" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:page forKey:@"page"];
    
    NSLog(@"%@?m=my_class&rndstring=%@&ident_code=%@&type=%@&page=%@",ZX_URL,rndstring,ident_code,type,page);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//取消预约课程 m=cancel_book_class rndstring ident_code bcid
-(void)cancelMyClassDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andBcid:(NSString *)bcid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"cancel_book_class" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:bcid forKey:@"bcid"];
    
    NSLog(@"%@?m=cancel_book_class&rndstring=%@&ident_code=%@&bcid=%@",ZX_URL,rndstring,ident_code,bcid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//删除预约课程 m=delete_book_class rndstring ident_code bcid
-(void)deleteMyClassDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andBcid:(NSString *)bcid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"delete_book_class" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:bcid forKey:@"bcid"];
    
    NSLog(@"%@?m=delete_book_class&rndstring=%@&ident_code=%@&bcid=%@",ZX_URL,rndstring,ident_code,bcid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//考试记录列表 m=exam_list rndstring ident_code
- (void)kaoShiJiLuDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"exam_list" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    
    NSLog(@"%@?m=exam_list&rndstring=%@&ident_code=%@",ZX_URL,rndstring,ident_code);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//订单列表 m=book_order_lists2 rndstring ident_code order_status page
- (void)orderListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_status:(NSString *)order_status andPage:(NSString *)page success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_order_lists2" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_status forKey:@"order_status"];
    [dic setValue:page forKey:@"page"];
    
    NSLog(@"%@?m=book_order_lists2&rndstring=%@&ident_code=%@&order_status=%@&page=%@",ZX_URL,rndstring,ident_code,order_status,page);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//添加课时 m=addclass rndstring ident_code order_id
- (void)addKeShiDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"addclass" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"order_id"];
    
    NSLog(@"%@?m=addclass&rndstring=%@&ident_code=%@&order_id=%@",ZX_URL,rndstring,ident_code,order_id);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.failedBlock)
         {
             self.failedBlock(task,error);
         }
     }];
}

//从订单列表付款 m=book_exam_buyto rndstring ident_code order_id
- (void)payCoinFromOrderListWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_exam_buyto" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"order_id"];
    
    NSLog(@"%@?m=book_exam_buyto&rndstring=%@&ident_code=%@&order_id=%@",ZX_URL,rndstring,ident_code,order_id);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress){
     }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.failedBlock)
         {
             self.failedBlock(task,error);
         }
     }];
}

//订单删除 m=book_order_lists rndstring ident_code order_id op
- (void)deleteOrderDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString*)ident_code andOrder_id:(NSString *)order_id andOp:(NSString *)op success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_order_lists" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"order_id"];
    [dic setValue:op forKey:@"op"];
    
    NSLog(@"%@?m=book_order_lists&rndstring=%@&ident_code=%@&order_id=%@&op=%@",ZX_URL,rndstring,ident_code,order_id,op);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//退款 m=book_back_order op=submit  rndstring ident_code order_id reason
- (void)tuiKuanDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andOrder_id:(NSString *)order_id andReason:(NSString *)reason success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_back_order" forKey:@"m"];
    [dic setValue:@"submit" forKey:@"op"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"order_id"];
    [dic setValue:reason forKey:@"reason"];
    
    NSLog(@"%@?m=book_back_order&op=submit&rndstring=%@&ident_code=%@&order_id=%@&reason=%@",ZX_URL,rndstring,ident_code,order_id,reason);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//优惠券 m=discount_lists rndstring ident_code id goods_num goods_type page use_type list
- (void)getYouHuiQuanListDataWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andId:(NSString *)order_id andGoods_num:(NSString *)goods_num andGoods_type:(NSString *)goods_type andPage:(NSString *)page andUse_type:(NSString *)use_type andList:(NSString *)list success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"discount_lists" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:order_id forKey:@"id"];
    [dic setValue:goods_num forKey:@"goods_num"];
    [dic setValue:goods_type forKey:@"goods_type"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:use_type forKey:@"use_type"];
    [dic setValue:list forKey:@"list"];
    
    NSLog(@"%@?m=discount_lists&rndstring=%@&ident_code=%@&order_id=%@&goods_num=%@&goods_type=%@&page=%@&use_type=%@&list=%@",ZX_URL,rndstring,ident_code,order_id,goods_num,goods_type,page,use_type,list);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (self.successBlock)
         {
             self.successBlock(task,responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.failedBlock)
         {
             self.failedBlock(task,error);
         }
     }];
}

//预约状态的查询 m=book_status rndstring ident_code sid tid erid erpid
- (void)YuYueStateWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andErid:(NSString *)erid andErpid:(NSString *)erpid success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_status" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:sid forKey:@"sid"];
    [dic setValue:tid forKey:@"tid"];
    [dic setValue:erid forKey:@"erid"];
    [dic setValue:erpid forKey:@"erpid"];
    
    NSLog(@"%@?m=book_status&rndstring=%@&ident_code=%@&sid=%@&tid=%@&erid=%@&erpid=%@",ZX_URL,rndstring,ident_code,sid,tid,erid,erpid);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//预约驾校 m=book_school rndstring ident_code sid phone name code id_card
- (void)yuYueJiaXiaoWithRndstring:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andPhone:(NSString *)phone andName:(NSString *)name andCode:(NSString *)code andId_card:(NSString *)id_card success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"book_school" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:sid forKey:@"sid"];
    [dic setValue:phone forKey:@"phone"];
    [dic setValue:name forKey:@"name"];
    [dic setValue:code forKey:@"code"];
    [dic setValue:id_card forKey:@"id_card"];
    
    NSLog(@"%@?m=book_school&rndstring=%@&ident_code=%@&sid=%@&phone=%@&name=%@&code=%@&id_card=%@",ZX_URL,rndstring,ident_code,sid,phone,name,code,id_card);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//科一、科四做题排行榜 m=score_rank rndstring subjects
-(void)recordsPaiHangDataWithRndString:(NSString *)rndstring andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"score_rank" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:subject forKey:@"subjects"];

    NSLog(@"%@?m=score_rank&rndstring=%@&subjects=%@",ZX_URL,rndstring,subject);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//科一和科四的模拟考试记录 m=score_record rndstring ident_code subjects
- (void)recordsWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"score_record" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:subject forKey:@"subjects"];
    
    NSLog(@"%@?m=score_record&rndstring=%@&ident_code=%@&subjects=%@",ZX_URL,rndstring,ident_code,subject);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self .successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self .failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//做题记录保存 m=save_record rndstring ident_code score use_time subjects
- (void)saveRecordDataWithRndString:(NSString *)rndstring andIdent_code:(NSString *)ident_code andScore:(NSString *)score andUseTime:(NSString *)use_time andSubjects:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"save_record" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:score forKey:@"score"];
    [dic setValue:use_time forKey:@"use_time"];
    [dic setValue:subject forKey:@"subjects"];
    
    NSLog(@"%@?m=save_record&rndstring=%@&ident_code=%@&score=%@&use_time=%@&subjects=%@",ZX_URL,rndstring,ident_code,score,use_time,subject);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (self.successBlock)
        {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (self.failedBlock)
        {
            self.failedBlock(task,error);
        }
    }];
}

//评论功能 m=comment rndstring  ident_code sid tid score content bid order_id
- (void)getPingLunDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSid:(NSString *)sid andTid:(NSString *)tid andScore:(NSString *)score andContent:(NSString *)content success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"comment" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:sid forKey:@"sid"];
    [dic setValue:tid forKey:@"tid"];
    [dic setValue:score forKey:@"score"];
    [dic setValue:content forKey:@"content"];
 
    NSLog(@"%@?m=comment&rndstring=%@&ident_code=%@&sid=%@&tid=%@&score=%@&content=%@",ZX_URL,rndstring,ident_code,sid,tid,score,content);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//手机扫码 m=log_code_phone rndstring rand_str ident_code app=student
- (void)saoYiSaoDataWithRndStrng:(NSString *)rndstring andRand_str:(NSString *)rand_str andIdent_code:(NSString *)ident_code success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"log_code_phone" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:rand_str forKey:@"rand_str"];
    [dic setValue:@"student" forKey:@"app"];
    
    NSLog(@"%@?m=log_code_phone&rndstring=%@&ident_code=%@&rand_str=%@&app=student",ZX_URL,rndstring,ident_code,rand_str);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//补考缴费 m=buy_resit rndstring ident_code subject
- (void)buKaoJiaoFeiDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"buy_resit" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:subject forKey:@"subject"];
    
    NSLog(@"%@?m=buy_resit&rndstring=%@&ident_code=%@&subject=%@",ZX_URL,rndstring,ident_code,subject);
    
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

//补考缴费订单 m=buy_resit rndstring op=submit ident_code subject
- (void)buKaoJiaoFeiDingdanDataWithRndStrng:(NSString *)rndstring andIdent_code:(NSString *)ident_code andSubject:(NSString *)subject success:(SuccessBlockType)successBlock failed:(FailuerBlockType)failedBlock
{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"buy_resit" forKey:@"m"];
    [dic setValue:rndstring forKey:@"rndstring"];
    [dic setValue:@"submit" forKey:@"op"];
    [dic setValue:ident_code forKey:@"ident_code"];
    [dic setValue:subject forKey:@"subject"];
    
    NSLog(@"%@?m=buy_resit&rndstring=%@&op=submit&ident_code=%@&subject=%@",ZX_URL,rndstring,ident_code,subject);
    [self.manager POST:ZX_URL parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failedBlock) {
            self.failedBlock(task,error);
        }
    }];
}

@end
