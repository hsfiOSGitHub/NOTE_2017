//
//  UITableViewCell+WHC_AutoHeightForCell.h
//  Github <https://github.com/netyouli/WHC_AutoLayoutKit>
//
//  Created by 吴海超 on 16/2/17.
//  Copyright © 2016年 吴海超. All rights reserved.
//

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// VERSION:(2.6)

#import <UIKit/UIKit.h>

@interface UITableView (WHC_CacheCellHeight)

///// 缓存cell高度字典
//@property (nonatomic , strong) NSMutableDictionary * whc_CacheHeightDictionary;
//
//- (void)screenWillChange:(NSNotification *)notification;
//
//- (void)monitorScreenOrientation;
//
//- (NSMutableDictionary *)whc_CacheHeightDictionary;
@end
////////////////////////////列表视图//////////////////////////////

@interface UITableViewCell (WHC_AutoHeightForCell)
/// cell最底部视图
@property (nonatomic , strong) UIView * whc_CellBottomView;
/// cell最底部视图集合
@property (nonatomic , strong) NSArray * whc_CellBottomViews;
/// cell最底部视图与cell底部的间隙
@property (nonatomic , assign) CGFloat  whc_CellBottomOffset;
/// cell中包含的UITableView
@property (nonatomic , strong) UITableView * whc_CellTableView;
/// 指定tableview宽度（有助于提高自动计算效率）
@property (nonatomic , assign) CGFloat whc_TableViewWidth;

/// 自动计算cell高度
+ (CGFloat)whc_CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end

