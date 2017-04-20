//
//  PatientVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//


#import "PatientVC.h"
#import "SZBNetDataManager+PatientManageNetData.h"
#import "SearchTableViewController.h"
#import "SectionModel.h"
#import "HeaderView.h"
#import "SearchBarHeader.h"
#import "NetStateView.h"
@interface PatientVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)NSMutableDictionary *listSourceDic;//存整个数据
@property (nonatomic, strong)NSMutableArray *ProjectNameArr;//存所有项目名字
@property (nonatomic, strong)NSMutableArray *modelArray;//存展开或者隐藏标志的model
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//网络重新加载
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空的占位图
@property (nonatomic, strong)LoadingView *loadingView;//加载动画
@property (nonatomic,strong) NetStateView *netStateView;
@end

@implementation PatientVC
# pragma mark 懒加载
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 110)];
    }
    return _loadFailureView;
}
-(UITableView *)tableV {
    if (!_tableV) {
        self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 110) style:UITableViewStyleGrouped];
        self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableV.delegate = self;
        self.tableV.dataSource = self;
    }
    return _tableV;
}
- (NSMutableDictionary *)listSourceDic {
    if (!_listSourceDic) {
       _listSourceDic = [NSMutableDictionary dictionary];
    }
    return _listSourceDic;
}
- (NSMutableArray *)ProjectNameArr {
    if (!_ProjectNameArr) {
        _ProjectNameArr = [NSMutableArray array];
    }
    return _ProjectNameArr;
}
- (NSMutableArray *)modelArray {
    if (!_modelArray ) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableV];
    self.navigationItem.title = @"患者管理";
    //加载的数据为空
    _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    //加载动画
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, -14, KScreenWidth, KScreenHeight - 99)];
    
    [self.view addSubview:_loadingView];
    //注册cell
    [self.tableV registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCellID"];
    //注册搜索区头
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchBarHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"SearchBarHeader"];
    //添加刷新头与加载尾
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只有下拉刷新的事件被触发,就应该重新请求数据.
        //获取患者管理信息
        [self getPatientList];
    }];
    [self getPatientList];
    //接收通知 去刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPatientList) name:@"reloadData" object:nil];
}
-(void)netStateViewRemove{
    [self.netStateView removeFromSuperview];
}
- (void)getPatientList {
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
    
        [self.tableV.mj_header endRefreshing];
        //移除空数据图片
        [_placeholdView removeFromSuperview];
        //停止加载中动画
        [self.loadingView dismiss];
       // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         //   [self.loadFailureView removeFromSuperview];
        //    [self.view addSubview:self.loadFailureView];
        //    [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getPatientList) forControlEvents:UIControlEventTouchUpInside];
      //  });
        [MBProgressHUD showError:@"请检查您的网络"];
        return;
    }
      [[SZBNetDataManager manager] patientListRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableV.mj_header endRefreshing];
        [_loadingView dismiss];
        [self.loadFailureView removeFromSuperview];
        [self.placeholdView removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            [self.listSourceDic removeAllObjects];
            [self.modelArray removeAllObjects];
            [self.ProjectNameArr removeAllObjects];
            if ([responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"list"]) {
                    if ([dic[@"activity_name"] isKindOfClass:[NSString class]]) {
                        [self.ProjectNameArr addObject:dic[@"activity_name"]];
                        [self.listSourceDic setValue:dic[@"patient"] forKey:dic[@"activity_name"]];
                    }else {
                        [self.ProjectNameArr addObject:@"未知项目"];
                        [self.listSourceDic setValue:dic[@"patient"] forKey:@"未知项目"];
                    }
                    SectionModel *model = [[SectionModel alloc]init];
                    model.isOpen = YES;
                    [self.modelArray addObject:model];
                }
            }
            if (self.listSourceDic.count == 0) {
                _placeholdView.label.text = @"点击右上角➕添加患者吧";
                [self.view addSubview:_placeholdView];
            }
            [self.tableV reloadData];
        }else  if ([responseObject[@"res"] isEqualToString:@"1002"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                LoginVC *VC = [[LoginVC alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
        }else if ([responseObject[@"res"] isEqualToString:@"100666"]) {
            _placeholdView.label.text = @"您还没有认证成功, 无法查看该内容";
            [self.tableV addSubview:_placeholdView];
        }else {
             [MBProgressHUD showError:responseObject[@"msg"]];
        }

    } failed:^(NSURLSessionTask *task, NSError *error) {
        [self.tableV.mj_header endRefreshing];
        [_loadingView dismiss];
        [self.loadFailureView removeFromSuperview];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getPatientList) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listSourceDic.count) {
        return self.listSourceDic.count + 1;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    SectionModel *model = self.modelArray[section - 1];
    if (model.isOpen) {
        NSArray *PatientArr = self.listSourceDic[self.ProjectNameArr[section - 1]];
        return PatientArr.count;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *PatientArr = self.listSourceDic[self.ProjectNameArr[indexPath.section - 1]];
        NSDictionary *dic = PatientArr[indexPath.row];
        [cell setData:dic];
        return cell;
}
//cell点击跳患者详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
        PatientDetailViewController *PaDetail = [[PatientDetailViewController alloc]init];
        NSArray *PatientArr = self.listSourceDic[self.ProjectNameArr[indexPath.section - 1]];
        NSDictionary *dic = PatientArr[indexPath.row];
        PaDetail.patient_id = dic[@"patient_id"];
        PaDetail.phone = dic[@"phone"];
    
        [self.navigationController pushViewController:PaDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    return 40;
}

//自定义页眉
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SearchBarHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SearchBarHeader"];
        header.SearchTF.delegate = self;
        header.SearchTF.placeholder = @"请输入要搜索的内容";
        [header.SearchBtn addTarget:self action:@selector(PushSearchVC) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else {
        NSArray *PatientArr = self.listSourceDic[self.ProjectNameArr[section - 1]];
        HeaderView *header = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
        header.tag = 100 + section - 1;
        [header addGestureRecognizer:tap];
        
        header.lable.text = self.ProjectNameArr[section - 1];
        header.numLable.textColor = [UIColor darkGrayColor];
        header.numLable.text = [NSString stringWithFormat:@"%ld", (unsigned long)PatientArr.count];
        SectionModel *model = self.modelArray[section - 1];
        if (model.isOpen) {
            header.imageV.image = [UIImage imageNamed:@"展开"];
            header.numLable.hidden = YES;
        }else {
            header.imageV.image = [UIImage imageNamed:@"下一步-拷贝"];
            header.numLable.hidden = NO;
        }
        return header;
    }
}
//项目标题点击事件
- (void)btnAction:(UITapGestureRecognizer *)tap {
    
    SectionModel *model = self.modelArray[tap.view.tag - 100];
    model.isOpen = !model.isOpen;
    [self.tableV reloadData];
}
//输入框开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    //跳到搜索
    [self PushSearchVC];
}
//跳到搜索
- (void)PushSearchVC {
    SearchTableViewController *SearchVC = [[SearchTableViewController alloc]init];
  
    [self.navigationController pushViewController:SearchVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.tableV.mj_header endRefreshing];
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
