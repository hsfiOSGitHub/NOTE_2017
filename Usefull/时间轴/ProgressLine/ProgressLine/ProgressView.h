//
//  ProgressView.h
//  ProgressLine
//
//  Created by lujh on 2017/6/5.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressView;
@protocol sequenceViewDelegate <NSObject>

- (void)sequenceViewWithSequenceView:(ProgressView *)sequenceView sequenceBtn:(UIButton *)sequenceBtn ;

@end


@interface ProgressView : UIView

- (void)sequenceWith:(NSArray *)titleArr contentArr: (NSArray *)contentArr uiscrollview:(UIScrollView*)scrollview;

@property (nonatomic, weak) id<sequenceViewDelegate> delegate;

@end
