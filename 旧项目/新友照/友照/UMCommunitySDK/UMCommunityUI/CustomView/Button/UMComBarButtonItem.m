//
//  UMComBarButtonItem.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComBarButtonItem.h"
#import "UMComButton.h"
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+Color.h>


@implementation UMComBarButtonItem

- (id)initWithNormalImageNameWithBackItem:(NSString *)imageName target:(id)target action:(SEL)action
{
    if(![imageName length]){
        return nil;
    }
    
    self.customButtonView = [[UMComButton alloc] initWithNormalImageName:imageName target:target action:action];
    //创建父控件---begin
    UIButton* containerBTN=  [UIButton buttonWithType:UIButtonTypeCustom];
    containerBTN.frame = self.customButtonView.bounds;
    [containerBTN addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [containerBTN addSubview:self.customButtonView];
    //创建父控件---end
    self = [super initWithCustomView:containerBTN];
    
    
    if(self){
    }
    
    return self;
}

- (id)initWithNormalImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    if(![imageName length]){
        return nil;
    }
    
    self.customButtonView = [[UMComButton alloc] initWithNormalImageName:imageName target:target action:action];
    self = [super initWithCustomView:self.customButtonView];
    
    
    if(self){
    }
    
    return self;
}

- (id)initWithNormalImageWithBackItem:(UIImage*)image target:(id)target action:(SEL)action
{
    if(!image){
        return nil;
    }
    
    self.customButtonView = [[UMComButton alloc] initWithNormalImage:image target:target action:action];
    //self.customButtonView = [[UMComButton alloc] initWithNormalImageName:imageName target:target action:action];
    //创建父控件---begin
    UIButton* containerBTN=  [UIButton buttonWithType:UIButtonTypeCustom];
    containerBTN.frame = self.customButtonView.bounds;
    [containerBTN addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [containerBTN addSubview:self.customButtonView];
    //创建父控件---end
    self = [super initWithCustomView:containerBTN];
    
    
    if(self){
    }
    
    return self;
    
}
- (id)initWithNormalImage:(UIImage *)image target:(id)target action:(SEL)action
{
    if(!image){
        return nil;
    }
    
    self.customButtonView = [[UMComButton alloc] initWithNormalImage:image target:target action:action];
    self = [super initWithCustomView:self.customButtonView];
    
    
    if(self){
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if(![title length]){
        return nil;
    }

    self.customButtonView = [UMComButton buttonWithType:UIButtonTypeCustom];
    [self.customButtonView setFrame:CGRectMake(0, 0, 65, 35)];
    [self.customButtonView setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.customButtonView setTitle:title forState:UIControlStateNormal];
    [self.customButtonView setTitleColor:UMComColorWithHexString(FontColorBlue) forState:UIControlStateNormal];

    [self.customButtonView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:self.customButtonView];
    return self;
}

- (id)initWithCustomView:(UIView*)customView
{
    if (!customView) {
        return nil;
    }
    self = [super initWithCustomView:customView];
    return self;
}

- (void)setItemFrame:(CGRect)itemFrame
{
    _itemFrame = itemFrame;
    self.customButtonView.frame = itemFrame;
}

@end
