//
//  EditPicView.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditPicView.h"

@implementation EditPicView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (EditPicView *)[self loadNibView];
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
    self.maskBtn_pic.alpha = 0.2;
}
//展示
-(void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskBtn_pic.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}

//>>>>>>>>>点击事件
- (IBAction)maskBtn_picACTION:(UIButton *)sender {
    [self removeFromSuperview];
}
//点击相册
- (IBAction)photoBtnACTION:(UIButton *)sender {
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPicView_photo" object:nil userInfo:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
//点击拍照
- (IBAction)cameraBtnACTION:(UIButton *)sender {
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kEditPicView_camera" object:nil userInfo:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}




@end
