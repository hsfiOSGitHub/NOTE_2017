//
//  JK_Class1VC.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "JK_Class1VC.h"
#import "ZX_Web_ViewController.h"
#import "ZX_JiaoTongBiaoZhi_ViewController.h"
#import "ZX_JiaoJingShouShi_ViewController.h"
#import "UMComSimpleTopicFeedTableViewController.h"
#import "ZX_Test_ViewController.h"
#import "ZX_KaoShiPaiHang_ViewController.h"
#import "UMComSelectTopicViewController.h"
#import "UMComBriefEditViewController.h"


@class UMComTopic;

@interface JK_Class1VC ()
//练习
@property (weak, nonatomic) IBOutlet UIButton *practice_orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *practice_randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *practice_specialBtn;
@property (weak, nonatomic) IBOutlet UIButton *practice_wrongBtn;
@property (weak, nonatomic) IBOutlet UIButton *practice_unfinishedBtn;
//考试
@property (weak, nonatomic) IBOutlet UIButton *exam_mockBtn;
@property (weak, nonatomic) IBOutlet UIButton *exam_ranklistBtn;
@property (weak, nonatomic) IBOutlet UIButton *exam_recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *exam_noticeBtn;
@property (weak, nonatomic) IBOutlet UIButton *exam_wishBtn;
//other
@property (weak, nonatomic) IBOutlet UIImageView *icon_wrong;
@property (weak, nonatomic) IBOutlet UIImageView *icon_collect;
@property (weak, nonatomic) IBOutlet UIImageView *icon_sign;
@property (weak, nonatomic) IBOutlet UIImageView *icon_gesture;
//
@property (weak, nonatomic) IBOutlet UIView *wrongView;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIView *gestureView;




@end

@implementation JK_Class1VC

#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    //配置subViews
    [self setUpSubViews];

}
//配置subViews
-(void)setUpSubViews
{
    [self.practice_orderBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.practice_randomBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.practice_specialBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.practice_wrongBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.practice_unfinishedBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.exam_mockBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.exam_ranklistBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.exam_recordBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.exam_noticeBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.exam_wishBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    
    //配置icon
//    self.icon_wrong.backgroundColor = KRGB(24, 190, 250, 1);
//    self.icon_collect.backgroundColor = KRGB(240, 24, 26, 1);
//    self.icon_sign.backgroundColor = KRGB(154, 95, 197, 1);
//    self.icon_gesture.backgroundColor = KRGB(252, 140, 29, 1);
    
    self.icon_wrong.layer.masksToBounds = YES;
    self.icon_collect.layer.masksToBounds = YES;
    self.icon_sign.layer.masksToBounds = YES;
    self.icon_gesture.layer.masksToBounds = YES;
    
    self.icon_wrong.layer.cornerRadius = 25;
    self.icon_collect.layer.cornerRadius = 25;
    self.icon_sign.layer.cornerRadius = 25;
    self.icon_gesture.layer.cornerRadius = 25;
}

#pragma mark -点击事件
//顺序练习
- (IBAction)practice_orderBtnAction:(UIButton *)sender
{
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics];
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    //保存记录状态的文件名
    question_VC.plistName_seleteBtnArr_big1Path = @"class1_order_btn";
    question_VC.plistName_seleteCellArr_big1Path = @"class1_order_cell";
    question_VC.plistName_showExplainArr1Path = @"class1_order_explain";
    question_VC.plistName_currentAnswerArr_big1Path = @"class1_order_answer";
    question_VC.plistName_finishStatus_big1Path = @"class1_order_status";
    
    question_VC.plistName_seleteBtnArr_big4Path = @"class4_order_btn";
    question_VC.plistName_seleteCellArr_big4Path = @"class4_order_cell";
    question_VC.plistName_showExplainArr4Path = @"class4_order_explain";
    question_VC.plistName_currentAnswerArr_big4Path = @"class4_order_answer";
    question_VC.plistName_finishStatus_big4Path = @"class4_order_status";
    
    question_VC.class1Q_index = @"class1Q_index_order";
    question_VC.class4Q_index = @"class4Q_index_order";
    
    question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_order";
    question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_order";
    
    question_VC.isMock = NO;
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];
}

//随机练习
- (IBAction)practice_orderBtnACTION:(UIButton *)sender
{
    
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics];
    //随机
    NSMutableArray *randomArr_all = [NSMutableArray array];
    NSMutableArray *randomArr = [NSMutableArray arrayWithArray:arr];
    NSInteger COUNT = randomArr.count;
    for (int i = 0; i < COUNT; i++)
    {
        //随机
        NSInteger count = randomArr.count;
        int index = arc4random()%count;
        [randomArr_all addObject:randomArr[index]];
        [randomArr removeObjectAtIndex:index];
    }
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in randomArr_all)
    {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    //保存记录状态的文件名
    question_VC.plistName_seleteBtnArr_big1Path = @"class1_random_btn";
    question_VC.plistName_seleteCellArr_big1Path = @"class1_random_cell";
    question_VC.plistName_showExplainArr1Path = @"class1_random_explain";
    question_VC.plistName_currentAnswerArr_big1Path = @"class1_random_answer";
    question_VC.plistName_finishStatus_big1Path = @"class1_random_status";
    
    question_VC.plistName_seleteBtnArr_big4Path = @"class4_random_btn";
    question_VC.plistName_seleteCellArr_big4Path = @"class4_random_cell";
    question_VC.plistName_showExplainArr4Path = @"class4_random_explain";
    question_VC.plistName_currentAnswerArr_big4Path = @"class4_random_answer";
    question_VC.plistName_finishStatus_big4Path = @"class4_random_status";
    
    question_VC.class1Q_index = @"class1Q_index_random";
    question_VC.class4Q_index = @"class4Q_index_random";
    
    question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_random";
    question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_random";
    
    question_VC.isMock = NO;
    
    question_VC.random = @"random";
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];
}

//专项练习
- (IBAction)practice_specialBtnACTION:(UIButton *)sender
{
    SpecialQuestionVC *specialQuestion_VC = [[SpecialQuestionVC alloc]init];
    specialQuestion_VC.source = @[@"时间", @"距离", @"罚款", @"速度", @"标线", @"标志", @"手势", @"信号灯", @"记分", @"酒驾", @"灯光", @"仪表", @"装置", @"路况"];
    specialQuestion_VC.classType = @"class1";
    [self.navigationController pushViewController:specialQuestion_VC animated:YES];
}

//易错题
- (IBAction)practice_wrongBtnACTION:(UIButton *)sender
{
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readSubjectYiCuoTiWithSubject:@"1"];
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    //保存记录状态的文件名
    question_VC.plistName_seleteBtnArr_big1Path = @"class1_wrong_btn";
    question_VC.plistName_seleteCellArr_big1Path = @"class1_wrong_cell";
    question_VC.plistName_showExplainArr1Path = @"class1_wrong_explain";
    question_VC.plistName_currentAnswerArr_big1Path = @"class1_wrong_answer";
    question_VC.plistName_finishStatus_big1Path = @"class1_wrong_status";
    
    question_VC.plistName_seleteBtnArr_big4Path = @"class4_wrong_btn";
    question_VC.plistName_seleteCellArr_big4Path = @"class4_wrong_cell";
    question_VC.plistName_showExplainArr4Path = @"class4_wrong_explain";
    question_VC.plistName_currentAnswerArr_big4Path = @"class4_wrong_answer";
    question_VC.plistName_finishStatus_big4Path = @"class4_wrong_status";
    
    question_VC.class1Q_index = @"class1Q_index_wrong";
    question_VC.class4Q_index = @"class4Q_index_wrong";
    
    question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_wrong";
    question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_wrong";
    
    question_VC.isMock = NO;
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];
}

//未做题
- (IBAction)practice_unfinishBtnACTION:(UIButton *)sender
{
    
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readAllWeiZuoTiWithSubject:@"1"];
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    //保存记录状态的文件名
    question_VC.plistName_seleteBtnArr_big1Path = @"class1_unfinish_btn";
    question_VC.plistName_seleteCellArr_big1Path = @"class1_unfinish_cell";
    question_VC.plistName_showExplainArr1Path = @"class1_unfinish_explain";
    question_VC.plistName_currentAnswerArr_big1Path = @"class1_unfinish_answer";
    question_VC.plistName_finishStatus_big1Path = @"class1_unfinish_status";
    
    question_VC.plistName_seleteBtnArr_big4Path = @"class4_unfinish_btn";
    question_VC.plistName_seleteCellArr_big4Path = @"class4_unfinish_cell";
    question_VC.plistName_showExplainArr4Path = @"class4_unfinish_explain";
    question_VC.plistName_currentAnswerArr_big4Path = @"class4_unfinish_answer";
    question_VC.plistName_finishStatus_big4Path = @"class4_unfinish_status";
    
    question_VC.class1Q_index = @"class1Q_index_unfinish";
    question_VC.class4Q_index = @"class4Q_index_unfinish";
    
    question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_unfinish";
    question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_unfinish";
    
    question_VC.isMock = NO;

    question_VC.unfinish_Q = @"unfinish_Q";
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];
}

//模拟考试
- (IBAction)exam_mockBtnACTION:(UIButton *)sender
{
    MockVC *mock_VC = [[MockVC alloc]init];
    mock_VC.classTypeStr = @"科目一";
    mock_VC.subject = @"1";
    [ZXUD setObject:@"1" forKey:@"moNiKaoShi"];
    [self.navigationController pushViewController:mock_VC animated:YES];
}

//考试排行
- (IBAction)exam_ranklistBtnACTION:(UIButton *)sender
{
    ZX_KaoShiPaiHang_ViewController *kaoShiPaiHangVC = [[ZX_KaoShiPaiHang_ViewController alloc]init];
    kaoShiPaiHangVC.subject = @"1";
    [self.navigationController pushViewController:kaoShiPaiHangVC animated:YES];
}

//考试纪录
- (IBAction)exam_recordBtnACTION:(UIButton *)sender
{
    ZX_Test_ViewController *testVC = [[ZX_Test_ViewController alloc]init];
    testVC.subject = @"1";
    [self.navigationController pushViewController:testVC animated:YES];
}

//考试须知
- (IBAction)exam_noticeBtnACTION:(UIButton *)sender
{
    ZX_Web_ViewController *webVC = [[ZX_Web_ViewController alloc] init];
    webVC.htmlStr = @"科一内容";
    webVC.titleStr = @"考试须知";
    [self.navigationController pushViewController:webVC animated:YES];
}

//考前愿望
- (IBAction)exam_wishBtnACTION:(UIButton *)sender
{
    
    __weak typeof(self) weakself = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            
            //可变话题的选择----begin
            UMComSelectTopicViewController*  selectTopicViewController = [[UMComSelectTopicViewController alloc] initWithNibName:@"UMComSelectTopicViewController" bundle:nil];
            
            //有限赋值给当前的ViewController
            UIViewController* popToViewController = weakself;
            
            //如果有父窗口就判断是不是childViewControllers中包含self,把popToViewController定位到parentViewController
            UIViewController* parentViewController = weakself.parentViewController;
            if (parentViewController) {
                BOOL isContained = [parentViewController.childViewControllers containsObject:weakself];
                if (isContained) {
                    popToViewController = parentViewController;
                }
            }
            selectTopicViewController.selectTopicViewFinishAction = ^(UMComTopic* topic){
                UMComBriefEditViewController* editViewController = [[UMComBriefEditViewController alloc] initModifiedTopic:topic withPopToViewController:popToViewController];
                [weakself.navigationController pushViewController:editViewController animated:YES];
            };
            
            selectTopicViewController.closeTopicViewAction = ^(){
                [weakself.navigationController popViewControllerAnimated:YES];
            };
            [weakself.navigationController pushViewController:selectTopicViewController animated:YES];
            //可变话题的选择----end
        }
    }];

}
//我的错题
- (IBAction)myWrongQuestion:(UITapGestureRecognizer *)sender
{
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readClass1AllWrongTopics];
    if (arr.count == 0) {
        [MBProgressHUD showError:@"您的错题本里暂无内容！"];
    }else{
        //转模型
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
            [modelArr addObject:model];
        }
        question_VC.source = modelArr;
        //保存记录状态的文件名
        question_VC.plistName_seleteBtnArr_big1Path = @"class1_wrong_btn";
        question_VC.plistName_seleteCellArr_big1Path = @"class1_wrong_cell";
        question_VC.plistName_showExplainArr1Path = @"class1_wrong_explain";
        question_VC.plistName_currentAnswerArr_big1Path = @"class1_wrong_answer";
        question_VC.plistName_finishStatus_big1Path = @"class1_wrong_status";
        
        question_VC.plistName_seleteBtnArr_big4Path = @"class4_wrong_btn";
        question_VC.plistName_seleteCellArr_big4Path = @"class4_wrong_cell";
        question_VC.plistName_showExplainArr4Path = @"class4_wrong_explain";
        question_VC.plistName_currentAnswerArr_big4Path = @"class4_wrong_answer";
        question_VC.plistName_finishStatus_big4Path = @"class4_wrong_status";
        
        question_VC.class1Q_index = @"class1Q_index_wrong";
        question_VC.class4Q_index = @"class4Q_index_wrong";
        
        question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_wrong";
        question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_wrong";
        
        question_VC.isMock = NO;
        
        question_VC.wrongOrCollect = @"wrong";
        //跳转到答题页面
        [self.navigationController pushViewController:question_VC animated:YES];
    }
}

//我的收藏
- (IBAction)myCollection:(UITapGestureRecognizer *)sender 
{
    
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = @"class1";
    NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readClass1AllFavTopics];
    if (arr.count == 0) {
        [MBProgressHUD showError:@"暂无收藏内容！"];
    }else{
        //转模型
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
            [modelArr addObject:model];
        }
        question_VC.source = modelArr;
        //保存记录状态的文件名
        question_VC.plistName_seleteBtnArr_big1Path = @"class1_collect_btn";
        question_VC.plistName_seleteCellArr_big1Path = @"class1_collect_cell";
        question_VC.plistName_showExplainArr1Path = @"class1_collect_explain";
        question_VC.plistName_currentAnswerArr_big1Path = @"class1_collect_answer";
        question_VC.plistName_finishStatus_big1Path = @"class1_collect_status";
        
        question_VC.plistName_seleteBtnArr_big4Path = @"class4_collect_btn";
        question_VC.plistName_seleteCellArr_big4Path = @"class4_collect_cell";
        question_VC.plistName_showExplainArr4Path = @"class4_collect_explain";
        question_VC.plistName_currentAnswerArr_big4Path = @"class4_collect_answer";
        question_VC.plistName_finishStatus_big4Path = @"class4_collect_status";
        
        question_VC.class1Q_index = @"class1Q_index_collect";
        question_VC.class4Q_index = @"class4Q_index_collect";
        
        question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_collect";
        question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_collect";
        
        question_VC.isMock = NO;
        
        question_VC.wrongOrCollect = @"collect";
        //跳转到答题页面
        [self.navigationController pushViewController:question_VC animated:YES];
    }
}

//交通标志
- (IBAction)trafficSign:(UITapGestureRecognizer *)sender
{
    ZX_JiaoTongBiaoZhi_ViewController *jiaoTongBiaoZhiVC = [[ZX_JiaoTongBiaoZhi_ViewController alloc]init];
    [self.navigationController pushViewController:jiaoTongBiaoZhiVC animated:YES];
}

//交警手势
- (IBAction)tafficGesture:(UITapGestureRecognizer *)sender
{
    ZX_JiaoJingShouShi_ViewController *jiaoJingShouShiVC = [[ZX_JiaoJingShouShi_ViewController alloc]init];
    jiaoJingShouShiVC.fileName = @"traffic_police_gesture";
    jiaoJingShouShiVC.title = @"交警手势";
    [self.navigationController pushViewController:jiaoJingShouShiVC animated:YES];
   
}

- (void)login
{
    ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
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
