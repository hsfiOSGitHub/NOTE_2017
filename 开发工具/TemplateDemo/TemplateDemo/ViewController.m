//
//  ViewController.m
//  TemplateDemo
//
//  Created by JuZhenBaoiMac on 2017/4/21.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark -init

#pragma mark -lazyLoad

#pragma mark -lifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
    //配置导航栏
     [self setUpNavi];
    //配置tableView
     [self setUpTableView];
    //配置collectionView
     [self setUpCollectionView];
    //初始化视图
    //添加通知
     */
}
/**
#pragma mark -//配置导航栏
-(void)setUpNavi{
    self.navigationItem.title = @"个人头像";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backACTION)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreACTION)];
}
-(void)backACTION{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)moreACTION{
   
}
*/

/**
#pragma mark -//配置tableView
-(void)setUpTableView{
    <UITableViewDelegate,UITableViewDataSource>
    static NSString *identifierCell1 = @"identifierCell1";
    static NSString *identifierCell2 = @"identifierCell2";
    static NSString *identifierCell3 = @"identifierCell3";
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineCell1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineCell2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MineCell3 class]) bundle:nil] forCellReuseIdentifier:identifierCell3];
    //    //下拉刷新
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [self loadUserInfoData];
    //    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
}
*/

/**
#pragma mark -//配置collectionView
-(void)setUpCollectionView{
    //代理设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册item
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GuideDetailCell1 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell1];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GuideDetailCell2 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell2];
    //    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadMovieData];
//    }];
}

#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        header.frame = CGRectMake(0, 0, collectionView.width, collectionView.width/2);
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:header.bounds];
//        [header addSubview:imgView];
//        //图片
//        GuideDetailModel *model = self.tjlist[0];
//        NSString *baseURL = [kUserDefaults objectForKey:@"baseURL"];
//        NSArray *baseURL_arr = [baseURL componentsSeparatedByString:@"/api"];
//        NSString *img_url = [NSString stringWithFormat:@"%@%@",baseURL_arr[0], model.imgpath];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"noPic"] completed:nil];
//        reusableView = header;
//    }
//    reusableView.backgroundColor = [UIColor greenColor];
////    if (kind == UICollectionElementKindSectionFooter)
////    {
////        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
////        footerview.backgroundColor = [UIColor purpleColor];
////        reusableView = footerview;
////    }
//    return reusableView;
//}
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}
*/
 
#pragma mark -//初始化视图

#pragma mark -//添加通知

#pragma mark -点击取消第一响应
/**
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
*/

#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
