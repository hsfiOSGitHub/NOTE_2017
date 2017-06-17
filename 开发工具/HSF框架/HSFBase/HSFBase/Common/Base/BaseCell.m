//
//  BaseCell.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell
#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
//获取重用标识符
+(NSString *)getCellReuseIdentifier{
    return NSStringFromClass(self);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
