//
//  KnCellType2_1Cell.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KnMeetingInfoModel;

@interface KnCellType1_1Cell : UITableViewCell
@property (nonatomic,strong) KnMeetingInfoModel *meetingInfoModel;
@property (nonatomic,strong) NSString *doType; //报名方式 主动报名 后台邀请
@end
