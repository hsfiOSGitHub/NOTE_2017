//
//  EditEmergencyView.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditEmergencyView.h"

@implementation EditEmergencyView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (EditEmergencyView *)[self loadNibView];
        self.frame = frame;
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}

#pragma mark -awakeFromNib
-(void)awakeFromNib{
    [super awakeFromNib];
    self.maskBtn.alpha = 0.2;
}
//展示
-(void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskBtn.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}
//>>>>>>>点击事件
//点击maskBtn
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
}
//点击选项
- (IBAction)optionBtnACTION:(UIButton *)sender {
    NSString *title = @"";
    NSString *icon = @"";
    switch (sender.tag) {
        case 100:{//重要 紧急
            title = @"重要／紧急";
            icon = @"A";
        }
            break;
        case 200:{//重要 不紧急
            title = @"重要／不紧急";
            icon = @"B";
        }
            break;
        case 300:{//不重要 紧急
            title = @"不重要／紧急";
            icon = @"C";
        }
            break;
        case 400:{//不重要 不紧急
            title = @"不重要／不紧急";
            icon = @"D";
        }
            break;
            
        default:
            break;
    }
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditEmergencyView_noti" object:nil userInfo:@{@"title":title,@"icon":icon}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}



@end
