//
//  DCMySelfHeadView.h
//  CDDMall
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCMySelfHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/** 商品收藏点击事件 */
@property (nonatomic, copy) dispatch_block_t goodsCollectionClickBlock;
/** 店铺收藏点击事件 */
@property (nonatomic, copy) dispatch_block_t shopCollectionClickBlock;
/** 我的足迹点击事件 */
@property (nonatomic, copy) dispatch_block_t myFootprintClickBlock;
/** 身边点击事件 */
@property (nonatomic, copy) dispatch_block_t mySideClickBlock;

/** 头像点击事件 */
@property (nonatomic, copy) dispatch_block_t myHeadImageViewClickBlock;

@end
