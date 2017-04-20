//
//  MarqueeView.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "SXMarquee.h"

@interface MarqueeView : SXMarquee

@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,assign) CGFloat fontSize; 
@property (nonatomic,strong) NSString *title;


@end
