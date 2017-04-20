//
//  ChartVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/5.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ChartVC.h"

#import "ChartCountCell.h"//统计
#import "ChartChartCell.h"//饼图
#import "ChartBarChartCell.h"//柱状图
#import "ChartLineCell.h"//折线图

@interface ChartVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

//top
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userName;

//title
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIView *baseline;

//content
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
//bottom
@property (weak, nonatomic) IBOutlet UIButton *countBtn;//统计
@property (weak, nonatomic) IBOutlet UIButton *chartBtn;//饼图
@property (weak, nonatomic) IBOutlet UIButton *barChartBtn;//柱状图

@end


static NSString *identifierCell_count = @"identifierCell_count";
static NSString *identifierCell_chart = @"identifierCell_chart";
static NSString *identifierCell_bar = @"identifierCell_bar";
static NSString *identifierCell_line = @"identifierCell_line";
@implementation ChartVC

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
    self.navigationItem.title = @"我的成就";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置subView
    [self setUpSubViews];
    //配置scrollView
    [self setUpScrollView];
    //配置tableView
    [self setUpTableView];
}
//配置subView
-(void)setUpSubViews{
    //用户
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = 40;
    
    //统计
    [self.countBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.chartBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.barChartBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
}
//配置scrollView
-(void)setUpScrollView{
    self.scrollView.delegate = self;
}
//配置tableView
-(void)setUpTableView{
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView3.delegate = self;
    //高度
    self.tableView1.estimatedRowHeight = 44;
    self.tableView2.estimatedRowHeight = 44;
    self.tableView3.estimatedRowHeight = 44;
    self.tableView1.rowHeight = UITableViewAutomaticDimension;
    self.tableView2.rowHeight = UITableViewAutomaticDimension;
    self.tableView3.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartCountCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_count];
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_chart];
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartBarChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_bar];
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartLineCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_line];
    
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartCountCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_count];
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_chart];
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartBarChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_bar];
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartLineCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_line];
    
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartCountCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_count];
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_chart];
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartBarChartCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_bar];
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([ChartLineCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_line];
    
}
#pragma mark -UIScrollViewDelegate
//点击标题按钮
- (IBAction)titleBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//今天
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 200:{//本周 
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
        }
            break;
        case 300:{//本月
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 2, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}
//只要滑动就会掉用该方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //baseline的滑动
    if (scrollView == self.scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        [UIView animateWithDuration:0.3 animations:^{
            if (offsetX >= 0 && offsetX < KScreenWidth/2) {//今天
                self.baseline.center = CGPointMake(self.todayBtn.centerX, self.baseline.centerY);
            }else if (offsetX >= KScreenWidth/2 && offsetX < KScreenWidth/2 * 3) {//本周
                self.baseline.center = CGPointMake(self.weekBtn.centerX, self.baseline.centerY);
            }else if (offsetX >= KScreenWidth/2 * 3 && offsetX < KScreenWidth/2 * 5) {//本月
                self.baseline.center = CGPointMake(self.monthBtn.centerX, self.baseline.centerY);
            }
        }];
    }
//    //tableView的滑动
//    if (scrollView == self.tableView1 || scrollView == self.tableView2 || scrollView == self.tableView3) {
//        
//    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self.tableView1 reloadData];
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
    }
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChartCountCell *countCell = [tableView dequeueReusableCellWithIdentifier:identifierCell_count forIndexPath:indexPath];
        if (tableView == self.tableView1) {
            countCell.dateIcon.image = [UIImage imageNamed:@"today_chart"];
            countCell.dateLabel.text = [NSString stringWithFormat:@"%ld月%ld日",(long)[[NSDate date] dateMonth],(long)[[NSDate date] dateDay]];
            countCell.finishedLabel.text = [NSString stringWithFormat:@"今日完成："];
            countCell.unfinishedLabel.text = [NSString stringWithFormat:@"今日未完成："];
            countCell.percent = 0.6;
        }else if (tableView == self.tableView2) {
            countCell.dateIcon.image = [UIImage imageNamed:@"week_chart"];
            countCell.dateLabel.text = [NSDate currentWeek:[NSDate date]];
            countCell.finishedLabel.text = [NSString stringWithFormat:@"本周完成："];
            countCell.unfinishedLabel.text = [NSString stringWithFormat:@"本周未完成："];
            countCell.percent = 0.4;
        }else if (tableView == self.tableView3) {
            countCell.dateIcon.image = [UIImage imageNamed:@"month_chart"];
            countCell.dateLabel.text = [NSString stringWithFormat:@"%ld月01日 - %ld月%ld日",(long)[[NSDate date] dateMonth],(long)[[NSDate date] dateMonth],(long)[[NSDate date] dateDay]];
            countCell.finishedLabel.text = [NSString stringWithFormat:@"本月完成："];
            countCell.unfinishedLabel.text = [NSString stringWithFormat:@"本月未完成："];
            countCell.percent = 0.5;
        }
        return countCell;
    }else if (indexPath.row == 1) {
        ChartChartCell *chartCell = [tableView dequeueReusableCellWithIdentifier:identifierCell_chart forIndexPath:indexPath];
        chartCell.finishedValue = 10;
        chartCell.unfinishedValue = 20;
        chartCell.draw = @"draw";
        if (tableView == self.tableView1) {
            
        }else if (tableView == self.tableView2) {
            
        }else if (tableView == self.tableView3) {
            
        }
        return chartCell;
    }else if (indexPath.row == 2) {
        ChartBarChartCell *barCell = [tableView dequeueReusableCellWithIdentifier:identifierCell_bar forIndexPath:indexPath];
        barCell.XTitlesArr = @[@"12-01",@"12-02",@"12-03",@"12-04",@"12-05",@"12-06",@"12-07"];
        barCell.finishedArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
        barCell.unfinishedArr = @[@"7",@"6",@"5",@"4",@"3",@"2",@"1"];
        barCell.draw = @"draw";
        if (tableView == self.tableView1) {
            
        }else if (tableView == self.tableView2) {
            
        }else if (tableView == self.tableView3) {
            
        }
        return barCell;
    }else if (indexPath.row == 3) {
        ChartLineCell *lineCell = [tableView dequeueReusableCellWithIdentifier:identifierCell_line forIndexPath:indexPath];
        lineCell.XTitlesArr = @[@"12-01",@"12-02",@"12-03",@"12-04",@"12-05",@"12-06",@"12-07",@"12-01",@"12-02",@"12-03",@"12-04",@"12-05",@"12-06",@"12-07",@"12-01",@"12-02",@"12-03",@"12-04",@"12-05",@"12-06",@"12-07",@"12-01",@"12-02",@"12-03",@"12-04",@"12-05",@"12-06",@"12-07"];
        lineCell.finishedArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"7",@"6",@"5",@"4",@"3",@"2",@"1"];
        lineCell.unfinishedArr = @[@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"7",@"6",@"5",@"4",@"3",@"2",@"1"];
        lineCell.draw = @"draw";
        if (tableView == self.tableView1) {
            
        }else if (tableView == self.tableView2) {
            
        }else if (tableView == self.tableView3) {
            
        }
        return lineCell;
    }
    return nil;
}
//是否可以点击
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPathr{
    return NO;
}


#pragma mark -点击统计
- (IBAction)showChartACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 1000:{//统计
            
        }
            break;
        case 2000:{//饼图
            
        }
            break;
        case 3000:{//柱状图
            
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
