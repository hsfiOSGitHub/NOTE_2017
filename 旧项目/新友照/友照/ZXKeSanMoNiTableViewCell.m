//
//  ZXKeSanMoNiTableViewCell.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXKeSanMoNiTableViewCell.h"

@implementation ZXKeSanMoNiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carIdImageView.adjustsFontSizeToFitWidth=YES;
    
}
- (void)setKeSanMoNiCellWith:(NSDictionary *)model
{
    //有值但是赋值不成功
   [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model[@"pic"]] placeholderImage:[UIImage imageNamed:@"默认"]];
    
    //车牌号(brand、code?) 0为皮卡 1为轿车 
    if ([model[@"classify"] isEqualToString:@"1"])
    {
        self.carIdImageView.text = [NSString stringWithFormat:@"车牌号: %@  (皮卡)",model[@"code"]];
    }
    else if([model[@"classify"]  isEqualToString:@"0"])
    {
        self.carIdImageView.text = [NSString stringWithFormat:@"车牌号: %@  (轿车)",model[@"code"]];
    }
    else
    {
        self.carIdImageView.text = [NSString stringWithFormat:@"车牌号: %@  (未知)",model[@"code"]];
    }
    //满减
    if ([[NSString stringWithFormat:@"%@",model[@"discount"]] isEqualToString:@"0"])
    {
        self.manjian.hidden = NO;
        self.manjian.clipsToBounds = YES;
        self.manjian.text = @"暂无优惠";
        [self.manjian.layer setBorderWidth:1.0];
        [self.manjian.layer setCornerRadius:4.0];
        self.manjian.layer.borderColor = [[UIColor redColor] CGColor];
        //价格
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model[@"price"]];
    }
    else
    {
        self.manjian.hidden = NO;
        self.manjian.text = [NSString stringWithFormat:@"满%@送%@",model[@"times1"],model[@"times2"]];
        //价格
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model[@"price"]];
    }
    //驾校名字
    if (!model[@"exam_name"])
    {
        self.jiaxiaomingzi.hidden=YES;
    }
    else
    {
        self.jiaxiaomingzi.text=[NSString stringWithFormat:@"%@",model[@"exam_name"]];
    }
   
    //售出数量
    self.saleLabel.text = [NSString stringWithFormat:@"已售:%@",model[@"orders"]];
    //评分,如果为空的话，直接赋值为0
    if(![model[@"teacher_score"] isKindOfClass:[NSString class]])
    {
        self.scoreLabel.text = @"暂无评分";
    }
    else
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"(%@分)",model[@"teacher_score"]];
    }
    self.coachNameLabel.text = model[@"teacher_name"];
    [self getStarWithScore:model[@"teacher_score"]];
}
- (void)getStarWithScore:(NSString *)score
{
    CGFloat scroe1 = [score floatValue];
    
    //驾校星级
    [self.image11 removeFromSuperview];
    [self.image22 removeFromSuperview];
    [self.image33 removeFromSuperview];
    [self.image44 removeFromSuperview];
    [self.image55 removeFromSuperview];
    
    //新的驾校星级
    if(4 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-4),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        NSInteger hehe=16*(scroe1-4);
        self.image55=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-26,self.jiaxiaomingzi.frame.origin.y+self.jiaxiaomingzi.frame.size.height+10,hehe, 16)];
        self.image55.image=subIma;
        self.image55.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_image55];
        scroe1=scroe1-(scroe1-4);
    }
    if(3 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-3),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.image44=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-47,self.jiaxiaomingzi.frame.origin.y+self.jiaxiaomingzi.frame.size.height+10, 16*(scroe1-3), 16)];
        self.image44.contentMode=UIViewContentModeScaleAspectFill;
        self.image44.image = subIma;
        [self.contentView addSubview:_image44];
        scroe1=scroe1-(scroe1-3);
    }
    if(2 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-2),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.image33=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-68,self.jiaxiaomingzi.frame.origin.y+self.jiaxiaomingzi.frame.size.height+10, 16*(scroe1-2), 16)];
        self.image33.contentMode=UIViewContentModeScaleAspectFill;
        self.image33.image = subIma;
        [self.contentView addSubview:_image33];
        scroe1=scroe1-(scroe1-2);
    }
    if(1 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-1),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.image22=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-89,self.jiaxiaomingzi.frame.origin.y+self.jiaxiaomingzi.frame.size.height+10, 16*(scroe1-1), 16)];
        self.image22.contentMode=UIViewContentModeScaleAspectFill;
        self.image22.image = subIma;
        [self.contentView addSubview:_image22];
        scroe1=scroe1-(scroe1-1);
    }
    if(0 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*scroe1,44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.image11=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-110,self.jiaxiaomingzi.frame.origin.y+self.jiaxiaomingzi.frame.size.height+10,  16*scroe1, 16)];
        self.image11.contentMode=UIViewContentModeScaleAspectFill;
        self.image11.image = subIma;
        [self.contentView addSubview:_image11];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
