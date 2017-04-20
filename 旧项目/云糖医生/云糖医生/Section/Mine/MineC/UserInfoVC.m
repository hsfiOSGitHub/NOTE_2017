//
//  UserInfoVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "UserInfoVC.h"

#import "PersonalDataTableViewCell.h"
#import "SZBAlertView.h"
#import "ValueHelper.h"
#import "ProvinceVC.h"
#import "SZBNetDataManager+PersonalInformation.h"
#import "DepartmentVC.h"
#import "UserExperienceVC.h"
#import "SZBFmdbManager+userInfo.h"
#import "UserInfoModel.h"
#import "SZBNetDataManager+department.h"
#import "JobTitleVC.h"

@interface UserInfoVC ()<RemoveSelf,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UserInfoModel *userInfoModel;//个人信息模型
@property (nonatomic,strong) SZBAlertView *AlertV;//弹出框
@property (nonatomic,strong) UIButton *modifyBtn;//修改按钮

@end

@implementation UserInfoVC
#pragma mark -网络请求数据 （上传到服务器）
-(void)loadDoctor_update_UrlData{
    [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager doctor_updateWithRandomString:[ToolManager getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andHid:self.userInfoModel.hid andDid:self.userInfoModel.did andGender:self.userInfoModel.gender andContent:self.userInfoModel.conent andDo_at:self.userInfoModel.do_at andName:self.userInfoModel.name andTtid:self.userInfoModel.ttid success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            if ([responseObject[@"info"][@"name"] isKindOfClass:[NSString class]] && [responseObject[@"info"][@"name"] length]>0)
            {
                [ZXUD setObject:responseObject[@"info"][@"name"] forKey:@"name"];

            }
            if ([responseObject[@"info"][@"pic"] isKindOfClass:[NSString class]] && [responseObject[@"info"][@"pic"] length]>0)
            {
                [ZXUD setObject:responseObject[@"info"][@"pic"] forKey:@"pic"];
                
            }
            //上传成功 将数据库中的数据进行修改
            NSDictionary *info = responseObject[@"info"];
            [[SZBFmdbManager sharedManager] modifyUserInfoDataAtDBWith:info];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:responseObject[@"msg"]];
            });
        }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
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
            [MBProgressHUD showError:@"请填写不完善的信息"];
        }else if ([responseObject[@"res"] isEqualToString:@"1004"]) {
           
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络错误"];
    }];
}


#pragma mark -从数据库加载数据
-(void)loadDataFromLocal{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    NSArray *result = [manager readUserInfoModelArrFromDB];
    if (result.count == 0) {
        return;
    }
    self.userInfoModel = result[0];
    NSLog(@"%@",self.userInfoModel.pic);
    //刷新表
    [self.tableView reloadData];
}

//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    
    _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _modifyBtn.frame = CGRectMake(0, 0, 44, 44);
    [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [_modifyBtn setTitleColor: KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [_modifyBtn addTarget:self action:@selector(modifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_modifyBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//点击保存
-(void)modifyBtnAction:(UIButton *)sender{
    if (![self.userInfoModel.name isKindOfClass:[NSString class]] || [self.userInfoModel.name isEqualToString:@""]){
        [MBProgressHUD showError:@"请填写姓名"];
    }else if(![self.userInfoModel.gender isKindOfClass:[NSString class]] || [self.userInfoModel.gender isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择性别"];
    }else if (![self.userInfoModel.hid isKindOfClass:[NSString class]] || [self.userInfoModel.hid isEqualToString:@""]) {
         [MBProgressHUD showError:@"请选择医院"];
    }else if (![self.userInfoModel.did isKindOfClass:[NSString class]] || [self.userInfoModel.did isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择科室"];
    }else if (![self.userInfoModel.ttid isKindOfClass:[NSString class]] || [self.userInfoModel.ttid isEqualToString:@""]) {
         [MBProgressHUD showError:@"请选择职称"];
    }else {
        //提交到网络
        [self loadDoctor_update_UrlData];
    }
}
//返回
- (void)goToBack {
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"医生信息";
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    //注册通知
    [self registerNoti];
    //加载数据库数据
    [self loadDataFromLocal];
    
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //
}
//配置tableView
-(void)setUpTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalHistoryTableViewCellID"];
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
//行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        PersonalHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalHistoryTableViewCellID" forIndexPath:indexPath];
        cell.PersonalType.text = @"个人经历";
        [cell resetContentLabelFrame:self.userInfoModel.conent];
        if ([self.userInfoModel.conent isKindOfClass:[NSString class]] && ![self.userInfoModel.conent isEqualToString:@""]) {
              cell.DetailLable.text = self.userInfoModel.conent;
        }else {
            cell.DetailLable.text = @"点击编辑个人经历";
        }
        return cell;
    }else {
        PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataTableViewCellID" forIndexPath:indexPath];
        NSArray *arr = @[@"姓名", @"性别",@"医院", @"科室", @"职称"];
        cell.imageV.image = [UIImage imageNamed:arr[indexPath.row]];
        cell.name.text = arr[indexPath.row];
        if (self.userInfoModel == nil) {
            return cell;
        }
        if (indexPath.row == 0) {
            if ([self.userInfoModel.name isKindOfClass:[NSString class]] && ![self.userInfoModel.name isEqualToString:@""]) {
                 cell.selectLable.text = self.userInfoModel.name;
            }else {
                cell.selectLable.text = @"点击修改";
            }
        }else if (indexPath.row == 1) {
            if ([self.userInfoModel.gender isKindOfClass:[NSString class]] && ![self.userInfoModel.gender isEqualToString:@""]) {
                if ([self.userInfoModel.gender isEqualToString:@"0"]) {
                    cell.selectLable.text = @"男";
                }else if ([self.userInfoModel.gender isEqualToString:@"1"]) {
                    cell.selectLable.text = @"女";
              }
            }else{
                cell.selectLable.text = @"点击修改";
            }
        }else if (indexPath.row == 2) {
            if ([self.userInfoModel.hospital isKindOfClass:[NSString class]] && ![self.userInfoModel.hospital isEqualToString:@""]) {
               cell.selectLable.text = self.userInfoModel.hospital;
            }else {
                cell.selectLable.text = @"选择您所在的医院";
            }
        }else if (indexPath.row == 3) {
           
            if ([self.userInfoModel.department isKindOfClass:[NSString class]] && ![self.userInfoModel.department isEqualToString:@""]) {
                cell.selectLable.text = self.userInfoModel.department;
            }else {
                cell.selectLable.text = @"选择您所在的科室";
            }
        }else if (indexPath.row == 4) {
           
            if ([self.userInfoModel.title isKindOfClass:[NSString class]] && ![self.userInfoModel.title isEqualToString:@""]) {
                 cell.selectLable.text = self.userInfoModel.title;
            }else {
                cell.selectLable.text = @"选择您的职称";
            }
        }
        return cell;
    }
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 5) {
        //个人经历
        UserExperienceVC *userExperience_VC = [[UserExperienceVC alloc]init];
        userExperience_VC.content = [NSString stringWithFormat:@"%@",self.userInfoModel.conent];
  
        [self.navigationController pushViewController:userExperience_VC animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:{//姓名
                _AlertV = [[SZBAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height)];
                _AlertV.agency = self;
                _AlertV.type = SZBAlertType6;
                _AlertV.name = self.userInfoModel.name;
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [keyWindow addSubview:_AlertV];
            }
                break;
            case 1:{//性别
                _AlertV = [[SZBAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height)];
                _AlertV.agency = self;
                _AlertV.type = SZBAlertType2;
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                [keyWindow addSubview:_AlertV];
            }
                break;
            case 2:{//医院
                ProvinceVC *province_VC = [[ProvinceVC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:province_VC];
                [ValueHelper sharedHelper].registerGuider = @"userInfo";
                [self presentViewController:navi animated:YES completion:nil];
            }
                break;
            case 3:{//科室
                DepartmentVC *department_VC = [[DepartmentVC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:department_VC];
                [self presentViewController:navi animated:YES completion:nil];
            }
                break;
            case 4:{//职称
                JobTitleVC *JobTitle_VC = [[JobTitleVC alloc]init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:JobTitle_VC];
                [self presentViewController:navi animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark -alertV bgview 的代理方法
//取消弹出框
-(void)removeSelfAction{
    [_AlertV removeFromSuperview];
}
#pragma mark -注册通知
-(void)registerNoti{
    //姓名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameOKWith:) name:NameView_ok_noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAction) name:NameView_cancel_noti object:nil];
    //性别
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(genderWith:) name:SexView_ok_noti object:nil];
    //医院
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHospital:) name:UserInfoHospitalNoti object:nil];
    //科室
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDepartment:) name:UserInfoDepartmentNoti object:nil];
    //职称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobOK:) name:JobView_ok_noti object:nil];
    //个人经历
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(message:) name:UserInfoExperienceNoti object:nil];
}
//>>>>>>姓名
-(void)nameOKWith:(NSNotification *)noti{
    NSString * str = noti.userInfo[@"name"];
    if (str.length > 12) {
        self.userInfoModel.name =  [str substringToIndex:12];
    }else {
        self.userInfoModel.name = str;
    }
    [self.tableView reloadData];
    [_AlertV removeFromSuperview];
}
-(void)nameCancel{
    [_AlertV removeFromSuperview];
}
//>>>>>>>性别
-(void)genderWith:(NSNotification *)noti{
    self.userInfoModel.gender = noti.userInfo[@"gender"];
    [self.tableView reloadData];
    [_AlertV removeFromSuperview];
}
//>>>>>>>>>医院
-(void)updateHospital:(NSNotification *)noti{
    NSLog(@"%@", noti.userInfo);
    self.userInfoModel.hospital = noti.userInfo[@"name"];
    self.userInfoModel.hid = [NSString stringWithFormat:@"%@", noti.userInfo[@"id"]];
    [self.tableView reloadData];
}
//>>>>>>>科室
-(void)updateDepartment:(NSNotification *)noti{
    NSLog(@"%@", noti.userInfo);
    self.userInfoModel.department = noti.userInfo[@"name"];
    self.userInfoModel.did = noti.userInfo[@"id"];
    [self.tableView reloadData];
}
//>>>>>>>职称
-(void)jobOK:(NSNotification *)noti{
    self.userInfoModel.title = noti.userInfo[@"title"];
    self.userInfoModel.ttid = noti.userInfo[@"ttid"];
    [self.tableView reloadData];
}
//>>>>>>>>>接收个人经历信息
- (void)message:(NSNotification *)noti{
    self.userInfoModel.conent = noti.userInfo[@"conent"];
    [self.tableView reloadData];
}

-(void)cancelAction{
    [_AlertV removeFromSuperview];
}
-(void)okAction{
    [self.tableView reloadData];
    [_AlertV removeFromSuperview];
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
