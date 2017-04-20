//
//  Register2JobVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "Register2JobVC.h"

#import "Register2DepartmentCell.h"
#import "SZBNetDataManager+department.h"
#import "ValueHelper.h"

@interface Register2JobVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;//数据源
@property (nonatomic,strong) NSMutableArray *seletedArr;//选择的数组
@property (nonatomic,assign) NSInteger oldTag;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;//加载中
@end

static NSString *identifierCell_Job = @"identifierCell_Job";
@implementation Register2JobVC
#pragma mark -懒加载
-(NSArray *)source{
    if (!_source) {
        _source = [NSArray array];
    }
    return _source;
}
-(NSMutableArray *)seletedArr{
    if (!_seletedArr) {
        _seletedArr = [NSMutableArray array];
    }
    return _seletedArr;
}


#pragma mark -网络请求
- (void)getDoctorType {
    self.loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2 - 32);
    [self.view addSubview:self.loadingView];
    self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView.backgroundColor = [UIColor darkGrayColor];
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.layer.cornerRadius = 10;
    [self.loadingView startAnimating];
    
    [[SZBNetDataManager manager] get_doctor_typeRandomString:[ToolManager getCurrentTimeStamp] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadingView removeFromSuperview];
        //网络请求成功
        NSString *resStr = responseObject[@"res"];
        if ([resStr isEqualToString:@"1001"]) {
            NSArray *resault = responseObject[@"resault"];
            //给数据源赋值
            self.source = resault;
            //初始化seletedArr
            for (int i = 0; i < [self.source count]; i++) {
                [self.seletedArr addObject:@0];
            }
            //刷新表
            [self.tableView reloadData];
        }else if ([resStr isEqualToString: @"1005"] || [resStr isEqualToString: @"1004"]) {
            
        }else {
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        [self.loadingView removeFromSuperview];
        [MBProgressHUD showError:@"网络不给力啊，请重新尝试！"];
    }];
}
#pragma mark -导航栏设置
-(void)setUpNavi{
    self.navigationController.navigationBar.translucent = NO;
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    //确定按钮、
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//返回
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//确定
-(void)okAction{
    NSDictionary *dict = self.source[self.oldTag];
    [ValueHelper sharedHelper].registerJob = dict;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(253, 254, 255, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1)}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"选择职称";
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    //加载数据
    [self getDoctorType];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Register2DepartmentCell class]) bundle:nil] forCellReuseIdentifier:identifierCell_Job];
    //高度
    self.tableView.rowHeight = 50;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Register2DepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell_Job forIndexPath:indexPath];
    //配置seleteIcon 图片
    UIImage *seletedImg = [UIImage imageNamed:@"registerGuider_seleted"];
    UIImage *noseletedImg = [UIImage imageNamed:@"registerGuider_noseleted"];
    if ([self.seletedArr[indexPath.row] isEqual:@0]) {
        cell.seleteIcon.image = noseletedImg;
    }else if ([self.seletedArr[indexPath.row] isEqual:@1]) {
        cell.seleteIcon.image = seletedImg;
    }
    //添加点击事件
    [cell.seleteIcon setTag:indexPath.row + 100];
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seleteIconAction:)];
    //为图片添加手势
    [cell.seleteIcon addGestureRecognizer:singleTap];
    //配置titleLabel
    cell.titleLabel.text = self.source[indexPath.row][@"title"];
    
    return cell;
}
//点击seleteIcon
-(void)seleteIconAction:(UITapGestureRecognizer *)sender{
    UIImageView *seleteIcon = (UIImageView *)sender.view;
    //改数据源
    //先将原来的置0
    NSUInteger index = seleteIcon.tag - 100;
    if (index != self.oldTag) {
        [self.seletedArr replaceObjectAtIndex:self.oldTag withObject:@0];
    }
    if ([self.seletedArr[index] integerValue]) {//取消
        [self.seletedArr replaceObjectAtIndex:index withObject:@0];
    }else{//选择
        [self.seletedArr replaceObjectAtIndex:index withObject:@1];
    }
    //刷表
    [self.tableView reloadData];
    self.oldTag = index;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Register2DepartmentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *seleteIcon = cell.seleteIcon;
    [self seleteIconAction:seleteIcon.gestureRecognizers[0]];
}
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
