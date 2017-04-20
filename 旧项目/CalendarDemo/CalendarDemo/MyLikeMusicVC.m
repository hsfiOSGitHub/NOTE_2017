//
//  MyLikeMusicVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MyLikeMusicVC.h"

#import "MyLikeMusicCell1.h"
#import "MyLikeMusicCell2.h"

@interface MyLikeMusicVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) LittlePlayerView *littlePlayer_View;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *source;//数据源
@property (nonatomic,strong) NSMutableArray *source_singer;//数据源
@property (nonatomic,strong) UIButton *styleBtn;

@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
@implementation MyLikeMusicVC

#pragma mark -懒加载
-(NSMutableArray *)source{
    if (!_source) {
        NSArray *arr = [[HSFFmdbManager sharedManager] readLocalMusicModelFromDBWhereCondition:@{@"isLike":@"1"}];
        _source = [NSMutableArray arrayWithArray:arr];
    }
    return _source;
}
-(NSMutableArray *)source_singer{
    if (!_source_singer) {
        _source_singer = [NSMutableArray array];
        _source_singer = [self countTheSameSingerMusic];
    }
    return _source_singer;
}
-(UIButton *)styleBtn{
    if (!_styleBtn) {
        _styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _styleBtn.frame = CGRectMake(0, 0, 44, 44);
        [_styleBtn setImage:[UIImage imageNamed:@"styleIcon1_myLike"] forState:UIControlStateNormal];
        [_styleBtn addTarget:self action:@selector(styleBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _styleBtn;
}
-(void)styleBtnACTION:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_styleBtn setImage:[UIImage imageNamed:@"styleIcon2_myLike"] forState:UIControlStateNormal];
    }else{
        [_styleBtn setImage:[UIImage imageNamed:@"styleIcon1_myLike"] forState:UIControlStateNormal];
    }
    [self.collectionView reloadData];
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //切换样式
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.styleBtn];
}
//退出
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(23, 159, 155, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"我喜欢";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置collectionView
    [self setUpCollectioView];
    //创建播放小空间
    [self createLittlePlayerView];
}
//配置collectionView
-(void)setUpCollectioView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyLikeMusicCell1 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell1];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyLikeMusicCell2 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell2];
}
#pragma mark -UICollectionViewDelegate,UICollectionViewDataSource
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.styleBtn.selected) {
        return CGSizeMake((KScreenWidth - 10*2), (KScreenWidth - 10*2)/4);
    }else{
        return CGSizeMake((KScreenWidth - 10*3)/2, (KScreenWidth - 10*3)/2 + 50);
    }
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
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
    if (self.styleBtn.selected) {
        return self.source_singer.count;
    }else{
        return self.source.count;
    }
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.styleBtn.selected) {
        MyLikeMusicCell1 *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell1 forIndexPath:indexPath];
        NSArray *arr = self.source_singer[indexPath.row];
        MusicModel *model = arr[0];
        cell1.singerPic.image = [UIImage imageNamed:model.singerPic];
        cell1.singerName.text = model.singerName;
        cell1.count.text = [NSString stringWithFormat:@"%ld首",[arr count]];
        return cell1;
    }else{
        MyLikeMusicCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell2 forIndexPath:indexPath];
        MusicModel *model = self.source[indexPath.row];
        cell2.singerPic.image = [UIImage imageNamed:model.singerPic];
        cell2.musicName.text = model.musicName;
        cell2.singerName.text = model.singerName;
        return cell2;
    }
}
//点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.styleBtn.selected) {
        
    }else{
        
    }
}

#pragma mark -同一歌手的歌曲
-(NSMutableArray *)countTheSameSingerMusic{
    //1.先把所有的歌手组成一个数组
    NSMutableArray *singerArr = [NSMutableArray array];
    [self.source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = (MusicModel *)obj;
        [singerArr addObject:model.singerName];
    }];
    //2.使用asset去重
    NSSet *set = [NSSet setWithArray:singerArr];
    NSArray *arr = [set allObjects];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
    //3.按歌手名首字母升序排列
    NSArray *newSingerArr = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    //4.遍历newSingerArr,把newSingerArr按照newSingerArr里的歌手名分成几个组每个组都是空的数组
    NSMutableArray *newSingerArr_arr = [NSMutableArray array];
    [newSingerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *arr = [NSMutableArray array];
        [newSingerArr_arr addObject:arr];
    }];
   //5.遍历self.source取其中每个数据的歌手名，看看与newSingerArr里的哪个歌手名匹配就把这个数据装到newSingerArr_arr 对应的组中
    [self.source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = (MusicModel *)obj;
        for (NSString *singerName in newSingerArr) {
            if ([singerName isEqualToString:model.singerName]) {
                NSMutableArray *arr=[newSingerArr_arr objectAtIndex:[newSingerArr indexOfObject:singerName]];
                [arr addObject:model];
            }
        }
    }];
    return newSingerArr_arr;
}

#pragma mark -创建播放小空间
-(void)createLittlePlayerView{
    self.littlePlayer_View = [[LittlePlayerView alloc]initWithFrame:CGRectMake(0, 50, 50, 50)];
    self.littlePlayer_View.sourceVC = self.sourceVC;
    [self.view addSubview:self.littlePlayer_View];
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
