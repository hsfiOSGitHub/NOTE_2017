//
//  AYMenuItem.h
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYMenuItem : NSObject

@property (nonatomic , strong)NSString *title;//菜单标题
@property (nonatomic , assign)NSInteger level;//菜单级别
@property (nonatomic , strong)NSArray *subItems;//子级菜单
@property (nonatomic , assign)BOOL isSubItemsOpen;//菜单是否展开
@property (nonatomic , assign)BOOL isSubCascadeOpen;//子菜单是否要在其父菜单展开时自动展开


@end
