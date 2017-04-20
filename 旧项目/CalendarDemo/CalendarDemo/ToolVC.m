//
//  ToolVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ToolVC.h"

#import "ToolCell.h"
#import "PuzzleVC.h"//拼图游戏
#import "ExploreVC.h"//探险游戏
#import "LocalMusicListVC.h"//音乐播放器

@interface ToolVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *source;//数据源

@end

static NSString *identifierCell = @"identifierCell";
@implementation ToolVC

#pragma mark -拉加载
-(NSArray *)source{
    if (!_source) {
        _source = @[@{@"icon":@"calculator_tool",@"title":@"计算器"},
                    @{@"icon":@"puzzle_tool",@"title":@"拼图游戏"},
                    @{@"icon":@"explore_tool",@"title":@"探险之旅"},
                    @{@"icon":@"music_tool",@"title":@"音乐"}];
    }
    return _source;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back4_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
//退出
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"百宝箱";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置collectionView
    [self setUpCollectionView];

}
//配置collectionView
-(void)setUpCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ToolCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];

}

#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 50)/4, (KScreenWidth - 50)/4 + 30);
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.source.count;
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    NSDictionary *dic = self.source[indexPath.row];
    cell.icon.image = [UIImage imageNamed:dic[@"icon"]];
    cell.title.text = dic[@"title"];
    return cell;
}
//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//计算器
        
    }else if (indexPath.row == 1) {//拼图游戏
        PuzzleVC *puzzle_VC = [[PuzzleVC alloc]init];
        [self.navigationController pushViewController:puzzle_VC animated:YES];
    }else if (indexPath.row == 2) {//探险游戏
        ExploreVC *explore_VC = [[ExploreVC alloc]init];
        [self.navigationController pushViewController:explore_VC animated:YES];
    }else if (indexPath.row == 3) {//音乐
        LocalMusicListVC *musicList_VC = [[LocalMusicListVC alloc]init];
        [self.navigationController pushViewController:musicList_VC animated:YES];
    }
}


#pragma mark -didReceiveMemoryWarning
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
