//
//  ColorPickerView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ColorPickerView.h"

@implementation ColorPickerView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubViews];
    }
    return self;
}

#pragma mark -创建子视图
-(void)createSubViews{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    //创建icon
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    self.icon.image = [UIImage imageNamed:@"color_hd_34coins"];
    self.icon.contentMode = UIViewContentModeCenter;
    [self addSubview:self.icon];
    //创建levelView
    self.levelView = [[UIView alloc]initWithFrame:CGRectMake(self.icon.width, 0, 0, self.height)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    [self addSubview:self.levelView];
    //创建颜色按钮
    self.level1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.level2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.level3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.level4Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.level5Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat levelViewWidth = KScreenWidth - self.icon.width;
    
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
    
    [self.levelView addSubview:self.level1Btn];
    [self.levelView addSubview:self.level2Btn];
    [self.levelView addSubview:self.level3Btn];
    [self.levelView addSubview:self.level4Btn];
    [self.levelView addSubview:self.level5Btn];
}

#pragma mark -打开、关闭
-(void)open{
    self.backgroundColor = [UIColor darkGrayColor];
    CGRect fromRect;
    CGRect toRect;
    CGFloat levelViewWidth = KScreenWidth - self.icon.width;
    CGPoint center = self.center;
    
    if (center.x < self.superview.width/2) {
        fromRect = CGRectMake(self.icon.width, 0, 0, self.levelView.height);
        toRect = CGRectMake(self.icon.width, 0, levelViewWidth, self.levelView.height);
        
        self.icon.frame = CGRectMake(0, 0, self.icon.width, self.icon.height);
        self.levelView.frame = fromRect;
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, self.y, KScreenWidth, self.height);
            self.levelView.frame = toRect;
        }];
    }else if (center.x >= self.superview.width/2) {
        fromRect = CGRectMake(levelViewWidth, 0, 0, self.levelView.height);
        toRect = CGRectMake(0, 0, levelViewWidth, self.levelView.height);
        
        self.icon.frame = CGRectMake(levelViewWidth, 0, self.icon.width, self.icon.height);
        self.levelView.frame = fromRect;
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, self.y, KScreenWidth, self.height);
            self.levelView.frame = toRect;
        }];
    }
}
-(void)close{
    self.backgroundColor = [UIColor clearColor];
    CGFloat levelViewWidth = KScreenWidth - self.icon.width;
    CGPoint center = self.icon.center;
    
    if (center.x < self.superview.width/2) {
        self.frame = CGRectMake(0, self.y, self.height, self.height);
        self.icon.frame = CGRectMake(0, 0, self.icon.width, self.icon.height);
        self.levelView.frame = CGRectMake(self.icon.width, 0, 0, self.levelView.height);
    }else if (center.x >= self.superview.width/2) {
        self.frame = CGRectMake(levelViewWidth, self.y, self.height, self.height);
        self.icon.frame = CGRectMake(0, 0, self.icon.width, self.icon.height);
        self.levelView.frame = CGRectMake(levelViewWidth, 0, 0, self.levelView.height);
    }
}
//拖动
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

@end
