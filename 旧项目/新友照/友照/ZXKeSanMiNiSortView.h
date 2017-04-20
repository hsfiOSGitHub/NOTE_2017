//
//  ZXKeSanMiNiSortView.h
//  ZXJiaXiao
//
//  Created by yujian on 16/5/13.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ZXKeSanMoNiSortType) {
    
    ZXKeSanMoNiSortTypeNone = 0,
    ZXKeSanMoNiSortTypeAll,
    ZXKeSanMoNiSortTypeDefault,

};
typedef void(^SelectedBlock)(NSString * changeValue,ZXKeSanMoNiSortType sortType);

@class ZXKeSanMoNiViewController;
@interface ZXKeSanMiNiSortView : UIView

@property (nonatomic, assign)  ZXKeSanMoNiSortType sortType;
//所有车辆类型的block
@property (nonatomic, copy) SelectedBlock SelectedTypeAll;


- (instancetype)initWithFrame:(CGRect)frame andSortType:(ZXKeSanMoNiSortType)sortType
             ;

@end
