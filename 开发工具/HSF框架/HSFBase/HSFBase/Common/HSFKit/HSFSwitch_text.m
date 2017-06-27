//
//  HSFSwitch_text.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFSwitch_text.h"

@interface HSFSwitch_text ()

@property (nonatomic,strong) UILabel *onLabel;
@property (nonatomic,strong) UILabel *offLabel;
@property (nonatomic,strong) UIView *tintView;

@end

@implementation HSFSwitch_text

//类方法
+(instancetype)switchWithFrame:(CGRect)frame offText:(NSString *)offText onText:(NSString *)onText offColor:(UIColor *)offColor onColor:(UIColor *)onColor {
    HSFSwitch_text *sw = [[HSFSwitch_text alloc]initWithFrame:frame];
    
    sw.offLabel.text = offText;
    sw.onLabel.text = onText;
    
    sw.color_off = offColor;
    sw.color_on = onColor;
    
    return sw;
}
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kRGBColor(245, 245, 245);
        
        self.offLabel.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height);
        self.onLabel.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
        self.tintView.frame = CGRectMake(1, 1, frame.size.width/2 - 2, frame.size.height - 2);
        
        [self addSubview:self.offLabel];
        [self addSubview:self.onLabel];
        [self addSubview:self.tintView];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        
        self.tintView.layer.masksToBounds = YES;
        self.tintView.layer.cornerRadius = self.tintView.frame.size.height/2;
    }
    return self;
}


//打开
-(void)open{
    
}
//关闭
-(void)close{
    
}



#pragma mark -懒加载
-(UILabel *)onLabel{
    if (!_onLabel) {
        _onLabel = [[UILabel alloc]init];
        _onLabel.textAlignment = NSTextAlignmentCenter;
        _onLabel.textColor = [UIColor blackColor];
        _onLabel.font = [UIFont systemFontOfSize:12];
    }
    return _onLabel;
}
-(UILabel *)offLabel{
    if (!_offLabel) {
        _offLabel = [[UILabel alloc]init];
        _offLabel.textAlignment = NSTextAlignmentCenter;
        _offLabel.textColor = [UIColor blackColor];
        _offLabel.font = [UIFont systemFontOfSize:12];
    }
    return _offLabel;
}
-(UIView *)tintView{
    if (!_tintView) {
        _tintView = [[UIView alloc]init];
        _tintView.backgroundColor = [UIColor whiteColor];
    }
    return _tintView;
}


@end
