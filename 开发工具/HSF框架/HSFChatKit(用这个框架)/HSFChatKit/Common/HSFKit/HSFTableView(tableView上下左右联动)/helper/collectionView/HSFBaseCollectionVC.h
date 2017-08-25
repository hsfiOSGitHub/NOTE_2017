//
//  HSFBaseCollectionVC.h
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/11.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseVC.h"

@class HSFBaseCollectionView;

@interface HSFBaseCollectionVC : BaseVC

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic,strong) HSFBaseCollectionView *collectionView;

@end
