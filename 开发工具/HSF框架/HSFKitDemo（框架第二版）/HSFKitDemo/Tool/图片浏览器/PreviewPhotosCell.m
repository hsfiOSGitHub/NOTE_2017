//
//  PreviewPhotosCell.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "PreviewPhotosCell.h"

@implementation PreviewPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 1;
    self.imgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
}

//获取重用标识符
+(NSString *)getCellReuseIdentifier{
    return NSStringFromClass(self);
}

@end
