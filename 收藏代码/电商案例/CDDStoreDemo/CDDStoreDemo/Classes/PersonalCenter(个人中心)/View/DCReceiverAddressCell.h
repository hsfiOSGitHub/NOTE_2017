//
//  DCReceiverAddressCell.h
//  CDDMall
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCAddressItem;

@interface DCReceiverAddressCell : UITableViewCell
/* 地址数组 */
@property (strong , nonatomic)DCAddressItem *adItem;

/** 默认地址点击回调 */
@property (nonatomic, copy) dispatch_block_t defaultClickBlock;
/** 编辑点击回调 */
@property (nonatomic, copy) dispatch_block_t editClickBlock;
/** 删除点击回调 */
@property (nonatomic, copy) dispatch_block_t delectClickBlock;

@end
