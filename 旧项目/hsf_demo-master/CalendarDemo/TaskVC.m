//
//  TaskVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "TaskVC.h"

#import "TaskCell.h"
#import "TaskHeader.h"

@interface TaskVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *timeBgVIew;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//侧滑菜单
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UITableView *drawerTable;
@property (nonatomic,strong) NSMutableArray *source_unfinished;//数据源
@property (nonatomic,strong) NSMutableArray *source_finished;//数据源
@property (nonatomic,assign) BOOL fold_unfinished;
@property (nonatomic,assign) BOOL fold_finished;
@property (nonatomic,strong) NSArray *drawerSource;//抽屉数据源
//导航栏
@property (nonatomic,strong) UIButton *userBtn;
@property (nonatomic,strong) UIButton *moreBtn;

@property (nonatomic,strong) NSDate *currentDate;


@end

//侧滑菜单
static NSString *identifier_header = @"identifier_header";
static NSString *identifier_cell = @"identifier_cell";
//taskCell
static NSString *identifier_taskCell = @"identifier_taskCell";
static NSString *identifier_taskHeader = @"identifier_taskHeader";
@implementation TaskVC
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
-(NSMutableArray *)source_finished{
    if (!_source_finished) {
        _source_finished = [NSMutableArray array];
    }
    return _source_finished;
}
-(NSMutableArray *)source_unfinished{
    if (!_source_unfinished) {
        _source_unfinished = [NSMutableArray array];
    }
    return _source_unfinished;
}


#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //配置左右item
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.userBtn setImage:[UIImage imageNamed:@"user_common"] forState:UIControlStateNormal];
    [_userBtn addTarget:self action:@selector(userBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_userBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.moreBtn setTitle:@"历史" forState:UIControlStateNormal];
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
    
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark -viewDidDisappear
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置数据源
    self.currentDate = [NSDate date];
    self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readTaskModelFromDBWhereCondition:@{@"date":self.timeLabel.text}];
    [modelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = (TaskModel *)obj;
        if ([model.isFinished isEqualToString:@"0"]) {
            [self.source_unfinished addObject:model];
        }else if ([model.isFinished isEqualToString:@"1"]) {
            [self.source_finished addObject:model];
        }
    }];
    //配置tableView
    [self setUpTableView];
    //注册通知－用于编辑完成时调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAddTomato:) name:@"kSaveAddTomato" object:nil];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TaskCell class]) bundle:nil] forCellReuseIdentifier:identifier_taskCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TaskHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier_taskHeader];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.drawerTable) {
        return 4;
    }
    else if (tableView == self.tableView) {
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
            return self.fold_unfinished ? 0 : self.source_unfinished.count;
        }else{
            return self.fold_finished ? 0 : self.source_finished.count;
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
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>> tableView    
    else if (tableView == self.tableView) {
        TaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:identifier_taskCell forIndexPath:indexPath];
        if (indexPath.section == 0) {
            TaskModel *model_unfinished = self.source_unfinished[indexPath.row];
            taskCell.icon.image = [UIImage imageNamed:@"clip_tomato"];
            taskCell.title.text = model_unfinished.title;
            taskCell.time.text = model_unfinished.time;
        }else if (indexPath.section == 1) {
            TaskModel *model_unfinished = self.source_finished[indexPath.row];
            taskCell.icon.image = [UIImage imageNamed:@"clip_hd_tomato"];
            taskCell.title.text = model_unfinished.title;
            taskCell.time.text = model_unfinished.time;
        }
        return taskCell;
    }
    return nil;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>侧滑菜单
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
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>> tableView
    else  if (tableView == self.tableView) {
        TaskModel *model;
        if (indexPath.section == 0) {
            model = self.source_unfinished[indexPath.row];
        }else if (indexPath.section == 1) {
            model = self.source_finished[indexPath.row];
        }
        //开始🍅
        StartTomatoVC *startTomato_VC = [[StartTomatoVC alloc]init];
        startTomato_VC.model = model;
        startTomato_VC.sourceVC = @"TaskVC";
        [self.navigationController pushViewController:startTomato_VC animated:YES];
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
        return 40;
    }else if (tableView == self.drawerTable) {
        if (section == 0) {
            return 20;
        }
    }
    return 0.1;
}
#pragma mark -自定义section的header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TaskHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier_taskHeader];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        header.icon.image = [UIImage imageNamed:@"tomato_unfinished"];
        header.title.text = [NSString stringWithFormat:@"待完成：（%ld/%ld）",self.source_unfinished.count,(self.source_unfinished.count + self.source_finished.count)];
        if (self.fold_unfinished) {
            [header.detailBtn setImage:[UIImage imageNamed:@"detail_down_tomato"] forState:UIControlStateNormal];
        }else{
            [header.detailBtn setImage:[UIImage imageNamed:@"detail_up_tomato"] forState:UIControlStateNormal];
        }
    }else if (section == 1) {
        header.icon.image = [UIImage imageNamed:@"tomato_finished"];
        header.title.text = [NSString stringWithFormat:@"已完成：（%ld/%ld）",self.source_finished.count,(self.source_unfinished.count + self.source_finished.count)];
        if (self.fold_finished) {
            [header.detailBtn setImage:[UIImage imageNamed:@"detail_down_tomato"] forState:UIControlStateNormal];
        }else{
            [header.detailBtn setImage:[UIImage imageNamed:@"detail_up_tomato"] forState:UIControlStateNormal];
        }
    }
    [header.detailBtn setTag:section + 100];
    [header.detailBtn addTarget:self action:@selector(detailBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}
//点击detailBtn
-(void)detailBtnACTION:(UIButton *)sender{
    //折叠
    switch (sender.tag) {
        case 100:{//待完成
            self.fold_unfinished = !self.fold_unfinished;
            NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:0];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
        }
            break;
        case 101:{//已完成
            self.fold_finished = !self.fold_finished;
            NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:1];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationTop];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -右滑删除、编辑
//设置可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return YES;
    }
    return NO;
}
//设置编辑操作:删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//自定义按钮
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        TaskModel *model;
        if (indexPath.section == 0) {
            model = self.source_unfinished[indexPath.row];
        }else if (indexPath.section == 1) {
            model = self.source_finished[indexPath.row];
        }
        [[HSFFmdbManager sharedManager] deleteTaskWhereCondition:@{@"task_id":model.task_id}];
        if (indexPath.section == 0) {
            [self.source_unfinished removeObjectAtIndex:indexPath.row];
        }else if (indexPath.section == 1) {
            [self.source_finished removeObjectAtIndex:indexPath.row];
        }
        [tableView reloadData];
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        TaskModel *model;
        if (indexPath.section == 0) {
            model = self.source_unfinished[indexPath.row];
        }else if (indexPath.section == 1) {
            model = self.source_finished[indexPath.row];
        }
        AddTomatoVC *addTomato_VC  = [[AddTomatoVC alloc]init];
        addTomato_VC.model = model;
        addTomato_VC.addOrEdit = @"edit";
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:addTomato_VC];
        [self presentViewController:navi animated:YES completion:nil];
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction2.backgroundColor = KRGB(52, 168, 238, 1.0);
    
    NSArray *arr = @[layTopRowAction1,layTopRowAction2];
    return arr;
}



#pragma mark -点击日期（前一天、后一天）
- (IBAction)lastBtnACTION:(UIButton *)sender {
    //前一天
    self.currentDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.currentDate];
    self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
    [self.source_unfinished removeAllObjects];
    [self.source_finished removeAllObjects];
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readTaskModelFromDBWhereCondition:@{@"date":self.timeLabel.text}];
    [modelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = (TaskModel *)obj;
        if ([model.isFinished isEqualToString:@"0"]) {
            [self.source_unfinished addObject:model];
        }else if ([model.isFinished isEqualToString:@"1"]) {
            [self.source_finished addObject:model];
        }
    }];
    //刷表
    [self.tableView reloadData];
    
    //获取当前画图的设备上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //开始准备动画
    [UIView beginAnimations:nil context:context];
    //设置动画曲线，翻译不准，见苹果官方文档
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置动画持续时间
    [UIView setAnimationDuration:1.0];
    //设置动画效果
    [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.bgView cache:YES];  //从上向下
//    [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.bgView cache:YES];   //从下向上
    //    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.bgView cache:YES];  //从左向右
    //  [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.dialView cache:YES];//从右向左
    //设置动画委托
    [UIView setAnimationDelegate:self];
    //当动画执行结束，执行animationFinished方法
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    //提交动画
    [UIView commitAnimations];
}
- (IBAction)nextBtnACTION:(UIButton *)sender {
    //后一天
    self.currentDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.currentDate];
    self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
    [self.source_unfinished removeAllObjects];
    [self.source_finished removeAllObjects];
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readTaskModelFromDBWhereCondition:@{@"date":self.timeLabel.text}];
    [modelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = (TaskModel *)obj;
        if ([model.isFinished isEqualToString:@"0"]) {
            [self.source_unfinished addObject:model];
        }else if ([model.isFinished isEqualToString:@"1"]) {
            [self.source_finished addObject:model];
        }
    }];
    //刷表
    [self.tableView reloadData];
    
    
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
        [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.bgView cache:YES];   //从下向上
//    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.bgView cache:YES];  //从左向右
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
    
}

#pragma mark -通知
-(void)saveAddTomato:(NSNotification *)sender{
    //编辑成功，点击保存
    self.timeLabel.text = [NSDate allDayTimeWithDate:self.currentDate];
    [self.source_unfinished removeAllObjects];
    [self.source_finished removeAllObjects];
    NSArray *modelArr = [[HSFFmdbManager sharedManager] readTaskModelFromDBWhereCondition:@{@"date":self.timeLabel.text}];
    [modelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = (TaskModel *)obj;
        if ([model.isFinished isEqualToString:@"0"]) {
            [self.source_unfinished addObject:model];
        }else if ([model.isFinished isEqualToString:@"1"]) {
            [self.source_finished addObject:model];
        }
    }];
    //刷表
    [self.tableView reloadData];
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
