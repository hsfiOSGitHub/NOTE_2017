//
//  HWAdAlretView.h
//  HWAdAlertView
//
//  Created by Lee on 2017/4/25.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWAdAlertViewDelegate <NSObject>

-(void)alertViewClickedIndex:(NSInteger)index;

@end

@interface HWAdAlretView : UIView

+ (HWAdAlretView *)showInView:(UIView *)view delegate:(id)delegate adDataArray:(NSArray *)adList;
@property (nonatomic, weak) id <HWAdAlertViewDelegate>delegate;

@end

@interface HWAlterItemView : UIView

@property (nonatomic, assign) NSInteger currentIndex;//当前的item

@property (nonatomic, strong) UIImageView * imageView;

@end
