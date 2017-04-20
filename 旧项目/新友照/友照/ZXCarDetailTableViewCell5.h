//
//  ZXCarDetailTableViewCell5.h
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCarDetailTableViewCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *CallBtn;
@property (weak, nonatomic) IBOutlet UILabel *CoachName;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

- (void)setUpCellWith:(NSDictionary *)model;

@end
