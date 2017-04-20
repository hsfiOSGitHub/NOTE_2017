//
//  ZXCommentTableViewCell.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/19.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCommentTableViewCell.h"

@implementation ZXCommentTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 25;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    _headImageView.layer.borderWidth = 1;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     
}
+(CGFloat )calculateContentHeight:(NSDictionary *)model{
   
    CGSize mysize = CGSizeMake(KScreenWidth - 2 * 10, 0);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect myRect = [model[@"content"] boundingRectWithSize:mysize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    return myRect.size.height + 88;
}

-(void)resetContentLabelFrame:(NSDictionary *)model{
    CGRect frame = self.commentLabel.frame;
    frame.size.height = [ZXCommentTableViewCell calculateContentHeight:model];
    self.commentLabel.frame = frame;
}
- (void)setUpCellWith:(NSDictionary *)model {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model[@"student_pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    //根据星级设置图片
    [self setstartImageWith:model[@"score"]];
    _nameLabel.text = model[@"student_name"];
    _dateLabel.text = [model[@"addtime"] substringWithRange:NSMakeRange(0, [model[@"addtime"] length]-3)];
     _commentLabel.text = model[@"content"];
    if (model[@"student_name"] == nil || [model[@"student_name"] isEqualToString:@""]) {
        _nameLabel.text = @"匿名用户";
    }
}
-(void)setstartImageWith:(NSString *)score
{
    CGFloat scroe1 = [score floatValue];
    self.startImage1.image = nil;
    self.startImage2.image = nil;
    self.startImage3.image = nil;
    self.startImage4.image = nil;
    self.startImage5.image = nil;
    //驾校星级
    if (0.00 <= scroe1 && scroe1 <= 0.49)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_normal"];
        self.startImage2.image = [UIImage imageNamed:@"star_normal"];
        self.startImage3.image = [UIImage imageNamed:@"star_normal"];
        self.startImage4.image = [UIImage imageNamed:@"star_normal"];
        self.startImage5.image = [UIImage imageNamed:@"star_normal"];
    }
    else if (0.50 <= scroe1 && scroe1 <= 1.49)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_hd"];
        self.startImage2.image = [UIImage imageNamed:@"star_normal"];
        self.startImage3.image = [UIImage imageNamed:@"star_normal"];
        self.startImage4.image = [UIImage imageNamed:@"star_normal"];
        self.startImage5.image = [UIImage imageNamed:@"star_normal"];
    }
    else if (1.50 <= scroe1 && scroe1 <= 2.49)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_hd"];
        self.startImage2.image = [UIImage imageNamed:@"star_hd"];
        self.startImage3.image = [UIImage imageNamed:@"star_normal"];
        self.startImage4.image = [UIImage imageNamed:@"star_normal"];
        self.startImage5.image = [UIImage imageNamed:@"star_normal"];
    }
    else if (2.50 <= scroe1 && scroe1 <=  3.49)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_hd"];
        self.startImage2.image = [UIImage imageNamed:@"star_hd"];
        self.startImage3.image = [UIImage imageNamed:@"star_hd"];
        self.startImage4.image = [UIImage imageNamed:@"star_normal"];
        self.startImage5.image = [UIImage imageNamed:@"star_normal"];
    }
    else if (3.50 <= scroe1 && scroe1 <=  4.49)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_hd"];
        self.startImage2.image = [UIImage imageNamed:@"star_hd"];
        self.startImage3.image = [UIImage imageNamed:@"star_hd"];
        self.startImage4.image = [UIImage imageNamed:@"star_hd"];
        self.startImage5.image = [UIImage imageNamed:@"star_normal"];
    }
    else if (4.50 <= scroe1)
    {
        self.startImage1.image = [UIImage imageNamed:@"star_hd"];
        self.startImage2.image = [UIImage imageNamed:@"star_hd"];
        self.startImage3.image = [UIImage imageNamed:@"star_hd"];
        self.startImage4.image = [UIImage imageNamed:@"star_hd"];
        self.startImage5.image = [UIImage imageNamed:@"star_hd"];
    }
}
@end
