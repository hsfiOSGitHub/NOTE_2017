//
//  EditScheduleTagColorVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/3.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditScheduleTagColorVCDelegate <NSObject>

@optional

-(void)changeTagColorAtIndex:(NSInteger)index withColor:(UIColor *)color;

@end

@interface EditScheduleTagColorVC : UIViewController

@property (nonatomic,assign) NSInteger currentTagIndex;

@property (nonatomic,assign) id<EditScheduleTagColorVCDelegate> delegate;

@end
