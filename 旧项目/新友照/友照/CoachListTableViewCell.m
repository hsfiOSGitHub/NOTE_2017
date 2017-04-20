//
//  CoachListTableViewCell.m
//  友照
//
//  Created by chaoyang on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "CoachListTableViewCell.h"

@implementation CoachListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(NSDictionary *)Dic {
    self.name.text = Dic[@"name"];
    self.age.text = Dic[@"school_name"];
    self.agv_rate.text = [NSString stringWithFormat:@"通过率 %.f%%", [Dic[@"avg_rate"] floatValue]*100];
    //根据星级设置图片
    [self setstartImageWith:Dic[@"score"]];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:Dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
}
-(void)setstartImageWith:(NSString *)score
{
    CGFloat scroe1 = [score floatValue];
    [self.img55 removeFromSuperview];
    [self.img44 removeFromSuperview];
    [self.img33 removeFromSuperview];
    [self.img22 removeFromSuperview];
    [self.img11 removeFromSuperview];
    //新的教练星级
    if(4 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-4),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        NSInteger hehe=16*(scroe1-4);
        self.img55=[[UIImageView alloc]initWithFrame:CGRectMake(175, 42,hehe, 16)];
        self.img55.image=subIma;
        self.img55.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_img55];
        scroe1=scroe1-(scroe1-4);
    }
    if(3 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-3),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img44=[[UIImageView alloc]initWithFrame:CGRectMake(155, 42, 16*(scroe1-3), 16)];
        self.img44.contentMode=UIViewContentModeScaleAspectFill;
        self.img44.image = subIma;
        [self.contentView addSubview:_img44];
        scroe1=scroe1-(scroe1-3);
    }
    if(2 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-2),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img33=[[UIImageView alloc]initWithFrame:CGRectMake(135, 42, 16*(scroe1-2), 16)];
        self.img33.contentMode=UIViewContentModeScaleAspectFill;
        self.img33.image = subIma;
        [self.contentView addSubview:_img33];
        scroe1=scroe1-(scroe1-2);
    }
    if(1 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*(scroe1-1),44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img22=[[UIImageView alloc]initWithFrame:CGRectMake(115, 42, 16*(scroe1-1), 16)];
        self.img22.contentMode=UIViewContentModeScaleAspectFill;
        self.img22.image = subIma;
        [self.contentView addSubview:_img22];
        scroe1=scroe1-(scroe1-1);
    }
    if(0 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,44*scroe1,44);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img11=[[UIImageView alloc]initWithFrame:CGRectMake(95, 42,  16*scroe1, 16)];
        self.img11.contentMode=UIViewContentModeScaleAspectFill;
        self.img11.image = subIma;
        [self.contentView addSubview:_img11];
    }

}

@end
