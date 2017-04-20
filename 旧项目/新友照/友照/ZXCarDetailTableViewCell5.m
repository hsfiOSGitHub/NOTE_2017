//
//  ZXCarDetailTableViewCell5.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCarDetailTableViewCell5.h"

@implementation ZXCarDetailTableViewCell5


- (void)setUpCellWith:(NSDictionary *)model{

    _CoachName.text = model[@"list"][0][@"teacher_name"];
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
