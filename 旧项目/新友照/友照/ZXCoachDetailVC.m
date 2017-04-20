//
//  ZXCoachDetailVC.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/4/7.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCoachDetailVC.h"
#import "ZXCoachNameStarImageCell.h"
#import "ZXCoachCalandarCell.h"
#import "ZXCommentTableViewCell.h"
#import "ZXNetDataManager+CoachData.h"
#import "ZXPhoneAndMessageTableViewCell.h"
#import "ZXIDVerifyViewController.h"
//轮播图
#import "SDCycleScrollView.h"
#import "AllCommetTableViewController.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface ZXCoachDetailVC ()<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,SDCycleScrollViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (nonatomic) NSDictionary *dateDic;
@property (nonatomic, copy) NSString *teacher_pic;
@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *Tphone;
@property (nonatomic) NSMutableArray *pinLunArr;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property(strong,nonatomic) ZXCoachCalandarCell *CalandarCell;
@property (strong,nonatomic) FyCalendarView *rili;
@property(strong,nonatomic)NSArray* haha;
@property (nonatomic, strong) NSDate *xindate;
@property(nonatomic)BOOL en;
@property(nonatomic,strong)UIView* xinrili;

@property(nonatomic,strong)NSMutableArray* allDaysArr;
@property (strong, nonatomic) UIButton *yuYueBtn;
@property(nonatomic,strong)NSDictionary* dict;
@property (nonatomic) UIView *VV;
@property (nonatomic, strong)NSMutableArray *titleArr;//存轮播图标题
@property (nonatomic,strong)NSMutableArray *dataSouceImagesURLArr;//存轮播图图片
@property (nonatomic, strong)NSMutableArray *CycleDetailArr;//轮播图详情网址
/*
 _selectDate
 _teacher_classArr
 _classArray
 */
@property (nonatomic, copy) NSString *selectDate;
@property (nonatomic, copy) NSArray *teacher_classArr;
@property (nonatomic, copy) NSArray *classArray;
@property (nonatomic)int flag;

@end

@implementation ZXCoachDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.title = self.name;
    _pinLunArr = [NSMutableArray array];
    self.dataSouceImagesURLArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    
    if (![[ZXUD objectForKey:@"T_ID"] isEqualToString:@"0"] || ![[ZXUD objectForKey:@"T_ID2"] isEqualToString:@"0"] || ![[ZXUD objectForKey:@"T_ID3"] isEqualToString:@"0"])
    {
        //判断科二和科三
        if (_benxiao)
        {
            if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"] && [[ZXUD objectForKey:@"T_ID2"] isEqualToString:@"0"] && _kesan==NO)
            {
                _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50)];
                [self.view addSubview:_tableView];
                _yuYueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
                _yuYueBtn.backgroundColor=dao_hang_lan_Color;
                [_yuYueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"] && [[ZXUD objectForKey:@"T_ID3"] isEqualToString:@"0"] && _kesan==YES)
            {
                _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-50)];
                [self.view addSubview:_tableView];
                _yuYueBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
                _yuYueBtn.backgroundColor=dao_hang_lan_Color;
                [_yuYueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                [self.view addSubview:_tableView];
            }
        }
        else
        {
            _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
            [self.view addSubview:_tableView];
        }
    }
    else
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [self.view addSubview:_tableView];
    }
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.view.backgroundColor = ZX_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCoachNameStarImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZXCoachNameStarImageCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCoachCalandarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZXCoachCalandarCellID2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXCommentTableViewCellID"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXPhoneAndMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getNetData];
    
}

//表视图头部放轮播图
- (void)addLoop
{
    if (self.dataSouceImagesURLArr.count==0) {
        UIImageView* imagev=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 3  / 4)];
        imagev.image=[UIImage imageNamed:@"jiaxiaobg.jpg"];
        self.tableView.tableHeaderView=imagev;
        return ;
    }
     _VV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth * 3  / 4)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenWidth * 3  / 4, KScreenWidth, 1)];
    lab.backgroundColor = ZX_BG_COLOR;
    [self.tableView addSubview:lab];
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:self.VV.bounds delegate:self placeholderImage:nil];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    cycleScrollView2.titlesGroup = self.titleArr;
    cycleScrollView2.currentPageDotColor = [UIColor cyanColor]; //自定义分页控件小圆标颜色
    if (self.dataSouceImagesURLArr.count < 2)
    {
        cycleScrollView2.autoScroll = NO;
    }
    [_VV addSubview:cycleScrollView2];
    cycleScrollView2.autoScrollTimeInterval = 3.0;
    
    //--- 模拟加载延迟
    cycleScrollView2.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = self.dataSouceImagesURLArr;
    });
    self.tableView.tableHeaderView = _VV;
}

#pragma 获取网络数据
- (void)getNetData
{
   if (!_dict)
   {
       _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
       [self.view addSubview:_animationView];
   }
  
    [[ZXNetDataManager manager] JiaoLianDetailWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andTid:self.tid success:^(NSURLSessionDataTask *task, id responseObject)
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
        
    if ([jsonDict[@"res"] isEqualToString:@"1001"])
    {
        _dict=[NSDictionary dictionaryWithDictionary:jsonDict];
        _Tphone = _dict[@"teacher"][0][@"phone"];
        self.classArray = [NSArray arrayWithArray:_dict[@"teacher"][0][@"class"]];
        [self shezhirili];
        self.flag = 1;
        for (NSDictionary *dic in _dict[@"teacher"][0][@"photo"])
        {
            [_dataSouceImagesURLArr addObject:dic[@"photo"]];
        }
        //轮播图
        [self addLoop];
        //获取评论数据
        [self getPinLunData];
    }
    else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
        {
            //让用户重新登录
            [ZXUD setObject:nil forKey:@"ident_code"];
            ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
            [self presentViewController:navi animated:YES completion:nil];
        }];
        [alert addAction:anotherAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
    {
        
    }
    else
    {
        [MBProgressHUD showError:jsonDict[@"msg"]];
    }
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
        
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [_animationView removeFromSuperview];
    }];
    
}
- (void)getPinLunData
{
    for (NSDictionary *dic in _dict[@"teacher"][0][@"comment"])
    {
        [_pinLunArr addObject:dic];
    }
    [self.tableView reloadData];
}


-(void)shezhirili
{
     _xinrili=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
    [self sherili:self.classArray];
    [_CalandarCell.xinrili addSubview:_xinrili];
}

-(void)sherili:(NSArray*)shuzu
{
    //刷新界面
    [self.rili removeFromSuperview];
    //获取当前日期
    self.xindate = [NSDate date];
    //设置位置和大小
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240)];
    self.rili.allDaysArr=[NSMutableArray array];
    self.rili.partDaysArr=[NSMutableArray array];
    //加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rili addGestureRecognizer: self.leftSwipeGestureRecognizer];
    [self.rili addGestureRecognizer: self.rightSwipeGestureRecognizer];
    //对日期进行判断
    for (int i = 0; i<self.classArray.count; i++)
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-d"];
        NSDate* inputDate = [inputFormatter dateFromString:self.classArray[i][@"day"]];
        int total = [self.classArray[i][@"total_num"] intValue];
        int real = [self.classArray[i][@"real_num"] intValue];
        if (real < total)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString* str=[formatter stringFromDate:inputDate];
            NSString* str2=[formatter stringFromDate:self.xindate];
            if([str isEqualToString:str2])
            {
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.allDaysArr addObject:str];
            }
        }
        else if(real == total)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString* str=[formatter stringFromDate:inputDate];
            NSString* str2=[formatter stringFromDate:self.xindate];
            if([str isEqualToString:str2])
            {
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.partDaysArr addObject:str];
            }
        }
    }
    self.rili.partDaysArr =nil;
    self.rili.panduan=YES;
    self.rili.leftBtn.alpha=0.3;
    self.rili.leftBtn.userInteractionEnabled=NO;
    self.xinrili.backgroundColor=[UIColor whiteColor];
    [self.xinrili addSubview:self.rili];
    self.rili.date = [NSDate date];
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
    };
    WS(weakSelf)
    self.rili.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.rili.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

//手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && !_en) {
        [self setupNextMonth];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight && _en) {
        [self setupLastMonth];
        
    }
}

//新日历下一月
- (void)setupNextMonth
{
    self.xindate = [self.rili nextMonth:self.xindate];
    self.rili.date=self.xindate;
    _en=YES;
    [self xinrilishuaxin];
}

//新日历上一月
- (void)setupLastMonth
{
    self.xindate = [self.rili lastMonth:self.xindate];
    self.rili.date=self.xindate;
    _en=NO;
    [self xinrilishuaxin];
}
-(void)panduanriqi
{
    for (int i = 0; i<self.classArray.count; i++)
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-d"];
        NSDate* inputDate = [inputFormatter dateFromString:self.classArray[i][@"day"]];
        int total = [self.classArray[i][@"total_num"] intValue];
        int real = [self.classArray[i][@"real_num"] intValue];
        if (real < total)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"MM"];
            NSString* str=[formatter stringFromDate:self.xindate];
            NSString* str2=[formatter stringFromDate:inputDate];
            if([str isEqualToString:str2])
            {
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                if (!self.rili.allDaysArr)
                {
                    self.rili.allDaysArr =[NSMutableArray array];
                }
                [self.rili.allDaysArr addObject:str];
            }
        }
    }
}

//新日历刷新
-(void)xinrilishuaxin
{
    //刷新界面
    [self.rili.allDaysArr removeAllObjects];
    [self.rili removeFromSuperview];
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.xinrili.frame.size.height)];
    //加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rili addGestureRecognizer: self.leftSwipeGestureRecognizer];
    [self.rili addGestureRecognizer: self.rightSwipeGestureRecognizer];
    [self panduanriqi];
    [self.xinrili addSubview:self.rili];
    self.rili.panduan=YES;
    
    if (!_en)
    {
        self.rili.leftBtn.alpha=0.3;
        self.rili.leftBtn.userInteractionEnabled=NO;
    }
    else
    {
        self.rili.rightBtn.alpha=0.3;
        self.rili.rightBtn.userInteractionEnabled=NO;
    }
    //日期状态
    [self.rili createCalendarViewWith:self.xindate];
    self.rili.date=self.xindate;
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
    };
    WS(weakSelf)
    self.rili.lastMonthBlock = ^()
    {
        [weakSelf setupLastMonth];
    };
    self.rili.nextMonthBlock = ^()
    {
        [weakSelf setupNextMonth];
    };
}
#pragma mark - tableViewDelegata
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        if (_pinLunArr.count == 0)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.flag == 1)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ZXCoachNameStarImageCell *nameStarImageCell = [tableView dequeueReusableCellWithIdentifier:@"ZXCoachNameStarImageCellID"];
        nameStarImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.title = _dict[@"teacher"][0][@"name"];
        [nameStarImageCell setCellWith: _dict[@"teacher"][0]];
        return nameStarImageCell;
    }
    else if(indexPath.section ==1)
    {
        ZXPhoneAndMessageTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return Cell;
    }
    else if(indexPath.section ==2)
    {
        ZXCoachCalandarCell *CalandarCell = [tableView dequeueReusableCellWithIdentifier:@"ZXCoachCalandarCellID2"];
        CalandarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [CalandarCell.xinrili addSubview: _xinrili];
        //如果没有评价的话，就显示该教练暂无评价
        if ([_pinLunArr isKindOfClass:[NSArray class]])
        {
            CalandarCell.zanwupingjia.text = [NSString stringWithFormat:@"评价(%@)",_dict[@"teacher"][0][@"commentnum"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PushMorePinLunVC)];
            CalandarCell.userInteractionEnabled = YES;
            [CalandarCell.commentBGV addGestureRecognizer:tap];
        }
        if (_pinLunArr.count > 0)
        {
             CalandarCell.noCommentLable.hidden = YES;
             CalandarCell.image1.hidden = NO;
             CalandarCell.image2.hidden = NO;
             CalandarCell.image3.hidden = NO;
             CalandarCell.image4.hidden = NO;
             CalandarCell.image5.hidden = NO;
             CalandarCell.fenlable.hidden = NO;
        }
        else
        {
            //显示暂无评价
            CalandarCell.noCommentLable.hidden = NO;
            CalandarCell.noCommentLable.text = @"暂无评价";
            CalandarCell.image1.hidden = YES;
            CalandarCell.image2.hidden = YES;
            CalandarCell.image3.hidden = YES;
            CalandarCell.image4.hidden = YES;
            CalandarCell.image5.hidden = YES;
            CalandarCell.fenlable.hidden = YES;
        }
        [CalandarCell setCellWith: _dict[@"teacher"][0]];
        return CalandarCell;
    }
    else
    {
        ZXCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentTableViewCellID"];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = _pinLunArr[indexPath.row];
        [commentCell resetContentLabelFrame:dic];
        [commentCell setUpCellWith:dic];
        return commentCell;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *footer = [[UIView alloc]init];
        footer.backgroundColor = ZX_BG_COLOR;
        return footer;
    }
    else if (section == 1)
    {
        UIView *footer = [[UIView alloc]init];
        footer.backgroundColor = ZX_BG_COLOR;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 50)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.textColor = [UIColor blackColor];
        lab.text = @"教练排课";
        lab.textAlignment = NSTextAlignmentCenter;
        [footer addSubview:lab];
        return footer;
    }
    else if (section == 3)
    {
        if (_pinLunArr.count > 0)
        {
            UIView *footer = [[UIView alloc]init];
            footer.backgroundColor = [UIColor whiteColor];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((KScreenWidth - 120)/2, 15, 120, 30);
            [btn setTitle:@"查看全部评价" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
            [btn setTitleColor:ZX_DarkGray_Color forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
            [btn addTarget:self action:@selector(PushMorePinLunVC) forControlEvents:UIControlEventTouchUpInside];
            [footer addSubview:btn];
            return footer;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
//进入全部评论
- (void)PushMorePinLunVC
{
    if (_pinLunArr.count == 0)
    {
        [MBProgressHUD showSuccess:@"暂无更多评价，赶快去评价吧"];
    }
    else
    {
        AllCommetTableViewController *VC = [[AllCommetTableViewController alloc]init];
        VC.tid = self.tid;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1)
    {
        return 60;
    }else if (section == 3){
        if (_pinLunArr.count > 0) {
            return 60;
        }else {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}
//返回不同cell高度，indexPath.row = 2 是日历的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (KScreenWidth / 4 + 40) * 2;
    }
    else if(indexPath.section == 1)
    {
        return 60;
    }
    else if(indexPath.section == 2)
    {
        return 350;
    }
    else
    {
        NSDictionary *dic = _pinLunArr[indexPath.row];
        return [ZXCommentTableViewCell calculateContentHeight:dic];
    }
}
//电话咨询
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if ([_Tphone isEqualToString:@""])
        {
            return;
        }
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_Tphone]]])
        {
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_Tphone]]];
    }
}

//预约教练
- (void)yuyueAction:(id)sender
{
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"0"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"1"])
        {
            [MBProgressHUD showSuccess:@"您现在还不能预约教练"];
        }
        else if ([[ZXUD objectForKey:@"usersubject"] isEqualToString:@"2"] || [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"])
        {
            [self yuYueJiaoLianData];
        }
    }
}

- (void)yuYueJiaoLianData
{
    [MBProgressHUD showMessage:@"正在预约..."];
    _yuYueBtn.userInteractionEnabled = NO;
    [[ZXNetDataManager manager]YuYueStateWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSid:@"" andTid:_tid andErid:@"" andErpid:@"" success:^(NSURLSessionDataTask *task, id responseObject)
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
        [MBProgressHUD hideHUD];
        if ([jsonDict[@"res"] isEqualToString:@"1001"])
        {
            ZXIDVerifyViewController *idVerifyVC = [[ZXIDVerifyViewController alloc] init];
            idVerifyVC.verifyType = verifyTypeJiaoLian;
            idVerifyVC.yanZhengMaType = @"3";
            idVerifyVC.teacher_pic = _teacher_pic;
            idVerifyVC.teacher_name = _teacher_name;
            //把教练的id传过去
            idVerifyVC.jiaolianID = _tid;
            [self.navigationController pushViewController:idVerifyVC animated:YES];
            _yuYueBtn.userInteractionEnabled = YES;
        }
        else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                            {
                                                //让用户重新登录
                                                [ZXUD setObject:nil forKey:@"ident_code"];
                                                ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                                                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                                                [self presentViewController:navi animated:YES completion:nil];
                                            }];
            [alert addAction:anotherAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
        {
            
        }
        else
        {
            [MBProgressHUD showError:jsonDict[@"msg"]];
            
        }
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

@end
