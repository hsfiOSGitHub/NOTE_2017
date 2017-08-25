//
//  HSFBaseCollectionVC.m
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/11.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFBaseCollectionVC.h"

#import "HSFBaseCollectionView.h"

@interface HSFBaseCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@end

@implementation HSFBaseCollectionVC

#pragma mark -viewDidLoad
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //配置collectionView
    [self setUpCollectionView];
}

//配置collectionView
-(void)setUpCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[HSFBaseCollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    //代理设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册item header footer
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsItem class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GoodsItem class])];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopHomeHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ShopHomeHeader class])];
    
    //    //下拉刷新
    //    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //    }];
    //    //上啦加载更多
    //    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //
    //    }];
}


#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2, kScreenWidth/2 * 5/3);
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


#pragma mark -点击事件
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        if (!self.vcCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.vcCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCScrollState" object:nil userInfo:nil];//到顶通知父视图改变状态
        }
        self.collectionView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;

    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
