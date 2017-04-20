//
//  ZXCarDetailTableViewCell2.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCarDetailTableViewCell2.h"

@implementation ZXCarDetailTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setUpCellWith:(NSDictionary *)model{
    
    NSDictionary *infoModel = model[@"info"];
    
    //日期 第一天
    [_firstDayBtn setTitle:@"今天" forState:UIControlStateNormal];
    [_firstDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _firstDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14 ;
    _firstDayBtn.layer.masksToBounds = YES;
    _firstDayBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    //第二天
    [_secDayBtn setTitle:@"明天" forState:UIControlStateNormal];
    [_secDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _secDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _secDayBtn.layer.masksToBounds = YES;
    _secDayBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    //第三天
    [_thrsrDayBtn setTitle:@"后天" forState:UIControlStateNormal];
    [_thrsrDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _thrsrDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _thrsrDayBtn.layer.masksToBounds = YES;
    _thrsrDayBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    
    //第四天
    [_fouDayBtn setTitle:[NSString stringWithFormat:@"%@",[infoModel[@"simulate"][3] [@"dateTime"]substringFromIndex:8]] forState:UIControlStateNormal];
    [_fouDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fouDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _fouDayBtn.layer.masksToBounds = YES;
    
    
    //第五天
    [_fivDayBtn setTitle:[NSString stringWithFormat:@"%@",[infoModel[@"simulate"][4] [@"dateTime"]substringFromIndex:8]] forState:UIControlStateNormal];
    [_fivDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fivDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _fivDayBtn.layer.masksToBounds = YES;
    
    //第六天
    [_sixDayBtn setTitle:[NSString stringWithFormat:@"%@",[infoModel[@"simulate"][5] [@"dateTime"]substringFromIndex:8]] forState:UIControlStateNormal];
    [_sixDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sixDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _sixDayBtn.layer.masksToBounds = YES;
    
    
    //第七天
    [_sevDayBtn setTitle:[NSString stringWithFormat:@"%@",[infoModel[@"simulate"][6] [@"dateTime"]substringFromIndex:8]] forState:UIControlStateNormal];
    [_sevDayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sevDayBtn.layer.cornerRadius = (KScreenWidth - 80) / 14;
    _sevDayBtn.layer.masksToBounds = YES;
    
    
    //label赋值  周几的展示
    _firstDaylabel.text = infoModel[@"simulate"][0][@"weekd"];
    _secDaylabel.text = infoModel[@"simulate"][1][@"weekd"];
    _thrDaylabel.text = infoModel[@"simulate"][2][@"weekd"];
    _fouDaylabel.text = infoModel[@"simulate"][3][@"weekd"];
    _fivDaylabel.text = infoModel[@"simulate"][4][@"weekd"];
    _sixDaylabel.text = infoModel[@"simulate"][5][@"weekd"];
    _sevDaylabel.text = infoModel[@"simulate"][6][@"weekd"];
    
}


@end
