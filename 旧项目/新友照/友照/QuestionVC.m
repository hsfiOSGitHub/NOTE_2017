//
//  QuestionVC.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionVC.h"
#import "zhu_ye_ViewController.h"
#import "jia_kao_ViewController.h"
#import "QuestionCell.h"
#import "QuestionCardVC.h"//答题卡
#import "MockResultVC.h"//考试结果

@interface QuestionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QuestionCellDelegate,QuestionCardVCDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//我的收藏
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;//对题集
@property (weak, nonatomic) IBOutlet UIButton *wrongBtn;//错题集
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;//答题卡
@property (nonatomic,assign) NSInteger currentQ_index;//当前问题序号

@property (nonatomic,strong) UISegmentedControl *segmentC; 
@property (nonatomic,strong) NSTimer *mockTimer;

@property (nonatomic,assign) NSInteger yourScore;//你的得分
@property (nonatomic,assign) BOOL finishMockAndGoOn;//考试结束 点击继续答题
@property (nonatomic,assign) BOOL doneAllAndGoOn;//全部做完了，点击继续答题

@property (nonatomic,assign) NSInteger usedTime;
@property (nonatomic,assign) NSInteger allTime;

@property (nonatomic,assign) BOOL isAlert92;

@property (nonatomic,strong) NSMutableArray *playerArr;//数组：播放器对象
@property (nonatomic,strong) NSMutableArray *lastPlayer;

@property (strong, nonatomic) UIButton *guideBtn;


@property (nonatomic,assign) CGFloat offsetX; 

@end

static NSString *identifierCell = @"identifierCell";
@implementation QuestionVC

//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -懒加载
-(NSMutableArray *)lastPlayer{
    if (!_lastPlayer) {
        _lastPlayer = [NSMutableArray arrayWithObjects:@"0", nil];
    }
    return _lastPlayer;
}
-(NSMutableArray *)playerArr{
    if (!_playerArr) {
        _playerArr = [NSMutableArray array];
        for (int i = 0; i < self.source.count; i++) {
            [_playerArr addObject:@"0"];
        }
    }
    return _playerArr;
}
-(NSInteger)currentQ_index{
    if (_currentQ_index == 0) {
        _currentQ_index = 1;
    }
    return _currentQ_index;
}
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}
-(NSMutableArray *)seleteBtnArr_big{
    if (!_seleteBtnArr_big) {
        _seleteBtnArr_big = [NSMutableArray array];
        //标记seleteBtn的状态
        for (int i = 0; i < self.source.count; i++) {
            NSMutableArray *seleteStateArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];//0代表还没选择；1代表选对了；2代表选错了
            [self.seleteBtnArr_big addObject:seleteStateArr];
        }
    }
    return _seleteBtnArr_big;
}
-(NSMutableArray *)seleteCellArr_big{
    if (!_seleteCellArr_big) {
        _seleteCellArr_big = [NSMutableArray array];
        //标记cell的选中状态
        for (int i = 0; i < self.source.count; i++) {
            NSMutableArray *seleteCellArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];//0代表还没选择；1代表选了；
            [self.seleteCellArr_big addObject:seleteCellArr];
        }
    }
    return _seleteCellArr_big;
}
-(NSMutableArray *)showExplainArr{
    if (!_showExplainArr) {
        _showExplainArr = [NSMutableArray array];
        for (int i = 0; i < self.source.count; i++) {
            [_showExplainArr addObject:@"0"];
        }
    }
    return _showExplainArr;
}

-(NSMutableArray *)currentAnswerArr_big{
    if (!_currentAnswerArr_big) {
        _currentAnswerArr_big = [NSMutableArray array];
        for (int i = 0; i < self.source.count; i++) {
            NSMutableArray *currentAnswer = [NSMutableArray array];
            [_currentAnswerArr_big addObject:currentAnswer];
        }
    }
    return _currentAnswerArr_big;
}

-(NSMutableArray *)finishStatus_big{
    if (!_finishStatus_big) {
        _finishStatus_big = [NSMutableArray array];
        for (int i = 0; i < self.source.count; i++) {
            [_finishStatus_big addObject:@"0"];
        }
    }
    return _finishStatus_big;
}
#pragma mark -导航栏设置
-(void)mockTimerACTION{
    _allTime--;
    _usedTime++;
    self.navigationItem.title = [NSString stringWithFormat:@"%02d:%02d",(int)_allTime/60,(int)_allTime%60];
    //监控得分
    [self acountScore];
    //考试时间到
    if (_allTime == 0) {
        [self.mockTimer setFireDate:[NSDate distantFuture]];
        [self.mockTimer invalidate];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"考试结束,请交卷" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //push到考试结果界面
            MockResultVC *mockResult_VC = [[MockResultVC alloc]init];
            mockResult_VC.yourScore = self.yourScore;
            mockResult_VC.usedTimeStr = [NSString stringWithFormat:@"%02d:%02d",(int)_usedTime/60,(int)_usedTime%60];
            mockResult_VC.subject = _subject;
            [self.navigationController pushViewController:mockResult_VC animated:YES];
            //移除定时器
            [self.mockTimer invalidate];
        }];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    //题目做完了（考完了）
    if (![self.finishStatus_big containsObject:@"0"]) {
        if (!self.doneAllAndGoOn) {
            [self collectBtnAction:self.collectBtn];//点击交卷
        }
    }
}
-(void)setUpNavi{
    //解决无故偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //考试吗？》》》》》》》》》》》》》》》》》
    if (self.isMock) {//在考试
        self.mockTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mockTimerACTION) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.mockTimer forMode:NSRunLoopCommonModes];
    }else{//练习
        //答题／背题 
        self.segmentC = [[UISegmentedControl alloc]initWithItems:@[@"答题模式",@"背题模式"]];
        self.segmentC.tintColor = [UIColor whiteColor];
        //取出selectedSegmentIndex（模式）
        NSInteger selectedSegmentIndex = 0;
        NSString *str = @"";
        if ([self.classType isEqualToString:@"class1"]) {//科一
            str = [ZXUD objectForKey:self.selectedSegmentIndex1];
        }else if ([self.classType isEqualToString:@"class4"]) {//科四
            str = [ZXUD objectForKey:self.selectedSegmentIndex4];
        }
        if (!str || [str isEqualToString:@""]) {
            selectedSegmentIndex = 0;
        }else{
            selectedSegmentIndex = [str integerValue];
        }
        self.segmentC.selectedSegmentIndex = selectedSegmentIndex;
        [self.segmentC addTarget:self action:@selector(segmentCAction:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = self.segmentC;
    }
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnACTION)];
}
//返回
-(void)backBtnACTION{
    if (self.isMock) {//在考试
        [self.mockTimer setFireDate:[NSDate distantFuture]];//暂停定时器
        NSString *message = @"";
        if ([self.classType isEqualToString:@"class1"]) {//科一
            message = @"您正在模拟科目一考试,确定要退出吗？";
        }else if ([self.classType isEqualToString:@"class4"]) {//科四
            message = @"您正在模拟科目四考试,确定要退出吗？";
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message: message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
        {
            for (UIViewController* VC in self.navigationController.viewControllers)
            {
                if ([[ZXUD objectForKey:@"moNiKaoShi"] isEqualToString:@"0"])
                {
                    if ([VC isKindOfClass:[zhu_ye_ViewController class]])
                    {
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                }
                else
                {
                    if ([VC isKindOfClass:[jia_kao_ViewController class]])
                    {
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                }
            }
            //移除定时器
            [self.mockTimer invalidate];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续考试" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                  {
            [self.mockTimer setFireDate:[NSDate distantPast]];//开始定时器
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self.mockTimer invalidate];//移除定时器
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//答题／背题 
-(void)segmentCAction:(UISegmentedControl *)sender{
    [self.collectionView reloadData];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //保存题号
    if ([self.unfinish_Q isEqualToString:@"unfinish_Q"] || [self.random isEqualToString:@"random"]) {
    
    }else{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString *seleteBtnArr_big1Path = [path stringByAppendingPathComponent:self.plistName_seleteBtnArr_big1Path];
        NSString *seleteCellArr_big1Path = [path stringByAppendingPathComponent:self.plistName_seleteCellArr_big1Path];
        NSString *showExplainArr1Path = [path stringByAppendingPathComponent:self.plistName_showExplainArr1Path];
        NSString *currentAnswerArr_big1Path = [path stringByAppendingPathComponent:self.plistName_currentAnswerArr_big1Path];
        NSString *finishStatus_big1Path = [path stringByAppendingPathComponent:self.plistName_finishStatus_big1Path];
        
        NSString *seleteBtnArr_big4Path = [path stringByAppendingPathComponent:self.plistName_seleteBtnArr_big4Path];
        NSString *seleteCellArr_big4Path = [path stringByAppendingPathComponent:self.plistName_seleteCellArr_big4Path];
        NSString *showExplainArr4Path = [path stringByAppendingPathComponent:self.plistName_showExplainArr4Path];
        NSString *currentAnswerArr_big4Path = [path stringByAppendingPathComponent:self.plistName_currentAnswerArr_big4Path];
        NSString *finishStatus_big4Path = [path stringByAppendingPathComponent:self.plistName_finishStatus_big4Path];
        
        if ([self.classType isEqualToString:@"class1"]) {//科一
            [ZXUD setObject:[NSString stringWithFormat:@"%ld",(long)self.currentQ_index] forKey:self.class1Q_index];
            [ZXUD setObject:[NSString stringWithFormat:@"%ld",(long)self.segmentC.selectedSegmentIndex] forKey:self.selectedSegmentIndex1];
            if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
                //什么也不做
            }else{//保存选中状态
                [self.seleteBtnArr_big writeToFile:seleteBtnArr_big1Path atomically:YES];
                [self.seleteCellArr_big writeToFile:seleteCellArr_big1Path atomically:YES];
                [self.showExplainArr writeToFile:showExplainArr1Path atomically:YES];
                [self.currentAnswerArr_big writeToFile:currentAnswerArr_big1Path atomically:YES];
            }
            [self.finishStatus_big writeToFile:finishStatus_big1Path atomically:YES];
        }else if ([self.classType isEqualToString:@"class4"]) {//科四
            [ZXUD setObject:[NSString stringWithFormat:@"%ld",(long)self.currentQ_index] forKey:self.class4Q_index];
            [ZXUD setObject:[NSString stringWithFormat:@"%ld",(long)self.segmentC.selectedSegmentIndex] forKey:self.selectedSegmentIndex4];
            if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
                //什么也不做
            }else{//保存选中状态
                [self.seleteBtnArr_big writeToFile:seleteBtnArr_big4Path atomically:YES];
                [self.seleteCellArr_big writeToFile:seleteCellArr_big4Path atomically:YES];
                [self.showExplainArr writeToFile:showExplainArr4Path atomically:YES];
                [self.currentAnswerArr_big writeToFile:currentAnswerArr_big4Path atomically:YES];
            }
            [self.finishStatus_big writeToFile:finishStatus_big4Path atomically:YES];
        } 
    }
}
- (void)guideBtnACTION:(UIButton *)sender {
    self.guideBtn.hidden = YES;
    [self.guideBtn removeFromSuperview];
    self.guideBtn = nil;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"guideQuestion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //是否进行引导
    NSString *isGuide = [[NSUserDefaults standardUserDefaults] objectForKey:@"guideQuestion"];
    if ([isGuide isEqualToString:@"0"]) {//不引导
        self.guideBtn.hidden = YES;
        [self.guideBtn removeFromSuperview];
        self.guideBtn = nil;
    }else if ([isGuide isEqualToString:@"1"]) {//引导
        self.guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.guideBtn.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideBtn];
        [self.guideBtn setBackgroundImage:[UIImage imageNamed:@"步骤"] forState:UIControlStateNormal];
        [self.guideBtn addTarget:self action:@selector(guideBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        self.guideBtn.hidden = NO;
    }
    
    //配置collectionView
    [self setUpCollectionView];
    //配置底部按钮
    [self setUpBottomBtns];
    //配置导航栏
    self.allTime = 1 * 10;
    self.usedTime = 0;
    [self setUpNavi];
    
}
//配置collectionView
-(void)setUpCollectionView{
    //代理设置
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //注册item
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionCell class]) bundle:nil] forCellWithReuseIdentifier:identifierCell];
    
}
//配置collectBtn
-(void)setUpCollectBtn{
    if (self.isMock) {//在考试
        [self.collectBtn setImage:[UIImage imageNamed:@"交卷2"] forState:UIControlStateNormal];
        [self.collectBtn setTitle:@"交卷" forState:UIControlStateNormal];
    }else{//练习
        if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
            [self.collectBtn setImage:[UIImage imageNamed:@"delete_wrong_hd"] forState:UIControlStateNormal];
            [self.collectBtn setTitle:@"删除" forState:UIControlStateNormal];
        }else{
            //先判断是否已经收藏
            ZXBaseTopicModel *model = self.source[self.currentQ_index - 1];
            BOOL isCollect = [[ZXTopicManager sharedTopicManager] isExist:saveTypeFav andContentID:model.ID];
            if (isCollect) {
                self.collectBtn.selected = YES;
                [self.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
            }else{
                self.collectBtn.selected = NO;
                [self.collectBtn setImage:[UIImage imageNamed:@"icon_weishoucang"] forState:UIControlStateNormal];
            } 
        }
    }
}
//配置对错题
-(void)setUpRightWrong{
    __block NSInteger rightNum = 0;
    __block NSInteger wrongNum = 0;
    [self.finishStatus_big enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *status = (NSString *)obj;
        if ([status isEqualToString:@"1"]) {//1代表答对了
            rightNum++;
        }else if ([status isEqualToString:@"2"]) {//2代表答错了
            wrongNum++;
        }
    }];
    [self.rightBtn setTitle:[NSString stringWithFormat:@"%ld",(long)rightNum] forState:UIControlStateNormal];
    [self.wrongBtn setTitle:[NSString stringWithFormat:@"%ld",(long)wrongNum] forState:UIControlStateNormal];
}
//配置底部按钮
-(void)setUpBottomBtns{
    [self.collectBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [self.rightBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [self.wrongBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [self.cardBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    //配置collectBtn
    [self setUpCollectBtn];   
    //配置对错题
    [self setUpRightWrong];
    //取出记录信息
    if ([self.unfinish_Q isEqualToString:@"unfinish_Q"] || [self.random isEqualToString:@"random"]) {
        self.seleteBtnArr_big = nil;
        self.seleteCellArr_big = nil;
        self.showExplainArr = nil;
        self.currentAnswerArr_big = nil;
        self.finishStatus_big = nil;
    }else{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *seleteBtnArr_big1Path = [path stringByAppendingPathComponent:self.plistName_seleteBtnArr_big1Path];
        NSString *seleteCellArr_big1Path = [path stringByAppendingPathComponent:self.plistName_seleteCellArr_big1Path];
        NSString *showExplainArr1Path = [path stringByAppendingPathComponent:self.plistName_showExplainArr1Path];
        NSString *currentAnswerArr_big1Path = [path stringByAppendingPathComponent:self.plistName_currentAnswerArr_big1Path];
        NSString *finishStatus_big1Path = [path stringByAppendingPathComponent:self.plistName_finishStatus_big1Path];
        
        NSString *seleteBtnArr_big4Path = [path stringByAppendingPathComponent:self.plistName_seleteBtnArr_big4Path];
        NSString *seleteCellArr_big4Path = [path stringByAppendingPathComponent:self.plistName_seleteCellArr_big4Path];
        NSString *showExplainArr4Path = [path stringByAppendingPathComponent:self.plistName_showExplainArr4Path];
        NSString *currentAnswerArr_big4Path = [path stringByAppendingPathComponent:self.plistName_currentAnswerArr_big4Path];
        NSString *finishStatus_big4Path = [path stringByAppendingPathComponent:self.plistName_finishStatus_big4Path];
        
        if ([self.classType isEqualToString:@"class1"]) {//科一
            if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
                self.seleteBtnArr_big = nil;
                self.seleteCellArr_big = nil;
                self.showExplainArr = nil;
                self.currentAnswerArr_big = nil;
                self.finishStatus_big = nil;
            }else{
                self.seleteBtnArr_big = [NSMutableArray arrayWithContentsOfFile:seleteBtnArr_big1Path];
                self.seleteCellArr_big = [NSMutableArray arrayWithContentsOfFile:seleteCellArr_big1Path];
                self.showExplainArr = [NSMutableArray arrayWithContentsOfFile:showExplainArr1Path];
                self.currentAnswerArr_big = [NSMutableArray arrayWithContentsOfFile:currentAnswerArr_big1Path];
                self.finishStatus_big = [NSMutableArray arrayWithContentsOfFile:finishStatus_big1Path];
            }
            
        }else if ([self.classType isEqualToString:@"class4"]) {//科四
            if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
                self.seleteBtnArr_big = nil;
                self.seleteCellArr_big = nil;
                self.showExplainArr = nil;
                self.currentAnswerArr_big = nil;
                self.finishStatus_big = nil;
            }else{
                self.seleteBtnArr_big = [NSMutableArray arrayWithContentsOfFile:seleteBtnArr_big4Path];
                self.seleteCellArr_big = [NSMutableArray arrayWithContentsOfFile:seleteCellArr_big4Path];
                self.showExplainArr = [NSMutableArray arrayWithContentsOfFile:showExplainArr4Path];
                self.currentAnswerArr_big = [NSMutableArray arrayWithContentsOfFile:currentAnswerArr_big4Path];
                self.finishStatus_big = [NSMutableArray arrayWithContentsOfFile:finishStatus_big4Path];
            }
        }
        if (self.seleteBtnArr_big.count == 0) {
            self.seleteBtnArr_big = nil;
        }
        if (self.seleteCellArr_big.count == 0) {
            self.seleteCellArr_big = nil;
        }
        if (self.showExplainArr.count == 0) {
            self.showExplainArr = nil;
        }
        if (self.currentAnswerArr_big.count == 0) {
            self.currentAnswerArr_big = nil;
        }
        if (self.finishStatus_big.count == 0) {
            self.finishStatus_big = nil;
        }
    }
    //滚动到上一次做题的地方
    if ([self.unfinish_Q isEqualToString:@"unfinish_Q"]) {
        self.currentQ_index = 1;
    }else{
        if ([self.classType isEqualToString:@"class1"]) {//科一
            if ([self.random isEqualToString:@"random"]) {
                self.currentQ_index = 1;
            }else{
                self.currentQ_index = [[ZXUD objectForKey:self.class1Q_index] integerValue];
            }
        }else if ([self.classType isEqualToString:@"class4"]) {//科四
            if ([self.random isEqualToString:@"random"]) {
                self.currentQ_index = 1;
            }else{
                self.currentQ_index = [[ZXUD objectForKey:self.class4Q_index] integerValue];
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentQ_index - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
    //题号
    [self.cardBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentQ_index,(unsigned long)self.source.count] forState:UIControlStateNormal];
    
    //更改数据的完成状态
    NSMutableArray *newSource = [NSMutableArray array];
    [self.finishStatus_big enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXBaseTopicModel *model = self.source[idx];
        if ([obj isEqualToString:@"0"]) {//0代表没做
            model.status = @"0";
        }else if ([obj isEqualToString:@"1"]) {//1代表做对了
            model.status = @"1";
        }else if ([obj isEqualToString:@"2"]) {//2代表做错了
            model.status = @"2";
        }
        [newSource addObject:model];
    }];
    self.source = newSource;
}
#pragma mark -<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KScreenWidth - 20, KScreenHeight - 64 - 60 - 20);
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
    return 10;
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
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    //赋值
    cell.Q_Model = self.source[indexPath.row];
    cell.Q_Model.status = self.finishStatus_big[indexPath.row];
    cell.agency = self;
    cell.currentIndex = indexPath.row;
    cell.currentAnswer = self.currentAnswerArr_big[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;
    cell.seleteStateArr = (NSMutableArray *)self.seleteBtnArr_big[indexPath.row];
    cell.seleteCellArr = (NSMutableArray *)self.seleteCellArr_big[indexPath.row];
    cell.playerArr = self.playerArr;
    cell.lastPlayer = self.lastPlayer;
    //是否显示详解
    NSString *isShowExplain = self.showExplainArr[indexPath.row];
    if (self.segmentC.selectedSegmentIndex == 0) {
        isShowExplain = self.showExplainArr[indexPath.row];
        cell.isPracticeMode = YES;
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.source.count; i++) {
            [arr addObject:@"1"];
        }
        isShowExplain = arr[indexPath.row];
        cell.isPracticeMode = NO;
    }
    if ([isShowExplain isEqualToString:@"0"]) {
        cell.isShowExplain = NO;
    }else if ([isShowExplain isEqualToString:@"1"]) {
        cell.isShowExplain = YES;
    }
    
    [cell.tableView reloadData];
    
    //配置对错题
    [self setUpRightWrong];
    
    return cell;
}

//通过偏移量来确定时第几题(shoudo)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        self.currentQ_index = (int)scrollView.contentOffset.x/self.collectionView.frame.size.width + 1;
        [self.cardBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentQ_index,(unsigned long)self.source.count] forState:UIControlStateNormal];
        //配置collectBtn
        [self setUpCollectBtn];
        //配置对错题
        [self setUpRightWrong];
        
        
        if (scrollView.contentOffset.x < self.offsetX) {
            [self.collectionView reloadData];
        }
        self.offsetX = scrollView.contentOffset.x;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        
        self.currentQ_index = (int)scrollView.contentOffset.x/self.collectionView.frame.size.width + 1;
        [self.cardBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentQ_index,(unsigned long)self.source.count] forState:UIControlStateNormal];
        //配置collectBtn
        [self setUpCollectBtn];
        //配置对错题
        [self setUpRightWrong];
        
        
        if (scrollView.contentOffset.x < self.offsetX) {
            [self.collectionView reloadData];
        }
        self.offsetX = scrollView.contentOffset.x;
    }
}
#pragma mark -下边栏点击事件
//点击收藏(交卷)
- (IBAction)collectBtnAction:(UIButton *)sender {
    if (self.isMock) {//在考试
        [self.mockTimer setFireDate:[NSDate distantFuture]];//暂停定时器
        //遍历计算还有几道题没有做
        __block NSInteger unfinishNum = self.source.count;//总共100  \  50道题
        __block NSInteger currentScore = 0;//当前得分
        [self.finishStatus_big enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@"0"]) {
                unfinishNum--;
            }
            if ([obj isEqualToString:@"1"]){
                if ([self.classType isEqualToString:@"class1"]) {
                    currentScore++;
                }else{
                    currentScore += 2;
                }
            }
        }];
        self.yourScore = currentScore;//您当前得分
        //提示
        NSString *message = @"";
        if (unfinishNum != 0) {
            message = [NSString stringWithFormat:@"您还有%ld道题没做，确认交卷吗？",(long)unfinishNum];
        }else{
            message = @"您已答题完毕，确认交卷吗？";
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //push到考试结果界面
            MockResultVC *mockResult_VC = [[MockResultVC alloc]init];
            mockResult_VC.yourScore = self.yourScore;
            mockResult_VC.usedTimeStr = [NSString stringWithFormat:@"%02d:%02d",(int)_usedTime/60,(int)_usedTime%60];
            mockResult_VC.subject = _subject;
            [self.navigationController pushViewController:mockResult_VC animated:YES];
            //移除定时器
            [self.mockTimer invalidate];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.mockTimer setFireDate:[NSDate distantPast]];//开始定时器
            if ([message isEqualToString:@"您已答题完毕，确认交卷吗？"]) {
                self.doneAllAndGoOn = YES;
            }
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{//练习
        if ([self.wrongOrCollect isEqualToString:@"wrong"] || [self.wrongOrCollect isEqualToString:@"collect"]) {
            //移除
            [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC); 
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){                
                //题号
                NSInteger num = 0;
                if (self.source.count != 0) {
                    num = self.currentQ_index;
                    if (self.currentQ_index == self.source.count) {
                        num--;
                    }
                }else{
                    num = 0;
                }
                [self.cardBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)num,(unsigned long)self.source.count - 1]forState:UIControlStateNormal];
                //删除数据库里的数据
                ZXBaseTopicModel *model = self.source[self.currentQ_index - 1];
                if ([self.wrongOrCollect isEqualToString:@"wrong"]) {
                    [[ZXTopicManager sharedTopicManager] removeTopic:model saveType:saveTypeWrong];
                }else if ([self.wrongOrCollect isEqualToString:@"collect"]) {
                    [[ZXTopicManager sharedTopicManager] removeTopic:model saveType:saveTypeFav];
                }
                //删除当前控制器里的数据
                [self.source removeObjectAtIndex:self.currentQ_index - 1];
                [self.seleteBtnArr_big removeObjectAtIndex:self.currentQ_index - 1];
                [self.seleteCellArr_big removeObjectAtIndex:self.currentQ_index - 1];
                [self.showExplainArr removeObjectAtIndex:self.currentQ_index - 1];
                [self.currentAnswerArr_big removeObjectAtIndex:self.currentQ_index - 1];
                [self.finishStatus_big removeObjectAtIndex:self.currentQ_index - 1];
                //更新index
                if (self.currentQ_index == self.source.count + 1) {
                    self.currentQ_index--;
                }
                //刷新
                [self.collectionView reloadData];
                
                
                if (self.source.count == 0) {
                    //空空如也
                    self.collectBtn.userInteractionEnabled = NO;
                    self.cardBtn.userInteractionEnabled = NO;
                    [self.collectBtn setImage:[UIImage imageNamed:@"delete_wrong"] forState:UIControlStateNormal];
                    [self.collectBtn setTitleColor:KRGB(225, 225, 225, 1) forState:UIControlStateNormal];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([self.wrongOrCollect isEqualToString:@"wrong"]) {
                        [MBProgressHUD showError:@"您的错题本里没有内容了！"];
                    }else if ([self.wrongOrCollect isEqualToString:@"collect"]) {
                        [MBProgressHUD showError:@"暂时没有收藏内容了！"];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }                
            });
            
        }else{
            //先判断是否已经收藏
            ZXBaseTopicModel *model = self.source[self.currentQ_index - 1];
            if (self.collectBtn.selected) {//要移除
                self.collectBtn.selected = NO;
                [[ZXTopicManager sharedTopicManager] removeTopic:model saveType:saveTypeFav];
                [self.collectBtn setImage:[UIImage imageNamed:@"icon_weishoucang"] forState:UIControlStateNormal];
            }else{//要添加
                self.collectBtn.selected = YES;
                [[ZXTopicManager sharedTopicManager] addTopic:model saveType:saveTypeFav];
                [self.collectBtn setImage:[UIImage imageNamed:@"icon_yishoucang"] forState:UIControlStateNormal];
            } 
        }
    }
}
//点击对题集
- (IBAction)rightBtnAction:(UIButton *)sender {
}
//点击错题集
- (IBAction)wrongBtnAction:(UIButton *)sender {
}
//点击答题卡
- (IBAction)cardBtnAction:(UIButton *)sender {
    QuestionCardVC *questionCard_VC = [[QuestionCardVC alloc]init];
    questionCard_VC.source = self.finishStatus_big;
    questionCard_VC.agency = self;
    questionCard_VC.currentIndex = self.currentQ_index;
    questionCard_VC.isMock = self.isMock;
    questionCard_VC.wrongNum = self.wrongBtn.titleLabel.text;
    questionCard_VC.rightNum = self.rightBtn.titleLabel.text;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:questionCard_VC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark -QuestionCellDelegate
//做错了显示详解
-(void)changeShowExplainArrWith:(NSInteger)index{
    [HSFValueHelper sharedHelper].isReset = NO;
    [self.showExplainArr replaceObjectAtIndex:index withObject:@"1"];
    //更改数据的完成状态
    [self.finishStatus_big replaceObjectAtIndex:index withObject:@"2"];
    //刷表
    [self.collectionView reloadData];
    //先判断是否已经添加到错题本
    ZXBaseTopicModel *model = self.source[index];
    BOOL isSeveWrong = [[ZXTopicManager sharedTopicManager] isExist:saveTypeWrong andContentID:model.ID];
    if (isSeveWrong) {
        //什么也不做
    }else{//要添加
        [[ZXTopicManager sharedTopicManager] addTopic:model saveType:saveTypeWrong];
    }
}
//做对了跳转下一题
-(void)jumpToNextQuestionWith:(NSInteger)index{
    [HSFValueHelper sharedHelper].isReset = NO;
    [self.showExplainArr replaceObjectAtIndex:index withObject:@"1"];
    //更改数据的完成状态
    [self.finishStatus_big replaceObjectAtIndex:index withObject:@"1"];
//    //刷表
//    [self.collectionView reloadData];
    //跳转下一题
    if (index+1 == self.source.count) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    });
}

#pragma mark -QuestionCardVCDelegate
-(void)offsetCollectionViewWith:(NSIndexPath *)indexPath{
     [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.currentQ_index = indexPath.row + 1;
    //题号
    [self.cardBtn setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.currentQ_index,(unsigned long)self.source.count] forState:UIControlStateNormal];
    //配置collectBtn
    [self setUpCollectBtn];
    
}
//重置
-(void)resetQuestion{
//    [self.source enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        ZXBaseTopicModel *model = (ZXBaseTopicModel *)obj;
//        [[ZXTopicManager sharedTopicManager] resetTopicStatus:model];
//    }];
//    //重置数据
//    NSMutableArray *arr = [NSMutableArray array];
//    if ([self.classType isEqualToString:@"class1"]) {//科一
//        arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics];
//    }else if ([self.classType isEqualToString:@"class4"]) {//科四
//        arr = [[ZXTopicManager sharedTopicManager] readAllSubject4Topics];
//    }
//    NSMutableArray *modelArr = [NSMutableArray array];
//    for (NSDictionary *dic in arr) {
//        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
//        [modelArr addObject:model];
//    }
//    self.source = modelArr;
    
    [HSFValueHelper sharedHelper].isReset = YES;
    //重置记录状态
    self.seleteBtnArr_big = nil;
    self.seleteCellArr_big = nil;
    self.showExplainArr = nil;
    self.currentAnswerArr_big = nil;
    self.finishStatus_big = nil;
    
    //滚动到第一题
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //刷表
    [self.collectionView reloadData];
}

#pragma mark -计算得分
-(void)acountScore{
    __block NSInteger allScore = 100;//满分
    __block NSInteger currentScore = 0;//当前得分
    __block NSInteger wrongNum = 0;//错了几个
    [self.finishStatus_big enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"2"]) {
            wrongNum++;
            if ([self.classType isEqualToString:@"class1"]) {
                allScore--;
            }else if ([self.classType isEqualToString:@"class4"]) {
                allScore -= 2;
            }
        }
        if ([obj isEqualToString:@"1"]){
            if ([self.classType isEqualToString:@"class1"]) {
                currentScore++;
            }else if ([self.classType isEqualToString:@"class4"]) {
                currentScore += 2;
            }
        }
    }];
    self.yourScore = currentScore;
    if (self.finishMockAndGoOn) {
        return;
    }else{
        if (allScore == 92) {//分数小于92分提示
            if (!self.isAlert92) {
                self.isAlert92 = YES;
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经被扣了8分，请注意！ PS：考试成绩为90分以上才算合格哦^_^" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertC dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }
        if (allScore < 90) {//小于90分直接不合格
            [self.mockTimer setFireDate:[NSDate distantFuture]];//暂停定时器
            NSString *message = [NSString stringWithFormat:@"您已答错%ld题，考试得分：%ld分，成绩不合格，是否继续答题？",(long)wrongNum,(long)self.yourScore];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"交卷" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //push到考试结果界面
                MockResultVC *mockResult_VC = [[MockResultVC alloc]init];
                mockResult_VC.yourScore = self.yourScore;
                mockResult_VC.usedTimeStr = [NSString stringWithFormat:@"%02d:%02d",(int)_usedTime/60,(int)_usedTime%60];
                mockResult_VC.subject = _subject;
                [self.navigationController pushViewController:mockResult_VC animated:YES];
                //移除定时器
                [self.mockTimer invalidate];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.finishMockAndGoOn = YES;
                [self.mockTimer setFireDate:[NSDate distantPast]];//开始定时器
            }];
            [alertC addAction:action1];
            [alertC addAction:action2];
            [self presentViewController:alertC animated:YES completion:nil];
        }
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
