//
//  KnCellType1VC.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KnCellType1VCDelegate <NSObject>
-(void)updateMeetingWithDoType:(NSString *)doTpye andIndex:(NSInteger)index;
-(void)updateMeetingUIWithIndex:(NSInteger)index;
@end


@interface KnCellType1VC : UIViewController
@property (nonatomic,strong) NSString *meetingID;//新闻id
@property (nonatomic,strong) NSString *doType;//报名方式 主动报名 后台邀请
@property (nonatomic,assign) id<KnCellType1VCDelegate> delegate;//代理
@property (nonatomic,assign) NSInteger index;//点击的cell index
@end
