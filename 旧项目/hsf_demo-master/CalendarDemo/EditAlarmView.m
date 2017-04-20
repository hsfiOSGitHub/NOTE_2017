//
//  EditAlarmView.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditAlarmView.h"

@implementation EditAlarmView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (EditAlarmView *)[self loadNibView];
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
    self.maskBtn_alarm.alpha = 0.2;
}
//展示
-(void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskBtn_alarm.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}
//>>>>>>>点击事件
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)optionBtnACTION:(UIButton *)sender {
    NSString *title = @"";
    switch (sender.tag) {
        case 100:{//不提醒
            title = @"不提醒";
        }
            break;
        case 200:{//准点提醒
            title = @"准点提醒";
        }
            break;
        case 300:{//提前5分钟
            title = @"提前5分钟";
        }
            break;
        case 400:{//提前10分钟
            title = @"提前10分钟";
        }
            break;
        case 500:{//提前30分钟
            title = @"提前30分钟";
        }
            break;
        case 600:{//提前1小时
            title = @"提前1小时";
        }
            break;
        case 700:{//自定义
            title = @"自定义";
        }
            break;
            
        default:
            break;
    }
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditAlarmView_noti" object:nil userInfo:@{@"title":title}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


@end
