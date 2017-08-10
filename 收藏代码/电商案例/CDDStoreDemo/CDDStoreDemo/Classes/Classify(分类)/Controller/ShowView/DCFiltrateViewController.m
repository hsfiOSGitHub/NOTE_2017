//
//  DCFiltrateViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/16.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#define FiltrateViewScreenW ScreenW * 0.7

#import "DCFiltrateViewController.h"

// Controllers

// Models
#import "DCFiltrateItem.h"
// Views
#import "DCFiltrateAttrCell.h"
#import "DCFiltrateHeaderView.h"
// Vendors
#import <MJExtension.h>
#import "UIViewController+XWTransition.h"
// Categories

// Others

@interface DCFiltrateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 筛选父View */
@property (strong , nonatomic)UIView *filtrateConView;

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (nonatomic , strong) NSMutableArray<DCFiltrateItem *> *filtrateItem;

@end

static NSString * const DCFiltrateAttrCellID = @"DCFiltrateAttrCell";
static NSString * const DCFiltrateHeaderViewID = @"DCFiltrateHeaderView";

@implementation DCFiltrateViewController

#pragma mark - LazyLoad

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;

        [_collectionView registerClass:[DCFiltrateAttrCell class] forCellWithReuseIdentifier:DCFiltrateAttrCellID];
        
        [_collectionView registerClass:[DCFiltrateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFiltrateHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpFootprintAlterView];
    
    [self setUpInit];
    
    [self setUpFiltrateData];
    
    [self setUpBottomButton];
}

#pragma mark - initialize
- (void)setUpInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    _filtrateConView = [[UIView alloc] init];
    _filtrateConView.backgroundColor = self.view.backgroundColor;
    
    _filtrateConView.frame = CGRectMake(0, 0, FiltrateViewScreenW, ScreenH);
    [self.view addSubview:_filtrateConView];
    
    [_filtrateConView addSubview:self.collectionView];
    _collectionView.frame = CGRectMake(5, 0, FiltrateViewScreenW - DCMargin, ScreenH - 50);
}

#pragma mark - 筛选Item数据
- (void)setUpFiltrateData
{
    _filtrateItem = [DCFiltrateItem mj_objectArrayWithFilename:@"FiltrateItem.plist"];
}

#pragma mark - 底部重置确定按钮
- (void)setUpBottomButton
{
    CGFloat buttonW = FiltrateViewScreenW/2;
    CGFloat buttonH = 50;
    CGFloat buttonY = ScreenH - buttonH;
    NSArray *titles = @[@"重置",@"确定"];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i;
        if (i == 0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        CGFloat buttonX = i*buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        button.titleLabel.font = PFR16Font;
        button.backgroundColor = (i == 0) ? self.collectionView.backgroundColor : [UIColor redColor];
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_filtrateConView addSubview:button];
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.filtrateItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.filtrateItem[section].isOpen ? self.filtrateItem[section].content.count + self.filtrateItem[section].header.count: self.filtrateItem[section].header.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFiltrateAttrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFiltrateAttrCellID forIndexPath:indexPath];
    
    cell.content = self.filtrateItem[indexPath.section].header[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        
        DCFiltrateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFiltrateHeaderViewID forIndexPath:indexPath];
        headerView.title = _filtrateItem[indexPath.section].title;
        
        return headerView;
    }else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        [DCSpeedy dc_setUpAcrossPartingLineWith:footerView WithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.4]];
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((FiltrateViewScreenW - 7 * 5) / 3, 22);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.collectionView.dc_width, 55);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(FiltrateViewScreenW, DCMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
#pragma mark - 弹出弹框
- (void)setUpFootprintAlterView
{
    XWInteractiveTransitionGestureDirection direction = XWInteractiveTransitionGestureDirectionLeft;
    __weak typeof(self)weakSelf = self;
    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
        [weakSelf selfViewBack];
    } edgeSpacing:80];
}


#pragma mark - 展开列表
- (void)openSection:(NSInteger)section{
    
    if (!self.filtrateItem[section].content) {return;}
    [self.collectionView insertItemsAtIndexPaths:[self getIndexArray:section]];
}

#pragma mark - 关闭列表
- (void)closeSection:(NSInteger)section{
    
    if (!self.filtrateItem[section].content) {return;}
    [self.collectionView deleteItemsAtIndexPaths:[self getIndexArray:section]];
}

#pragma mark - 获得需要展开的数据
- (NSMutableArray *)getIndexArray : (NSInteger)section {
    
    NSMutableArray *indexArray = [NSMutableArray array];
    NSInteger subCount = self.filtrateItem[section].content.count;
    if (subCount <= 0) {return nil;}
    
    for (int i = 0; i < subCount; i++) {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexArray addObject:indexpath];
    }
    return indexArray;
}


#pragma mark - 退出当前View
- (void)selfViewBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击事件
- (void)bottomButtonClick:(UIButton *)button
{
    if (button.tag == 0) {//重置点击
        [self.collectionView reloadData];
    }else if (button.tag == 1){//确定点击
        
    }
}

@end
