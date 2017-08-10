//
//  HSFTimeProgressView.h
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSFTimeProgressView;

@protocol HSFTimeProgressViewDelegate <NSObject>

- (void)timeProgressViewWithSequenceView:(HSFTimeProgressView *)timeProgressView sequenceBtn:(UIButton *)sender ;

@end

@interface HSFTimeProgressView : UIView

@property (nonatomic,assign) id<HSFTimeProgressViewDelegate> delegate;


- (void)timeProgressViewWithTitleArr:(NSArray *)titleArr iconArr:(NSArray *)iconArr contentArr: (NSArray *)contentArr inScrollview:(UIScrollView*)scrollview;

@end
