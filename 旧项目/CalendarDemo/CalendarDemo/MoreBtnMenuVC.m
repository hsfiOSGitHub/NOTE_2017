//
//  MoreBtnMenuVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MoreBtnMenuVC.h"

@interface MoreBtnMenuVC ()

@property (nonatomic,strong) NSString *sound;

@end

@implementation MoreBtnMenuVC

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (MoreBtnMenuVC *)[self loadNibView];
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
    //配置subViews
    [self setUpSubViews];
    self.maskBtn.alpha = 0.1;
}
//配置subViews
-(void)setUpSubViews{
    self.scrollView.delegate = self;
    self.soundSlider.minimumValue = 0;
    self.soundSlider.maximumValue = 1.0;
    _sound = [HSF_UD objectForKey:@"sound"];
    if (!_sound || [_sound isEqualToString:@""]) {
        _sound = @"0.5";
    }
    self.soundSlider.value =  [_sound floatValue];
    [self.soundSlider setThumbImage:[UIImage imageNamed:@"sound_menu"] forState:UIControlStateNormal];
}

#pragma mark -//调节声音大小
- (IBAction)soundSliderACTION:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(dragSoundSliderWithValue:)]) {
        [self.delegate dragSoundSliderWithValue:self.soundSlider.value];
    }
    self.sound = [NSString stringWithFormat:@"%f",self.soundSlider.value];
}
- (IBAction)decreaseBtnACTION:(UIButton *)sender {
    if (self.soundSlider.value >= self.soundSlider.minimumValue) {
        self.soundSlider.value -= 0.1;
    }
    if (self.soundSlider.value == 0) {
        [self.soundSlider setThumbImage:[UIImage imageNamed:@"nosound_menu"] forState:UIControlStateNormal];
    }else{
        [self.soundSlider setThumbImage:[UIImage imageNamed:@"sound_menu"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(dragSoundSliderWithValue:)]) {
        [self.delegate dragSoundSliderWithValue:self.soundSlider.value];
    }
    self.sound = [NSString stringWithFormat:@"%f",self.soundSlider.value];
}
- (IBAction)increaseBtnACTION:(UIButton *)sender {
    if (self.soundSlider.value <= self.soundSlider.maximumValue) {
        self.soundSlider.value += 0.1;
    }
    if (self.soundSlider.value == 0) {
        [self.soundSlider setThumbImage:[UIImage imageNamed:@"nosound_menu"] forState:UIControlStateNormal];
    }else{
        [self.soundSlider setThumbImage:[UIImage imageNamed:@"sound_menu"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(dragSoundSliderWithValue:)]) {
        [self.delegate dragSoundSliderWithValue:self.soundSlider.value];
    }
    self.sound = [NSString stringWithFormat:@"%f",self.soundSlider.value];
}

#pragma mark -打开、关闭
//show
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBtn.alpha = 0.4;
        self.contentView.frame = CGRectMake(0, KScreenHeight - self.contentView.height, self.contentView.width, self.contentView.height);
    }];
}
//dismiss
-(void)dismiss{
    [self removeFromSuperview];
}
//点击maskBtn
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
    [HSF_UD setObject:_sound forKey:@"sound"];
}
//点击关闭按钮
- (IBAction)closeBtnACTION:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBtn.alpha = 0.1;
        self.contentView.frame = CGRectMake(0, KScreenHeight, self.contentView.width, self.contentView.height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    int i = (int)offsetX/(scrollView.width/2);
    self.pageC.currentPage = i;
}


@end
