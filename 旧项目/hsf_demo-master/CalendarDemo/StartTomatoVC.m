//
//  StartTomatoVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/10.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "StartTomatoVC.h"

@interface StartTomatoVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *startOrStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic,strong) CKCircleView* dialView;//时间进度条
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int allSeconds;

//finish
@property (weak, nonatomic) IBOutlet UIView *finishBgView;
@property (weak, nonatomic) IBOutlet UIView *finishMaskView;
@property (weak, nonatomic) IBOutlet UILabel *finishTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBgViewBottomCons;
@property (weak, nonatomic) IBOutlet UIButton *finishOKBtn;

@property (nonatomic,assign) int currentNum;

@end

@implementation StartTomatoVC

#pragma mark -配置导航栏
-(void)setUpNavi{
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction{
    //返回
    if ([self.sourceVC isEqualToString:@"AddTomatoVC"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([self.sourceVC isEqualToString:@"TaskVC"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //刷新TaskVC
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSaveAddTomato" object:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"珍惜每一分每一秒";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KRGB(139, 188, 199, 1.0);
    //配置导航栏
    [self setUpNavi];
    //配置数据Model
    if ([self.model.time length]<=3) {
        self.currentNum = [[self.model.time substringToIndex:1] intValue];
    }else{
        self.currentNum = [[self.model.time substringToIndex:2] intValue];
    }
    self.titleLabel.text = self.model.title;
    //配置按钮
    [self.startOrStopBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.finishBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    //添加时间进度条
    [self setUpTimeSlider];
    //配置定时器
    [self setUpTimer];
    //配置finish
    [self setUpFinish];
}
//添加时间进度条
-(void)setUpTimeSlider{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dialView = [[CKCircleView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 120, KScreenWidth - 120)];
        self.dialView.center = CGPointMake(KScreenWidth/2, self.bgView.height/2);
        self.dialView.arcColor = [UIColor whiteColor];
        self.dialView.backColor = [KRGB(235, 235, 235, 1.0) colorWithAlphaComponent:0.6];
        self.dialView.dialColor = [UIColor whiteColor];
        self.dialView.arcRadius = KScreenWidth - 120;
        self.dialView.units = @"分钟";
        self.dialView.minNum = 0;
        self.dialView.maxNum = 60;
        self.dialView.labelColor = [UIColor whiteColor];
        self.dialView.labelFont = [UIFont systemFontOfSize:40.0];
        [self.bgView addSubview: self.dialView];
        //进度条不可交互
        self.dialView.userInteractionEnabled = NO;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //最大进度条
        double angle = ((double)(self.currentNum - self.dialView.minNum)/(self.dialView.maxNum - self.dialView.minNum)) * 360.0;
        [self.dialView moveCircleToAngle:angle];
    });
}
//配置定时器
-(void)setUpTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerACTION:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.allSeconds = self.currentNum * 60;//一共多少秒
}
//配置finish
-(void)setUpFinish{
    self.finishBgView.hidden = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFinishView)];
    self.finishMaskView.userInteractionEnabled = YES;
    [self.finishMaskView addGestureRecognizer:singleTap];
    self.finishOKBtn.layer.masksToBounds = YES;
    self.finishOKBtn.layer.cornerRadius = 10;
    self.finishOKBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.finishOKBtn.layer.borderWidth = 1;
}
//点击移除finish
-(void)removeFinishView{
    [self backAction];
}
//点击开始暂停按钮
- (IBAction)startOrStopBtnACTION:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"stop2_tomato"] forState:UIControlStateNormal];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"start2_tomato"] forState:UIControlStateNormal];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    }
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:1.0];
    //设置动画效果
//    [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.dialView cache:YES];  //从上向下
//    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.dialView cache:YES];   //从下向上
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.bgView cache:YES];  //从左向右
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
    if (self.startOrStopBtn.selected) {
        [self.timer setFireDate:[NSDate distantPast]];//开始定时器
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];//暂停定时器
    }
}
-(void)timerACTION:(NSTimer *)timer{
    self.allSeconds--;
    //配置进度条
    double angle = ((double)(self.allSeconds - self.dialView.minNum*60)/(self.dialView.maxNum*60 - self.dialView.minNum*60)) * 360.0;
    [self.dialView moveCircleToAngle:angle];
    if (self.startOrStopBtn.selected) {
        self.dialView.numberLabel.text = [NSString stringWithFormat:@"00:%02d:%02d",self.allSeconds/60,self.allSeconds%60];
    }else{
        
    }
}
//点击完成按钮
- (IBAction)finishBtnACTION:(UIButton *)sender {
    //暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    self.finishBgView.hidden = NO;
    self.finishTitleLabel.text = self.titleLabel.text;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.finishBgView.frame = CGRectMake(0, 0, self.finishBgView.width, self.finishBgView.height);
        }];
    });
    //更改数据库中的isFinished字段
    self.model.isFinished = @"1";
    [[HSFFmdbManager sharedManager] modifyTaskWith:self.model whereCondition:@{@"task_id":self.model.task_id}];
}

//点击完成finish
- (IBAction)finishOKBtnACTION:(UIButton *)sender {
    [self backAction];
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
