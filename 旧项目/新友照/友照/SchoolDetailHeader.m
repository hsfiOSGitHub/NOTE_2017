//
//  SchoolDetailHeader.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailHeader.h"

@implementation SchoolDetailHeader

-(void)setHeaderWith:(NSDictionary *)model
{
    self.fenlable.text = [NSString stringWithFormat:@"%@分", model[@"score"]];
    [self setstartImageWith:model[@"score"]];
}

-(void)setstartImageWith:(NSString *)score
{
    CGFloat scroe1 = [score floatValue];
    //教练星级
    [self.img55 removeFromSuperview];
    [self.img44 removeFromSuperview];
    [self.img33 removeFromSuperview];
    [self.img22 removeFromSuperview];
    [self.img11 removeFromSuperview];
    self.image1.image=[UIImage imageNamed:@"star_normal"];
    self.image2.image=[UIImage imageNamed:@"star_normal"];
    self.image3.image=[UIImage imageNamed:@"star_normal"];
    self.image4.image=[UIImage imageNamed:@"star_normal"];
    self.image5.image=[UIImage imageNamed:@"star_normal"];
    //新的教练星级
    if(4 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,50*(scroe1-4),50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        NSInteger hehe=20*(scroe1-4);
        self.img55=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,hehe, 20)];
        self.img55.image=subIma;
        self.img55.contentMode=UIViewContentModeScaleAspectFill;
        [self.image1 addSubview:_img55];
        scroe1=scroe1-(scroe1-4);
    }
    if(3 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,50*(scroe1-3),50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img44=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*(scroe1-3), 20)];
        self.img44.contentMode=UIViewContentModeScaleAspectFill;
        self.img44.image = subIma;
        [self.image2 addSubview:_img44];
        scroe1=scroe1-(scroe1-3);
    }
    if(2 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,50*(scroe1-2),50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img33=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*(scroe1-2), 20)];
        self.img33.contentMode=UIViewContentModeScaleAspectFill;
        self.img33.image = subIma;
        [self.image3 addSubview:_img33];
        scroe1=scroe1-(scroe1-2);
    }
    if(1 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,50*(scroe1-1),50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img22=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*(scroe1-1), 20)];
        self.img22.contentMode=UIViewContentModeScaleAspectFill;
        self.img22.image = subIma;
        [self.image4 addSubview:_img22];
        scroe1=scroe1-(scroe1-1);
    }
    if(0 <= scroe1)
    {
        UIImage *ima = [UIImage imageNamed:@"star_hd"];
        CGRect rect =CGRectMake(0, 0,50*scroe1,50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([ima CGImage], rect);
        UIImage *subIma = [UIImage imageWithCGImage:imageRef];
        self.img11=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  20*scroe1, 20)];
        self.img11.contentMode=UIViewContentModeScaleAspectFill;
        self.img11.image = subIma;
        [self.image5 addSubview:_img11];
    }
}


@end
