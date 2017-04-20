//
//  MockVC.m
//  友照
//
//  Created by monkey2016 on 16/12/13.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "MockVC.h"

@interface MockVC ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *classType;
@property (weak, nonatomic) IBOutlet UIButton *starExamBtn;
@property (weak, nonatomic) IBOutlet UIButton *dengLu;
@property (nonatomic,strong) NSString *currentMockTime;//当前模拟考试次数
@end

@implementation MockVC
//初始化方法
-(instancetype)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark -配置导航栏
-(void)setUpNavi
{
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnACTION)];
}

//返回
-(void)backBtnACTION
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = [NSString stringWithFormat:@"%@模拟考试",self.classTypeStr];
    self.navigationController.navigationBarHidden = NO;
    
    //取出考试次数
    if ([self.classTypeStr isEqualToString:@"科目一"])
    {
        self.currentMockTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"mockTime1"];
    }
    else if ([self.classTypeStr isEqualToString:@"科目四"])
    {
        self.currentMockTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"mockTime4"];
    }
    
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:[ZXUD objectForKey:@"userpic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        _userName.text = [ZXUD objectForKey:@"username"];
        _dengLu.hidden = YES;
    }
    else
    {
        [MBProgressHUD showSuccess:@"您还没有登录哦"];
        _dengLu.hidden = NO;
    }
}
#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //考试类型(科一科四)
    self.classType.text = self.classTypeStr;
    //头像
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 60;
    self.userIcon.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.userIcon.layer.borderWidth = 1;
    [_dengLu addTarget:self action:@selector(turnToLogin) forControlEvents:UIControlEventTouchDown];
}

- (void)turnToLogin
{
    ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//点击开始考试
- (IBAction)starExamBtnACTION:(UIButton *)sender
{
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取题
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.classTypeStr isEqualToString:@"科目一"])
    {
        question_VC.classType = @"class1";
        arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics];
    }else if ([self.classTypeStr isEqualToString:@"科目四"])
    {
        question_VC.classType = @"class4";
        arr = [[ZXTopicManager sharedTopicManager] readAllSubject4Topics];
    }
    
    //取出100道题/50道题
    NSMutableArray *randomArr100_50 = [NSMutableArray array];
    NSMutableArray *randomArr = [NSMutableArray arrayWithArray:arr];
    if ([self.classTypeStr isEqualToString:@"科目一"])
    {
        for (int i = 0; i < 100; i++)
        {
            //随机
            NSInteger count = randomArr.count;
            int index = arc4random()%count;
            [randomArr100_50 addObject:randomArr[index]];
            [randomArr removeObjectAtIndex:index];
        }
        
    }
    else if ([self.classTypeStr isEqualToString:@"科目四"])
    {
        for (int i = 0; i < 50; i++)
        {
            //随机
            NSInteger count = randomArr.count;
            int index = arc4random()%count;
            [randomArr100_50 addObject:randomArr[index]];
            [randomArr removeObjectAtIndex:index]; 
        }
    }    
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in randomArr100_50)
    {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    
    NSInteger time = [self.currentMockTime integerValue];
    time++;
    self.currentMockTime = [NSString stringWithFormat:@"%ld",(long)time];
    //保存考试次数
    if ([self.classTypeStr isEqualToString:@"科目一"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.currentMockTime forKey:@"mockTime1"];
    }
    else if ([self.classTypeStr isEqualToString:@"科目四"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.currentMockTime forKey:@"mockTime4"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //保存记录状态的文件名
    question_VC.plistName_seleteBtnArr_big1Path = [NSString stringWithFormat:@"class1_mock%@_btn",self.currentMockTime];
    question_VC.plistName_seleteCellArr_big1Path = [NSString stringWithFormat:@"class1_mock%@_cell",self.currentMockTime];
    question_VC.plistName_showExplainArr1Path = [NSString stringWithFormat:@"class1_mock%@_explain",self.currentMockTime];
    question_VC.plistName_currentAnswerArr_big1Path = [NSString stringWithFormat:@"class1_mock%@_answer",self.currentMockTime];
    question_VC.plistName_finishStatus_big1Path = [NSString stringWithFormat:@"class1_mock%@_status",self.currentMockTime];
    
    question_VC.plistName_seleteBtnArr_big4Path = [NSString stringWithFormat:@"class4_mock%@_btn",self.currentMockTime];
    question_VC.plistName_seleteCellArr_big4Path = [NSString stringWithFormat:@"class4_mock%@_cell",self.currentMockTime];
    question_VC.plistName_showExplainArr4Path = [NSString stringWithFormat:@"class4_mock%@_explain",self.currentMockTime];
    question_VC.plistName_currentAnswerArr_big4Path = [NSString stringWithFormat:@"class4_mock%@_answer",self.currentMockTime];
    question_VC.plistName_finishStatus_big4Path = [NSString stringWithFormat:@"class4_mock%@_status",self.currentMockTime];
    
    question_VC.class1Q_index = [NSString stringWithFormat:@"class1Q_index_mock%@",self.currentMockTime];
    question_VC.class4Q_index = [NSString stringWithFormat:@"class4Q_index_mock%@",self.currentMockTime];
    
    question_VC.selectedSegmentIndex1 = [NSString stringWithFormat:@"selectedSegmentIndex1_mock%@",self.currentMockTime];
    question_VC.selectedSegmentIndex4 = [NSString stringWithFormat:@"selectedSegmentIndex4_mock%@",self.currentMockTime];
    question_VC.subject = _subject;
    question_VC.isMock = YES;
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];
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
