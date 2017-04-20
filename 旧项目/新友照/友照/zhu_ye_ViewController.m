//
//  zhu_ye_ViewController.m
//  友照
//
//  Created by ZX on 16/11/17.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "zhu_ye_ViewController.h"

//AppStore
#import <StoreKit/StoreKit.h>

//轮播图
#import "SDCycleScrollView.h"
//轮播图详情
#import "ZXCycleDetailViewController.h"
//cell
#import "ZXBaoMingTableViewCell.h"
#import "ZXSubject2And3TableViewCell.h"
//本地Web
#import "ZX_Web_ViewController.h"
//购买模拟卡
#import "ZX_GouMaiMoNiKa_ViewController.h"
//预约模拟
#import "ZX_YuYueMoNi_ViewController.h"
//排队详情界面
#import "ZX_KeErPaiDuiDetail_ViewController.h"
//教练列表
#import "CoachViewController.h"
//去上课
#import "ZX_QuShangKe_ViewController.h"
#import "ZXKeSanMoNiViewController.h"
//附近驾校
#import "NearbySchoolVC.h"
//补考缴费
#import "ZX_BuKaoJiaoFei_ViewController.h"

@interface zhu_ye_ViewController ()<SKStoreProductViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) UITableView *tab;
//下载地址
@property (nonatomic,strong) NSString *trackViewUrl;
//轮播图对应的链接
@property (nonatomic,strong) NSMutableArray *lunbolianjie;
//判断哪个分区展开隐藏
@property (nonatomic) int section;
//区头上的小字说明
@property (nonatomic, strong) UILabel *lable;
//根据标识 判断是否展开
@property (nonatomic) int flag;
//当前处于哪个阶段
@property (nonatomic) NSInteger sub;
//目前所学到的科目
@property (nonatomic ,copy) NSString *subject;
//科目二预约的教练的id
@property (nonatomic ,copy) NSString *sub2id;
//科目三预约的教练的id
@property (nonatomic ,copy) NSString *sub3id;
//预约的驾校id
@property (nonatomic ,copy) NSString *sid;
//轮播图加载是否成功
@property (nonatomic) BOOL isSuccess;
//点击的是不是驾校
@property (nonatomic) BOOL isJiaXiao;
//点击的是去上课?预约学车
@property (nonatomic) BOOL isQuShangKe;
//点击购买学时卡的按钮是科二?科三
@property (nonatomic) BOOL isXueShiKa;
//点击的是去上课?购买学时
@property (nonatomic) BOOL isGouMaiXueShi;

@end

@implementation zhu_ye_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:YES];
    //请求轮播图数据
    [self lunbo];
    
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        NSString *subject = [ZXUD objectForKey:@"usersubject"];
        self.sub = [subject integerValue];
    }
    else
    {
        self.sub = 0;
    }
    self.section = 888 + (int)self.sub;
    [_tab reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //检测版本
//    [self jiancebenben];

    //创建tabview
    [self tabview];
    self.flag = 1;
}

//创建tabview
-(void)tabview
{
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    UIImageView* uiv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/4)];
    uiv.image = [UIImage imageNamed:@"轮播备用"];
    _tab.tableHeaderView = uiv;
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
    [_tab registerNib:[UINib nibWithNibName:@"ZXBaoMingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_tab registerNib:[UINib nibWithNibName:@"ZXSubject2And3TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    _tab.backgroundColor = ZX_BG_COLOR;
    [self.view addSubview:_tab];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.flag == 0)
    {
        return 0;
    }
    if (self.section == 888)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if (self.section == 889)
    {
        if (section == 1)
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }
    else if (self.section == 890)
    {
        if (section == 2)
        {
            return 3;
        }
        else
        {
            return 0;
        }
    }
    else if (self.section == 891)
    {
        if (section == 3)
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }
    else if (self.section == 892)
    {
        if (section == 4)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (section == 5)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (KScreenWidth-24)/3;
}

//自定义区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 73)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 8, KScreenWidth - 20, 65)];
    view1.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:view1];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 65)];
    imageV.image = [UIImage imageNamed:@"圆角矩形-1-拷贝"];
    
    [view1 addSubview:imageV];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 0, view1.frame.size.width - 10, 65);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [view1 addSubview:btn];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *titleArr = @[@"报名", @"科目一", @"科目二", @"科目三", @"科目四", @"友车"];
    [btn setTitle:titleArr[section] forState:UIControlStateNormal];
    btn.tag = 888 + section;
    
    self.lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, btn.frame.size.width - 110 , 65)];
    self.lable.textAlignment = NSTextAlignmentRight;
    self.lable.font = [UIFont systemFontOfSize:14];
    
    [btn addSubview:self.lable];
    
    NSArray *arr = @[@"还没有报名, 快去看看驾校吧", @"多做题就会有好运, 说不定就过了", @"找个好教练才能愉快的练车", @"找个好教练才能愉快的练车", @"离有照就差最后一步了, 加油", @"终于有照了, 现在开始自己的车生活吧"];
    self.lable.adjustsFontSizeToFitWidth = YES;
    self.lable.text = arr[section];
    self.lable.tag = 300 + section;
    //添加已完成图标
    UIImageView *wanchengimage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) - 65, 10, 40, 40)];
    wanchengimage.image = [UIImage imageNamed:@"已完成"];
    //保持原图片的宽高比
    wanchengimage.contentMode = UIViewContentModeScaleAspectFit;
    if (section < self.sub)
    {
        [btn addSubview:wanchengimage];
        wanchengimage.tag = 400 + section;
    }
    if (_flag == 0)
    {
        self.lable.alpha = 0;
    }
    else
    {
        self.lable.alpha = 0;
        if (self.section == 888)
        {
            UILabel *lab = [btn viewWithTag:300];
            UIImageView *imaV = [btn viewWithTag:400];
            lab.alpha = 1;
            imaV.alpha = 0;
        }
        else if (self.section == 889)
        {
            UILabel *lab = [btn viewWithTag:301];
            UIImageView *imaV = [btn viewWithTag:401];
            lab.alpha = 1;
            imaV.alpha = 0;
        }
        else if (self.section == 890)
        {
            UILabel *lab = [btn viewWithTag:302];
            UIImageView *imaV = [btn viewWithTag:402];
            lab.alpha = 1;
            imaV.alpha = 0;
            
        }
        else if (self.section == 891)
        {
            UILabel *lab = [btn viewWithTag:303];
            UIImageView *imaV = [btn viewWithTag:403];
            lab.alpha = 1;
            imaV.alpha = 0;
        }
        else if (self.section == 892)
        {
            UILabel *lab = [btn viewWithTag:304];
            UIImageView *imaV = [btn viewWithTag:404];
            lab.alpha = 1;
            imaV.alpha = 0;
        }
        else
        {
            UILabel *lab = [btn viewWithTag:305];
            UIImageView *imaV = [btn viewWithTag:405];
            lab.alpha = 1;
            imaV.alpha = 0;
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 73;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaoMingTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell1.image1.image = [UIImage imageNamed:@"教练"];
            cell1.image2.image = [UIImage imageNamed:@"去上课"];
            cell1.image3.image = [UIImage imageNamed:@"约考试"];
            cell1.name1.text = @"找教练";
            cell1.name2.text = @"去上课";
            cell1.name3.text = @"约考试";
            cell1.view1.tag = 100 + indexPath.section;
            cell1.view2.tag = 200 + indexPath.section;
            cell1.view3.tag = 300 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
        else if (indexPath.row == 1)
        {
            cell1.image1.image = [UIImage imageNamed:@"买模拟卡"];
            cell1.image2.image = [UIImage imageNamed:@"预约模拟"];
            cell1.image3.image = [UIImage imageNamed:@"我的队伍"];
            cell1.name1.text = @"买模拟卡";
            cell1.name2.text = @"预约模拟";
            cell1.name3.text = @"我的队伍";
            cell1.view1.tag = 400 + indexPath.section;
            cell1.view2.tag = 500 + indexPath.section;
            cell1.view3.tag = 600 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
        else if (indexPath.row == 2)
        {
            cell1.image1.image = [UIImage imageNamed:@"学时卡"];
            cell1.image2.image = [UIImage imageNamed:@"补考缴费"];
            cell1.image3.image = [UIImage imageNamed:@""];
            cell1.name1.text = @"买学时卡";
            cell1.name2.text = @"补考费";
            cell1.name3.text = @"";
            cell1.view1.tag = 700 + indexPath.section;
            cell1.view2.tag = 800 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            cell1.image1.image = [UIImage imageNamed:@"教练"];
            cell1.image2.image = [UIImage imageNamed:@"去上课"];
            cell1.image3.image = [UIImage imageNamed:@"模拟科三"];
            cell1.name1.text = @"找教练";
            cell1.name2.text = @"去上课";
            cell1.name3.text = @"预约模拟";
            cell1.view1.tag = 100 + indexPath.section;
            cell1.view2.tag = 200 + indexPath.section;
            cell1.view3.tag = 300 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
        else if (indexPath.row == 1)
        {
            cell1.image1.image = [UIImage imageNamed:@"约考试"];
            cell1.image2.image = [UIImage imageNamed:@"学时卡"];
            cell1.image3.image = [UIImage imageNamed:@"补考缴费"];
            cell1.name1.text = @"约考试";
            cell1.name2.text = @"买学时卡";
            cell1.name3.text = @"补考费";
            cell1.view1.tag = 400 + indexPath.section;
            cell1.view2.tag = 500 + indexPath.section;
            cell1.view3.tag = 600 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            cell1.image1.image = [UIImage imageNamed:@"报名须知"];
            cell1.image2.image = [UIImage imageNamed:@"学车流程"];
            cell1.image3.image = [UIImage imageNamed:@"附近驾校"];
            cell1.name1.text = @"报名须知";
            cell1.name2.text = @"学车流程";
            cell1.name3.text = @"附近驾校";
            cell1.view1.tag = 900;
            cell1.view2.tag = 901;
            cell1.view3.tag = 902;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
        else if (indexPath.section == 1 && indexPath.row == 1)
        {
            cell1.image1.image = [UIImage imageNamed:@"补考缴费"];
            cell1.image2.image = [UIImage imageNamed:@""];
            cell1.image3.image = [UIImage imageNamed:@""];
            cell1.name1.text = @"补考费";
            cell1.name2.text = @"";
            cell1.name3.text = @"";
            cell1.view1.tag = 500 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
        }
        else
        {
            cell1.image1.image = [UIImage imageNamed:@"开始学习"];
            cell1.image2.image = [UIImage imageNamed:@"模拟考试"];
            cell1.image3.image = [UIImage imageNamed:@"预约考试14"];
            cell1.name1.text = @"开始学习";
            cell1.name2.text = @"模拟考试";
            cell1.name3.text = @"预约考试";
            cell1.view1.tag = 200 + indexPath.section;
            cell1.view2.tag = 300 + indexPath.section;
            cell1.view3.tag = 400 + indexPath.section;
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view2 addGestureRecognizer:tap2];
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
            [cell1.view3 addGestureRecognizer:tap3];
        }
    }
    return cell1;
}

//轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ZXCycleDetailViewController *CycleVC = [[ZXCycleDetailViewController alloc]init];
    CycleVC.url = self.lunbolianjie[index];
    CycleVC.title = @"活动详情";
    [self.navigationController pushViewController:CycleVC animated:YES];
}

//点击展开
- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == self.section)
    {
        _flag = !_flag;
        self.section = (int)btn.tag;
        [self.tab reloadData];
    }
    else if(_flag == 1)
    {
        self.section = (int)btn.tag;
        [self.tab reloadData];
    }
    else
    {
        _flag = !_flag;
        self.section = (int)btn.tag;
        [self.tab reloadData];
    }
}

//报名,科目一, 科目二,科目四,点击事件
- (void)btnClick:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag)
    {
        //报名须知
        case 900:
        {
            ZX_Web_ViewController *webVC = [[ZX_Web_ViewController alloc]init];
            webVC.titleStr = @"报名须知";
            webVC.htmlStr = @"baomingxuzhi";
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        //学车流程
        case 901:
        {
            ZX_Web_ViewController *webVC = [[ZX_Web_ViewController alloc]init];
            webVC.titleStr = @"学车流程";
            webVC.htmlStr = @"xuecheliucheng";
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        //附近驾校
        case 902:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                NearbySchoolVC *nearbySchool_VC = [[NearbySchoolVC alloc]init];
                nearbySchool_VC.city = [ZXUD objectForKey:@"city"];
                nearbySchool_VC.currentLocation = [[CLLocation alloc]initWithLatitude:[self.weidu doubleValue] longitude:[self.jingdu doubleValue]];
                [self.navigationController pushViewController:nearbySchool_VC animated:YES];
            }
            else
            {
                _isJiaXiao = YES;
                [self chaKanXueYuanXinXiData];
                NearbySchoolVC *nearbySchool_VC = [[NearbySchoolVC alloc]init];
                nearbySchool_VC.city = [ZXUD objectForKey:@"city"];
                nearbySchool_VC.currentLocation = [[CLLocation alloc]initWithLatitude:[self.weidu doubleValue] longitude:[self.jingdu doubleValue]];
                [self.navigationController pushViewController:nearbySchool_VC animated:YES];
            }
            break;
        }
        //开始学习
        case 201:
        {
            QuestionVC *question_VC = [[QuestionVC alloc]init];
            //取出科一所有的题
            question_VC.classType = @"class1";
            NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readAllSubject1Topics];
            //转模型
            NSMutableArray *modelArr = [NSMutableArray array];
            for (NSDictionary *dic in arr)
            {
                ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
                [modelArr addObject:model];
            }
            question_VC.source = modelArr;
            //保存记录状态的文件名
            question_VC.plistName_seleteBtnArr_big1Path = @"class1_order_btn";
            question_VC.plistName_seleteCellArr_big1Path = @"class1_order_cell";
            question_VC.plistName_showExplainArr1Path = @"class1_order_explain";
            question_VC.plistName_currentAnswerArr_big1Path = @"class1_order_answer";
            question_VC.plistName_finishStatus_big1Path = @"class1_order_status";
            
            question_VC.plistName_seleteBtnArr_big4Path = @"class4_order_btn";
            question_VC.plistName_seleteCellArr_big4Path = @"class4_order_cell";
            question_VC.plistName_showExplainArr4Path = @"class4_order_explain";
            question_VC.plistName_currentAnswerArr_big4Path = @"class4_order_answer";
            question_VC.plistName_finishStatus_big4Path = @"class4_order_status";
            
            question_VC.class1Q_index = @"class1Q_index_order";
            question_VC.class4Q_index = @"class4Q_index_order";
            
            question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_order";
            question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_order";
            
            question_VC.isMock = NO;
            //跳转到答题页面
            [self.navigationController pushViewController:question_VC animated:YES];
            break;
        }
        //模拟考试
        case 301:
        {
            MockVC *mock_VC = [[MockVC alloc]init];
            mock_VC.classTypeStr = @"科目一";
            mock_VC.subject = @"1";
            [ZXUD setObject:@"0" forKey:@"moNiKaoShi"];
            [self.navigationController pushViewController:mock_VC animated:YES];
            break;
        }
        //预约考试
        case 401:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]];
            }
            else
            {
                [MBProgressHUD showSuccess:@"抱歉，该网址不能被打开"];
            }
            break;
        }
        //科目一补考费
        case 501:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginPageViewController = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginPageViewController animated:YES];
            }
            else
            {
                if (![[ZXUD objectForKey:@"S_ID"] isEqualToString:@"0"])
                {
                    if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"])
                    {
                        ZX_BuKaoJiaoFei_ViewController *buKaoFeiVC = [[ZX_BuKaoJiaoFei_ViewController alloc] init];
                        buKaoFeiVC.subject = @"1";
                        [self.navigationController pushViewController:buKaoFeiVC animated:YES];
                    }
                    else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"])
                    {
                        [MBProgressHUD showSuccess:@"没有进行到该科目，无法缴费"];
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"该科目已完成，无需补考"];
                    }
                }
                else
                {
                    [MBProgressHUD showSuccess:@"请先报名驾校"];
                }
            }
            break;
        }
        //科目二找教练
        case 102:
        {
            CoachViewController *CoachVC = [[CoachViewController alloc]init];
            CoachVC.CoachType = @"科目二教练";
            CoachVC.subject = @"2";
            CoachVC.cityName = [ZXUD objectForKey:@"city"];
            CoachVC.sid = @"0";
            [self.navigationController pushViewController:CoachVC animated:YES];
            break;
        }
        //科目二去上课
        case 202:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                _isJiaXiao = NO;
                _isQuShangKe = YES;
                _isGouMaiXueShi = NO;
                [self chaKanXueYuanXinXiData];
            }
            break;
        }
        //科目二约考试
        case 302:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]];
            }
            else
            {
                [MBProgressHUD showSuccess:@"抱歉，该网址不能被打开"];
            }
            break;
        }
        //科目二买模拟卡
        case 402:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                ZX_GouMaiMoNiKa_ViewController * gouMaiMoNiKaVC = [[ZX_GouMaiMoNiKa_ViewController alloc] init];
                gouMaiMoNiKaVC.goods_type = @"1";
                [self.navigationController pushViewController:gouMaiMoNiKaVC animated:YES];
            }
            break;
        }
        //科目二预约模拟
        case 502:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                ZX_YuYueMoNi_ViewController * yuYueMoNiVC = [[ZX_YuYueMoNi_ViewController alloc] init];
                [self.navigationController pushViewController:yuYueMoNiVC animated:YES];
            }
            break;
        }
        //科目二我的队伍
        case 602:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                //是否买卡，如果已经买卡已经排队就去我的队伍，如果没买卡就让去买卡，买卡没排队的话就去排队
                [self getKeErPaiDuiDetailData];
            }
            break;
        }
        //科目二买学时卡
        case 702:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                _isJiaXiao = NO;
                _isXueShiKa = YES;
                _isGouMaiXueShi = YES;
                [self chaKanXueYuanXinXiData];
            }
            break;
        }
        //科目二补考费
        case 802:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginPageViewController = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginPageViewController animated:YES];
            }
            else
            {
                if (![[ZXUD objectForKey:@"S_ID"] isEqualToString:@"0"])
                {
                    if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"])
                    {
                        ZX_BuKaoJiaoFei_ViewController *buKaoFeiVC = [[ZX_BuKaoJiaoFei_ViewController alloc] init];
                        buKaoFeiVC.subject = @"2";
                        [self.navigationController pushViewController:buKaoFeiVC animated:YES];
                    }
                    else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"])
                    {
                        [MBProgressHUD showSuccess:@"没有进行到该科目，无法缴费"];
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"该科目已完成，无需补考"];
                    }
                }
                else
                {
                    [MBProgressHUD showSuccess:@"请先报名驾校"];
                }
            }
            break;
        }
        //科目三教练
        case 103:
        {
            CoachViewController *CoachVC = [[CoachViewController alloc]init];
            CoachVC.CoachType = @"科目三教练";
            CoachVC.subject = @"3";
            CoachVC.cityName = [ZXUD objectForKey:@"city"];
            CoachVC.sid = @"0";
            [self.navigationController pushViewController:CoachVC animated:YES];
            break;
        }
        //科目三去上课
        case 203:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginPageViewController = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginPageViewController animated:YES];
            }
            else
            {
                _isJiaXiao = NO;
                _isQuShangKe = NO;
                _isGouMaiXueShi = NO;
                [self chaKanXueYuanXinXiData];
            }
            break;
        }
        //科目三预约模拟
        case 303:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginPageViewController =[[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginPageViewController animated:YES];
            }
            else
            {
                ZXKeSanMoNiViewController *keSanMoNiVC = [[ZXKeSanMoNiViewController alloc] init];
                [self.navigationController pushViewController:keSanMoNiVC animated:YES];
            }
            break;
        }
        //科目三预约考试
        case 403:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]];
            }
            else
            {
                [MBProgressHUD showSuccess:@"抱歉，该网址不能被打开"];
            }
            break;
        }
        //科目三买学时卡
        case 503:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                _isJiaXiao = NO;
                _isXueShiKa = NO;
                _isGouMaiXueShi = YES;
                [self chaKanXueYuanXinXiData];
            }
            break;
        }
        //科目三补考费
        case 603:
        {
            if (![ZXUD boolForKey:@"IS_LOGIN"])
            {
                ZX_Login_ViewController *loginPageViewController = [[ZX_Login_ViewController alloc] init];
                [self.navigationController pushViewController:loginPageViewController animated:YES];
            }
            else
            {
                if (![[ZXUD objectForKey:@"S_ID"] isEqualToString:@"0"])
                {
                    if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"])
                    {
                        ZX_BuKaoJiaoFei_ViewController *buKaoFeiVC = [[ZX_BuKaoJiaoFei_ViewController alloc] init];
                        buKaoFeiVC.subject = @"3";
                        [self.navigationController pushViewController:buKaoFeiVC animated:YES];
                    }
                    else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"])
                    {
                        [MBProgressHUD showSuccess:@"没有进行到该科目，无法缴费"];
                    }
                    else
                    {
                        [MBProgressHUD showSuccess:@"该科目已完成，无需补考"];
                    }
                }
                else
                {
                    [MBProgressHUD showSuccess:@"请先报名驾校"];
                }
            }
            break;
        }
        //科四开始学习
        case 204:
        {
            QuestionVC *question_VC = [[QuestionVC alloc]init];
            //取出科一所有的题
            question_VC.classType = @"class4";
            NSMutableArray *arr = [[ZXTopicManager sharedTopicManager] readAllSubject4Topics];
            //转模型
            NSMutableArray *modelArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                ZXBaseTopicModel *model = [ZXBaseTopicModel modelWithDic:dic];
                [modelArr addObject:model];
            }
            question_VC.source = modelArr;
            //保存记录状态的文件名
            question_VC.plistName_seleteBtnArr_big1Path = @"class1_order_btn";
            question_VC.plistName_seleteCellArr_big1Path = @"class1_order_cell";
            question_VC.plistName_showExplainArr1Path = @"class1_order_explain";
            question_VC.plistName_currentAnswerArr_big1Path = @"class1_order_answer";
            question_VC.plistName_finishStatus_big1Path = @"class1_order_status";
            
            question_VC.plistName_seleteBtnArr_big4Path = @"class4_order_btn";
            question_VC.plistName_seleteCellArr_big4Path = @"class4_order_cell";
            question_VC.plistName_showExplainArr4Path = @"class4_order_explain";
            question_VC.plistName_currentAnswerArr_big4Path = @"class4_order_answer";
            question_VC.plistName_finishStatus_big4Path = @"class4_order_status";
            
            question_VC.class1Q_index = @"class1Q_index_order";
            question_VC.class4Q_index = @"class4Q_index_order";
            
            question_VC.selectedSegmentIndex1 = @"selectedSegmentIndex1_order";
            question_VC.selectedSegmentIndex4 = @"selectedSegmentIndex4_order";
            
            question_VC.isMock = NO;
            //跳转到答题页面
            [self.navigationController pushViewController:question_VC animated:YES];
            break;
        }
            //科四模拟考试
        case 304:
        {
            MockVC *mock_VC = [[MockVC alloc]init];
            mock_VC.classTypeStr = @"科目四";
            mock_VC.subject = @"4";
            [ZXUD setObject:@"0" forKey:@"moNiKaoShi"];
            [self.navigationController pushViewController:mock_VC animated:YES];
            break;
        }
        //科四预约考试
        case 404:
        {
            //跳转网址
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ha.122.gov.cn/m/login?"]];
            }
            else
            {
                [MBProgressHUD showSuccess:@"抱歉，该网址不能被打开"];
            }
            break;
        }
            
        default:
            break;
    }
}




//检测版本
-(void)jiancebenben
{
    //检测版本,版本更新
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=1112427256";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (!error) {
            if(response)
            {
                NSError *errorr;
              
                NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&errorr];
                if (errorr)
                {
                    return;
                }

                NSArray *resultArray = [appInfoDict objectForKey:@"results"];
                if (![resultArray count])
                {
                    return;
                }
    
                NSDictionary *infoDict = [resultArray objectAtIndex:0];
                //获取服务器上应用的最新版本号
                NSArray* arr=[infoDict[@"version"] componentsSeparatedByString:@"."];
                NSInteger updateVersion=0;
                for (int i=0; i<arr.count; i++)
                {
                    if(i==0)
                    {
                        updateVersion+=[arr[i] integerValue]*1000;
                    }
                    else if (i==1)
                    {
                        updateVersion+=[arr[i] integerValue]*100;
                    }
                    else if (i==2)
                    {
                        updateVersion+=[arr[i] integerValue]*10;
                    }
                    else if (i==3)
                    {
                        updateVersion+=[arr[i] integerValue]*1;
                    }
                }
                NSString *trackName = infoDict[@"trackName"];
                _trackViewUrl = infoDict[@"trackViewUrl"];
                YZLog(@"%ld",(long)updateVersion);
                //获取当前设备中应用的版本号
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSArray* arr2=[[infoDic objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
                NSInteger currentVersion=0;
    
                for (int i=0; i<arr2.count; i++)
                {
                    if(i==0)
                    {
                        currentVersion+=[arr2[i] integerValue]*1000;
                    }
                    else if (i==1)
                    {
                        currentVersion+=[arr2[i] integerValue]*100;
                    }
                    else if (i==2)
                    {
                        currentVersion+=[arr2[i] integerValue]*10;
                    }
                    else if (i==3)
                    {
                        currentVersion+=[arr2[i] integerValue]*1;
                    }
                }
                //判断两个版本是否相同
                if (currentVersion < updateVersion)
                {
                    NSString *titleStr = [NSString stringWithFormat:@"检查更新：%@", trackName];
                    NSString *messageStr = [NSString stringWithFormat:@"发现新版本%@,是否更新", infoDict[@"version"]];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
                    alert.tag = 1112427256;
                    [alert show];
                }
            }
            YZLog(@"%@",data);
        }else{
            YZLog(@"%@",error);
        }
    }];
    [dataTask resume];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1112427256)
    {
        if (buttonIndex == 1)
        {
            //点击”升级“按钮，就从打开app store上应用的详情页面
            SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
            storeProductVC.delegate = self;
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1112427256" forKey:SKStoreProductParameterITunesItemIdentifier];
            [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error)
             {
                 if (result)
                 {
                     [self presentViewController:storeProductVC animated:YES completion:nil];
                 }
             }];
        }
    }
}

//请求轮播图数据
-(void)lunbo
{
    [[ZXNetDataManager manager3] qingqiulunboushujusuccess:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         NSMutableArray* lunbo_arr = [NSMutableArray array];
         for (NSDictionary *dic in jsonDict[@"list"])
         {
             [lunbo_arr addObject:dic[@"src"]];
             if(!_lunbolianjie)
             {
                 _lunbolianjie = [NSMutableArray array];
                 [_lunbolianjie addObject:dic[@"link"]];
             }
             else
             {
                 [_lunbolianjie addObject:dic[@"link"]];
             }
         }
         SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/4) delegate:self placeholderImage:nil];
         cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
         cycleScrollView2.currentPageDotColor = [UIColor cyanColor]; //自定义分页控件小圆标颜色
         cycleScrollView2.autoScrollTimeInterval = 3.0;
         //--- 模拟加载延迟
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             cycleScrollView2.imageURLStringsGroup = lunbo_arr;
         });
         _tab.tableHeaderView = cycleScrollView2;
     }Failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

//请求科二模拟排队详情的数据
-(void)getKeErPaiDuiDetailData
{
    //如果没有登录就让登录
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        //用户没有登陆的
        ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    else
    {
        [[ZXNetDataManager manager]keErYuYueMoNiPaiDuiDetaiDatalWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andErid:@"" andMoni_time:@"" andStid:@"" success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSError *err;
             NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
             jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
             NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
             if(err)
             {
                 NSLog(@"json解析失败：%@",err);
             }

             if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:nil])
             {
                 if ([jsonDict[@"resault"] isKindOfClass:[NSArray class]] && ((NSArray*)jsonDict[@"resault"]).count>0)
                 {
                     ZX_KeErPaiDuiDetail_ViewController * keErPaiDuiDetailVC = [[                ZX_KeErPaiDuiDetail_ViewController alloc] init];
                     keErPaiDuiDetailVC.keErPaiDuiArr = jsonDict[@"resault"];
                     keErPaiDuiDetailVC.isWoDeDuiWu = YES;
                     [self.navigationController pushViewController:keErPaiDuiDetailVC animated:YES];
                 }
                 else
                 {
                     ZX_YuYueMoNi_ViewController * yuYueMoNiVC = [[ZX_YuYueMoNi_ViewController alloc] init];
                     [self.navigationController pushViewController:yuYueMoNiVC animated:YES];
                 }
             }
         } failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         }];
    }
}

// 查看学员信息
- (void)chaKanXueYuanXinXiData
{
    [[ZXNetDataManager manager] chaKanXueYuanXinXiDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         
         if(err)
         {
             YZLog(@"jso n解析失败：%@",err);
         }
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             //取出用户信息，判断用户学到科目几
             _subject = jsonDict[@"info"][0][@"subject"];
             _sub2id = jsonDict[@"info"][0][@"tid2"];
             _sub3id = jsonDict[@"info"][0][@"tid3"];
             _sid = jsonDict[@"info"][0][@"sid"];
             
             if (!_isJiaXiao)
             {
                 if([_subject isEqualToString:@"1"] || [_subject isEqualToString:@"0"])
                 {
                     if (!_isGouMaiXueShi)
                     {
                         if (_isQuShangKe)
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目二哦"];
                             CoachViewController *coachVC = [[CoachViewController alloc] init];
                             coachVC.cityName = [ZXUD objectForKey:@"city"];
                             coachVC.CoachType = @"科目二教练";
                             coachVC.subject = @"2";
                             coachVC.sid = @"0";
                             [self.navigationController pushViewController:coachVC animated:YES];
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目三哦"];
                             CoachViewController *coachVC = [[CoachViewController alloc] init];
                             coachVC.cityName = [ZXUD objectForKey:@"city"];
                             coachVC.CoachType = @"科目三教练";
                             coachVC.subject = @"3";
                             coachVC.sid = @"0";
                             [self.navigationController pushViewController:coachVC animated:YES];
                         }
                     }
                     else
                     {
                         if (_isXueShiKa)
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目二哦"];
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目三哦"];
                         }
                     }
                 }
                 else if ([_subject isEqualToString:@"2"])
                 {
                     if (!_isGouMaiXueShi)
                     {
                         if (_isQuShangKe)
                         {
                             if ([_sub2id isEqualToString:@"0"])
                             {
                                 [MBProgressHUD showSuccess:@"您还没有选择教练哦"];
                                 CoachViewController *coachVC = [[CoachViewController alloc] init];
                                 coachVC.cityName = [ZXUD objectForKey:@"city"];
                                 coachVC.CoachType = @"科目二教练";
                                 coachVC.subject = @"2";
                                 coachVC.sid = _sid;
                                 [self.navigationController pushViewController:coachVC animated:YES];
                             }
                             else
                             {
                                 ZX_QuShangKe_ViewController *quShangKeVC = [[ZX_QuShangKe_ViewController alloc] init];
                                 quShangKeVC.jiaoLianName = jsonDict[@"info"][0][@"teacher_name"];
                                 quShangKeVC.subId = _sub2id;
                                 quShangKeVC.subject = @"2";
                                 quShangKeVC.goods_type = @"12";
                                 [self.navigationController pushViewController:quShangKeVC animated:YES];
                             }
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目三哦"];
                             CoachViewController *coachVC = [[CoachViewController alloc] init];
                             coachVC.cityName = [ZXUD objectForKey:@"city"];
                             coachVC.CoachType = @"科目三教练";
                             coachVC.subject = @"3";
                             coachVC.sid = @"0";
                             [self.navigationController pushViewController:coachVC animated:YES];
                         }
                     }
                     else
                     {
                         if (_isXueShiKa)
                         {
                             if ([_sub2id isEqualToString:@"0"])
                             {
                                 [MBProgressHUD showSuccess:@"您还没有选择教练哦"];
                             }
                             else
                             {
                                 ZX_GouMaiMoNiKa_ViewController * gouMaiMoNiKaVC = [[ZX_GouMaiMoNiKa_ViewController alloc] init];
                                 gouMaiMoNiKaVC.goods_type = @"12";
                                 [self.navigationController pushViewController:gouMaiMoNiKaVC animated:YES];
                             }
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您还没有学到科目三哦"];
                         }
                     }
                 }
                 else if([_subject isEqualToString:@"3"])
                 {
                     if (!_isGouMaiXueShi)
                     {
                         if (_isQuShangKe)
                         {
                             [MBProgressHUD showSuccess:@"您的科二已经完成了哟"];
                         }
                         else
                         {
                             if ([_sub3id isEqualToString:@"0"])
                             {
                                 [MBProgressHUD showSuccess:@"您还没有选择教练哦"];
                                 CoachViewController *coachVC = [[CoachViewController alloc] init];
                                 coachVC.cityName = [ZXUD objectForKey:@"city"];
                                 coachVC.CoachType = @"科目三教练";
                                 coachVC.subject = @"3";
                                 coachVC.sid = _sid;
                                 [self.navigationController pushViewController:coachVC animated:YES];
                             }
                             else
                             {
                                 ZX_QuShangKe_ViewController *quShangKeVC = [[ZX_QuShangKe_ViewController alloc] init];
                                 quShangKeVC.jiaoLianName = jsonDict[@"info"][0][@"teacher_name"];
                                 quShangKeVC.subId = _sub3id;
                                 quShangKeVC.subject = @"3";
                                 quShangKeVC.goods_type = @"13";
                                 [self.navigationController pushViewController:quShangKeVC animated:YES];
                             }
                         }
                     }
                     else
                     {
                         if (_isXueShiKa)
                         {
                             [MBProgressHUD showSuccess:@"您的科二已经完成了哟"];
                         }
                         else
                         {
                             if ([_sub3id isEqualToString:@"0"])
                             {
                                 [MBProgressHUD showSuccess:@"您还没有选择教练哦"];
                             }
                             else
                             {
                                 ZX_GouMaiMoNiKa_ViewController * gouMaiMoNiKaVC = [[ZX_GouMaiMoNiKa_ViewController alloc] init];
                                 gouMaiMoNiKaVC.goods_type = @"13";
                                 [self.navigationController pushViewController:gouMaiMoNiKaVC animated:YES];
                             }
                         }
                     }
                 }
                 else if([_subject isEqualToString:@"4"] || [_subject isEqualToString:@"5"])
                 {
                     if (!_isGouMaiXueShi)
                     {
                         if (_isQuShangKe)
                         {
                             [MBProgressHUD showSuccess:@"您的科二已经完成了哟"];
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您的科三已经完成了哟"];
                         }
                     }
                     else
                     {
                         if (_isXueShiKa)
                         {
                             [MBProgressHUD showSuccess:@"您的科二已经完成了哟"];
                         }
                         else
                         {
                             [MBProgressHUD showSuccess:@"您的科三已经完成了哟"];
                         }
                     }
                 }
             }
             else
             {
                 if (![_sid isEqualToString:@"0"])
                 {
                     [MBProgressHUD showSuccess:@"您已经选过驾校了哦"];
                 }
                 else
                 {
                     [MBProgressHUD showSuccess:@"您还没有选择驾校哦"];
                 }
                 
             }
        }
         else
         {
             [MBProgressHUD showSuccess:@"获取用户信息失败"];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD hideHUD];
     }];
}



- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
