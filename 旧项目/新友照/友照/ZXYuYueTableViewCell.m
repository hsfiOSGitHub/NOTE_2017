//
//  ZXYuYueTableViewCell.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXYuYueTableViewCell.h"
typedef NS_ENUM(NSInteger ,YuYueBtnType) {
    YuYueBtnTypeNormal = 0,//可预约
    YuYueBtnTypeFull,//预约已满，
    YuYueBtnTypeDone,//已预约

};

//预约状态的RGB
//预约成功
#define YuYueSuccessColor [UIColor colorWithRed:129/255.0 green:214/255.0 blue:58/255.0 alpha:1]
//预约失败
#define YuYueFailedColor [UIColor colorWithRed:255/255.0 green:112/255.0 blue:68/255.0 alpha:1]
//预约审核
#define YuYueAuditColor [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1]
//正常状态（没预约的时候）
#define YuYueNormalColor [UIColor colorWithRed:108/255.0 green:169/255.0 blue:255/255.0 alpha:1]

@interface ZXYuYueTableViewCell()
@property (nonatomic, assign) YuYueBtnType yuYueBtnType;
@end
@implementation ZXYuYueTableViewCell

- (void)awakeFromNib
{
    [self corneradioforImageView:_imageView1];
    [self corneradioforImageView:_imageView2];
    [self corneradioforImageView:_imageView3];
    [self corneradioforImageView:_imageView4];
    [self corneradioforImageView:_imageView5];
    [self corneradioforImageView:_imageView6];
    [self corneradioforImageView:_imageView7];
    [self corneradioforImageView:_imageView8];
    _imageViewArr = @[_imageView1,_imageView2,_imageView3,_imageView4,_imageView5,_imageView6,_imageView7,_imageView8];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


- (void)setUpCell:(NSDictionary *)model
{
    if (model == nil)
    {
        return;
    }
    _imageView1.image = nil;
    _imageView2.image = nil;
    _imageView3.image = nil;
    _imageView4.image = nil;
    _imageView5.image = nil;
    _imageView6.image = nil;
    _imageView7.image = nil;
    _imageView8.image = nil;
    
    _imageView1.layer.borderWidth = 0;
    _imageView2.layer.borderWidth = 0;
    _imageView3.layer.borderWidth = 0;
    _imageView4.layer.borderWidth = 0;
    _imageView5.layer.borderWidth = 0;
    _imageView6.layer.borderWidth = 0;
    _imageView7.layer.borderWidth = 0;
    _imageView8.layer.borderWidth = 0;
    NSInteger num = [model[@"num"] integerValue];
    if (num > 8)
    {
        num = 8;
    }
    for (int index = 0; index < num; index++)
    {
        _imgView = _imageViewArr[index];
        _imgView.layer.cornerRadius = 13;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.borderWidth = 1;
        _imgView.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
        [_imgView setImage:[UIImage imageNamed:@"touxiang"]];
    }

    //数据显示
    NSArray *startTimes = [model[@"start_time"] componentsSeparatedByString:@" "];
    NSArray *endTimes = [model[@"end_time"] componentsSeparatedByString:@" "];
    if (![model[@"start_time"] isEqualToString:@""] && ![model[@"end_time"] isEqualToString:@""])
    {
        _numOfYuYue.text = [NSString stringWithFormat:@"%@~%@已预约%@人，剩余%ld人",[startTimes[1] substringWithRange:NSMakeRange(0, 5)],[endTimes[1] substringWithRange:NSMakeRange(0, 5) ],model[@"book_num"],(num - [model[@"book_num"] intValue])];
    }
    
    NSInteger numOfstu;
    if (((NSArray*)model[@"student"]).count > 8)
    {
        numOfstu = 8;
    }
    else
    {
        numOfstu = ((NSArray*)model[@"student"]).count ;
    }
    for (NSInteger i = 0; i < numOfstu; i++)
    {
        [_imageViewArr[i] sd_setImageWithURL:[NSURL URLWithString:model[@"student"][i][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //按钮状态处理
    
    if ([model[@"book_id"] isEqualToString:@""])
    {
        if ([model[@"book_num"] intValue] >= [model[@"num"] intValue])
        {
            _yuYueBtnType = YuYueBtnTypeFull;
        }
        else
        {
            _yuYueBtnType = YuYueBtnTypeNormal;
        }
    }
    else
    {
        _yuYueBtnType = YuYueBtnTypeDone;
    }
    [self setBtnStateType];
}



- (void) setBtnStateType
{
    //根据状态确定按钮显示
    switch (_yuYueBtnType)
    {
        case YuYueBtnTypeNormal:
        {
            [_yuYueButton setTitle:@"预约" forState: UIControlStateNormal];
            _yuYueButton.backgroundColor = YuYueNormalColor;
            
            _yuYueButton.enabled = YES;
        }
            
            break;
        case YuYueBtnTypeFull:
        {
            [_yuYueButton setTitle:@"已约满" forState: UIControlStateNormal];
             _yuYueButton.backgroundColor = YuYueFailedColor;
            
            _yuYueButton.enabled = NO;
        }
            
            break;
        case YuYueBtnTypeDone:
        {
            [_yuYueButton setTitle:@"已预约" forState:UIControlStateNormal];
            _yuYueButton.backgroundColor = YuYueSuccessColor;
            _yuYueButton.enabled = NO;
        }
            
            break;
            
        default:
            break;
    }

}
-(void)corneradioforImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 14;
    imageView.layer.masksToBounds = YES;
}

@end
