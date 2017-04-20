//
//  WeekChartCionVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "WeekChartCionVC.h"

#import "CoinChartCell.h"

@interface WeekChartCionVC ()<UITableViewDelegate,UITableViewDataSource>
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
@implementation WeekChartCionVC

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
    self.navigationItem.title = @"周小结";
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
    self.tableView.rowHeight = KScreenHeight - 64 - 210;
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
    if (indexPath.row == 0) {//饼图>>>>>>>>>>
        [cell.chartCell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 70, KScreenWidth - 70)];
        pie.backgroundColor = [UIColor clearColor];
        pie.center = CGPointMake(KScreenWidth/2, (KScreenHeight - 64 - 210)/2);
        pie.valueArr = @[@18,@14,@25,@40,@18];
        pie.descArr = @[@"尽兴娱乐",@"休闲放松",@"高效工作",@"强迫工作",@"无效工作"];
        [cell.chartCell addSubview:pie];
        pie.positionChangeLengthWhenClick = 15;
        pie.showDescripotion = NO;
        pie.colorArr = @[KRGB(23, 127, 207, 1),KRGB(123, 177, 21, 1),KRGB(226, 124, 42, 1),KRGB(204, 0, 10, 1),KRGB(179, 179, 179, 1)];
        [pie showAnimation];
    }else if (indexPath.row == 1) {//柱状图>>>>>>>>>>
        [cell.chartCell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(10, 30, KScreenWidth - 20, 300)];
        column.center = CGPointMake(KScreenWidth/2, (KScreenHeight - 64 - 210)/2);
        column.valueArr = @[@[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30],
                            @[@12,@2,@23,@10,@30]];
        column.originSize = CGPointMake(10, 30);
        /*    The first column of the distance from the starting point     */
        column.drawFromOriginX = 20;
        column.typeSpace = 10;
        column.isShowYLine = YES;
        /*        Column width         */
        column.columnWidth = 10;
        /*        Column backgroundColor         */
        column.bgVewBackgoundColor = [UIColor whiteColor];
        /*        X, Y axis font color         */
        column.drawTextColorForX_Y = [UIColor blackColor];
        /*        X, Y axis line color         */
        column.colorForXYLine = [UIColor darkGrayColor];
        /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
        column.columnBGcolorsArr = @[KRGB(23, 127, 207, 1),KRGB(123, 177, 21, 1),KRGB(226, 124, 42, 1),KRGB(204, 0, 10, 1),KRGB(179, 179, 179, 1)];
        /*        Module prompt         */
        column.xShowInfoText = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
//        column.isShowLineChart = YES;
//        column.lineValueArray =  @[@6,
//                                   @12,
//                                   @10,
//                                   @1,
//                                   @9,
//                                   @5,
//                                   @9];
//        
        [column showAnimation];
        [cell.chartCell addSubview:column];
    }else if (indexPath.row == 2) {//折线图>>>>>>>>>>
        [cell.chartCell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:cell.chartCell.bounds];
        [cell.chartCell addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(KScreenWidth, scrollView.height);
        
        JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 20, scrollView.contentSize.width - 20, 300) andLineChartType:JHChartLineValueNotForEveryX];
        lineChart.center =CGPointMake(scrollView.contentSize.width/2, (KScreenHeight - 64 - 210)/2);;
        lineChart.xLineDataArr = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
        lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);        
        lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
        
        lineChart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6],@[@"3",@"1",@"2",@16,@2,@3,@25],@[@"3",@"22",@"41",@16,@24,@39,@46],@[@"43",@"31",@"22",@16,@2,@33,@5],@[@"71",@"52",@"91",@26,@54,@69,@66]];
        lineChart.showYLevelLine = YES;
        lineChart.showYLine = YES;
        lineChart.showValueLeadingLine = NO;
        lineChart.valueFontSize = 12;
        lineChart.xDescTextFontSize = 12;
        lineChart.yDescTextFontSize = 12;
        lineChart.backgroundColor = [UIColor whiteColor];
        /* Line Chart colors */
        lineChart.valueLineColorArr =@[KRGB(23, 127, 207, 1),KRGB(123, 177, 21, 1),KRGB(226, 124, 42, 1),KRGB(204, 0, 10, 1),KRGB(179, 179, 179, 1)];
        /* Colors for every line chart*/
        lineChart.pointColorArr = @[KRGB(23, 127, 207, 1),KRGB(123, 177, 21, 1),KRGB(226, 124, 42, 1),KRGB(204, 0, 10, 1),KRGB(179, 179, 179, 1)];
        /* color for XY axis */
        lineChart.xAndYLineColor = [UIColor blackColor];
        /* XY axis scale color */
        lineChart.xAndYNumberColor = [UIColor darkGrayColor];
        /* Dotted line color of the coordinate point */
//        lineChart.positionLineColorArr = @[[UIColor whiteColor],[UIColor greenColor]];
        /*        Set whether to fill the content, the default is False         */
        lineChart.contentFill = YES;
        /*        Set whether the curve path         */
        lineChart.pathCurve = YES;
        /*        Set fill color array         */
//        lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
        [scrollView addSubview:lineChart];
        /*       Start animation        */
        [lineChart showAnimation];
    }
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark -点击底部跳转按钮
- (IBAction)pushBtnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//今天
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 200:{//周小结
            
        }
            break;
        case 300:{//月总结
            MonthChartCoinVC *month_VC = [[MonthChartCoinVC alloc]init];
            [self.navigationController pushViewController:month_VC animated:NO];
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
