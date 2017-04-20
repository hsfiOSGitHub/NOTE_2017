//
//  EditScheduleContentVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/28.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditScheduleContentVCDelegate <NSObject>

@optional

-(void)endEditContentWith:(NSString *)content;

@end

@interface EditScheduleContentVC : UIViewController
@property (nonatomic,strong) NSString *contentStr;

@property (nonatomic,strong) id<EditScheduleContentVCDelegate> delegate;

@end
