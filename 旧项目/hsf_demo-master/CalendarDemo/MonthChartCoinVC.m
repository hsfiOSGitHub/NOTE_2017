//
//  MonthChartCoinVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MonthChartCoinVC.h"

#import "CoinChartCell.h"

@interface MonthChartCoinVC ()<UITableViewDataSource,UITableViewDelegate>
//XIB>>>>>>>>>>
//顶部星期
@property (weak, nonatomic) IBOutlet UIView *timeBgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//底部转场按钮
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;

//Code>>>>>>>>>

@end

static NSString *identifierCell = @"identifierCell";
@implementation MonthChartCoinVC

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
    self.navigationItem.title = @"月总结";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    //配置底部转场按钮
    [self.todayBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.weekBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self.monthBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CoinChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CoinChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    return cell;
}



#pragma mark -点击底部跳转按钮
- (IBAction)pushBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//今天
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 200:{//周小结
            WeekChartCionVC *week_C = [[WeekChartCionVC alloc]init];
            [self.navigationController pushViewController:week_C animated:NO];
        }
            break;
        case 300:{//月总结
            
        }
            break;
            
        default:
            break;
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
