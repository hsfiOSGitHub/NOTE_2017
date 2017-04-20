//
//  AppDelegate.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/20.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class LeftMenuVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;




- (void)saveContext;


@end

