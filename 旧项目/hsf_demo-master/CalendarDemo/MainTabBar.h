//
//  MainTabBar.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTabBarAgency <NSObject>

@optional

-(void)clickCenterBtnEvent;

@end

@interface MainTabBar : UITabBar

@property (nonatomic,assign) id<MainTabBarAgency> agency;

@end
