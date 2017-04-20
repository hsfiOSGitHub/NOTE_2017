//
//  ZXRecordTableViewCell.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/31.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end
