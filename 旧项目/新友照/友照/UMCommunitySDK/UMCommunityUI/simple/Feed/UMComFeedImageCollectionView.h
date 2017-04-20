//
//  UMComFeedImageCollectionView.h
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComFeedImageCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *imageArray;

/**
 *设置列数
 */
@property (nonatomic,assign) NSInteger column;

/**
 *当前视图高度（根据）图片宽度计算各个图片高度 得出的总和
 */
@property (nonatomic, assign) CGFloat currentViewHeight;

/**
 *默认图片高度
 */
@property (nonatomic,assign) CGFloat defualtImageHeight;


@property (nonatomic, copy) void (^collectionRefreshBlock)(CGFloat imageHeight);

@end
