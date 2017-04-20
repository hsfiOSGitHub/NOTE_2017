//
//  EditScheduleTagVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/29.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditScheduleTagVCDelegate <NSObject>

@optional

-(void)backToEditScheduleVCWithCurrentTags:(NSArray *)currentTags;

@end

@interface EditScheduleTagVC : UIViewController

@property (nonatomic,strong) NSString *tagsStr;

@property (nonatomic,assign) id<EditScheduleTagVCDelegate> delegate;

@end
