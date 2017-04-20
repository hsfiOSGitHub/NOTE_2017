//
//  KnSignUpDetailCell3.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnSignUpDetailCell3.h"



@interface KnSignUpDetailCell3 ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;//图片
@property (weak, nonatomic) IBOutlet UILabel *title;//标题


@end

@implementation KnSignUpDetailCell3

-(void)setIconAndTitleDic:(NSDictionary *)iconAndTitleDic{
    _iconAndTitleDic = iconAndTitleDic;
    //确定图片和标题
    _icon.image = [UIImage imageNamed:iconAndTitleDic[@"icon"]];
    _title.text = iconAndTitleDic[@"title"];
}



#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
