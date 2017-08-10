//
//  AYMenuData.h
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AYMenuItem;

@interface AYMenuData : NSObject

@property (nonatomic , strong)NSMutableArray *menuData;


- (NSArray*)ay_insertMenuAtIndexPaths:(AYMenuItem*)item;

- (NSArray*)ay_removeMenuAtIndexPaths:(AYMenuItem*)item;

@end
