//
//  PuzzleVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/17.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "PuzzleVC.h"

#import "PuzzleCell.h"
#import "PuzzleCell2.h"
#import "PuzzleCell3.h"

@interface PuzzleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YBPopupMenuDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *labelBgView;//广告位
@property (weak, nonatomic) TXScrollLabelView *scrollLabelView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *puzzlePicArr_big;//数据源
@property (nonatomic,strong) NSMutableArray *puzzlePicArr_big_copy;
@property (nonatomic,strong) NSMutableArray *puzzlePicArr;//数据源
@property (nonatomic,strong) NSMutableArray *isStartArr;//是否在答题状态
@property (nonatomic,strong) NSMutableArray *isAnswerArr;//是否在查看原图页面
@property (nonatomic,strong) NSMutableArray *timeArr;//每一题的用时
@property (nonatomic,strong) NSMutableArray *clickTimeArr;//每一题点击的次数
@property (nonatomic,assign) NSInteger currentIndex;//当前页数
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentTime;//当前时间计时 
@property (nonatomic,assign) NSInteger currentNSTimer;//当前时间计时器标志
@property (nonatomic,strong) UIButton *moreBtn;//更多按钮
@property (nonatomic,assign) BOOL isTakePhoto;//相册 还是  拍照
@property (nonatomic,assign) NSInteger num;//难度系数

@end

static NSString *identifierCell = @"identifierCell";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
@implementation PuzzleVC
#pragma mark -懒加载
-(NSMutableArray *)puzzlePicArr_big{
    if (!_puzzlePicArr_big) {
        _puzzlePicArr_big = [NSMutableArray array];
    }
    return _puzzlePicArr_big;
}
-(NSMutableArray *)puzzlePicArr_big_copy{
    if (!_puzzlePicArr_big_copy) {
        _puzzlePicArr_big_copy = [NSMutableArray array];
    }
    return _puzzlePicArr_big_copy;
}
-(NSMutableArray *)puzzlePicArr{
    if (!_puzzlePicArr) {
        _puzzlePicArr = [NSMutableArray array];
    }
    return _puzzlePicArr;
}
-(NSMutableArray *)isStartArr{
    if (!_isStartArr) {
        _isStartArr = [NSMutableArray array];
        for (int i = 0; i < self.puzzlePicArr.count; i++) {
            [_isStartArr addObject:@"0"];
        }
    }
    return _isStartArr;
}
-(NSMutableArray *)isAnswerArr{
    if (!_isAnswerArr) {
        _isAnswerArr = [NSMutableArray array];
        for (int i = 0; i < self.puzzlePicArr.count; i++) {
            [_isAnswerArr addObject:@"0"];
        }
    }
    return _isAnswerArr;
}
-(NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
        for (int i = 0; i < self.puzzlePicArr.count; i++) {
            [_timeArr addObject:@"0"];
        }
    }
    return _timeArr;
}
-(NSMutableArray *)clickTimeArr{
    if (!_clickTimeArr) {
        _clickTimeArr = [NSMutableArray array];
        for (int i = 0; i < self.puzzlePicArr.count; i++) {
            [_clickTimeArr addObject:@"0"];
        }
    }
    return _clickTimeArr;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //更多按钮
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.moreBtn setImage:[UIImage imageNamed:@"more2_common"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_moreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//退出
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击更多按钮
-(void)moreBtnACTION:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:@[@"我的记录", @"难度系数", @"添加图片"] icons:@[@"record_puzzle", @"setting_puzzle", @"addPic_puzzle"] menuWidth:150 delegate:self];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(25, 216, 218, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"拼图游戏";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //数据源（图片）
    [self setUpSourcePic];
    //配置collectionView
    [self setUpCollectionView];
    //配置广告位
    [self setUpAD];
    //计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nstimerACTION:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    //刷一遍
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
-(void)nstimerACTION:(NSTimer *)sender{
    self.currentTime++;
    [self.timeArr replaceObjectAtIndex:self.currentNSTimer withObject:[NSString stringWithFormat:@"%ld",self.currentTime]];
    PuzzleCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentNSTimer inSection:0]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)self.currentTime/60,(int)self.currentTime%60];
}

//数据源（图片）
-(void)setUpSourcePic{
    self.num = 3;//默认（3*3）
    for (int i = 1 ; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%03d",i]];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth - 40), (KScreenWidth - 40))];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = image;
        [self.puzzlePicArr addObject:image];
        //分割后的图片
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int j = 0; j<9; j++) {
            if (j<8) {
                CGFloat w = (KScreenWidth - 40 - 5*4)/3;
                CGFloat x = 5 + (w +5)*(j%3);
                CGFloat y = 5 + (w +5)*(j/3);
                UIImage *img = [image captureView:imgView frame:CGRectMake(x, y, w, w)];
                [imgArr addObject:img];
            }else if (j == 8) {
                UIImage *img = [UIImage imageNamed:@"0"];
                [imgArr addObject:img];
            }                
        }
        [self.puzzlePicArr_big addObject:imgArr];
        [self.puzzlePicArr_big_copy addObject:imgArr];
    }
}
//配置collectionView
-(void)setUpCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PuzzleCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PuzzleCell2 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell2];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PuzzleCell3 class]) bundle:nil] forCellWithReuseIdentifier:identifierCell3];
    
}
//配置广告位
-(void)setUpAD{
    NSString *scrollTitle = @"这是一条广告,一共右4种轮播样式可以选择,现在使用的是第四种,您可以通过更改option来更改轮播样式";
    //options 是 TXScrollLabelViewType 枚举类型， 此处仅为了方便举例
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:3 velocity:3 options:UIViewAnimationOptionTransitionFlipFromTop];
    [self.labelBgView addSubview:scrollLabelView];
    
    //布局(Required)
    scrollLabelView.frame = self.labelBgView.bounds;
    
    //偏好(Optional)
    scrollLabelView.tx_centerX  = [UIScreen mainScreen].bounds.size.width * 0.5;
    scrollLabelView.scrollInset = UIEdgeInsetsMake(0, 10 , 10, 0);
    scrollLabelView.scrollSpace = 10;
    scrollLabelView.font = [UIFont systemFontOfSize:15];
    scrollLabelView.textAlignment = NSTextAlignmentCenter;
    scrollLabelView.backgroundColor = [UIColor blackColor];
    scrollLabelView.layer.cornerRadius = 5;
    
    //开始滚动
    [scrollLabelView beginScrolling];
    self.scrollLabelView = scrollLabelView;
}

#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.width, self.collectionView.height - 20);
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
    return self.puzzlePicArr.count;
}
//行内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.num == 3) {//难度系数（3*3）
        PuzzleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
        //点击次数
        NSString *clickTimeStr = self.clickTimeArr[indexPath.row];
        cell.clickTimeLabel.text = [NSString stringWithFormat:@"%@次",clickTimeStr];
        //时间
        NSString *timeStr = self.timeArr[indexPath.row];
        NSInteger time = [timeStr integerValue];
        cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
        //点击查看原图
        cell.answerImg.image = self.puzzlePicArr[indexPath.row];
        if ([self.isAnswerArr[indexPath.row] isEqualToString:@"0"]) {//在答题界面
            [cell.btnBgView sendSubviewToBack:cell.answerImg];
            [cell.answerBtn setTitle:@"查看原图" forState:UIControlStateNormal];
            cell.startBtn.hidden = NO;
        }else if ([self.isAnswerArr[indexPath.row] isEqualToString:@"1"]) {//在答案界面
            [cell.btnBgView bringSubviewToFront:cell.answerImg];
            [cell.answerBtn setTitle:@"返回" forState:UIControlStateNormal];
            cell.startBtn.hidden = YES;
        }
        
        [cell.answerBtn setTag:indexPath.row+10];
        [cell.answerBtn addTarget:self action:@selector(answerBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //配置btn的图片
        cell.puzzlePicArr = self.puzzlePicArr_big[indexPath.row];
        //btn的点击事件
        [cell.btn1 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn2 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn3 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn4 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn5 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn6 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn7 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn8 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn9 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //点击开始按钮
        [cell.startBtn setTag:indexPath.row+100];
        [cell.startBtn addTarget:self action:@selector(startBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.isStartArr[indexPath.row] isEqualToString:@"0"]) {
            [cell.startBtn setTitle:@"开始" forState:UIControlStateNormal];
            cell.startBtn.backgroundColor = KRGB(25, 216, 218, 1);
        }else if ([self.isStartArr[indexPath.row] isEqualToString:@"1"]) {
            [cell.startBtn setTitle:@"结束" forState:UIControlStateNormal];
            cell.startBtn.backgroundColor = KRGB(218, 54, 31, 1);
        }
        //页码
        cell.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(indexPath.row + 1), self.puzzlePicArr.count];
        return cell;
    }else if (self.num == 4) {//难度系数（4*4）
        PuzzleCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell2 forIndexPath:indexPath];
        //点击次数
        NSString *clickTimeStr = self.clickTimeArr[indexPath.row];
        cell2.clickTimeLabel.text = [NSString stringWithFormat:@"%@次",clickTimeStr];
        //时间
        NSString *timeStr = self.timeArr[indexPath.row];
        NSInteger time = [timeStr integerValue];
        cell2.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
        //点击查看原图
        cell2.answerImg.image = self.puzzlePicArr[indexPath.row];
        if ([self.isAnswerArr[indexPath.row] isEqualToString:@"0"]) {//在答题界面
            [cell2.btnBgView sendSubviewToBack:cell2.answerImg];
            [cell2.answerBtn setTitle:@"查看原图" forState:UIControlStateNormal];
            cell2.startBtn.hidden = NO;
        }else if ([self.isAnswerArr[indexPath.row] isEqualToString:@"1"]) {//在答案界面
            [cell2.btnBgView bringSubviewToFront:cell2.answerImg];
            [cell2.answerBtn setTitle:@"返回" forState:UIControlStateNormal];
            cell2.startBtn.hidden = YES;
        }
        
        [cell2.answerBtn setTag:indexPath.row+10];
        [cell2.answerBtn addTarget:self action:@selector(answerBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //配置btn的图片
        cell2.puzzlePicArr = self.puzzlePicArr_big[indexPath.row];
        //btn的点击事件
        [cell2.btn1 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn2 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn3 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn4 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn5 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn6 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn7 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn8 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn9 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn10 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn11 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn12 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn13 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn14 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn15 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.btn16 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //点击开始按钮
        [cell2.startBtn setTag:indexPath.row+100];
        [cell2.startBtn addTarget:self action:@selector(startBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.isStartArr[indexPath.row] isEqualToString:@"0"]) {
            [cell2.startBtn setTitle:@"开始" forState:UIControlStateNormal];
            cell2.startBtn.backgroundColor = KRGB(25, 216, 218, 1);
        }else if ([self.isStartArr[indexPath.row] isEqualToString:@"1"]) {
            [cell2.startBtn setTitle:@"结束" forState:UIControlStateNormal];
            cell2.startBtn.backgroundColor = KRGB(218, 54, 31, 1);
        }
        //页码
        cell2.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(indexPath.row + 1), self.puzzlePicArr.count];
        return cell2;
    }else if (self.num == 5) {//难度系数（5*5）
        PuzzleCell3 *cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell3 forIndexPath:indexPath];
        //点击次数
        NSString *clickTimeStr = self.clickTimeArr[indexPath.row];
        cell3.clickTimeLabel.text = [NSString stringWithFormat:@"%@次",clickTimeStr];
        //时间
        NSString *timeStr = self.timeArr[indexPath.row];
        NSInteger time = [timeStr integerValue];
        cell3.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
        //点击查看原图
        cell3.answerImg.image = self.puzzlePicArr[indexPath.row];
        if ([self.isAnswerArr[indexPath.row] isEqualToString:@"0"]) {//在答题界面
            [cell3.btnBgView sendSubviewToBack:cell3.answerImg];
            [cell3.answerBtn setTitle:@"查看原图" forState:UIControlStateNormal];
            cell3.startBtn.hidden = NO;
        }else if ([self.isAnswerArr[indexPath.row] isEqualToString:@"1"]) {//在答案界面
            [cell3.btnBgView bringSubviewToFront:cell3.answerImg];
            [cell3.answerBtn setTitle:@"返回" forState:UIControlStateNormal];
            cell3.startBtn.hidden = YES;
        }
        
        [cell3.answerBtn setTag:indexPath.row+10];
        [cell3.answerBtn addTarget:self action:@selector(answerBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //配置btn的图片
        cell3.puzzlePicArr = self.puzzlePicArr_big[indexPath.row];
        //btn的点击事件
        [cell3.btn1 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn2 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn3 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn4 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn5 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn6 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn7 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn8 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn9 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn10 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn11 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn12 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn13 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn14 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn15 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn16 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn17 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn18 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn19 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn20 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn21 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn22 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn23 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn24 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        [cell3.btn25 addTarget:self action:@selector(ClickBtnToChangePosition:) forControlEvents:UIControlEventTouchUpInside];
        
        //点击开始按钮
        [cell3.startBtn setTag:indexPath.row+100];
        [cell3.startBtn addTarget:self action:@selector(startBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.isStartArr[indexPath.row] isEqualToString:@"0"]) {
            [cell3.startBtn setTitle:@"开始" forState:UIControlStateNormal];
            cell3.startBtn.backgroundColor = KRGB(25, 216, 218, 1);
        }else if ([self.isStartArr[indexPath.row] isEqualToString:@"1"]) {
            [cell3.startBtn setTitle:@"结束" forState:UIControlStateNormal];
            cell3.startBtn.backgroundColor = KRGB(218, 54, 31, 1);
        }
        //页码
        cell3.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(indexPath.row + 1), self.puzzlePicArr.count];
        return cell3;
    }
    return nil;
}

#pragma mark -//点击查看原图
-(void)answerBtnACTION:(UIButton *)sender{
    PuzzleCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag - 10 inSection:0]];
//添加动画
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:0.8];
    //设置动画效果
    //    [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.dialView cache:YES];  //从上向下
    //    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.dialView cache:YES];   //从下向上
    if ([self.isAnswerArr[sender.tag - 10] isEqualToString:@"0"]) {//在答题界面
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:cell.bgView cache:YES];  //从左向右
        [self.isAnswerArr replaceObjectAtIndex:sender.tag - 10 withObject:@"1"];
        [cell.btnBgView bringSubviewToFront:cell.answerImg];
        
    }else if ([self.isAnswerArr[sender.tag - 10] isEqualToString:@"1"]) {//在答案界面
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:cell.bgView cache:YES];  //从右向左
        [self.isAnswerArr replaceObjectAtIndex:sender.tag - 10 withObject:@"0"];
        [cell.btnBgView sendSubviewToBack:cell.answerImg];
    }
    //  [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.dialView cache:YES];//从右向左
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    //提交动画
    [UIView commitAnimations];
}
//动画效果执行完毕
- (void) animationFinished: (id) sender{
    NSLog(@"animationFinished !");
    [self.collectionView reloadData];
}
#pragma mark -点击开始按钮
-(void)startBtnACTION:(UIButton *)sender{
    self.currentNSTimer = sender.tag - 100;
    
    if ([self.isStartArr[sender.tag - 100] isEqualToString:@"0"]) {
        [self.isStartArr replaceObjectAtIndex:sender.tag - 100 withObject:@"1"];
        NSArray *currentPuzzlePicArr = self.puzzlePicArr_big[sender.tag - 100];
        NSMutableArray *arr = [self getRandomArrFrome:currentPuzzlePicArr];
        [self.puzzlePicArr_big replaceObjectAtIndex:sender.tag - 100 withObject:arr];
        //开始计时
        [self.timer setFireDate:[NSDate distantPast]];
        //点击次数
        [self.clickTimeArr replaceObjectAtIndex:self.currentIndex withObject:@"0"];
        //更多按钮不可响应
        self.moreBtn.userInteractionEnabled = NO;
        [self.moreBtn setImage:[UIImage imageNamed:@"more2_hd_common"] forState:UIControlStateNormal];
        //不可以滑动
        self.collectionView.scrollEnabled = NO;
        //初始化用时
        self.currentTime = 0;
        
    }else if ([self.isStartArr[sender.tag - 100] isEqualToString:@"1"]) {
        [self.isStartArr replaceObjectAtIndex:sender.tag - 100 withObject:@"0"];
        [self.puzzlePicArr_big replaceObjectAtIndex:sender.tag - 100 withObject:self.puzzlePicArr_big_copy[sender.tag - 100]];
        //暂停计时
        [self.timer setFireDate:[NSDate distantFuture]];
        //弹出提示
        NSString *message = [NSString stringWithFormat:@"挑战失败！点击了：%@次,用时：%@",self.clickTimeArr[self.currentIndex],[NSString stringWithFormat:@"%02d:%02d",(int)self.currentTime/60,(int)self.currentTime%60]];
        [MBProgressHUD showError:message];
        //更多按钮可响应
        self.moreBtn.userInteractionEnabled = YES;
        [self.moreBtn setImage:[UIImage imageNamed:@"more2_common"] forState:UIControlStateNormal];
        //可以滑动
        self.collectionView.scrollEnabled = YES;
    }
    //刷新
    [self.collectionView reloadData];
}

#pragma mark -PuzzleCellDelegate 点击btn 换位置
-(void)ClickBtnToChangePosition:(UIButton *)sender{
    NSString *isStart = self.isStartArr[self.currentIndex];
    if ([isStart isEqualToString:@"1"]) {
        NSMutableArray *currentPuzzlePicArr = self.puzzlePicArr_big[self.currentIndex];
        PuzzleCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        UIButton *grayBtn;
        BOOL isChanged = NO;//是否要增加点击次数
        if (sender.tag > self.num) {//上移
            grayBtn = [cell.btnBgView viewWithTag:(sender.tag - self.num)];
            UIImage *grayImg = grayBtn.currentImage;
            if ([grayImg isEqual:[UIImage imageNamed:@"0"]]) {
                [currentPuzzlePicArr exchangeObjectAtIndex:(sender.tag - 1) withObjectAtIndex:((sender.tag - 1) - self.num)];
                isChanged = YES;
            }
        }
        if (sender.tag <= (self.num*self.num - self.num)) {//下移
            grayBtn = [cell.btnBgView viewWithTag:(sender.tag + self.num)];
            UIImage *grayImg = grayBtn.currentImage;
            if ([grayImg isEqual:[UIImage imageNamed:@"0"]]) {
                [currentPuzzlePicArr exchangeObjectAtIndex:(sender.tag - 1) withObjectAtIndex:((sender.tag - 1) + self.num)];
                isChanged = YES;
            }
        }
        if (sender.tag % self.num != 1) {//左移
            grayBtn = [cell.btnBgView viewWithTag:(sender.tag - 1)];
            UIImage *grayImg = grayBtn.currentImage;
            if ([grayImg isEqual:[UIImage imageNamed:@"0"]]) {
                [currentPuzzlePicArr exchangeObjectAtIndex:(sender.tag - 1) withObjectAtIndex:((sender.tag - 1) - 1)];
                isChanged = YES;
            }
        }
        if (sender.tag % self.num != 0) {//右移
            grayBtn = [cell.btnBgView viewWithTag:(sender.tag + 1)];
            UIImage *grayImg = grayBtn.currentImage;
            if ([grayImg isEqual:[UIImage imageNamed:@"0"]]) {
                [currentPuzzlePicArr exchangeObjectAtIndex:(sender.tag - 1) withObjectAtIndex:((sender.tag - 1) + 1)];
                isChanged = YES;
            }
        }
        [self.puzzlePicArr_big replaceObjectAtIndex:self.currentIndex withObject:currentPuzzlePicArr];
        //点击次数
        if (isChanged) {
            NSInteger clickTime = [self.clickTimeArr[self.currentIndex] integerValue];
            clickTime++;
            [self.clickTimeArr replaceObjectAtIndex:self.currentIndex withObject:[NSString stringWithFormat:@"%ld",clickTime]];
        }
        
        //刷新
        [self.collectionView reloadData];
        
        //提示游戏通关
        NSMutableArray *nowArray = [NSMutableArray array];
        UIButton *btn;
        for (int i = 1; i <= 9; i++) {
            btn = [cell.btnBgView viewWithTag:i];
            UIImage *image = btn.currentImage;
            [nowArray addObject:image];
        }
        NSArray *answerPicArr = self.puzzlePicArr_big_copy[self.currentIndex];
        if ([nowArray isEqualToArray:answerPicArr]) {
            //停止答题
            [self.isStartArr replaceObjectAtIndex:self.currentIndex withObject:@"0"];
            NSString *message = [NSString stringWithFormat:@"一共点击了：%@次,用时：%@",self.clickTimeArr[self.currentIndex],[NSString stringWithFormat:@"%02d:%02d",(int)self.currentTime/60,(int)self.currentTime%60]];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"恭喜您，挑战成功！" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:okAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}


//将一个数组打乱顺序
-(NSMutableArray*)getRandomArrFrome:(NSArray*)arr{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        self.currentIndex = (int)offsetX/self.collectionView.width;
    }
}


#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    switch (index) {
        case 0:{//我的记录
            
        }
            break;
        case 1:{//难度系数
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"选择难度系数" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *easy = [UIAlertAction actionWithTitle:@"简单（3*3）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.num = 3;
                [self changeDifficultLevelWith:3];
            }];
            UIAlertAction *normal = [UIAlertAction actionWithTitle:@"一般（4*4）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.num = 4;
                [self changeDifficultLevelWith:4];
            }];
            UIAlertAction *difficult = [UIAlertAction actionWithTitle:@"困难（5*5）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.num = 5;
                [self changeDifficultLevelWith:5];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:easy];
            [alertC addAction:normal];
            [alertC addAction:difficult];
            [alertC addAction:cancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
            break;
        case 2:{//添加图片
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片添加方式" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openAlbum];
            }];
            UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:album];
            [alertC addAction:photo];
            [alertC addAction:cancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -选择图片
/**
 *  打开相册
 */
- (void)openAlbum{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    _isTakePhoto = NO;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
/**
 *  拍照
 */
-(void)takePhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    _isTakePhoto = YES;
    
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    ip.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    ip.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:ip animated:YES completion:nil];
    }
}
#pragma mark -难度系数
-(void)changeDifficultLevelWith:(NSInteger)num{
    self.puzzlePicArr_big = nil;
    self.puzzlePicArr_big_copy = nil;
    for (int i = 0 ; i < self.puzzlePicArr.count; i++) {
        UIImage *image = self.puzzlePicArr[i];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth - 40), (KScreenWidth - 40))];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = image;
        //分割后的图片
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int j = 0; j<(num * num); j++) {
            if (j < (num * num - 1)) {
                CGFloat w = (KScreenWidth - 40 - 5*4)/num;
                CGFloat x = 5 + (w +5)*(j%num);
                CGFloat y = 5 + (w +5)*(j/num);
                UIImage *img = [image captureView:imgView frame:CGRectMake(x, y, w, w)];
                [imgArr addObject:img];
            }else if (j == (num * num - 1)) {
                UIImage *img = [UIImage imageNamed:@"0"];
                [imgArr addObject:img];
            }                
        }
        [self.puzzlePicArr_big addObject:imgArr];
        [self.puzzlePicArr_big_copy addObject:imgArr];
    }
    //刷表
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if (_isTakePhoto) {
        image = info[UIImagePickerControllerOriginalImage];
    } else {
        image = info[UIImagePickerControllerEditedImage];
    }
    //添加图片 
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (KScreenWidth - 40), (KScreenWidth - 40))];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.image = image;
    [self.puzzlePicArr addObject:image];
    //分割后的图片
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int j = 0; j<9; j++) {
        if (j<8) {
            CGFloat w = (KScreenWidth - 40 - 5*4)/3;
            CGFloat x = 5 + (w +5)*(j%3);
            CGFloat y = 5 + (w +5)*(j/3);
            UIImage *img = [image captureView:imgView frame:CGRectMake(x, y, w, w)];
            [imgArr addObject:img];
        }else if (j == 8) {
            UIImage *img = [UIImage imageNamed:@"0"];
            [imgArr addObject:img];
        }                
    }
    [self.puzzlePicArr_big addObject:imgArr];
    [self.puzzlePicArr_big_copy addObject:imgArr];
    self.isStartArr = nil;
    self.isAnswerArr = nil;
    self.timeArr = nil;
    self.clickTimeArr = nil;
    //刷表
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    //退出
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 改变图像的尺寸，方便上传服务器
    //    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
    //    UIImageView *tempV = (UIImageView *)[self.view viewWithTag:888];
    //    tempV.image = uploadImage;
    
    //取出选中的图片
    //    NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
    
    
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
