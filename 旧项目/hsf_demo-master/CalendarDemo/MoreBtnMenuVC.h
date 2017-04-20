//
//  MoreBtnMenuVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreBtnMenuVCDelegate <NSObject>

@optional

-(void)dragSoundSliderWithValue:(CGFloat)value;

@end

@interface MoreBtnMenuVC : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *maskBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIButton *increaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;
@property (weak, nonatomic) IBOutlet UISlider *soundSlider;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageC;

@property (nonatomic,assign) id<MoreBtnMenuVCDelegate>delegate;

//show
-(void)show;

@end
