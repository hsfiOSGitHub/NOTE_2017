//
//  AYMenuData.m
//  AYMenuList
//
//  Created by Andy on 2017/4/26.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "AYMenuData.h"
#import "AYMenuItem.h"
#import <UIKit/UIKit.h>


@interface AYMenuData ()


@property (nonatomic , strong)AYMenuItem *rootMenuItem;
@property (nonatomic , strong)NSMutableArray *treeItemsInsert;
@property (nonatomic , strong)NSMutableArray *treeItemsRemove;



@end

@implementation AYMenuData

- (NSArray *)ay_insertMenuAtIndexPaths:(AYMenuItem *)item{
    [self.treeItemsInsert removeAllObjects];
    [self ay_insertSubMenuItems:item];
    return [self ay_insertIndexsOfInsertItems:self.treeItemsInsert];
}


/**
 添加子菜单

 @param item 点击菜单模型
 */
- (void)ay_insertSubMenuItems:(AYMenuItem*)item{
    
    /**
     通过便利菜单数据，将子级菜单添加到列表要显示的数组，更改数据源，刷新 tableView 实现子级菜单展开。
     采用递归算法实现便历。
     */
    
    if (item == nil) {
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_menuData indexOfObject:item] inSection:0];
    AYMenuItem *subItem ;
    for (int i = 0; i < item.subItems.count ; i++) {
        subItem = item.subItems[i];
        [_menuData insertObject:subItem atIndex:path.row + i + 1];
        [self.treeItemsInsert addObject:subItem];
        item.isSubItemsOpen = YES;
    }
    
    for (AYMenuItem *childItem in item.subItems) {
        if (childItem.isSubCascadeOpen) {
            [self ay_insertSubMenuItems:childItem];
        }
        
    }
}

- (NSArray*)ay_insertIndexsOfInsertItems:(NSMutableArray*)insertItemsArray{
    
    /**
    遍历要插入菜单数据，得到插入数据在tableView中的indexPaths，刷新列表
    */
    NSMutableArray *insertIndesPathsArray = [NSMutableArray array];
    for (AYMenuItem *item in insertItemsArray) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_menuData indexOfObject:item] inSection:0];
        [insertIndesPathsArray addObject:path];
    }
    return [insertIndesPathsArray copy];
}




/**
 删除子菜单

 @param item 要删除的节点
 @return 要删除菜单的位置
 */
- (NSArray *)ay_removeMenuAtIndexPaths:(AYMenuItem *)item{
    
    [self.treeItemsRemove removeAllObjects];
    [self ay_removeSubItems:item];
    return [self ay_removeIndexPathsOfRemoveItems:self.treeItemsRemove];
}

- (void)ay_removeSubItems:(AYMenuItem*)item{
    
    if (item == nil) {
        return;
    }
    if (item.isSubItemsOpen) {
        for (AYMenuItem *subItem in item.subItems) {
            [self ay_removeSubItems:subItem];
            [self.treeItemsRemove addObject:subItem];
        }
    }
    
    item.isSubItemsOpen = NO;
}

- (NSArray*)ay_removeIndexPathsOfRemoveItems:(NSMutableArray*)removeItemsArray{
    
    NSMutableArray *removeIndexParhsArray = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (AYMenuItem *item in removeItemsArray) {
        NSIndexPath *path = [NSIndexPath  indexPathForRow:[_menuData indexOfObject:item] inSection:0];
        [removeIndexParhsArray addObject:path];
        [indexSet addIndex:path.row];
    }
    
    [_menuData removeObjectsAtIndexes:indexSet];
    return [removeIndexParhsArray copy];
}




#pragma mark ---- 懒加载 ----
- (NSMutableArray *)treeItemsInsert{
    if (!_treeItemsInsert) {
        _treeItemsInsert = [NSMutableArray array];
    }
    return _treeItemsInsert;
}

- (NSMutableArray *)treeItemsRemove{
    if (!_treeItemsRemove) {
        _treeItemsRemove = [NSMutableArray array];
    }
    return _treeItemsRemove;
}



@end
