//
//  PersonalHistoryTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/1.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PersonalHistoryTableViewCell.h"

@implementation PersonalHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat )calculateContentHeight:(NSString *)model{
    
    CGSize mysize = CGSizeMake(KScreenWidth - 2 * 10, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGFloat height = [model boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return height;
}
-(void)resetContentLabelFrame:(NSString *)model{
    CGFloat height = [PersonalHistoryTableViewCell calculateContentHeight:model];
    CGRect frame = self.DetailLable.frame;
    frame.size.height = height;
    self.DetailLable.frame = frame;
    
}
@end
