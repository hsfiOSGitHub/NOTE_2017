//
//  DCPersonalCenterViewController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define DCHeadImageTopY 180

#import "DCPersonalCenterViewController.h"

// Controllers
#import "DCSettingViewController.h"
#import "DCMessageViewController.h"
#import "DCGoodsSetViewController.h"
#import "DCMySelfMessageViewController.h"
// Models
#import "DCFlowItem.h"
#import "DCRecommendItem.h"
// Views
#import "DCHoverNavView.h"
#import "DCMySelfHeadView.h"    //头部
#import "DCFlowAttributeCell.h" //属性
#import "DCGoodsYouLikeCell.h"  //猜你喜欢
#import "DCOverFootView.h"      //结束
#import "DCYouLikeHeadView.h"   //猜你喜欢等头部标语
// Vendors
#import <MJExtension.h>
// Categories
#import "UIBarButtonItem+DCBarButtonItem.h"
// Others

@interface DCPersonalCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collection */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

/* 购买流程属性 */
@property (strong , nonatomic)NSMutableArray<DCFlowItem *> *buyFlowItem;
/* 娱乐属性 */
@property (strong , nonatomic)NSMutableArray<DCFlowItem *> *recreationFlowItem;
/* 推荐商品属性 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *youLikeItem;
/* 自定义导航栏 */
@property (strong , nonatomic)DCHoverNavView *hoverNavView;
@end

static NSInteger offsetY_;
static NSString *const DCMySelfHeadViewID = @"DCMySelfHeadView";
static NSString *const DCFlowAttributeCellID = @"DCFlowAttributeCell";
static NSString *const DCGoodsYouLikeCellID = @"DCGoodsYouLikeCell";
static NSString *const DCOverFootViewID = @"DCOverFootView";
static NSString *const DCYouLikeHeadViewID = @"DCYouLikeHeadView";
@implementation DCPersonalCenterViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.frame = CGRectMake(0, -DCHeadImageTopY, ScreenW, ScreenH - DCBottomTabH + DCHeadImageTopY);
        
        //头部
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DCMySelfHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCMySelfHeadViewID];
        [_collectionView registerClass:[DCYouLikeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID];
        //尾部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"]; //分割线
        [_collectionView registerClass:[DCOverFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID];
        //cell
        [_collectionView registerClass:[DCFlowAttributeCell class] forCellWithReuseIdentifier:DCFlowAttributeCellID];
        [_collectionView registerClass:[DCGoodsYouLikeCell class] forCellWithReuseIdentifier:DCGoodsYouLikeCellID];

    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpNav];
    
    [self setUpData];
    
    [self setUpScrollToTopView];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.view.backgroundColor = DCBGColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 加载数据
- (void)setUpData
{
    _buyFlowItem = [DCFlowItem mj_objectArrayWithFilename:@"MyBuyFlow.plist"];
    _recreationFlowItem = [DCFlowItem mj_objectArrayWithFilename:@"MyRecreationFlow.plist"];
    _youLikeItem = [DCRecommendItem mj_objectArrayWithFilename:@"YouLikeGoods.plist"];
}

#pragma mark - 滚回顶部
- (void)setUpScrollToTopView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 110, 40, 40);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == 0 || section == 1) ? 5 : (section == 2) ? 8 : 10;
}
#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
   if (indexPath.section == 3) {//猜你喜欢
       DCGoodsYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsYouLikeCellID forIndexPath:indexPath];
       cell.youLikeItem = _youLikeItem[indexPath.row];
       cell.sameButton.hidden = YES;
       gridcell = cell;
    }
    else {//属性
        DCFlowAttributeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFlowAttributeCellID forIndexPath:indexPath];
        NSArray *titles = @[@"账户余额",@"优惠券",@"美豆",@"美通卡",@"我的金融"];
        cell.backgroundColor = (indexPath.row == titles.count - 1 && indexPath.section != 2) ? RGB(249, 249, 249) : [UIColor whiteColor];
        if (indexPath.section == 0) {
            cell.type = DCFlowTypeImage;
            cell.flowItem = _buyFlowItem[indexPath.row];
        }else if (indexPath.section == 1){
            cell.type = DCFlowTypeLabel;
            if (indexPath.row == titles.count - 1) {
                cell.lastIsImageView = YES;
                cell.flowImageView.image = [UIImage imageNamed:@"wodejingrong"];
            }else{
                cell.lastIsImageView = NO;
                cell.flowNumLabel.text = @"0";
            }
            cell.flowTextLabel.text = titles[indexPath.row];
        }else{
            cell.type = DCFlowTypeImage;
            cell.flowItem = _recreationFlowItem[indexPath.row];
        }
        gridcell = cell;
    }
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            DCMySelfHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCMySelfHeadViewID forIndexPath:indexPath];
            __weak typeof(self)weakSelf = self;
            DCUserInfo *userInfo = UserInfoData;
            UIImage *image = ([userInfo.userimage isEqualToString:@"icon"]) ? [UIImage imageNamed:@"icon"] : [DCSpeedy Base64StrToUIImage:userInfo.userimage];
            headerView.nickNameLabel.text = userInfo.nickname;
            [headerView.headImageButton setImage:image forState:UIControlStateNormal];
            
            headerView.goodsCollectionClickBlock = ^{
                NSLog(@"点击了商品收藏");
            };
            headerView.shopCollectionClickBlock = ^{
                NSLog(@"点击了店铺收藏");
            };
            headerView.myFootprintClickBlock = ^{
                NSLog(@"点击了我的足迹");
            };
            headerView.mySideClickBlock = ^{
                NSLog(@"点击了身边");
            };
            headerView.myHeadImageViewClickBlock = ^{
                NSLog(@"点击了头像");
                DCMySelfMessageViewController *selfVc = [[DCMySelfMessageViewController alloc] init];
                [weakSelf.navigationController pushViewController:selfVc animated:YES];
            };
            reusableview = headerView;
        }else if (indexPath.section == 3){
            DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
            [headerView.likeButton setTitle:@"热门推荐" forState:UIControlStateNormal];
            [headerView.likeButton setTitleColor:RGB(14, 122, 241) forState:UIControlStateNormal];
            [headerView.likeButton setImage:[UIImage imageNamed:@"shouye_icon02"] forState:UIControlStateNormal];
            reusableview = headerView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
            UICollectionReusableView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            footview.backgroundColor = DCBGColor;
            reusableview = footview;
        }else if (indexPath.section == 3){
            DCOverFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {//属性
        return CGSizeMake(ScreenW/5 , 80);
    }
    if (indexPath.section == 2) {//属性
        return CGSizeMake(ScreenW/4, 80);
    }
    if (indexPath.section == 3) {//猜你喜欢
        return CGSizeMake((ScreenW - 4)/2, (ScreenW - 4)/2 + 40);
    }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return (section == 0) ? CGSizeMake(ScreenW, 400) : (section == 3) ? CGSizeMake(ScreenW, 40) : CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return (section == 3) ? CGSizeMake(ScreenW, 40) : CGSizeMake(ScreenW, DCMargin);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 3) ? 4 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 3) ? 4 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了10个第%zd属性第%zd",indexPath.section,indexPath.row);
    if (indexPath.section == 3) {
        DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init];
        goodSetVc.goodPlisName = @"ClasiftyGoods.plist";
        [self.navigationController pushViewController:goodSetVc animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
}

#pragma mark - 判断当前ScrollView是上拉还是下拉BeginDragging，BeginDecelerating
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    offsetY_ = scrollView.contentOffset.y;

}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    __weak typeof(self)weakSlef = self;
    [UIView animateWithDuration:0.3 animations:^{
        if (scrollView.contentOffset.y < offsetY_){
            weakSlef.hoverNavView.dc_y = DCHeadImageTopY - 70;
        }
    }completion:^(BOOL finished) {
        weakSlef.hoverNavView.dc_y = -100;
        [UIView animateWithDuration:0.4 animations:^{
            weakSlef.hoverNavView.dc_y = DCHeadImageTopY;
        }];
    }];
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


#pragma mark - 导航栏
- (void)setUpNav
{
    _hoverNavView = [[DCHoverNavView alloc] init];
    [self.collectionView insertSubview:_hoverNavView atIndex:0];
    _hoverNavView.frame = CGRectMake(0, DCHeadImageTopY, ScreenW, 64);
    __weak typeof(self)weakSelf = self;
    _hoverNavView.leftItemClickBlock = ^{
        [weakSelf settingItemClick];
    };
    _hoverNavView.rightItemClickBlock = ^{
        [weakSelf messageItemClick];
    };
}

#pragma mark - 设置
- (void)settingItemClick
{
    DCSettingViewController *settingVC = [[DCSettingViewController alloc] init];
    settingVC.title = @"设置";
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - 消息
- (void)messageItemClick
{
    DCMessageViewController *messageVc = [[DCMessageViewController alloc] init];
    messageVc.title = @"消息中心";
    [self.navigationController pushViewController:messageVc animated:YES];
}

#pragma 设置StatusBar为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
