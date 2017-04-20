//
//  UMComHorizonMenuView.h
//  UMCommunity
//
//  Created by umeng on 15/11/26.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComSimpleHorizonCollectionCell,UMComSimpleHorizonMenuView,UMComDropdownColumnCell;


@protocol UMComSimpleHorizonMenuViewDelegate <NSObject>

@optional;

//- (NSInteger)numberOfRowInHorizonCollectionView:(UMComHorizonMenuView *)collectionView;
//
//- (void)horizonCollectionView:(UMComHorizonMenuView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//
- (void)horizonCollectionView:(UMComSimpleHorizonMenuView *)collectionView didSelectedColumn:(NSInteger)column;
//
//- (UIImage *)horizonCollectionView:(UMComHorizonMenuView *)collectionView imageForIndexPath:(NSIndexPath *)indexPath;
//
//- (UIImage *)horizonCollectionView:(UMComHorizonMenuView *)collectionView hilightImageForIndexPath:(NSIndexPath *)indexPath;
//
//- (NSString *)horizonCollectionView:(UMComHorizonMenuView *)collectionView titleForIndexPath:(NSIndexPath *)indexPath;

@end

@interface UMComSimpleHorizonMenuView : UIView

@property (nonatomic, assign) BOOL isHighLightWhenDidSelected;

@property (nonatomic, assign) BOOL showScrollIndicator;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic, readonly) NSInteger lastIndex;

@property (nonatomic, copy) UIColor *titleHightColor;

@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, strong) UIImageView *scrollIndicatorView;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, weak) id<UMComSimpleHorizonMenuViewDelegate> cellDelegate;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)startIndex:(NSInteger)index;

- (void)reloadData;

@end


@interface UMComSimpleHorizonCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) NSInteger index;


@end

