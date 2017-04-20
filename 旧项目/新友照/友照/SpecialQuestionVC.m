//
//  SpecialQuestionVC.m
//  友照
//
//  Created by monkey2016 on 16/12/13.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SpecialQuestionVC.h"

#import "SpecialQuestionCell.h"

@interface SpecialQuestionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *identifierCell = @"identifierCell";
@implementation SpecialQuestionVC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -懒加载
-(NSArray *)source{
    if (!_source) {
        _source = [NSArray array];
    }
    return _source;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnACTION)];
}
//返回
-(void)backBtnACTION{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"专项练习";
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置Navi
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
}
//配置tableView
-(void)setUpTableView{
    //设置数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SpecialQuestionCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.title.text = self.source[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionVC *question_VC = [[QuestionVC alloc]init];
    //取出科一所有的题
    question_VC.classType = self.classType;
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.classType isEqualToString:@"class1"]) {
        arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics:self.source[indexPath.row]];
    }else if ([self.classType isEqualToString:@"class4"]) {
        arr = [[ZXTopicManager sharedTopicManager] readAllSubject4Topics:self.source[indexPath.row]];
    }
    //转模型
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
        [modelArr addObject:model];
    }
    question_VC.source = modelArr;
    //保存记录状态的文件名
    [self makeSureAboutFileNameWith:question_VC andtype:self.source[indexPath.row]];
    //跳转到答题页面
    [self.navigationController pushViewController:question_VC animated:YES];

}
//保存记录状态的文件名
-(void)makeSureAboutFileNameWith:(QuestionVC *)question_VC andtype:(NSString *)type{
    question_VC.plistName_seleteBtnArr_big1Path = [NSString stringWithFormat:@"class1_special_btn_%@",type];
    question_VC.plistName_seleteCellArr_big1Path = [NSString stringWithFormat:@"class1_special_cell_%@",type];
    question_VC.plistName_showExplainArr1Path = [NSString stringWithFormat:@"class1_special_explain_%@",type];
    question_VC.plistName_currentAnswerArr_big1Path = [NSString stringWithFormat:@"class1_special_answer_%@",type];
    question_VC.plistName_finishStatus_big1Path = [NSString stringWithFormat:@"class1_special_status_%@",type];
    
    question_VC.plistName_seleteBtnArr_big4Path = [NSString stringWithFormat:@"class4_special_btn_%@",type];
    question_VC.plistName_seleteCellArr_big4Path = [NSString stringWithFormat:@"class4_special_cell_%@",type];
    question_VC.plistName_showExplainArr4Path = [NSString stringWithFormat:@"class4_special_explain_%@",type];
    question_VC.plistName_currentAnswerArr_big4Path = [NSString stringWithFormat:@"class4_special_answer_%@",type];
    question_VC.plistName_finishStatus_big4Path = [NSString stringWithFormat:@"class4_special_status_%@",type];
    
    question_VC.class1Q_index = [NSString stringWithFormat:@"class1Q_index_special_%@",type];
    question_VC.class4Q_index = [NSString stringWithFormat:@"class4Q_index_special_%@",type];
    
    question_VC.selectedSegmentIndex1 = [NSString stringWithFormat:@"selectedSegmentIndex1_special_%@",type];
    question_VC.selectedSegmentIndex4 = [NSString stringWithFormat:@"selectedSegmentIndex4_special_%@",type];
    
    question_VC.isMock = NO;
    
    
}

#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
