//
//  AYMenuView.h
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AYMenuView;
@class AYMenuItem;

@protocol AYMenuViewDelegate <NSObject>

@required
- (NSMutableArray*)ay_dataArrayInMenuView:(AYMenuView*)menuView;

- (void)ay_menuView:(AYMenuView*)menuView didDeselectRowAtIndexPath:(NSIndexPath*)indexPaths;

@optional
- (void)ay_menuView:(AYMenuView*)menuView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*)ay_menuView:(AYMenuView*)menuView tableView:(UITableView*)tableView cellForRowWithMenuItem:(AYMenuItem*)item;

@end

@interface AYMenuView : UIView

@property (nonatomic , weak)id<AYMenuViewDelegate> delegate;


@end
