//
//  SchoolDetailVC.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailVC.h"

#import "SchoolDetailCell1.h"
#import "SchoolDetailCell2.h"
#import "SchoolDetailCell3.h"
#import "SchoolDetailCell4.h"
#import "SchoolDetailHeader.h"
#import "SchoolDetailCell5.h"
#import "SchoolDetailCell6.h"
#import "SchoolDetailCell6_2.h"
#import "ZXCommentTableViewCell.h"
#import "CoachViewController.h"
#import "ZXCoachDetailVC.h"
//点击查看更多评价
#import "MoreCommentVC.h"
//点击驾校图片
#import "ZX_JiaoJingShouShi_ViewController.h"
#import "ZXIDVerifyViewController.h"
#import "ZXMapViewController.h"
//评论
#import "ZXEvaluateOrderListVC.h"

@interface SchoolDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *signUpBtn;//报名学车按钮
@property (nonatomic,strong) UIView *topView;//顶部视图
//数据源
@property (nonatomic,strong) SchoolDetailModel *source;
@property (nonatomic,strong)NSString* jiaxiao;//用于加载驾校详情（网络请求）
@property (nonatomic,strong) NSMutableArray *tuPianArr;
@property (nonatomic,strong) NSArray *schoolArr;
@property (nonatomic, strong) UIButton *footerBtn;
@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
static NSString *identifierCell4 = @"identifierCell4";
static NSString *identifierCell5 = @"identifierCell5";
static NSString *identifierCell6 = @"identifierCell6";
static NSString *identifierCell6_2 = @"identifierCell6_2";
static NSString *identifierCell7 = @"identifierCell7";
static NSString *identifierHeader = @"identifierHeader";
static NSString *identifierHeader2 = @"identifierHeader2";
static NSString *identifierHeader3 = @"identifierHeader3";

@implementation SchoolDetailVC

#pragma mark -viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"驾校详情";

    if ([[ZXUD objectForKey:@"S_ID"] isEqualToString:@"0"] || ![ZXUD boolForKey:@"IS_LOGIN"])
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50)];
        [self.view addSubview:self.tableView];
        _signUpBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
        [_signUpBtn addTarget:self action:@selector(signUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_signUpBtn setTitle:@"报名学车" forState:UIControlStateNormal];
        _signUpBtn.backgroundColor=dao_hang_lan_Color;
        [self.view addSubview:_signUpBtn];
    }
    else
    {
        if([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]])
        {
            self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50)];
            [self.view addSubview:self.tableView];
            _signUpBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
            [_signUpBtn addTarget:self action:@selector(signUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _signUpBtn.backgroundColor=dao_hang_lan_Color;
            [self.view addSubview:_signUpBtn];
            if ([[ZXUD objectForKey:@"S_C"] isEqualToString:@"2"])
            {
                [_signUpBtn setTitle:@"驾校已评价" forState:UIControlStateNormal];
            }
            else
            {
                [_signUpBtn setTitle:@"赶快去评价驾校吧" forState:UIControlStateNormal];
            }
        }
        else
        {
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            [self.view addSubview:self.tableView];
        }
    }
    //配置tableView
    [self setUpTableView];
    //加载数据
    [self loadData_schoolDetail];
    [self loadDataSchoolImageList];
}

//配置tableView
-(void)setUpTableView
{
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell3 class]) bundle:nil] forCellReuseIdentifier:identifierCell3];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell4 class]) bundle:nil] forCellReuseIdentifier:identifierCell4];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell5 class]) bundle:nil] forCellReuseIdentifier:identifierCell5];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell6 class]) bundle:nil] forCellReuseIdentifier:identifierCell6];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailCell6_2 class]) bundle:nil] forCellReuseIdentifier:identifierCell6_2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifierCell7];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SchoolDetailHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader3];
}

//点击footer
-(void)footerAction:(UIButton *)sender
{
    MoreCommentVC *moreComment_VC = [[MoreCommentVC alloc]init];
    moreComment_VC.sid = self.sid;
    [self.navigationController pushViewController:moreComment_VC animated:YES];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        if (self.source.teacher_subject2.count==0)
        {
            return 0;
        }
        return 1;
    }
    else if (section == 3)
    {
        if (self.source.teacher_subject3.count==0)
        {
            return 0;
        }
        return 1;
    }
    else if (section == 4)
    {
        if ([_schoolArr[0][@"comment"] count] > 0)
        {
            return 1;
        }
    }
    return 0;
}

//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SchoolDetailCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
            [cell1.imgView sd_setImageWithURL:[NSURL URLWithString:self.source.pic] placeholderImage:[UIImage imageNamed:@"jiaxiaobg"]];
            //点击图片放大
            cell1.imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigImgView:)];
            tap.numberOfTapsRequired = 1;
            [cell1.imgView addGestureRecognizer:tap];
            //配置图片按钮
            cell1.jizhang.text=[NSString stringWithFormat:@"%@张",self.source.school_images_num];

            //给图片按钮添加点击事件
            [cell1.picBtn addTarget:self action:@selector(picBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell1.selectionStyle=0;
            return cell1;
        }
        else if (indexPath.row == 1)
        {
            SchoolDetailCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
            cell2.selectionStyle=0;
            cell2.schoolDetailModel = self.source;
            return cell2;
        }
        else if (indexPath.row == 2)
        {
            //地图
            SchoolDetailCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:identifierCell3 forIndexPath:indexPath];
            cell3.location.text = self.source.address;
             cell3.selectionStyle=0;
            return cell3;
        }
        else if (indexPath.row == 3)
        {
            //电话
            SchoolDetailCell4 *cell4 = [tableView dequeueReusableCellWithIdentifier:identifierCell4 forIndexPath:indexPath];
            if(self.source.tel.length>15)
            {
                 cell4.tel.text = [self.source.tel componentsSeparatedByString:@" "][0];
            }
            else
            {
                 cell4.tel.text = self.source.tel;
            }
           
             cell4.selectionStyle=0;
            return cell4;
        }
    }
    else if (indexPath.section == 1)
    {
        SchoolDetailCell5 *cell5 = [tableView dequeueReusableCellWithIdentifier:identifierCell5 forIndexPath:indexPath];
        cell5.schoolInfo.text = self.source.content;
        cell5.selectionStyle=0;
        return cell5;
    }
    else if (indexPath.section == 2)
    {
        SchoolDetailCell6 *cell6 = [tableView dequeueReusableCellWithIdentifier:identifierCell6 forIndexPath:indexPath];
        cell6.selectionStyle=0;
        //配置数据
        cell6.schoolDetailModel_2 = self.source;
        //点击查看科二教练详情
        [cell6.iconBtn1 setTag:1000];
        [cell6.iconBtn2 setTag:1001];
        [cell6.iconBtn3 setTag:1002];
        [cell6.iconBtn4 setTag:1003];
        [cell6.iconBtn1 addTarget:self action:@selector(class2TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6.iconBtn2 addTarget:self action:@selector(class2TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6.iconBtn3 addTarget:self action:@selector(class2TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6.iconBtn4 addTarget:self action:@selector(class2TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell6;
    }
    else if (indexPath.section == 3)
    {
        SchoolDetailCell6_2 *cell6_2 = [tableView dequeueReusableCellWithIdentifier:identifierCell6_2 forIndexPath:indexPath];
         cell6_2.selectionStyle=0;
        //配置数据
        cell6_2.schoolDetailModel_3 = self.source;
        //点击查看科三教练详情
        [cell6_2.iconBtn1 setTag:2000];
        [cell6_2.iconBtn2 setTag:2001];
        [cell6_2.iconBtn3 setTag:2002];
        [cell6_2.iconBtn4 setTag:2003];
        [cell6_2.iconBtn1 addTarget:self action:@selector(class3TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6_2.iconBtn2 addTarget:self action:@selector(class3TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6_2.iconBtn3 addTarget:self action:@selector(class3TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell6_2.iconBtn4 addTarget:self action:@selector(class3TeacherDetail:) forControlEvents:UIControlEventTouchUpInside];
        return cell6_2;
    }
    else if (indexPath.section == 4)
    {
        ZXCommentTableViewCell *cell7 = [tableView dequeueReusableCellWithIdentifier:identifierCell7 forIndexPath:indexPath];
        NSDictionary *dic = _schoolArr[0][@"comment"][indexPath.row];
        [cell7 resetContentLabelFrame:dic];
        [cell7 setUpCellWith:dic];
        cell7.selectionStyle=0;
        return cell7;
    }
    return nil;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中
    if (indexPath.section == 0)
    {
        //跳转到地图
        if (indexPath.row == 2)
        {
            //没有坐标信息直接返回
            if ([self.source.location isEqualToString:@""])
            {
                return;
            }
            NSArray *locations = [self.source.location componentsSeparatedByString:@","];
            ZXMapViewController *mapVC = [[ZXMapViewController alloc] init];
            mapVC.schoolName = self.source.name;
            mapVC.deatilInfo = self.source.address;
            mapVC.locations = locations;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
        if (indexPath.row == 3)
        {
            //打电话
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否拨打驾校热线" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
            {
                if ([self.source.tel isEqualToString:@""])
                {
                    return;
                }
                if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.source.tel]]])
                {
                    return;
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.source.tel]]];
            }];
            [alertC addAction:cancel];
            [alertC addAction:ok];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}

//点击图片放大
-(void)seeBigImgView:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    [HSFImageHelper showWithImageView:imgView];
}

//点击科二教练(4个)
-(void)class2TeacherDetail:(UIButton *)sender
{
    ZXCoachDetailVC *coachDetailVC = [[ZXCoachDetailVC alloc]init];
    if ([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]])
    {
        coachDetailVC.benxiao=YES;
        coachDetailVC.kesan=NO;
    }
    else
    {
        coachDetailVC.benxiao=NO;
    }
    switch (sender.tag)
    {
        case 1000:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject2"][0][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject2"][0][@"tname"];
        }
            break;
        case 1001:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject2"][1][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject2"][1][@"tname"];
        }
            break;
        case 1002:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject2"][2][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject2"][2][@"tname"];
        }
            break;
        case 1003:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject2"][3][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject2"][3][@"tname"];
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}

//点击科三教练(4个)
-(void)class3TeacherDetail:(UIButton *)sender
{
    ZXCoachDetailVC *coachDetailVC = [[ZXCoachDetailVC alloc]init];
    if ([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]])
    {
        coachDetailVC.benxiao=YES;
        coachDetailVC.kesan=YES;
    }
    else
    {
        coachDetailVC.benxiao=NO;
    }
    switch (sender.tag)
    {
        case 2000:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject3"][0][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject3"][0][@"tname"];
        }
            break;
        case 2001:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject3"][1][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject3"][1][@"tname"];
        }
            break;
        case 2002:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject3"][2][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject3"][2][@"tname"];
        }
            break;
        case 2003:
        {
            coachDetailVC.tid = _schoolArr[0][@"teacher_subject3"][3][@"tid"];
            coachDetailVC.name = _schoolArr[0][@"teacher_subject3"][3][@"tname"];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:coachDetailVC animated:YES];
}

//自定义section header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {
        return nil;
    }
    else if (section == 1)
    {
        SchoolDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
        header.title.text = @"驾校详情";
        header.moreBtn.hidden=YES;
        header.image1.hidden = YES;
        header.image2.hidden = YES;
        header.image3.hidden = YES;
        header.image4.hidden = YES;
        header.image5.hidden = YES;
        header.fenlable.hidden = YES;
        header.noCommentLable.hidden = YES;
        header.moreImgV.hidden = YES;
        return header;
    }
    else if (section == 2)
    {
        SchoolDetailHeader *header2 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader2];
        header2.title.text = @"科二教练";
        header2.noCommentLable.hidden = NO;
        header2.noCommentLable.text = @"查看更多教练";
        header2.fenlable.hidden = YES;
        header2.moreImgV.hidden = NO;
        [header2.moreBtn addTarget:self action:@selector(moreTeacher2Action:) forControlEvents:UIControlEventTouchUpInside];
        return header2;
    }
    else if (section == 3)
    {
        SchoolDetailHeader *header3 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader3];
        header3.title.text = @"科三教练";
        header3.noCommentLable.hidden = NO;
        header3.noCommentLable.text = @"查看更多教练";
        header3.fenlable.hidden = YES;
        header3.moreImgV.hidden = NO;
        [header3.moreBtn addTarget:self action:@selector(moreTeacher3Action:) forControlEvents:UIControlEventTouchUpInside];
        return header3;
    }
    else
    {
        SchoolDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
        header.moreImgV.hidden = NO;
        //如果没有评价的话，就显示该教练暂无评价
        if ([_schoolArr[0][@"comment"] isKindOfClass:[NSArray class]])
        {
            header.title.text = [NSString stringWithFormat:@"评价(%@)",self.source.commentNums];
            [header.moreBtn addTarget:self action:@selector(moreCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([_schoolArr[0][@"comment"] count] > 0)
        {
            header.moreBtn.hidden=NO;
            header.noCommentLable.hidden = YES;
            header.image1.hidden = NO;
            header.image2.hidden = NO;
            header.image3.hidden = NO;
            header.image4.hidden = NO;
            header.image5.hidden = NO;
            header.fenlable.hidden = NO;
        }
        else
        {
            //显示暂无评价
            header.noCommentLable.hidden = NO;
            header.noCommentLable.text = @"暂无评价";
            header.image1.hidden = YES;
            header.image2.hidden = YES;
            header.image3.hidden = YES;
            header.image4.hidden = YES;
            header.image5.hidden = YES;
            header.fenlable.hidden = YES;
        }
        [header setHeaderWith: _schoolArr[0]];
        return header;
    }
} 

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        if ([_schoolArr[0][@"comment"] count] > 0)
        {
            //添加footer
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
            footerView.backgroundColor = [UIColor whiteColor];
            _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _footerBtn.frame = CGRectMake(0, 0, KScreenWidth/3, 35);
            _footerBtn.center = CGPointMake(KScreenWidth/2, 25);
            _footerBtn.layer.masksToBounds = YES;
            _footerBtn.layer.cornerRadius = 10;
            _footerBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
            _footerBtn.layer.borderWidth = 1;
            _footerBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_footerBtn setTitle:@"查看全部评论" forState:UIControlStateNormal];
            [_footerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_footerBtn addTarget:self action:@selector(footerAction:) forControlEvents:UIControlEventTouchUpInside];
            _footerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [footerView addSubview:_footerBtn];
            self.tableView.tableFooterView = footerView;
        }
    }
    return nil;
}

//点击查看更多科二教练
-(void)moreTeacher2Action:(UIButton *)sender
{
    if ([_schoolArr[0][@"teacher_subject2"] count] == 0)
    {
        [MBProgressHUD showSuccess:@"暂无更多科二教练"];
    }
    else
    {
        CoachViewController *coachVC = [[CoachViewController alloc] init];
        coachVC.cityName = [ZXUD objectForKey:@"city"];
        coachVC.CoachType = @"科目二教练";
        coachVC.subject = @"2";
        coachVC.sid = _sid;
        [self.navigationController pushViewController:coachVC animated:YES];
    }
}

//点击查看更多科三教练
-(void)moreTeacher3Action:(UIButton *)sender
{
    if ([_schoolArr[0][@"teacher_subject3"] count] == 0)
    {
        [MBProgressHUD showSuccess:@"暂无更多科三教练"];
    }
    else
    {
        CoachViewController *coachVC = [[CoachViewController alloc] init];
        coachVC.cityName = [ZXUD objectForKey:@"city"];
        coachVC.CoachType = @"科目三教练";
        coachVC.subject = @"3";
        coachVC.sid = _sid;
        [self.navigationController pushViewController:coachVC animated:YES];
    }
}

//点击查看更多评价
-(void)moreCommentAction:(UIButton *)sender
{
    if ([_schoolArr[0][@"comment"] count] == 0)
   {
       [MBProgressHUD showSuccess:@"暂无更多评价,赶快去评价吧"];
    }
    else
    {
        MoreCommentVC *moreComment_VC = [[MoreCommentVC alloc]init];
        moreComment_VC.sid = _sid;
        [self.navigationController pushViewController:moreComment_VC animated:YES];
    }
}

//section header 高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 0.1;
    }
    else
    {
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    else if (section == 1)
    {
        return 50;
    }
    else if (section == 2)
    {
        return 50;
    }
    else if (section == 3)
    {
        return 50;
    }
    else if (section == 4)
    {
        return 50;
    }
    return 0;
}

#pragma mark -点击驾校图片
-(void)picBtnAction:(UIButton *)sender
{
    if (_tuPianArr.count > 0)
    {
        ZX_JiaoJingShouShi_ViewController *jiaoJingShouShiVC = [[ZX_JiaoJingShouShi_ViewController alloc]init];
        jiaoJingShouShiVC.tupianArr = _tuPianArr;
        jiaoJingShouShiVC.isJiaXiaoTuPian = YES;
        [self.navigationController pushViewController:jiaoJingShouShiVC animated:YES];
    }
    else
    {
        [MBProgressHUD showSuccess:@"此驾校无更多图片"];
    }
}

#pragma mark -点击报名学车
- (void)signUpBtnAction:(UIButton *)sender
{
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        if ([_sid isEqualToString:[ZXUD objectForKey:@"S_ID"]])
        {
            if (![[ZXUD objectForKey:@"S_ID"] isEqualToString:@"0"])
            {
                if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"5"])
                {
                    if ([[ZXUD objectForKey:@"S_C"] isEqualToString:@"1"])
                    {
                        //拿到驾照后去评价
                        ZXEvaluateOrderListVC *vc = [[ZXEvaluateOrderListVC alloc]init];
                        vc.sid=_sid;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                else
                {
                    [MBProgressHUD showSuccess:@"拿到驾照后再去评价吧"];
                }
            }
        }
        else
        {
            [[ZXNetDataManager manager] YuYueStateWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSid:_sid andTid:nil andErid:nil andErpid:nil success:^(NSURLSessionDataTask *task, id responseObject)
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
                 
                 if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
                 {
                     ZXIDVerifyViewController *IDVerifyVC = [[ZXIDVerifyViewController alloc] init];
                     IDVerifyVC.verifyType = verifyTypeJiaXiao;
                     IDVerifyVC.yanZhengMaType = @"2";
                     IDVerifyVC.jiaxiaoID = _sid;
                     [self.navigationController pushViewController:IDVerifyVC animated:YES];
                 }
                 else
                 {
                     [MBProgressHUD showSuccess:jsonDict[@"msg"]];
                 }
             }failed:^(NSURLSessionTask *task, NSError *error)
             {
                 [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
             }];
        }
    }
}
#pragma mark -网络请求
//加载数据
-(void)loadData_schoolDetail{
    
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    [self.view addSubview:_animationView];
    
    
    [[ZXNetDataManager manager] schoolDetailDataWithM:@"school" andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andSid:[NSString stringWithFormat:@"%@",_sid] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *err;
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        YZLog(@"%@",receiveStr);
        _jiaxiao=[[receiveStr componentsSeparatedByString:@"\"content\":\""][1] componentsSeparatedByString:@"\",\r\n\t\t\t\"location\""][0];
        YZLog(@"%@",_jiaxiao);
        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        YZLog(@"%@",receiveStr);
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
        //网络请求成功
        NSString *res = jsonDict[@"res"];
        NSString *msg = jsonDict[@"msg"];
        if ([res isEqualToString:@"1001"])
        {
            //请求成功
            _schoolArr = jsonDict[@"school"];
            //数据转模型
            //给数据源赋值
            self.source = [SchoolDetailModel modelWithDic:_schoolArr[0]];
            //刷表
            [self.tableView reloadData];
        }
        else if ([res isEqualToString:@"1004"])
        {
            //请求过于频繁
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1005"])
        {
            //缺少必选参数
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1006"])
        {
            //排序参数错误
            [MBProgressHUD showError:msg];
        }
        YZLog(@"%@",jsonDict);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
        
    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
    }];
}

-(void)loadDataSchoolImageList
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_images_list",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"sid":self.sid};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        //网络请求成功
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"])
        {
            //请求成功
            //给数据源赋值
            _tuPianArr = [NSMutableArray arrayWithArray:responseObject[@"list"]];
        }
        else if ([res isEqualToString:@"1004"])
        {
            //请求过于频繁
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1005"])
        {
            //缺少必选参数
            [MBProgressHUD showError:msg];
        }
        else if ([res isEqualToString:@"1006"])
        {
            //排序参数错误
            [MBProgressHUD showError:msg];
        }
        YZLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
    }];
}


#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
