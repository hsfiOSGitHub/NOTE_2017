//
//  DiscussVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "DiscussVC.h"

@interface DiscussVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//侧滑菜单
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UITableView *drawerTable;
@property (nonatomic,strong) NSMutableArray *source;//数据源
@property (nonatomic,strong) NSArray *drawerSource;//抽屉数据源
//导航栏
@property (nonatomic,strong) UIButton *userBtn;
@property (nonatomic,strong) UIButton *moreBtn;

@end

//侧滑菜单
static NSString *identifier_header = @"identifier_header";
static NSString *identifier_cell = @"identifier_cell";
@implementation DiscussVC
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
    
    self.navigationController.navigationBar.translucent = YES;
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
    //配置tableView
    //    [self setUpTableView];
    
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
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>> tableView    
    else if (tableView == self.tableView) {
        
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
