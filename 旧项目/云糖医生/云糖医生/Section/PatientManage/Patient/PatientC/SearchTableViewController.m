//
//  SearchTableViewController1.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/5.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SZBNetDataManager+PatientManageNetData.h"
#import "SearchBarHeader.h"
@interface SearchTableViewController ()<UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *HistoryName;//历史搜索;
@property (nonatomic, strong)NSMutableArray *dataSource;//检索到的热词;
@property (nonatomic, strong)UITextField *SearchPatientTF;//搜索患者
@property (nonatomic)BOOL active;//标记是否处于搜索状态
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation SearchTableViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //历史记录的消息
    [self.HistoryName removeAllObjects];
    for (NSDictionary *dic in [ZXUD objectForKey:@"history"]) {
        [self.HistoryName addObject:dic];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
# pragma mark 懒加载
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _dataSource;
}
-(NSMutableArray *)HistoryName {
    if (!_HistoryName) {
        self.HistoryName = [NSMutableArray array];
    }
    return _HistoryName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索患者";
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCellID"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //注册搜索区头
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchBarHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"SearchBarHeader"];
   
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.active) {
       
    return self.HistoryName.count + 1;
    }
    if (self.dataSource.count) {
        return self.dataSource.count;
    }else {
        return 1;
    }
    

  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.active) {
        return 100;
    }else {
        if (indexPath.row == 0) {
            return 30;
        }else {
            return 100;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.active) {
        if (self.dataSource.count) {
            PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCellID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic = self.dataSource[indexPath.row];
             [cell setData:dic];
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"没有相关结果";
            return cell;
        }
        
    }else if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.HistoryName.count == 0) {
           cell.textLabel.text = @"没有搜索记录";
        }else {
           cell.textLabel.text = @"最近搜过";
        }
        return cell;
    }else {
        PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.HistoryName[indexPath.row - 1];
        [cell setData:dic];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.view endEditing:YES];
    if (self.active) {
        PatientDetailViewController *PaDetail = [[PatientDetailViewController alloc]init];
        if (self.dataSource.count > 0) {
            NSDictionary *Dic = self.dataSource[indexPath.row];
            PaDetail.patient_id = Dic[@"patient_id"];
            PaDetail.phone = Dic[@"phone"];
            //搜索历史的处理
            NSMutableArray *newHistoryArr = [NSMutableArray array];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in self.HistoryName) {
              
            [arr addObject:dic[@"phone"]];
            }
            if (![arr containsObject:Dic[@"phone"]]) {
                [newHistoryArr addObject:Dic];
                [newHistoryArr addObjectsFromArray:self.HistoryName];
                while (newHistoryArr.count > 10) {
                    [newHistoryArr removeLastObject];
                }
                self.HistoryName = newHistoryArr;
                [ZXUD setObject:self.HistoryName forKey:@"history"];
                [ZXUD synchronize];
            }
         
        [self.navigationController pushViewController:PaDetail animated:YES];
        }
    }else if (indexPath.row > 0) {
        PatientDetailViewController *PaDetail = [[PatientDetailViewController alloc]init];
        NSDictionary *dic = self.HistoryName[indexPath.row - 1];
        PaDetail.patient_id = dic[@"patient_id"];
        [self.navigationController pushViewController:PaDetail animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchBarHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SearchBarHeader"];
    self.SearchPatientTF = header.SearchTF;
    header.SearchTF.placeholder = @"请输入要搜索的内容";
    header.SearchTF.keyboardType = UIKeyboardTypeDefault;
    header.SearchTF.delegate = self;
    [header.SearchTF becomeFirstResponder];
    [header.SearchBtn addTarget:self action:@selector(SearchAction:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//  
//    [self.view endEditing:YES];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)SearchAction:(UIButton *)btn{
    if ([self.SearchPatientTF.text isEqualToString:@""]) {
       [MBProgressHUD showError:@"请输入姓名" toView:self.view];
        return;
    }
     [self.view endEditing:YES];
     [MBProgressHUD showMessage:@"正在搜索" toView:self.view];
    [[SZBNetDataManager manager]patientSearchRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andStr:self.SearchPatientTF.text success:^(NSURLSessionDataTask *task, id responseObject) {
         [MBProgressHUD hideHUDForView:self.view];
        [self.loadFailureView removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            self.active = YES;
            [self.dataSource removeAllObjects];
            NSArray *arr = responseObject[@"list"];
            if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
               
                for (NSDictionary *dic in responseObject[@"list"]) {
                    [self.dataSource addObject:dic];
                }
            }
             [self.tableView reloadData];
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
        }else if ([responseObject[@"res"] isEqualToString:@"1005"]) {
             [MBProgressHUD showError:@"请输入搜索的内容" toView:self.view];
        }else if ([responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
//        [self.view addSubview:self.loadFailureView];
//        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(SearchAction:) forControlEvents:UIControlEventTouchUpInside];
         [MBProgressHUD hideHUDForView:self.view];
         [MBProgressHUD showError:@"网络错误"];
        
    }];
}

//设置tableView哪些行可以被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.active && indexPath.row > 0) {
         return YES;
    }
    return NO;
}
//提交编辑操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.HistoryName removeObjectAtIndex:indexPath.row - 1];
        //搜索历史的处理
        NSMutableArray *newHistoryArr = [NSMutableArray array];
        for (NSDictionary *dic in self.HistoryName) {
            [newHistoryArr addObject:dic];
        }
        self.HistoryName = newHistoryArr;
        [ZXUD setObject:newHistoryArr forKey:@"history"];
        [ZXUD synchronize];
        //更新界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    [btn setTitle:@"清空历史记录" forState:UIControlStateNormal];
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    if (!self.active) {
        if (self.HistoryName.count) {
            return btn;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}
- (void)deleteAction:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空历史记录吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.HistoryName removeAllObjects];
        //搜索历史的处理
        NSMutableArray *newHistoryArr = [NSMutableArray array];
        self.HistoryName = newHistoryArr;
        [ZXUD setObject:newHistoryArr forKey:@"history"];
        [ZXUD synchronize];
        //更新界面
        [self.tableView reloadData];
    }];
    [alert addAction:cancelAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
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
