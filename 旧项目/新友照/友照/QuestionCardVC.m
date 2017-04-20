//
//  QuestionCardVC.m
//  友照
//
//  Created by monkey2016 on 16/12/8.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionCardVC.h"

#import "QuestionCardCell.h"

@interface QuestionCardVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *finishNum;
@property (weak, nonatomic) IBOutlet UILabel *wrong;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UILabel *unfinish;
@property (nonatomic,assign) BOOL isReset;
@end

static NSString *identifierCell = @"identifierCell";
@implementation QuestionCardVC

#pragma mark -导航栏设置
-(void)setUpNavi{
    //解决无故偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"折叠"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    if (self.isMock) {
        
    }else{
        if ([self.source containsObject:@"1"] || [self.source containsObject:@"2"]) {
            //重置答题卡
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
        }else{
            
        }
    }
}
//返回
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//重置答题卡
-(void)reset{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"重置答题卡" message:@"是否清空记录数据，重新练习?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //遍历
        [self.source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSString *status = (NSString *)obj;
            if (![status isEqualToString:@"0"]) {
                status = @"0";
            }
        }];
//        //刷表
//        [self.collectionView reloadData];
//        self.finishNum.text = [NSString stringWithFormat:@"已完成:0/%ld",self.source.count];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
        hud.labelText = @"正在重置，请稍后";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC); 
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([self.agency respondsToSelector:@selector(resetQuestion)]) {
                [self.agency resetQuestion];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES]; 
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(77, 143, 235, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"答题卡";
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //配置导航栏
    [self setUpNavi];
    //配置collectionView
    [self setUpCollectionView];
    //滚动到当前题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    });
    //完成数量
    __block NSInteger num = 0;
    [self.source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *status = (NSString *)obj;
        if (![status isEqualToString:@"0"]) {
            num++;
        }
    }];
    self.finishNum.text = [NSString stringWithFormat:@"已完成:%ld/%ld",num,self.source.count];
    
    //对错题数量
    self.wrong.text = [NSString stringWithFormat:@"答错:%@",self.wrongNum];
    self.right.text = [NSString stringWithFormat:@"答对:%@",self.rightNum];
    NSInteger unfinishNum = self.source.count - [self.wrongNum integerValue] - [self.rightNum integerValue];
    self.unfinish.text = [NSString stringWithFormat:@"未答:%ld",unfinishNum];
}
//配置collectionView
-(void)setUpCollectionView{
    //代理设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册item
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCardCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
    
}
#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 20 * 6)/5, (KScreenWidth - 20 * 6)/5);
}
//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
//组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.source count];
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    NSString *status = self.source[indexPath.row];;
    if ([status isEqualToString:@"0"])
    {
        //还没做
        cell.num.backgroundColor = KRGB(239, 239, 239, 1);
    }
    else if ([status isEqualToString:@"1"])
    {
        //答对了
        cell.num.backgroundColor = KRGB(96, 241, 178, 1);
    }
    else if ([status isEqualToString:@"2"])
    {
        //答错了
        cell.num.backgroundColor = KRGB(237, 44, 57, 1);
    }
    return cell;
}
//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.agency respondsToSelector:@selector(offsetCollectionViewWith:)]) {
            [self.agency offsetCollectionViewWith:indexPath];
        }
    }];
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
