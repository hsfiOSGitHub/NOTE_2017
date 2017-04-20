//
//  KnSignUpDetailVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnSignUpDetailVC.h"

#import "KnSignUpDetailCell1.h"
#import "KnSignUpDetailCell2.h"
#import "KnSignUpDetailCell3.h"
#import "SZBNetDataManager+KnowLedgeNetData.h"
#import "KnMeetingSignUpModel.h"
#import "SZBNetDataManager+PersonalInformation.h"
#import "MyMeetingSignUpInfoModel.h"

@interface KnSignUpDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *iconAndTitleArr;//图标和标题
@property (nonatomic,strong) KnMeetingSignUpModel *meetingSignUpModel;//数据模型
@property (nonatomic,strong) MyMeetingSignUpInfoModel *myMeetingSignUpInfoModel;//数据模型

@property (nonatomic,strong) NSNumber *is_exist;//报名状态

@property (nonatomic,strong) LoadingView *loadingView;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空图片
@end

static NSString *identifierSignUpCell1 = @"identifierSignUpCell1";
static NSString *identifierSignUpCell2 = @"identifierSignUpCell2";
static NSString *identifierSignUpCell3 = @"identifierSignUpCell3";
@implementation KnSignUpDetailVC
#pragma mark -网络请求
//报名会议
-(void)loadMeeting_sign_up_UrlData{
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager meeting_sign_upWithMid:self.mid AndRandomStamp:[ToolManager getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        //网络请求成功
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            self.is_exist = @1;
            //数据转模型
            NSDictionary *resault = responseObject[@"resault"];
            self.meetingSignUpModel = [KnMeetingSignUpModel modelWithDict:resault];
            //刷新UI
            [self.tableView reloadData];
            [MBProgressHUD showError:@"报名成功"];
            
        }else{
            self.is_exist = @0;
            NSString *message = responseObject[@"msg"];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate returnSignUpStatus:self.is_exist];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertC addAction:cancel];
            [self presentViewController:alertC animated:YES completion:nil];
            self.meetingSignUpModel = nil;
        }
        [self.loadingView dismiss];//加载动画停止
        [self.tableView reloadData];//刷新UI
        NSLog(@"%@",responseObject);
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络加载失败
        self.is_exist = @0;
        [self.loadingView dismiss];//加载动画停止
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        [self.view addSubview:self.loadFailureView];//加载失败图片
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_sign) forControlEvents:UIControlEventTouchUpInside];
    }];
}
//点击重新加载
-(void)loadAgainBtnAction_sign{
    [self loadMeeting_sign_up_UrlData];
}

//我报名的会议
-(void)loadMeeting_sign_up_info_UrlData{
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager meeting_sign_up_infoWithRandomString:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] andMid:self.mid success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        //网络请求成功
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            //数据转模型
            NSDictionary *resault = responseObject[@"resault"];
            self.myMeetingSignUpInfoModel = [MyMeetingSignUpInfoModel modelWithDict:resault];
        }else{
            NSString *message = responseObject[@"msg"];
            [MBProgressHUD showError:message];
        }
        
        [self.loadingView dismiss];//加载动画停止
        [self.tableView reloadData];//刷新UI
        NSLog(@"%@",responseObject);
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络加载失败
        [self.loadingView dismiss];//加载动画停止
        [self.loadFailureView removeFromSuperview];//移除加载失败图片
        [self.view addSubview:self.loadFailureView];//加载失败图片
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_info) forControlEvents:UIControlEventTouchUpInside];
    }];
}
//点击重新加载
-(void)loadAgainBtnAction_info{
    [self loadMeeting_sign_up_info_UrlData];
}
#pragma mark -懒加载
-(NSArray *)iconAndTitleArr{
    if (!_iconAndTitleArr) {
        _iconAndTitleArr = @[@{@"icon":@"kn_signUpDetail_time",@"title":@"会议时间"},
                             @{@"icon":@"kn_signUpDetail_host",@"title":@"会议演讲人"},
                             @{@"icon":@"kn_signUpDetail_location",@"title":@"会议地点"},
                             @{@"icon":@"kn_signUpDetail_meetingName",@"title":@"会议名称"}];
    }
    return _iconAndTitleArr;
}
#pragma mark -导航栏设置
-(void)setUpNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
}
//返回
-(void)backAction{
    if ([self.sourcePushVC isEqualToString:@"MyMeetingListVC"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.delegate returnSignUpStatus:self.is_exist];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    self.navigationItem.title = @"报名详情";
    //初始化tableView
    [self initTableView];
    //导航栏设置
    [self setUpNavi];
    //网络加载图片（加载中  加载失败  空数据）
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadingView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _loadFailureView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
    
    //加载中动画
    [self.view addSubview:_loadingView];
    //网络请求
    if ([self.sourcePushVC isEqualToString:@"MyMeetingListVC"]) {
        [self loadMeeting_sign_up_info_UrlData];
    }else{
        [self loadMeeting_sign_up_UrlData];
    }
    
}
#pragma mark -viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
//初始化tableView
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //设置数据源代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnSignUpDetailCell1 class]) bundle:nil] forCellReuseIdentifier:identifierSignUpCell1];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnSignUpDetailCell2 class]) bundle:nil] forCellReuseIdentifier:identifierSignUpCell2];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnSignUpDetailCell3 class]) bundle:nil] forCellReuseIdentifier:identifierSignUpCell3];
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.sourcePushVC isEqualToString:@"MyMeetingListVC"]) {
        if (indexPath.section == 0) {
            KnSignUpDetailCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell1 forIndexPath:indexPath];
            if (!self.myMeetingSignUpInfoModel.meeting_sn) {
                cell1.signUpNum.text = [NSString stringWithFormat:@"报名序列号:"];
            }else{
                cell1.signUpNum.text = [NSString stringWithFormat:@"报名序列号：%@",self.myMeetingSignUpInfoModel.meeting_sn];
            }
            cell1.securityCodeImgView.image = [UIImage imageOfQRFromURL:cell1.signUpNum.text];
            return cell1;
        }else if (indexPath.section == 1) {
            KnSignUpDetailCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell2 forIndexPath:indexPath];
            if (!self.myMeetingSignUpInfoModel.status) {
                cell2.signOrNot.text = @"";
            }else{
                cell2.signOrNot.text = self.myMeetingSignUpInfoModel.status;
            }
            //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
            if (self.doType == NULL || [self.doType isEqualToString:@""]) {//未报名
                cell2.signType.text = @"";
            }else if ([self.doType isEqualToString:@"0"]) {//主动报名
                cell2.signType.text = @"(主动报名)";
            }else if ([self.doType isEqualToString:@"1"]) {//后台邀请
                cell2.signType.text = @"(后台邀请)";
            }
            return cell2;
        }else {
            KnSignUpDetailCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell3 forIndexPath:indexPath];
            cell3.iconAndTitleDic = self.iconAndTitleArr[indexPath.section - 2];
            if (indexPath.section == 2) {//报名时间
                cell3.content.text = self.myMeetingSignUpInfoModel.meeting_start_time;
            }else if (indexPath.section == 3) {//会议演讲人
                cell3.content.text = self.myMeetingSignUpInfoModel.actor;
            }else if (indexPath.section == 4) {//会议地点
                cell3.content.text = self.myMeetingSignUpInfoModel.address;
            }else if (indexPath.section == 5) {//会议名称
                cell3.content.text = self.myMeetingSignUpInfoModel.meeting_name;
            }
            return cell3;
        }
    }else{
        if (indexPath.section == 0) {
            KnSignUpDetailCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell1 forIndexPath:indexPath];
            if (!self.meetingSignUpModel.meeting_sn || [self.meetingSignUpModel.meeting_sn isKindOfClass:[NSNull class]] || [self.meetingSignUpModel.meeting_sn isEqualToString:@""]) {
                cell1.signUpNum.text = [NSString stringWithFormat:@"报名序列号:"];
            }else {
                cell1.signUpNum.text = [NSString stringWithFormat:@"报名序列号:%@",self.meetingSignUpModel.meeting_sn];
            }
            cell1.securityCodeImgView.image = [UIImage imageOfQRFromURL:cell1.signUpNum.text];
            return cell1;
        }else if (indexPath.section == 1) {
            KnSignUpDetailCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell2 forIndexPath:indexPath];
            if (!self.meetingSignUpModel.words || [self.meetingSignUpModel.words isKindOfClass:[NSNull class]] || [self.meetingSignUpModel.words isEqualToString:@""]) {
                cell2.signOrNot.text = @"报名失败";
            }else{
                cell2.signOrNot.text = self.meetingSignUpModel.words;
            }
            //"dotype": 1,//报名方式 空为未报名，0是主动报名，1是后台邀请
            if (self.doType == NULL || [self.doType isEqualToString:@""]) {//未报名
                cell2.signType.text = @"";
            }else if ([self.doType isEqualToString:@"0"]) {//主动报名
                cell2.signType.text = @"(主动报名)";
            }else if ([self.doType isEqualToString:@"1"]) {//后台邀请
                cell2.signType.text = @"(后台邀请)";
            }
            return cell2;
        }else {
            KnSignUpDetailCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:identifierSignUpCell3 forIndexPath:indexPath];
            cell3.iconAndTitleDic = self.iconAndTitleArr[indexPath.section - 2];
            if (indexPath.section == 2) {//报名时间
                cell3.content.text = self.meetingSignUpModel.meeting_start_time;
            }else if (indexPath.section == 3) {//会议演讲人
                cell3.content.text = self.meetingSignUpModel.actor;
            }else if (indexPath.section == 4) {//会议地点
                cell3.content.text = self.meetingSignUpModel.address;
            }else if (indexPath.section == 5) {//会议名称
                cell3.content.text = self.meetingSignUpModel.meeting_name;
            }
            return cell3;
        }
    }
    
    return nil;
}
//点击不变灰
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
//footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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
