//
//  UMComSelectTopicView.m
//  UMCommunity
//
//  Created by 张军华 on 16/3/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSelectTopicView.h"
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+Color.h>

//以下为iphone6的内部模板
const static int g_UMComSelectTopicView_leadmarginTemplate = 15;//左边空白区域
const static int g_UMComSelectTopicView_tailmarginTemplate = 13;//右边空白区域
const static int g_UMComSelectTopicView_ImageTopmargin = 13;//图片上边距
const static int g_UMComSelectTopicView_ImageWidth = 16;//图片宽
const static int g_UMComSelectTopicView_ImageHeight = 20;//图片高

const static int g_UMComSelectTopicView_IndicatorViewWidth = 20;//指示器的宽
const static int g_UMComSelectTopicView_IndicatorViewHeight = 20;//指示器的高

const static int g_UMComSelectTopicView_marginBetweenImageAndLabel = 6;//图片和文字区域的空白

@interface UMComSelectTopicView ()
@property (nonatomic, assign) CGFloat height;

@property (nonatomic,readwrite,strong) UILabel* placeholder;
@property (nonatomic,readwrite,strong)UITapGestureRecognizer* tap;
-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation UMComSelectTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithImage:UMComImageWithImageName(@"um_edit_#_normal")];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = UMComFontNotoSansLightWithSafeSize(15);
        self.label.textColor = UMComColorWithHexString(@"#A5A5A5");
        [self addSubview:self.label];
        
        
        self.indicatorView = [[UIImageView alloc] initWithImage:UMComImageWithImageName(@"um_edit_!_heilight")];
        self.indicatorView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.indicatorView];
        
        self.tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:self.tap];
    }
    return  self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.tap];
    
    self.imageView = nil;
    self.label = nil;
    self.indicatorView = nil;
    self.placeholder = nil;
}

-(void) doRelayoutChildControlsWithFrame:(CGRect)frame
{
    CGFloat parentHeight = frame.size.height;
    CGFloat parentWidth = frame.size.width;
    self.imageView.frame = CGRectMake(g_UMComSelectTopicView_leadmarginTemplate, g_UMComSelectTopicView_ImageTopmargin, g_UMComSelectTopicView_ImageWidth, g_UMComSelectTopicView_ImageHeight);
    
    
    self.indicatorView.frame = CGRectMake(parentWidth - g_UMComSelectTopicView_tailmarginTemplate - g_UMComSelectTopicView_IndicatorViewWidth, g_UMComSelectTopicView_ImageTopmargin, g_UMComSelectTopicView_IndicatorViewWidth, g_UMComSelectTopicView_IndicatorViewHeight);
    
    //计算label的位置
    self.label.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + g_UMComSelectTopicView_marginBetweenImageAndLabel,0, self.indicatorView.frame.origin.x - g_UMComSelectTopicView_marginBetweenImageAndLabel - self.imageView.frame.origin.x - self.imageView.frame.size.width,parentHeight);
}

-(void) hidePlaceholder:(BOOL)isHide
{
    self.placeholder.hidden = isHide;
    self.label.hidden = !isHide;
    self.imageView.hidden = !isHide;
}

-(void) relayoutChildControlsWithTopicName:(NSString*)topicName;
{
    if (!topicName) {
        //如果没有值就显示placeholder，隐藏其他控件
        //[self hidePlaceholder:NO];
        self.indicatorView.hidden = NO;
        self.imageView.image = UMComImageWithImageName(@"um_edit_#_normal");
        self.label.text = UMComLocalizedString(@"um_com_selectTopicView_prompt", @"所属话题");
        self.label.textColor = UMComColorWithHexString(@"#b5b5b5");
    }
    else if([topicName isEqualToString:@""])
    {
        //如果是空字符串，也隐藏其他控件
        self.indicatorView.hidden = YES;
        self.label.text = topicName;
        self.label.textColor = UMComColorWithHexString(@"#b5b5b5");
        //[self hidePlaceholder:NO];
    }
    else
    {
        self.indicatorView.hidden = YES;
        self.imageView.image = UMComImageWithImageName(@"um_edit_#_highlight");
        //如果有值就隐藏placeholder，显示其他控件
        self.label.text = topicName;
        self.label.textColor = UMComColorWithHexString(@"#008bea");
        //[self hidePlaceholder:YES];
    }
    
    [self doRelayoutChildControlsWithFrame:self.bounds];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    if (self.isDimed) {
        return;
    }
    
    if (YES) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (self.isDimed) {
        return;
    }
    
    if (YES) {
        if (self.locationbackgroudColor) {
            self.backgroundColor = self.locationbackgroudColor;
        }
        else{
            self.backgroundColor = [UIColor whiteColor];
        }
        
    }}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (self.isDimed) {
        return;
    }
    
    if (YES) {
        if (self.locationbackgroudColor) {
            self.backgroundColor = self.locationbackgroudColor;
        }
        else{
            self.backgroundColor = [UIColor whiteColor];
        }
    }
}


-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.seletctedTopicBlock) {
        self.seletctedTopicBlock();
    }
}

@end
