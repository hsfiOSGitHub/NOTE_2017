//
//  DCFiltrateHeaderView.h
//  CDDMall
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCFiltrateHeaderView : UICollectionReusableView

@property (nonatomic , copy) NSString *title;

/** 头部点击 */
@property (nonatomic, copy) dispatch_block_t sectionClick;

@end
