//
//  DCFlowAttributeCell.h
//  CDDMall
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCFlowItem;

typedef enum : NSUInteger {
    DCFlowTypeImage  =   0,
    DCFlowTypeLabel  =   1,
} DCFlowType;

@interface DCFlowAttributeCell : UICollectionViewCell

/* 图片 */
@property (strong , nonatomic)UIImageView *flowImageView;
/* 名字 */
@property (strong , nonatomic)UILabel *flowTextLabel;
/* 数字 */
@property (strong , nonatomic)UILabel *flowNumLabel;

/* 属性type */
@property (assign , nonatomic)DCFlowType type;
/* 数据 */
@property (strong , nonatomic)DCFlowItem *flowItem;

/** 最后一个按钮是图片判断 */
@property (nonatomic,assign)BOOL lastIsImageView;

@end
