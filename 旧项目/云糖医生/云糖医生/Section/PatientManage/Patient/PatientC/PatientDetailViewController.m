//
//  PatientDetailViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PatientDetailViewController.h"
#import "PatientListTableViewCell.h"
#import "bloodSugarTableViewCell.h"
#import "SortNotesTableViewCell.h"
#import "OnlineChatTableViewCell.h"
#import "SugarRecodeManageViewController.h"
#import "SZBNetDataManager+PatientManageNetData.h"
#import "SugarRecordTableViewController.h"
#import "PatientInfoTableViewController.h"
#import "ChatViewController.h"

@interface PatientDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, strong)NSDictionary *dic;//详情数据
@property (nonatomic, strong)LoadingView *loadingView;//加载中动画
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//重新加载占位图
@end

@implementation PatientDetailViewController
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"患者详情";
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    //注册cell
     [self.tableV registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatientListTableViewCellID"];
    [self.tableV registerNib:[UINib nibWithNibName:@"bloodSugarTableViewCell" bundle:nil] forCellReuseIdentifier:@"bloodSugarTableViewCellID"];
    [self.tableV registerNib:[UINib nibWithNibName:@"SortNotesTableViewCell" bundle:nil] forCellReuseIdentifier:@"SortNotesTableViewCellID"];
     [self.tableV registerNib:[UINib nibWithNibName:@"OnlineChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"OnlineChatTableViewCellID"];
    //添加刷新头与加载尾
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //只有下拉刷新的事件被触发,就应该重新请求数据.
        //获取患者详情的数据
        [self getDetailData];
    }];
     [self.view addSubview:_loadingView];
     [self getDetailData];
     [ZXUD setObject:self.patient_id forKey:@"patient_id"];
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getDetailData {
   
    [[SZBNetDataManager manager] patientContentRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPatientIds:self.patient_id success:^(NSURLSessionDataTask *task, id responseObject) {
        [_loadingView dismiss];
        [self.loadFailureView removeFromSuperview];
        [self.tableV.mj_header endRefreshing];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            self.dic = responseObject[@"info"];
            self.phone = _dic[@"phone"];
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
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }

    } failed:^(NSURLSessionTask *task, NSError *error) {
        [_loadingView dismiss];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getDetailData) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - UITableViewDataSource
//返回组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
//返回行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientListTableViewCellID"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = cell.nameLable.frame;
            frame.size.width = cell.bgView.frame.size.width;
            cell.nameLable.frame = frame;
        });
        cell.ziliao.hidden = YES;
        cell.showType.hidden = YES;
        cell.selectionStyle = NO;
        if ([_dic[@"name"] isEqualToString:@""]) {
             cell.nameLable.text = @"--";
        }else {
             cell.nameLable.text = _dic[@"name"];
        }
        
        cell.ageLable.text = [NSString stringWithFormat:@"%@岁", _dic[@"age"]];
        [cell.headImageV sd_setImageWithURL:_dic[@"pic"] placeholderImage:[UIImage imageNamed:@"默认患者头像"]];
        if ([_dic[@"gender"] isEqualToString:@"0"]) {
            cell.genderLable.text = @"男";
        }else {
            cell.genderLable.text = @"女";
        }
        if ([_dic[@"diabetes_name"] isEqualToString:@""]) {
             cell.sickType.text = @"--";
        }else {
             cell.sickType.text = _dic[@"diabetes_name"];;
        }
        

        return cell;
    }
    else if (indexPath.section == 1)
    {
        bloodSugarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bloodSugarTableViewCellID"];
        //查看血糖记录
        [cell.sevenDayRecordBtn addTarget:self action:@selector(sevenDayRecordAction) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = NO;
        if (_dic) {
            [cell.higheNum setTitle:[NSString stringWithFormat:@"%@次", _dic[@"higher"]]forState:UIControlStateNormal];
            [cell.normalNum setTitle:[NSString stringWithFormat:@"%@次",_dic[@"normal"]] forState:UIControlStateNormal];
            [cell.lowNum setTitle:[NSString stringWithFormat:@"%@次",_dic[@"lower"]] forState:UIControlStateNormal];
        }
        return cell;
       
    }
    else if (indexPath.section == 2)
    {
        SortNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortNotesTableViewCellID"];
        cell.leftImageV.image = [UIImage imageNamed:@"饮食"];
        cell.rightImageV.image = [UIImage imageNamed:@"运动"];
        cell.leftTopLable.text = @"饮食";
        cell.rightTopLable.text = @"运动";
        if (_dic) {
            if ([_dic[@"movement"] isKindOfClass:[NSString class]] && ![_dic[@"movement"] isEqualToString:@""]) {
//                cell.leftTopLable.text = _dic[@"movement"];
                cell.rightLowLable.text = [NSString stringWithFormat:@"%@%@分钟",_dic[@"movement"], _dic[@"movement_time"]];
            }
            if ([_dic[@"meal"] isKindOfClass:[NSString class]] && ![_dic[@"meal"] isEqualToString:@""]) {
                  cell.leftLowLable.text = [NSString stringWithFormat:@"%@Kcal", _dic[@"meal"]];
            }
          
        }
        UITapGestureRecognizer *tap1 =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoDetailAction:)];
        cell.LeftView.tag = 222;
        [cell.LeftView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoDetailAction:)];
         cell.RightView.tag = 333;
        [cell.RightView addGestureRecognizer:tap2];
        
        cell.selectionStyle = NO;
        return cell;
    }else if (indexPath.section == 3)
    {
        SortNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortNotesTableViewCellID"];
        UITapGestureRecognizer *tap1 =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoDetailAction:)];
        cell.LeftView.tag = 444;
        [cell.LeftView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoDetailAction:)];
        cell.RightView.tag = 555;
        [cell.RightView addGestureRecognizer:tap2];

        cell.leftImageV.image = [UIImage imageNamed:@"胰岛素"];
        cell.rightImageV.image = [UIImage imageNamed:@"口服药"];
        cell.leftTopLable.text = @"胰岛素";
        cell.rightTopLable.text = @"口服药";
        if (_dic) {
            if ([_dic[@"insulin"] isKindOfClass:[NSString class]] &&  ![_dic[@"insulin"] isEqualToString:@""]) {
            cell.leftLowLable.text =  _dic[@"insulin"];
            }
            if ([_dic[@"medication"] isKindOfClass:[NSString class]] &&  ![_dic[@"medication"] isEqualToString:@""]) {
            cell.rightLowLable.text = _dic[@"medication"];
            }
           
        }
        cell.selectionStyle = NO;
        return cell;
    }
    else
    {
        OnlineChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnlineChatTableViewCellID"];
        //在线事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatAction:)];
        [cell.OnlienV addGestureRecognizer:tap];
        //邀请事件
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteAction:)];
        [cell.inviteV addGestureRecognizer:tap1];
        cell.selectionStyle = NO;
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PatientInfoTableViewController *VC = [[PatientInfoTableViewController alloc]init];
        VC.patient_id = self.patient_id;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
//查看血糖记录
- (void)sevenDayRecordAction {
    SugarRecodeManageViewController *S_V = [[SugarRecodeManageViewController alloc]init];
    S_V.flag = 1;
    [self.navigationController pushViewController:S_V animated:YES];
}
- (void)intoDetailAction:(UITapGestureRecognizer *)tap {
     SugarRecodeManageViewController *S_V = [[SugarRecodeManageViewController alloc]init];
    switch (tap.view.tag) {
        case 222:
            //跑步
            [ZXUD setObject:@"0" forKey:@"flag2"];
            break;
        case 333:
            //饮食
            [ZXUD setObject:@"1" forKey:@"flag2"];
            break;
        case 444:
            //胰岛素
            [ZXUD setObject:@"2" forKey:@"flag2"];
            break;
        case 555:
            //口服药
            [ZXUD setObject:@"3" forKey:@"flag2"];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:S_V animated:YES];
}
//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }
    else if (indexPath.section == 4)
    {
        return KScreenWidth * 3 / 8 ;
    }
    else
    {
        return (KScreenWidth - 30) / 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *V = [[UIView alloc]init];
    V.backgroundColor = J_BackLightGray;
    return V;
}
//跳转带邀请设置界面
- (void)inviteAction:(UITapGestureRecognizer *)tap {
    PA_inviteSetViewController *inviteVC = [[PA_inviteSetViewController alloc]init];
    inviteVC.name = _dic[@"name"];//患者姓名
    inviteVC.patient_id = self.patient_id;//传患者id
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inviteVC animated:YES];
    
}
//在线聊天
- (void)chatAction:(UITapGestureRecognizer *)tap {
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_phone conversationType:EMConversationTypeChat];
    if([_dic[@"name"] isKindOfClass:[NSString class]] && [_dic[@"name"] length]>0)
    {
        chatController.title=_dic[@"name"];
    }
    else
    {
         chatController.title=_dic[@"phone"];
    }
    NSMutableArray* arr=[NSMutableArray arrayWithArray:[ZXUD arrayForKey:@"liaotian"]];
    if (arr.count==0)
    {
        NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
        [dict setObject:_dic[@"name"] forKey:@"name"];
        if (_dic[@"pic"]) {
            [dict setObject:_dic[@"pic"] forKey:@"pic"];
        }
        [dict setObject:_phone forKey:@"phone"];
        [arr addObject:dict];
        [ZXUD setObject:arr forKey:@"liaotian"];
        [ZXUD synchronize];
    }
    else
    {
        for (int i=0; i<arr.count; i++)
        {
            if (![arr[i][@"phone"] isEqualToString:_phone])
            {
                NSMutableDictionary* dict=[[NSMutableDictionary alloc]init];
                [dict setObject:_dic[@"name"] forKey:@"name"];
                if (_dic[@"pic"]) {
                   [dict setObject:_dic[@"pic"] forKey:@"pic"];
                }
                [dict setObject:_phone forKey:@"phone"];
                [arr addObject:dict];
                [ZXUD setObject:arr forKey:@"liaotian"];
                [ZXUD synchronize];
                
                continue;
            }
        }
    }
    chatController.flag = @"0";
    [self.navigationController pushViewController:chatController animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
    //默认进入饮食
    [ZXUD setObject:@"0" forKey:@"flag2"];
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
