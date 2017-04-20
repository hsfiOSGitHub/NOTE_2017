//
//  KnCellType2.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KnMeetingListModel;
@class MiMyMeetingListModel;

@interface KnCellType1 : UITableViewCell
@property (nonatomic,strong) KnMeetingListModel *listModel;
@property (nonatomic,strong) MiMyMeetingListModel *myMeetingListModel;

@end
