//
//  CMJHChartShowController.m
//  CMKit
//
//  Created by yons on 17/3/10.
//  Copyright © 2017年 UTOUU. All rights reserved.
//

#import "CMJHChartShowController.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height

@interface CMJHChartShowController ()

@end

@implementation CMJHChartShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    switch (_index) {
        case 0:
        {
            [self showFirstQuardrant];
        }
            break;
        case 1:
        {
            [self showFirstAndSecondQuardrant];
            
        }
            break;
        case 2:
        {
            [self showFirstAndFouthQuardrant];
        }
            break;
        case 3:
        {
            [self showAllQuardrant];
        }
            break;
        case 4:
        {
            [self showPieChartUpView];
        }
            break;
        case 5:
        {
            [self showRingChartView];
        }
            break;
        case 6:
        {
            [self showColumnView];
        }break;
        case 7:
        {
            [self showTableView];
        }break;
        case 8:
        {
            [self showRadarChartView];
        }break;
        case 9:
        {
            [self showScatterChart];
        }break;
        default:
            break;
    }
    
    
    
}


//第一象限折线图
- (void)showFirstQuardrant{
    
    // 绘制折线图
    
    
    /*     Create object        */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 40, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    /* The scale value of the X axis can be passed into the NSString or NSNumber type and the data structure changes with the change of the line chart type. The details look at the document or other quadrant X axis data source sample.*/
    
    lineChart.xLineDataArr = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    /* The different types of the broken line chart, according to the quadrant division, different quadrant correspond to different X axis scale data source and different value data source. */
    
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    lineChart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 0.0;
    lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ DEF_RGB_COLOR(12, 133, 239)];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor clearColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    lineChart.pathCurve = YES;
    lineChart.gradientColor = @[ DEF_RGB_COLOR(12, 133, 239)];
    lineChart.touchFlowLineColor = DEF_RGB_COLOR(12, 133, 239);
    //    self.lineChart.touchNumPrefixStr =@"¥";

    [self.view addSubview:lineChart];
    /*       Start animation        */
    [lineChart showAnimation];
    
    // 说明文字
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, CGRectGetMaxY(lineChart.frame) + 20, k_MainBoundsWidth-20, 200);
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.text = @"注：\n      为了满足项目需求，在源码中新增点击“竖线”提示、渐变色背景等功能，请看源码JHLineChart.m文件中（#pragma mark - 手势点击）的内容，若需要可手动导入Tool中的JHChart文件代替pod导入";
    
    [self.view addSubview:label];

}


//第一二象限
- (void)showFirstAndSecondQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 50, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndSecondQuardrant;
    lineChart.valueArr = @[@[@"5",@"2",@"7",@4,@25,@15,@6],@[@"1",@"2",@"1",@6,@4,@9,@7]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.showYLevelLine = YES;
    lineChart.showValueLeadingLine = NO;
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart.valueFontSize = 9.0;
    
    lineChart.showYLevelLine = YES;
    
    
    [self.view addSubview:lineChart];
    
    /*        设置是否填充内容         */
    lineChart.contentFill = YES;
    
    /*        设置曲线路径         */
    lineChart.pathCurve = YES;
    
    /*        填充颜色数组         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
    [lineChart showAnimation];
    
    /* 清除折线图内容 */
    //    [lineChart clear];
}

//第一四象限
- (void)showFirstAndFouthQuardrant{
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 54, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"一月份",@"二月份",@"三月份",@"四月份",@"五月份",@"六月份",@"七月份",@"八月份"];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
    lineChart.valueArr = @[@[@"5",@"-22",@"17",@(-4),@25,@5,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];
    lineChart.yDescTextFontSize = lineChart.xDescTextFontSize = 9.0;
    lineChart.valueFontSize = 9.0;
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor redColor], [UIColor greenColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /*        是否展示Y轴分层线条 默认否        */
    lineChart.showYLevelLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = YES;
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor darkGrayColor];
    lineChart.backgroundColor = [UIColor whiteColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    
    lineChart.contentFill = YES;
    
    lineChart.pathCurve = YES;
    
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.386],[UIColor colorWithRed:0.000 green:1 blue:0 alpha:0.472]];
    [self.view addSubview:lineChart];
    [lineChart showAnimation];
}


/**
 *  折线图全象限
 */
- (void)showAllQuardrant{
    
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 100, k_MainBoundsWidth-20, 300) andLineChartType:JHChartLineValueNotForEveryX];
    
    lineChart.xLineDataArr = @[@[@"-3",@"-2",@"-1"],@[@0,@1,@2,@3]];
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeAllQuardrant;
    lineChart.valueArr = @[@[@"5",@"-22",@"70",@(-4),@25,@15,@6,@9],@[@"1",@"-12",@"1",@6,@4,@(-8),@6,@7]];    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor greenColor];
    
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];
    
    [self.view addSubview:lineChart];
    
    [lineChart showAnimation];
}


/**
 *  饼状图
 */
- (void)showPieChartUpView{
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(100, 100, 321, 421)];
    pie.backgroundColor = [UIColor greenColor];
    pie.center = CGPointMake(CGRectGetMaxX(self.view.frame)/2, CGRectGetMaxY(self.view.frame)/2);
    /* Pie chart value, will automatically according to the percentage of numerical calculation */
    pie.valueArr = @[@18,@14,@25,@40,@18,@18,@25,@40];
    /* The description of each sector must be filled, and the number must be the same as the pie chart. */
    pie.descArr = @[@"第一个元素",@"第二个元素",@"第三个元素",@"第四个元素",@"5",@"6",@"7",@"8"];
    //    pie.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pie];
    /*    When touching a pie chart, the animation offset value     */
    pie.positionChangeLengthWhenClick = 15;
    pie.showDescripotion = NO;
    //    pie.colorArr = @[[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor redColor],[UIColor yellowColor]];
    /*        Start animation         */
    [pie showAnimation];
    
}


//环状图
- (void)showRingChartView{
    JHRingChart *ring = [[JHRingChart alloc] initWithFrame:CGRectMake(0, 100, k_MainBoundsWidth, k_MainBoundsWidth)];
    /*        background color         */
    ring.backgroundColor = [UIColor whiteColor];
    /*        Data source array, only the incoming value, the corresponding ratio will be automatically calculated         */
    ring.valueDataArr = @[@"0.5",@"5",@"2",@"10",@"6",@"6"];
    /*         Width of ring graph        */
    ring.ringWidth = 35.0;
    /*        Fill color for each section of the ring diagram         */
    ring.fillColorArray = @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]];
    /*        Start animation             */
    [ring showAnimation];
    [self.view addSubview:ring];
    
}

//柱状图
- (void)showColumnView{
    JHColumnChart *column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 64, k_MainBoundsWidth, 320)];
    /*        Create an array of data sources, each array is a module data. For example, the first array can represent the average score of a class of different subjects, the next array represents the average score of different subjects in another class        */
    column.valueArr = @[
                        @[@12],
                        @[@22],
                        @[@1],
                        @[@21],
                        @[@19],
                        @[@12],
                        @[@15],
                        @[@9],
                        @[@8],
                        @[@6],
                        @[@9],
                        @[@18],
                        @[@23],
                        ];
    /*       This point represents the distance from the lower left corner of the origin.         */
    column.originSize = CGPointMake(30, 20);
    /*    The first column of the distance from the starting point     */
    column.drawFromOriginX = 20;
    column.typeSpace = 10;
    column.isShowYLine = NO;
    /*        Column width         */
    column.columnWidth = 30;
    /*        Column backgroundColor         */
    column.bgVewBackgoundColor = [UIColor whiteColor];
    /*        X, Y axis font color         */
    column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    column.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    column.columnBGcolorsArr = @[[UIColor colorWithRed:72/256.0 green:200.0/256 blue:255.0/256 alpha:1],[UIColor greenColor],[UIColor orangeColor]];
    /*        Module prompt         */
    column.xShowInfoText = @[@"A班级",@"B班级",@"C班级",@"D班级",@"E班级",@"F班级",@"G班级",@"H班级",@"i班级",@"J班级",@"L班级",@"M班级",@"N班级"];
    column.isShowLineChart = YES;
    column.lineValueArray =  @[
                               @6,
                               @12,
                               @10,
                               @1,
                               @9,
                               @5,
                               @9,
                               @9,
                               @5,
                               @6,
                               @4,
                               @8,
                               @11
                               ];
    
    /*       Start animation        */
    [column showAnimation];
    [self.view addSubview:column];
}





/**
 *  创建表格视图
 */
- (void)showTableView{
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(10, 84, k_MainBoundsWidth-20, k_MainBoundsHeight)];
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    //    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"",@"",@"",@"",@"",@""];
    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"专业评价"];
    /*        The width of the column array, starting with the first column         */
    table.colWidthArr = @[@80.0,@160.0,@70,@40,@100];
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    table.bodyTextColor = [UIColor redColor];
    /*        Minimum grid height         */
    table.minHeightItems = 35;
    /*        Table line color         */
    table.lineColor = [UIColor orangeColor];
    
    table.backgroundColor = [UIColor whiteColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    table.dataArr = @[
                      @[@"2.4L优越版",@"2016皓白标准漆蓝棕",@[@"鸽子白",@"鹅黄",@"炫彩绿"],@[@"4"],@"价格十分优惠，相信市场会非常好"],
                      @[@"2.4专业版",@[@"2016皓白标准漆蓝棕",@"2016晶黑珠光漆黑",@"2016流沙金珠光漆蓝棕"],@[@"鸽子白",@"鹅黄",@"炫彩绿",@"彩虹多样色"],@[@"4",@"5",@"3"],@"性价比还不错，内部配置较为不错，值得入手"]                      ];
    /*        show                            */
    [table showAnimation];
    [self.view addSubview:table];
    /*        Automatic calculation table height        */
    table.frame = CGRectMake(10, 64, k_MainBoundsWidth-20, [table heightFromThisDataSource]);
}


- (void)showRadarChartView{
    
    
    JHRadarChart *radarChart = [[JHRadarChart alloc] initWithFrame:CGRectMake(10, 74, k_MainBoundsWidth - 20, k_MainBoundsWidth - 20)];
    radarChart.backgroundColor = [UIColor whiteColor];
    /*       Each point of the description text, according to the number of the array to determine the number of basic modules         */
    radarChart.valueDescArray = @[@"击杀",@"能力",@"生存",@"推塔",@"补兵",@"其他"];
    
    /*         Number of basic module layers        */
    radarChart.layerCount = 5;
    
    /*        Array of data sources, the need to add an array of arrays         */
    radarChart.valueDataArray = @[@[@"80",@"40",@"100",@"76",@"75",@"50"],@[@"50",@"80",@"30",@"46",@"35",@"50"]];
    
    /*        Color of each basic module layer         */
    radarChart.layerFillColor = [UIColor colorWithRed:94/ 256.0 green:187/256.0 blue:242 / 256.0 alpha:0.5];
    
    /*        The fill color of the value module is required to specify the color for each value module         */
    radarChart.valueDrawFillColorArray = @[[UIColor colorWithRed:57/ 256.0 green:137/256.0 blue:21 / 256.0 alpha:0.5],[UIColor colorWithRed:149/ 256.0 green:68/256.0 blue:68 / 256.0 alpha:0.5]];
    
    /*       show        */
    [radarChart showAnimation];
    
    [self.view addSubview:radarChart];
    
}





- (void)showScatterChart{
    
    /*        创建对象         */
    JHScatterChart *scatterChart = [[JHScatterChart alloc] initWithFrame:CGRectMake(0, 64, k_MainBoundsWidth, 320)];
    
    /*        X轴刻度值         */
    scatterChart.xLineDataArray = @[@0,@1,@2,@3,@4,@5];
    
    /*        点的数组         */
    scatterChart.valueDataArray = @[
                                    [NSValue valueWithCGPoint:P_M(0, 1)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 5.7)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 5)],
                                    [NSValue valueWithCGPoint:P_M(0.7, 5)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.2, 9)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5,4)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 2)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8.3)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 5.3)],
                                    [NSValue valueWithCGPoint:P_M(2, 3)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5)],
                                    [NSValue valueWithCGPoint:P_M(2, 11)],
                                    [NSValue valueWithCGPoint:P_M(6, 15)],
                                    [NSValue valueWithCGPoint:P_M(1, 3)],
                                    [NSValue valueWithCGPoint:P_M(1, 1)],
                                    [NSValue valueWithCGPoint:P_M(2.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(3.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(4, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(1.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 6.5)],
                                    [NSValue valueWithCGPoint:P_M(2.2,4)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 9.8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]  ,
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 14)],
                                    [NSValue valueWithCGPoint:P_M(0.9, 2)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 12.7)],
                                    [NSValue valueWithCGPoint:P_M(0.1, 3)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2)],
                                    [NSValue valueWithCGPoint:P_M(0.3, 2.3)],
                                    [NSValue valueWithCGPoint:P_M(0.5, 2.5)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(1.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(1.4, 3)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(1.3, 1.3)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 1.8)],
                                    [NSValue valueWithCGPoint:P_M(1.7, 1.4)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]   ,
                                    
                                    [NSValue valueWithCGPoint:P_M(0.7, 7.5)],
                                    [NSValue valueWithCGPoint:P_M(0.6, 11)],
                                    [NSValue valueWithCGPoint:P_M(0.8, 15)],
                                    [NSValue valueWithCGPoint:P_M(4, 3)],
                                    [NSValue valueWithCGPoint:P_M(5, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(4.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 3.5)],
                                    [NSValue valueWithCGPoint:P_M(4.9, 8.6)],
                                    [NSValue valueWithCGPoint:P_M(1.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2.2, 7)],
                                    [NSValue valueWithCGPoint:P_M(4.1, 5.9)],
                                    [NSValue valueWithCGPoint:P_M(4.3, 3)],
                                    [NSValue valueWithCGPoint:P_M(3.2, 8)],
                                    [NSValue valueWithCGPoint:P_M(3.3, 5)],
                                    [NSValue valueWithCGPoint:P_M(2.5, 8)],
                                    [NSValue valueWithCGPoint:P_M(2, 7)],
                                    [NSValue valueWithCGPoint:P_M(5.9, 5.6)]];
    scatterChart.contentInsets = UIEdgeInsetsMake(10, 40, 20, 10);
    
    [scatterChart showAnimation];
    
    [self.view addSubview:scatterChart];
    
}

@end
