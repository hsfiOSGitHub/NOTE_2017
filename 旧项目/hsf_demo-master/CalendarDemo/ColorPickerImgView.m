//
//  ColorPickerImgView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ColorPickerImgView.h"

@implementation ColorPickerImgView

- (id)initWithFrame:(CGRect)frame  
{  
    self = [super initWithFrame:frame];  
    if (self) {  
        // Initialization code  
        //允许用户交互  
        self.userInteractionEnabled = YES;  
    }  
    return self;  
}  

- (id)initWithImage:(UIImage *)image  
{  
    self = [super initWithImage:image];  
    if (self) {  
        //允许用户交互  
        self.userInteractionEnabled = YES;  
    }  
    return self;  
}  

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    //保存触摸起始点位置  
    CGPoint point = [[touches anyObject] locationInView:self];  
    startPoint = point;  
    
    //该view置于最前  
    [[self superview] bringSubviewToFront:self];  
}  

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  
{  
    //计算位移=当前位置-起始位置  
    CGPoint point = [[touches anyObject] locationInView:self];  
    float dx = point.x - startPoint.x;  
    float dy = point.y - startPoint.y;  
    
    //计算移动后的view中心点  
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);  
    
    
    /* 限制用户不可将视图托出屏幕 */  
    float halfx = CGRectGetMidX(self.bounds);  
    //x坐标左边界  
    newcenter.x = MAX(halfx, newcenter.x);  
    //x坐标右边界  
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);  
    
    //y坐标同理  
    float halfy = CGRectGetMidY(self.bounds);  
    newcenter.y = MAX(halfy, newcenter.y);  
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);  
    
    //移动view  
    self.center = newcenter;  
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint center = self.center;
    if (center.x < self.superview.width/2) {
        center.x = self.width/2;
    }
    if (center.x >= self.superview.width/2) {
        center.x = self.superview.width - self.width/2;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.center = center;
    }];
    
}

//>>>>>>>>>>>>>>>>>>>>>>>
-(void)open{
    self.backgroundColor = [UIColor darkGrayColor];
    CGRect fromRect;
    CGRect toRect;
    CGFloat levelViewWidth = self.superview.width - self.width;
    CGPoint center = self.center;
    if (center.x < self.superview.width/2) {
        fromRect = CGRectMake(self.width, 0, 0, self.height);
        toRect = CGRectMake(self.width, 0, levelViewWidth, self.height);
    }else if (center.x >= self.superview.width/2) {
        fromRect = CGRectMake(0, 0, 0, self.height);
        toRect = CGRectMake(-levelViewWidth, 0, levelViewWidth, self.height);
    }
    self.levelView.frame = fromRect;
    [UIView animateWithDuration:0.3 animations:^{
        self.levelView.frame = toRect;
    }];
}
-(void)close{
    CGRect fromRect;
    CGRect toRect;
    CGFloat levelViewWidth = self.superview.width - self.width;
    CGPoint center = self.center;
    if (center.x < self.superview.width/2) {
        toRect = CGRectMake(self.width, 0, 0, self.height);
        fromRect = CGRectMake(self.width, 0, levelViewWidth, self.height);
    }else if (center.x >= self.superview.width/2) {
        toRect = CGRectMake(0, 0, 0, self.height);
        fromRect = CGRectMake(-levelViewWidth, 0, levelViewWidth, self.height);
    }
    self.levelView.frame = fromRect;
    [UIView animateWithDuration:0.3 animations:^{
        self.levelView.frame = toRect;
    }];
}
//>>>>>>>>>>>>>>>>>>>>>>>
-(UIView *)levelView{
    if (!_levelView) {
        _levelView = [[UIView alloc]init];
        _levelView.clipsToBounds = YES;
        _levelView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_levelView];
        self.level1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.level2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.level3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.level4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.level5Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat levelViewWidth = self.superview.width - self.width;
        
        self.level1Btn.frame = CGRectMake(0, 0, levelViewWidth/5, self.height);
        self.level2Btn.frame = CGRectMake(levelViewWidth/5, 0, levelViewWidth/5, self.height);
        self.level3Btn.frame = CGRectMake(levelViewWidth/5 * 2, 0, levelViewWidth/5, self.height);
        self.level4Btn.frame = CGRectMake(levelViewWidth/5 * 3, 0, levelViewWidth/5, self.height);
        self.level5Btn.frame = CGRectMake(levelViewWidth/5 * 4, 0, levelViewWidth/5, self.height);
        
        [self.level1Btn setTitle:@"尽兴娱乐" forState:UIControlStateNormal];
        [self.level2Btn setTitle:@"休息放松" forState:UIControlStateNormal];
        [self.level3Btn setTitle:@"高效工作" forState:UIControlStateNormal];
        [self.level4Btn setTitle:@"强迫工作" forState:UIControlStateNormal];
        [self.level5Btn setTitle:@"无效工作" forState:UIControlStateNormal];
        
        self.level1Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.level2Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.level3Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.level4Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.level5Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.level1Btn setImage:[UIImage imageNamed:@"color_level1_34coins"] forState:UIControlStateNormal];
        [self.level2Btn setImage:[UIImage imageNamed:@"color_level2_34coins"] forState:UIControlStateNormal];
        [self.level3Btn setImage:[UIImage imageNamed:@"color_level3_34coins"] forState:UIControlStateNormal];
        [self.level4Btn setImage:[UIImage imageNamed:@"color_level4_34coins"] forState:UIControlStateNormal];
        [self.level5Btn setImage:[UIImage imageNamed:@"color_level5_34coins"] forState:UIControlStateNormal];
        
        [self.level1Btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.level2Btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.level3Btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.level4Btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.level5Btn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
        
        [self addSubview:self.level1Btn];
        [self addSubview:self.level2Btn];
        [self addSubview:self.level3Btn];
        [self addSubview:self.level4Btn];
        [self addSubview:self.level5Btn];
    }
    return _levelView;
}
-(void)createSubviews{
    
}


/*  
 // Only override drawRect: if you perform custom drawing.  
 // An empty implementation adversely affects performance during animation.  
 - (void)drawRect:(CGRect)rect  
 {  
 // Drawing code  
 }  
 */  

@end
