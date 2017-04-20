//
//  ScheduleVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "ScheduleVC.h"

#import "ScheduleCell_calendar.h"
#import "ScheduleCell_1.h"

@interface ScheduleVC ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,DateSeletorDelegate>
//导航栏
@property (nonatomic,strong) UIButton *userBtn;
@property (nonatomic,strong) UIButton *moreBtn;
//XIB
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgViewHeightCons;//高度约束
@property (weak, nonatomic) IBOutlet UIImageView *bgpic;
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UILabel *noDateLabel;

//日期
@property (weak, nonatomic) IBOutlet UIView *dateBgView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//侧滑菜单
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UITableView *drawerTable;
//日历
@property (nonatomic,strong) ScheduleCell_calendar *calender;
//待办事件
@property (nonatomic,strong) NSMutableArray *source;//数据源
@property (nonatomic,strong) NSArray *drawerSource;

@end

static NSString *identifierCell_calender = @"identifierCell_calender";
static NSString *identifierCell_1 = @"identifierCell_1";
//侧滑菜单
static NSString *identifier_header = @"identifier_header";
static NSString *identifier_cell = @"identifier_cell";
@implementation ScheduleVC
#pragma mark -懒加载
//侧滑菜单
-(UITableView *)drawerTable{
    if (!_drawerTable) {
        _drawerTable = [[UITableView alloc]initWithFrame:CGRectMake(-KScreenWidth * 4/5, 0, KScreenWidth * 4/5, KScreenHeight) style:UITableViewStyleGrouped];
        _drawerTable.delegate = self;
        _drawerTable.dataSource = self;
        _drawerTable.backgroundColor = [UIColor whiteColor];
        _drawerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _drawerTable.estimatedRowHeight = 44;
        _drawerTable.rowHeight = UITableViewAutomaticDimension;
        [_drawerTable registerNib:[UINib nibWithNibName:NSStringFromClass([DrawerHeader class]) bundle:nil] forCellReuseIdentifier:identifier_header];
        [_drawerTable registerNib:[UINib nibWithNibName:NSStringFromClass([DrawerCell class]) bundle:nil] forCellReuseIdentifier:identifier_cell];
        //设置阴影
        _drawerTable.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色  
        _drawerTable.layer.shadowOffset = CGSizeMake(8,8);
//        _drawerTable.layer.shadowOpacity = 0.8;//阴影透明度，默认0  
//        _drawerTable.layer.shadowRadius = 4;//阴影半径，默认3
    }
    return _drawerTable;
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
        //点击手势
        UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewACTION:)];
        [_maskView addGestureRecognizer:maskTap];
    }
    return _maskView;
}
-(void)maskViewACTION:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.drawerTable.frame = CGRectMake(-KScreenWidth * 4/5, 0, KScreenWidth * 4/5, KScreenHeight);
    }completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.drawerTable removeFromSuperview];
    }];
}
-(NSArray *)drawerSource{
    if (!_drawerSource) {
        _drawerSource = @[@{@"icon":@"phone_hd_drawer",@"title":@"绑定手机"},
                          @{@"icon":@"share_hd_drawer",@"title":@"分享给好友"},
                          @{@"icon":@"star_hd_drawer",@"title":@"纪念日"},
                          @{@"icon":@"memo_hd_drawer",@"title":@"记录好时光"},
                          @{@"icon":@"feedback_hd_drawer",@"title":@"意见反馈"},
                          @{@"icon":@"guide_hd_drawer",@"title":@"使用指南"},
                          @{@"icon":@"update_hd_drawer",@"title":@"检查更新"},
                          @{@"icon":@"table_hd_drawer",@"title":@"日程统计"},
                          @{@"icon":@"tool_hd_drawer",@"title":@"百宝箱"}];
    }
    return _drawerSource;
}
//数据源
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    //透明设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //配置左右item
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.userBtn setImage:[UIImage imageNamed:@"user_common"] forState:UIControlStateNormal];
    [_userBtn addTarget:self action:@selector(userBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_userBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.moreBtn setImage:[UIImage imageNamed:@"more_common"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_moreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
//点击用户头像
-(void)userBtnACTION:(UIButton *)sender{
    [KMyWindow addSubview:self.maskView];
    [KMyWindow addSubview:self.drawerTable];
    [UIView animateWithDuration:0.3 animations:^{
        self.drawerTable.frame = CGRectMake(0, 0, KScreenWidth * 4/5, KScreenHeight);
    }];
}
//点击更多按钮
-(void)moreBtnACTION:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:150 delegate:self];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self scrollViewDidScroll:self.tableView];
}
#pragma mark -viewDidDisappear
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UIColor *color = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar cnReset];//复原

}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置数据源
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readScheduleModelFromDBWhereCondition:@{@"date":[NSDate allDayTimeWithDate:[NSDate date]]}];
    self.source = [NSMutableArray arrayWithArray:modelArr];
    if (self.source.count <= 0) {
        self.noDateLabel.hidden = NO;
    }else{
        self.noDateLabel.hidden = YES;
    }
    //配置tableView
    [self setUpTableView];
    //配置日期
    [self setUpDate];
    //注册通知－用于编辑完成时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveEditedSchedule) name:@"kSaveEditedSchedule" object:nil];
    //用于侧边菜单栏中的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLLSlideMenuACTION:) name:@"kLLSlideMenu_notify" object:nil];

}
//配置日期
-(void)setUpDate{
    NSInteger firstWeekday = [[NSDate date] firstWeekDayInMonth];
    NSInteger num = [[NSDate date] dateDay] + firstWeekday;
    NSInteger todayWeek = num%7 - 1;
    NSString *weekString = [self weekStringWith:todayWeek];
    self.weekLabel.text = weekString;
    self.monthLabel.text = [NSString stringWithFormat:@"%ld",[[NSDate date] dateMonth]];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",[[NSDate date] dateYear]];
    //日历通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"ChangeCalendarHeaderNotification" object:nil];
    
    //今天按钮
    self.todayBtn.layer.masksToBounds = YES;
    self.todayBtn.layer.cornerRadius = 20;
    self.todayBtn.hidden = YES;
    //点击今天按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTodayBtnWith:) name:@"todayBtn" object:nil];
}

//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //缩进
    self.tableView.contentInset = UIEdgeInsetsMake(130, 0, 0, 0);
    //cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScheduleCell_calendar class]) bundle:nil] forCellReuseIdentifier:identifierCell_calender];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScheduleCell_1 class]) bundle:nil] forCellReuseIdentifier:identifierCell_1];
    
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.drawerTable) {
        return 4;
    }else if (tableView == self.tableView) {
        return 2;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.drawerTable) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return 4;
        }else if (section == 2) {
            return 3;
        }else if (section == 3) {
            return 2;
        }
    }else if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        }else{
            return self.source.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>侧滑菜单    
    if (tableView == self.drawerTable) {
        if (indexPath.section == 0) {
            DrawerHeader *header = [tableView dequeueReusableCellWithIdentifier:identifier_header forIndexPath:indexPath];
            header.backgroundColor = [UIColor clearColor];
            [header.icon addTarget:self action:@selector(iconACTION:) forControlEvents:UIControlEventTouchUpInside];
            [header.codeBtn addTarget:self action:@selector(codeBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
            return header;
        }else{
            DrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            NSDictionary *dic = [NSDictionary dictionary];
            if (indexPath.section == 1) {
                dic = self.drawerSource[indexPath.row];
            }else if (indexPath.section == 2) {
                dic = self.drawerSource[indexPath.row + 4];
            }else if (indexPath.section == 3) {
                dic = self.drawerSource[indexPath.row + 7];
            }
            cell.icon.image = [UIImage imageNamed:dic[@"icon"]];
            cell.title.text = dic[@"title"];
            return cell;
        }
    }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>     
    else if (tableView == self.tableView) {
        if (self.source.count <= 0) {
            self.noDateLabel.hidden = NO;
        }else{
            self.noDateLabel.hidden = YES;
        }
        
        if (indexPath.section == 0) {
            _calender = [tableView dequeueReusableCellWithIdentifier:identifierCell_calender forIndexPath:indexPath];
            return _calender;
        }else if (indexPath.section == 1) {
            ScheduleCell_1 *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell_1 forIndexPath:indexPath];
            ScheduleModel *model = self.source[indexPath.row];
            //紧急情况
            if ([model.emergency isEqualToString:@"重要／紧急"]) {
                cell.emergency.image = [UIImage imageNamed:@"A"];
            }else if ([model.emergency isEqualToString:@"重要／不紧急"]) {
                cell.emergency.image = [UIImage imageNamed:@"B"];
            }else if ([model.emergency isEqualToString:@"不重要／紧急"]) {
                cell.emergency.image = [UIImage imageNamed:@"C"];
            }else if ([model.emergency isEqualToString:@"不重要／不紧急"]) {
                cell.emergency.image = [UIImage imageNamed:@"D"];
            }
            //标题
            cell.titleName.text = model.name;
            //时间
            NSString *start_time = model.start_time;
            NSString *end_time = model.end_time;
            if ([start_time isEqualToString:end_time]) {//全天事件
                cell.time.text = [NSString stringWithFormat:@"%@ 全天",[start_time substringWithRange:NSMakeRange(5, 5)]];
            }else{
                cell.time.text = [NSString stringWithFormat:@"%@ 至 %@",[start_time substringWithRange:NSMakeRange(5, 11)],[end_time substringWithRange:NSMakeRange(5, 11)]];
            }   
            //标签
            if ([model.tags isEqualToString:@"点击添加标签"]) {
                cell.tag1.text = @"";
                cell.tag2.text = @"";
                cell.tag3.text = @"";
                cell.tag1.hidden = YES;
                cell.tag2.hidden = YES;
                cell.tag3.hidden = YES;
            }else{
                NSArray *tagsArr = [model.tags componentsSeparatedByString:@"、 "];
                if (tagsArr.count == 1) {
                    cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
                    cell.tag1.hidden = NO;
                    cell.tag2.hidden = YES;
                    cell.tag3.hidden = YES;
                }else if (tagsArr.count == 2) {
                    cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
                    cell.tag2.text = [NSString stringWithFormat:@"  %@  ",tagsArr[1]];
                    cell.tag1.hidden = NO;
                    cell.tag2.hidden = NO;
                    cell.tag3.hidden = YES;
                }else if (tagsArr.count >= 3) {
                    cell.tag1.text = [NSString stringWithFormat:@"  %@  ",tagsArr[0]];
                    cell.tag2.text = [NSString stringWithFormat:@"  %@  ",tagsArr[1]];
                    cell.tag3.text = [NSString stringWithFormat:@"  %@  ",tagsArr[2]];
                    cell.tag1.hidden = NO;
                    cell.tag2.hidden = NO;
                    cell.tag3.hidden = NO;
                }
            }
            //备注
            cell.content.text = model.content;
            //图片
            NSMutableArray *picArr = [NSMutableArray array];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *picArrPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",model.schedule_id]];
            NSArray *imageDataArr = [NSMutableArray arrayWithContentsOfFile:picArrPath];
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *image = [UIImage imageWithData:obj];
                [picArr addObject:image];
            }];
            if (picArr.count == 0) {
                cell.pic1.hidden = NO;
                cell.pic2.hidden = YES;
                cell.pic3.hidden = YES;
            }else if (picArr.count == 1) {
                cell.pic1.image = picArr[0];
                cell.pic1.hidden = NO;
                cell.pic2.hidden = YES;
                cell.pic3.hidden = YES;
            }else if (picArr.count == 2) {
                cell.pic1.image = picArr[0];
                cell.pic2.image = picArr[1];
                cell.pic1.hidden = NO;
                cell.pic2.hidden = NO;
                cell.pic3.hidden = YES;
            }else if (picArr.count >= 3) {
                cell.pic1.image = picArr[0];
                cell.pic2.image = picArr[1];
                cell.pic3.image = picArr[2];
                cell.pic1.hidden = NO;
                cell.pic2.hidden = NO;
                cell.pic3.hidden = NO;
            }
            
            return cell;
        } 
    }
    return nil;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.drawerTable) {
        if (indexPath.section == 0) {
            return;
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {//绑定手机
                
            }else if (indexPath.row == 1) {//分享给好友
            
            }else if (indexPath.row == 2) {//纪念日
                
            }else if (indexPath.row == 3) {//记录好时光
                Coin34VC *coin_VC = [[Coin34VC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:coin_VC];
                navi.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);// 设置导航栏背景颜色
                [navi.navigationBar setTitleTextAttributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                   NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
                [self presentViewController:navi animated:YES completion:nil];
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {//意见反馈
                
            }else if (indexPath.row == 1) {//使用指南
                
            }else if (indexPath.row == 2) {//检查更新
                
            }
        }else if (indexPath.section == 3) {
            if (indexPath.row == 0) {//统计
                ChartVC *chart_VC = [[ChartVC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:chart_VC];
                navi.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);// 设置导航栏背景颜色
                [navi.navigationBar setTitleTextAttributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                   NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
                [self presentViewController:navi animated:YES completion:nil];
            }else if (indexPath.row == 1) {//实用工具
                ToolVC *tool_VC = [[ToolVC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tool_VC];
                navi.navigationBar.barTintColor = KRGB(255, 147, 18, 1.0);// 设置导航栏背景颜色
                [navi.navigationBar setTitleTextAttributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                   NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.drawerTable.frame = CGRectMake(-KScreenWidth * 4/5, 0, KScreenWidth * 4/5, KScreenHeight);
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.drawerTable removeFromSuperview];
        }];
    }
    else  if (tableView == self.tableView) {
        if (indexPath.section == 1) {
            EditScheduleVC *editSchedule_VC = [[EditScheduleVC alloc]init];
            editSchedule_VC.pushOrMode = @"push";
            editSchedule_VC.model = self.source[indexPath.row];
            [self.navigationController pushViewController:editSchedule_VC animated:YES];
        }
    }    
}
//点击头像
-(void)iconACTION:(UIButton *)sender{
    
}
//点击二维码
-(void)codeBtnACTION:(UIButton *)sender{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 0.1;
    }else if (tableView == self.drawerTable) {
        if (section == 0) {
            return 50;
        } else{
            return 20;
        }
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        
    }else if (tableView == self.drawerTable) {
        if (section == 0) {
            return 20;
        }
    }
    return 0.1;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGPoint point = scrollView.contentOffset;
        CGFloat height = (130 - 64);
        UIColor *color = KRGB(52, 168, 238, 1.0);
        CGFloat alpha = MIN(1, ((point.y + 64) / height) + 1);
        
        if (point.y <= -130) {
            //将tableView放到最底层
            [self.view sendSubviewToBack:self.tableView];
            self.topBgViewHeightCons.constant = -point.y;
            [self.bgpic setNeedsLayout];
        }else{
            [self.view bringSubviewToFront:self.tableView];
        }
        if (point.y >= -120) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
        }else{
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
        }
        
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu {
    switch (index) {
        case 0:{//添加朋友
            
        }
            break;
        case 1:{//创建讨论组
            
        }
            break;
        case 2:{//扫一扫
            
        }
            break;
        case 3:{//搜索
            SearchVC *search_VC = [[SearchVC alloc]init];
            [self.navigationController pushViewController:search_VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -日历通知
- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    NSNumber *year = dic[@"year"];
    NSNumber *month = dic[@"month"];
    NSNumber *day = dic[@"day"];
    NSNumber *firstWeekday = dic[@"firstWeekDay"];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@月",month];
    self.yearLabel.text = [NSString stringWithFormat:@"%@",year];
    
    NSInteger firstWeekdayNew = [firstWeekday integerValue];
    NSInteger num = [day integerValue] + firstWeekdayNew;
    NSInteger todayWeek = num%7;
    NSString *weekString = [self weekStringWith:todayWeek];
    self.weekLabel.text = weekString;
}
#pragma mark -点击日期
- (IBAction)showDateSeletor:(UIButton *)sender {
    DateSeletor *dateSeletor = [[DateSeletor alloc]initWithFrame:[UIScreen mainScreen].bounds];
    dateSeletor.sourceVC = @"ScheduleVC";
    [KMyWindow addSubview:dateSeletor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [dateSeletor show];
    });
}
//点击今天按钮
- (IBAction)todayBtnACTION:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"todayBtn" object:self userInfo:@{@"dir":@"top_cell"}];
}
//今天按钮飘逸
-(void)showTodayBtnWith:(NSNotification *)notify{
    NSDictionary *userInfo = notify.userInfo;
    NSString *dir = userInfo[@"dir"];
    NSDate *currentDate = userInfo[@"currentDate"];
    NSArray *modelArr;
    if ([dir isEqualToString:@"cell_top"]) {
        self.todayBtn.hidden = NO;
        modelArr = [[HSFFmdbManager sharedManager] readScheduleModelFromDBWhereCondition:@{@"date":[NSDate allDayTimeWithDate:currentDate]}];
        
    }else if ([dir isEqualToString:@"top_cell"]) {
        self.todayBtn.hidden = YES;
        
        NSDate *todayDate = [NSDate date];
        [self.calender refreshToCurrentMonthToDate:todayDate];
        NSInteger day = [todayDate dateDay];
        NSInteger firstWeekDay = [todayDate firstWeekDayInMonth];
        
        [self.calender collectionView:self.calender.collectionViewMid didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:(firstWeekDay + day - 1) inSection:0]];
        
        modelArr = [[HSFFmdbManager sharedManager] readScheduleModelFromDBWhereCondition:@{@"date":[NSDate allDayTimeWithDate:[NSDate date]]}];
    }else if ([dir isEqualToString:@"cell_top_cell"]) {
        self.todayBtn.hidden = YES;
        modelArr = [[HSFFmdbManager sharedManager] readScheduleModelFromDBWhereCondition:@{@"date":[NSDate allDayTimeWithDate:currentDate]}];
    }
    
    [self.source removeAllObjects];
    self.source = [NSMutableArray arrayWithArray:modelArr];
    [self.tableView reloadData];
}


#pragma mark -DateSeletorDelegate//选好日期 点击确认
-(void)sendChoosedDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day firstWeekDayInMonth:(NSInteger)firstWeekDayInMonth{
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月",(long)month];
    self.yearLabel.text = [NSString stringWithFormat:@"%ld",(long)year];
    
    NSInteger num = day + firstWeekDayInMonth - 1;
    NSInteger todayWeek = num%7;
    NSString *weekString = [self weekStringWith:todayWeek];
    self.weekLabel.text = weekString;
    
}

//返回星期几
-(NSString *)weekStringWith:(NSInteger)sender{
    NSString *weekString = @"";
    switch (sender) {
        case 0:{
            weekString = @"星期日";
        }
            break;
        case 1:{
            weekString = @"星期一";
        }
            break;
        case 2:{
            weekString = @"星期二";
        }
            break;
        case 3:{
            weekString = @"星期三";
        }
            break;
        case 4:{
            weekString = @"星期四";
        }
            break;
        case 5:{
            weekString = @"星期五";
        }
            break;
        case 6:{
            weekString = @"星期六";
        }
            break;    
            
        default:
            break;
    }
    return weekString;
}

#pragma mark -通知
//用于编辑完成时调用
-(void)saveEditedSchedule{
    //编辑成功，点击保存
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readScheduleModelFromDBWhereCondition:@{@"date":[NSDate allDayTimeWithDate:[NSDate date]]}];
    [self.source removeAllObjects];
    self.source = [NSMutableArray arrayWithArray:modelArr];
    [self.tableView reloadData];
}
//用于侧边菜单栏中的点击
-(void)clickLLSlideMenuACTION:(NSNotification *)sender{
    //模拟点击一下用户头像
    [self userBtnACTION:self.userBtn];
    
    NSDictionary *userInfo = sender.userInfo;
    NSString *indexStr = userInfo[@"indexStr"];
    NSInteger index = [indexStr integerValue];
    switch (index) {
        case 0:{//用户信息
            
        }
            break;
        case 1:{//二维码
            
        }
            break;
        case 2:{//绑定手机
            
        }
            break;
        case 3:{//分享给好友
            
        }
            break;
        case 4:{//纪念日
            
        }
            break;
        case 5:{//备忘
            
        }
            break;
        case 6:{//意见反馈
            
        }
            break;
        case 7:{//使用指南
            
        }
            break;
        case 8:{//检查更新
            
        }
            break;
        case 9:{//统计
            ChartVC *chart_VC = [[ChartVC alloc]init];
            [self.navigationController pushViewController:chart_VC animated:YES];
        }
            break;
        case 10:{//设置
            
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
