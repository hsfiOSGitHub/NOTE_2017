//
//  UMComHorizonMenuView.m
//  UMCommunity
//
//  Created by umeng on 15/11/26.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComSimpleHorizonMenuView.h"
#import "UMComResouceDefines.h"

@interface UMComSimpleHorizonMenuView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *currentLayout;

@property (nonatomic, strong) NSMutableDictionary *indexPathsDict;

@property (nonatomic, assign) BOOL isTheFirstTime;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong)  NSMutableArray* cellCenterXArray;//cell的中心点坐标Array

@end

@implementation UMComSimpleHorizonMenuView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArray = titles;
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame titles:nil];
    return self;
}


- (void)initSubViews
{
    self.cellCenterXArray = [NSMutableArray arrayWithCapacity:2];
    
    UICollectionViewFlowLayout *currentLayout = [[UICollectionViewFlowLayout alloc]init];
    currentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    NSInteger itemCount = self.titlesArray.count;
    if (itemCount == 0) {
        itemCount = 1;
    }
    currentLayout.itemSize = CGSizeMake(self.frame.size.width/itemCount, self.frame.size.height);
//    currentLayout.sectionInset = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    self.currentLayout = currentLayout;
    
    _isTheFirstTime = YES;
    _indexPathsDict = [NSMutableDictionary dictionary];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:currentLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UMComSimpleHorizonCollectionCell class] forCellWithReuseIdentifier:@"UMComHorizonCollectionCell"];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    
    self.backgroundColor = [UIColor clearColor];
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.titleFont = [UIFont systemFontOfSize:18];
    
    self.titleColor = [UIColor blackColor];
    self.titleHightColor = [UIColor blackColor];
    
    //不允许滚动,防止出现滚动条
    self.collectionView.scrollEnabled = NO;
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setShowScrollIndicator:(BOOL)showScrollIndicator
{
    _showScrollIndicator = showScrollIndicator;
    if (_showScrollIndicator == YES) {
        self.scrollIndicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.collectionView.frame.size.height, self.frame.size.width, 1)];
        self.scrollIndicatorView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollIndicatorView];
    }else{
        _scrollIndicatorView.hidden = YES;
    }
}

//- (void)startIndex:(NSInteger)index
//{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.25 animations:^{
//
//    }];
//}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComSimpleHorizonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UMComHorizonCollectionCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.label.font = self.titleFont;
    cell.label.text = self.titlesArray[indexPath.row];
    if (self.currentIndex == indexPath.row) {
        cell.label.textColor = self.titleHightColor;
    }else{
        cell.label.textColor = self.titleColor;
    }
    //设置中心点
    CGFloat cellCenterX =  cell.center.x;
    if (self.cellCenterXArray.count < self.titlesArray.count) {
        self.cellCenterXArray[indexPath.row] = @(cellCenterX);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UMComHorizonCollectionCell *cell = (UMComHorizonCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    _lastIndex = self.currentIndex;
    _currentIndex = indexPath.row;
    
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:didSelectedColumn:)]) {
        
        //选中的时候，动画scrollIndicatorView
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber* centerXNumber =  weakSelf.cellCenterXArray[indexPath.row];
            CGFloat  centerX = centerXNumber.floatValue;
            CGFloat  centerY  = weakSelf.scrollIndicatorView.center.y;
            weakSelf.scrollIndicatorView.center = CGPointMake(centerX, centerY);
        }];
        
        [self.cellDelegate horizonCollectionView:self didSelectedColumn:indexPath.row];
    }
    [self reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount = self.titlesArray.count;
    if (itemCount == 0) {
        itemCount = 1;
    }
   CGSize itemSize = CGSizeMake(collectionView.frame.size.width/itemCount, collectionView.frame.size.height);
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGRect frame = self.scrollIndicatorView.frame;
    frame.size.width = itemSize.width;
    self.scrollIndicatorView.frame = frame;
    return itemSize;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *color = [UIColor redColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGFloat itemSpaceTopEdge = 6;
//    for (int index = 1; index < self.itemCount; index++) {
//          CGContextStrokeRect(context, CGRectMake(index * self.itemSize.width, itemSpaceTopEdge, self.itemSpace, rect.size.height - itemSpaceTopEdge*2));
//    }
//}

@end


@implementation UMComSimpleHorizonCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-1)];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = UMComFontNotoSansLightWithSafeSize(15);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
}
    return self;
}

@end