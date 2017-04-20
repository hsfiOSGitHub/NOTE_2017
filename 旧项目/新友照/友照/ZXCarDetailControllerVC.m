//
//  ZXCarDetailControllerVC.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCarDetailControllerVC.h"
#import "ZXCarDetailTableViewCell1.h"
#import "ZXCarDetailTableViewCell2.h"
#import "ZXCarDetailTableViewCell3.h"
#import "ZXCarDetailTableViewCell4.h"
#import "ZXCarDetailTableViewCell5.h"
#import "ZXBuyNotesCell.h"
#import "ZXDateTableViewCell.h"

//提交订单
#import "ZX_TiJiaoDingDan_ViewController.h"


@interface ZXCarDetailControllerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *str;//当前上下的剩余的数量
//购买数量显示的label
@property (nonatomic, strong) UILabel *number;
//购买数量
@property (nonatomic, assign) int numOfbuy;
@property(nonatomic) BOOL on;
@property(nonatomic) BOOL suiyi;
@property(nonatomic) BOOL manjian;       //是否有活动
@property(nonatomic) NSInteger manji;    //满几
@property(nonatomic) NSInteger songji;   //送几
@property(nonatomic,strong) UITableView* tableView;//
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic) UIImageView *VV;
@property (nonatomic) UILabel *label;
//创建9个按钮指针指向cell上对应的按钮
@property (nonatomic, strong) UIButton* btno;
@property (nonatomic, strong) UIButton* btnt;
@property (nonatomic, strong) UIButton* btn1;
@property (nonatomic, strong) UIButton* btn2;
@property (nonatomic, strong) UIButton* btn3;
@property (nonatomic, strong) UIButton* btn4;
@property (nonatomic, strong) UIButton* btn5;
@property (nonatomic, strong) UIButton* btn6;
@property (nonatomic, strong) UIButton* btn7;
//车辆详情
@property(nonatomic,strong) NSDictionary* keSanDetailModel;
@property(nonatomic,strong) NSDictionary* infoModel;
@property(nonatomic,strong) NSArray* jiage;
@property(nonatomic)BOOL isshuaxin;

@property(nonatomic,strong)NSArray* similateModel;
//创建5个label指针指向cell里的label
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *lab3;
@property (nonatomic, strong) UILabel *lab4;
@property (nonatomic, strong) UILabel *lab5;
@property (nonatomic, strong) UILabel *lab6;
//上午和下午的产品id、forms、nubmerOfBuys、price
@property (nonatomic, copy) NSString *ShangWuChanPinID;
@property (nonatomic, copy) NSString *XiaWuChanPinID;
//科三模拟详情列表里的产品id
@property (nonatomic, copy) NSString *chanPinID;
@property (nonatomic) NSInteger shangWuNumberOfBuys;
@property (nonatomic) NSInteger xiaWuNumberOfBuys;
@property (nonatomic, copy) NSString *shangWuPrice;
@property (nonatomic, copy) NSString *XiaWuPrice;
@property(nonatomic,strong)NSString* cid;
//确定点击的是某一天
@property(nonatomic) NSInteger dijitian;
@property (nonatomic) BOOL isclick;
@property (nonatomic) BOOL ishaha;
//新增(新改变了接口需要改变一下参数)
@property (nonatomic, copy) NSString *erid;
@property (nonatomic, copy) NSString *date;
//判断上下午
@property (nonatomic) BOOL issw;
@property (nonatomic) NSInteger zhouji;

@end

@implementation ZXCarDetailControllerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self tab];
    [self getData];
    self.title = @"车辆详情";
    self.numOfbuy = 1;
}

-(void)tab
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    //注册CELL
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCarDetailTableViewCell1" bundle:nil] forCellReuseIdentifier:@"ZXCarDetailTableViewCell1ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCarDetailTableViewCell2" bundle:nil] forCellReuseIdentifier:@"ZXCarDetailTableViewCell2ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCarDetailTableViewCell3" bundle:nil] forCellReuseIdentifier:@"ZXCarDetailTableViewCell3ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCarDetailTableViewCell4" bundle:nil] forCellReuseIdentifier:@"ZXCarDetailTableViewCell4ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCarDetailTableViewCell5" bundle:nil] forCellReuseIdentifier:@"ZXCarDetailTableViewCell5ID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXBuyNotesCell" bundle:nil] forCellReuseIdentifier:@"Buy"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"date"];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _VV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight / 3)];
    //车牌号的label
    UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(0, _VV.bounds.size.height - 44, KScreenWidth, 44)];
    lab.alpha = 0.8;
    lab.backgroundColor=[UIColor grayColor];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, _VV.bounds.size.height - 44, KScreenWidth, 44)];
    [_label setTextColor:[UIColor whiteColor]];
    _label.textColor=[UIColor whiteColor];
    _op = @"submit";
    _label.textAlignment = NSTextAlignmentCenter;
    [_VV addSubview:lab];
    [_VV addSubview:_label];
    self.tableView.tableHeaderView = _VV;
    _dataSource = [NSMutableArray array];
    [self.view addSubview:_tableView];
}

//请求科三数据
- (void)getData
{
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];

    [[ZXNetDataManager manager] KeSanMoNiDetailWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andID:self.kid andWeeked:_week andIdent_code:[ZXUD objectForKey:@"ident_code"] andOP:self.op  success:^(NSURLSessionDataTask *task, id responseObject)
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
            _keSanDetailModel = jsonDict ;
            _infoModel = _keSanDetailModel[@"info"];
            _jiage = _infoModel[@"simulate"];
            [_VV sd_setImageWithURL:[NSURL URLWithString:_infoModel[@"pic"]] placeholderImage:[UIImage imageNamed:@"科三汽车.jpg"]];
            _label.text = [NSString stringWithFormat:@"车牌号：%@",_infoModel[@"code"]];
            [self.tableView reloadData];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
        
    }failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
        YZLog(@"错误");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 8;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        return (KScreenWidth - 80) / 7 * 4;
    }
    else if (indexPath.section == 1 && indexPath.row == 7)
    {
        return 220;
    }
    else if (indexPath.row==4)
    {
        if (_ersan)
        {
            return 0;
        }
        else
        {
            return 60;
        }
    }
    else
    {
        if (indexPath.section==0)
        {
              return 80;
        }
        else
        {
              return 60;
        }
    }
}


- (void)setDateUI
{
    //日期按钮的颜色
    if (![_infoModel[@"simulate"][0][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][1][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][2][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][3][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][4][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][5][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn6 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn6 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
    if (![_infoModel[@"simulate"][6][@"list"] isKindOfClass:[NSArray class]])
    {
        [_btn7 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn7 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0)
    {
        //多少钱一圈
        ZXCarDetailTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCarDetailTableViewCell1ID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        //原价，现价
        YZLog(@"%@",self.lab6.text);

        if (self.lab6)
        {
            cell.youhui.text=self.lab6.text;
        }
        if(self.lab1)
        {
            cell.oldPriceLabel.text=self.lab1.text;
        }
        if (self.lab2)
        {
            cell.PriceLabel.text=self.lab2.text;
        }
        else
        {
            [cell setUpCellWith:_jiage];
        }
        self.lab6 = cell.youhui;
        self.lab1 = cell.oldPriceLabel;
        self.lab2 = cell.PriceLabel;
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            ZXDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"date" forIndexPath:indexPath];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            ZXCarDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCarDetailTableViewCell2ID" forIndexPath:indexPath];
            cell.btn1.layer.cornerRadius  = 6;
            cell.btn1.layer.masksToBounds = YES;
            cell.btn2.layer.cornerRadius  = 6;
            cell.btn2.layer.masksToBounds = YES;
            self.btn1 = cell.firstDayBtn;
            self.btn2 = cell.secDayBtn;
            self.btn3 = cell.thrsrDayBtn;
            self.btn4 = cell.fouDayBtn;
            self.btn5 = cell.fivDayBtn;
            self.btn6 = cell.sixDayBtn;
            self.btn7 = cell.sevDayBtn;
            //日期按钮的颜色
            if (![_infoModel[@"simulate"][0][@"list"] isKindOfClass:[NSArray class]])
            {
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
                [cell.firstDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [cell.firstDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.firstDayBtn.tag  = 1;
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            
            if (![_infoModel[@"simulate"][1][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.secDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                [_btn2 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.secDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.secDayBtn.tag = 2;
                [_btn2 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            
            if (![_infoModel[@"simulate"][2][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.thrsrDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                [_btn3 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.thrsrDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.thrsrDayBtn.tag  = 3;
                [_btn3 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            
            if (![_infoModel[@"simulate"][3][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.fouDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                [_btn4 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.fouDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.fouDayBtn.tag = 4;
                [_btn4 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            if (![_infoModel[@"simulate"][4][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.fivDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                
                [_btn5 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.fivDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                cell.fivDayBtn.tag = 5;
                [_btn5 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            if (![_infoModel[@"simulate"][5][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.sixDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                [_btn6 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.sixDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                cell.sixDayBtn.tag = 6;
                [_btn6 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
            }
            if (![_infoModel[@"simulate"][6][@"list"] isKindOfClass:[NSArray class]])
            {
                [cell.sevDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                [_btn7 setBackgroundImage:[UIImage imageNamed:@"ic_man"] forState:UIControlStateNormal];
            }
            else
            {
                [_btn7 setBackgroundImage:[UIImage imageNamed:@"ic_yue"] forState:UIControlStateNormal];
                [cell.sevDayBtn addTarget:self action:@selector(kesandianjishijian:) forControlEvents:UIControlEventTouchUpInside];
                cell.sevDayBtn.tag = 7;
            }
            
            [cell.btn1 addTarget:self action:@selector(getDataSource:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn1.tag = 3333;
            self.btno=cell.btn1;
            
            [cell.btn2 addTarget:self action:@selector(getDataSource:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn2.tag = 4444;
            self.btnt=cell.btn2;
            if (!_isshuaxin)
            {
                
                NSDate* datenow=[NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval2 = [zone secondsFromGMTForDate: datenow];
                NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval2];
                
                //先判断那天有课
                for(int i=0;i<((NSArray*)_infoModel[@"simulate"]).count;i++)
                {
                    //有一个元素有可能是上午或者是下午,有两个元素的话说明上下午都有课，还是只用取出上午的就可以了。
                    if ([_infoModel[@"simulate"][i][@"list"]isKindOfClass:[NSArray class]])
                    {
                        //看看有几个元素
                        if (((NSArray*)_infoModel[@"simulate"][i][@"list"]).count==1)
                        {
                            //判断是上午还是下午
                            //实例化一、NSDateFormatter对象
                            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                            //设定时间格式,这里可以设置成自己需要的格式
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSArray* arr=[_infoModel[@"simulate"][i][@"list"][0][@"start_time"] componentsSeparatedByString:@" "];
                            NSDate *date =[dateFormat dateFromString:_infoModel[@"simulate"][i][@"list"][0][@"start_time"]];
                            NSDate *date2 =[dateFormat dateFromString:[NSString stringWithFormat:@"%@ 12:00:00",arr[0]]];
                            NSInteger interval345 = [zone secondsFromGMTForDate: date];
                            date=[date  dateByAddingTimeInterval: interval345];
                            NSInteger interval = [zone secondsFromGMTForDate: date2];
                            date2= [date2  dateByAddingTimeInterval: interval];
                            NSComparisonResult result=[date compare:date2];
                            //如果是上午的话就判断现在是否已经过了上午，如果没有过上午的话就选中上午，如果过了上午就选下午，如果没有下午就选明天
                            //下午
                            if(result!=NSOrderedAscending)
                            {
                                _on=NO;
                                //看看下午过期没
                                NSDate *date4 =[dateFormat dateFromString:_infoModel[@"simulate"][i][@"list"][0][@"end_time"]];
                                NSInteger interval4 = [zone secondsFromGMTForDate: date4];
                                date4= [date4  dateByAddingTimeInterval: interval4];
                                NSComparisonResult result4=[localeDate compare:date4];
                                //没过期，选下午,过期的话就不用管直接循环下一次
                                if(result4 == NSOrderedAscending)
                                {
                                    self.isclick=YES;
                                    _issw=YES;
                                    //设置下午的颜色
                                    _on=NO;
                                    _similateModel=_infoModel[@"simulate"][i][@"list"];
                                    [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                    _shangWuPrice=_infoModel[@"simulate"][i][@"list"][0][@"price"];
                                    [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _btnt.hidden=NO;
                                    //设置下午的时间
                                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][i][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][i][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                    //设置优惠活动
                                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"old_price"]];
                                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"price"]];
                                    if ([_infoModel[@"simulate"][i][@"list"][0][@"discount"] isEqualToString:@"1"])
                                    {
                                        _manjian=YES;
                                        self.manji = [_infoModel[@"simulate"][i][@"list"][0][@"times1"] integerValue];
                                        self.songji = [_infoModel[@"simulate"][i][@"list"][0][@"times2"] integerValue];
                                        self.lab6.text = [NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][i][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                    }
                                    else
                                    {
                                        self.manji = 0;
                                        self.songji = 0;
                                        _manjian = NO;
                                        self.lab6.text = @"无";
                                    }
                                    YZLog(@"%@",self.lab6.text);
                                    YZLog(@"%@",self.lab1.text);
                                    YZLog(@"%@",self.lab2.text);
                                    //设置付款信息
                                    self.ShangWuChanPinID = _infoModel[@"simulate"][i][@"list"][0][@"id"];
                                    self.shangWuPrice = _infoModel[@"simulate"][i][@"list"][0][@"price"];
                                    //设置天数的颜色
                                    [self riqibeijing:i];
                                    break;
                                }
                            }
                            //上午
                            else
                            {
                                NSDate *date26 =[dateFormat dateFromString:_infoModel[@"simulate"][i][@"list"][0][@"end_time"]];
                                NSInteger interval = [zone secondsFromGMTForDate: date26];
                                date26= [date26  dateByAddingTimeInterval: interval];
                                NSComparisonResult result2=[localeDate compare:date26];
                                //已过期的话就下一天看看下午有没有，有的话就选下午。
                                if(result2==NSOrderedAscending)
                                {
                                    YZLog(@"上午没过期");
                                    _dijitian=i;
                                    self.isclick=YES;
                                    //设置上午的时间
                                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][i][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][i][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                    //设置上午的颜色
                                    _on=NO;
                                    _btno.hidden=NO;
                                    _similateModel=_infoModel[@"simulate"][i][@"list"];
                                    
                                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    //设置付款信息
                                    self.ShangWuChanPinID = _infoModel[@"simulate"][i][@"list"][0][@"id"];
                                    self.shangWuPrice = _infoModel[@"simulate"][i][@"list"][0][@"price"];
                                    //设置优惠活动
                                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"old_price"]];
                                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"price"]];
                                    if ([_infoModel[@"simulate"][i][@"list"][0][@"discount"] isEqualToString:@"1"])
                                    {
                                        _manjian=YES;
                                        self.manji=[_infoModel[@"simulate"][i][@"list"][0][@"times1"] integerValue];
                                        self.songji=[_infoModel[@"simulate"][i][@"list"][0][@"times2"] integerValue];
                                        self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][i][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                    }
                                    else
                                    {
                                        self.manji=0;
                                        self.songji=0;
                                        _manjian=NO;
                                        self.lab6.text=@"无";
                                    }
                                    YZLog(@"%@",self.lab6.text);
                                    YZLog(@"%@",self.lab1.text);
                                    YZLog(@"%@",self.lab2.text);
                                    //设置天数的颜色
                                    [self riqibeijing:i];
                                    YZLog(@"上午没有过期");
                                    break;
                                }
                            }
                        }
                        else
                        {
                            //先判断上午有没有课
                            //实例化一、、NSDateFormatter对象
                            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                            //设定时间格式,这里可以设置成自己需要的格式
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSDate *date2 =[dateFormat dateFromString:_infoModel[@"simulate"][i][@"list"][0][@"end_time"]];
                            NSInteger interval = [zone secondsFromGMTForDate: date2];
                            date2= [date2  dateByAddingTimeInterval: interval];
                            NSComparisonResult result=[localeDate compare:date2];
                            //如果是上午的话就判断现在是否已经过了上午，如果没有过上午的话就选中上午，如果过了上午就选下午，如果没有下午就选明天
                            //下午
                            if(result!=NSOrderedAscending)
                            {
                                //看看下午过期没
                                NSDate *date4 =[dateFormat dateFromString:_infoModel[@"simulate"][i][@"list"][1][@"end_time"]];
                                NSInteger interval4 = [zone secondsFromGMTForDate: date4];
                                date4= [date4  dateByAddingTimeInterval: interval4];
                                NSComparisonResult result4=[localeDate compare:date4];
                                //没过期，选下午,过期的话就不用管直接循环下一次
                                if(result4==NSOrderedAscending)
                                {
                                    self.isclick=YES;
                                    _issw=YES;
                                    //设置下午的颜色
                                    _on=YES;
                                    _similateModel=_infoModel[@"simulate"][i][@"list"];
                                    [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                    _shangWuPrice=_infoModel[@"simulate"][i][@"list"][1][@"price"];
                                    [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _btnt.hidden=NO;
                                    //设置下午的时间
                                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][i][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][i][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                    //设置优惠活动
                                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][i][@"list"][1][@"old_price"]];
                                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][i][@"list"][1][@"price"]];
                                    if ([_infoModel[@"simulate"][i][@"list"][1][@"discount"] isEqualToString:@"1"])
                                    {
                                        _manjian=YES;
                                        self.manji=[_infoModel[@"simulate"][i][@"list"][1][@"times1"] integerValue];
                                        self.songji=[_infoModel[@"simulate"][i][@"list"][1][@"times2"] integerValue];
                                        self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][i][@"list"][1][@"times1"],_similateModel[1][@"times2"]];
                                    }
                                    else
                                    {
                                        self.manji=0;
                                        self.songji=0;
                                        _manjian=NO;
                                        self.lab6.text=@"无";
                                    }
                                    //设置付款信息
                                    self.XiaWuChanPinID = _infoModel[@"simulate"][i][@"list"][1][@"id"];
                                    self.XiaWuPrice = _infoModel[@"simulate"][i][@"list"][1][@"price"];
                                    self.lab1.text=_infoModel[@"simulate"][i][@"list"][1][@"price"];
                                    YZLog(@"%@",self.lab6.text);
                                    YZLog(@"%@",self.lab1.text);
                                    YZLog(@"%@",self.lab2.text);
                                    //设置天数的颜色
                                    [self riqibeijing:i];
                                    break;
                                }
                            }
                            //上午
                            else
                            {
                                _dijitian=i;
                                self.isclick=YES;
                                //设置上午的时间
                                [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][i][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][i][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                _similateModel=_infoModel[@"simulate"][i][@"list"];
                                //设置上午的颜色
                                _on=NO;
                                _btno.hidden=NO;
                                [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                self.ShangWuChanPinID = _infoModel[@"simulate"][i][@"list"][0][@"id"];
                                self.shangWuPrice = _infoModel[@"simulate"][i][@"list"][0][@"price"];
                                //设置优惠活动
                                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"old_price"]];
                                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][i][@"list"][0][@"price"]];
                                if ([_infoModel[@"simulate"][i][@"list"][0][@"discount"] isEqualToString:@"1"])
                                {
                                    _manjian=YES;
                                    self.manji=[_infoModel[@"simulate"][i][@"list"][0][@"times1"] integerValue];
                                    self.songji=[_infoModel[@"simulate"][i][@"list"][0][@"times2"] integerValue];
                                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][i][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                }
                                else
                                {
                                    self.manji=0;
                                    self.songji=0;
                                    _manjian=NO;
                                    self.lab6.text=@"无";
                                }
                                YZLog(@"%@",self.lab6.text);
                                YZLog(@"%@",self.lab1.text);
                                YZLog(@"%@",self.lab2.text);
                                //设置天数的颜色
                                [self riqibeijing:i];
                                YZLog(@"上午没有过期");
                                _btnt.hidden=NO;
                                //设置下午的时间
                                [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][i][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][i][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                [_btnt setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
                                
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                //日期按钮的颜色
                [self riqibeijing:_dijitian];
                NSDate* datenow=[NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval2 = [zone secondsFromGMTForDate: datenow];
                NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval2];
                    //有一个元素有可能是上午或者是下午,有两个元素的话说明上下午都有课，还是只用取出上午的就可以了。
                    if ([_infoModel[@"simulate"][_dijitian][@"list"]isKindOfClass:[NSArray class]])
                    {
                        //看看有几个元素
                        if (((NSArray*)_infoModel[@"simulate"][_dijitian][@"list"]).count==1)
                        {
                            //判断是上午还是下午
                            //实例化一、NSDateFormatter对象
                            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                            //设定时间格式,这里可以设置成自己需要的格式
                            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSArray* arr=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"start_time"] componentsSeparatedByString:@" "];
                            NSDate *date =[dateFormat dateFromString:_infoModel[@"simulate"][_dijitian][@"list"][0][@"start_time"]];
                            NSDate *date2 =[dateFormat dateFromString:[NSString stringWithFormat:@"%@ 12:00:00",arr[0]]];
                            NSInteger interval345 = [zone secondsFromGMTForDate: date];
                            date=[date  dateByAddingTimeInterval: interval345];
                            NSInteger interval = [zone secondsFromGMTForDate: date2];
                            date2= [date2  dateByAddingTimeInterval: interval];
                            NSComparisonResult result=[date compare:date2];
                            //如果是上午的话就判断现在是否已经过了上午，如果没有过上午的话就选中上午，如果过了上午就选下午，如果没有下午就选明天
                            //下午
                            if(result!=NSOrderedAscending)
                            {
                                _on=NO;
                                //看看下午过期没
                                NSDate *date4 =[dateFormat dateFromString:_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"]];
                                NSInteger interval4 = [zone secondsFromGMTForDate: date4];
                                date4= [date4  dateByAddingTimeInterval: interval4];
                                NSComparisonResult result4=[localeDate compare:date4];
                                //没过期，选下午,过期的话就不用管直接循环下一次
                                if(result4==NSOrderedAscending)
                                {
                                    self.isclick=YES;
                                    _issw=YES;
                                    //设置下午的颜色
                                    _on=NO;
                                    _similateModel=_infoModel[@"simulate"][_dijitian][@"list"];
                                    [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                    _shangWuPrice=_infoModel[@"simulate"][_dijitian][@"list"][0][@"price"];
                                    [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    _btnt.hidden=NO;
                                    //设置下午的时间
                                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][_dijitian][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                    //设置优惠活动
                                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"old_price"]];
                                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"price"]];
                                    if ([_infoModel[@"simulate"][_dijitian][@"list"][0][@"discount"] isEqualToString:@"1"])
                                    {
                                        _manjian=YES;
                                        self.manji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"] integerValue];
                                        self.songji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times2"] integerValue];
                                        self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                    }
                                    else
                                    {
                                        self.manji=0;
                                        self.songji=0;
                                        _manjian=NO;
                                        self.lab6.text=@"无";
                                    }
                                    //设置付款信息
                                    self.ShangWuChanPinID = _infoModel[@"simulate"][_dijitian][@"list"][0][@"id"];
                                    self.shangWuPrice = _infoModel[@"simulate"][_dijitian][@"list"][0][@"price"];
                                    YZLog(@"%@",self.lab6.text);
                                    YZLog(@"%@",self.lab1.text);
                                    YZLog(@"%@",self.lab2.text);
                                }
                            }
                            //上午
                            else
                            {
                                NSDate *date26 =[dateFormat dateFromString:_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"]];
                                NSInteger interval = [zone secondsFromGMTForDate: date26];
                                date26= [date26  dateByAddingTimeInterval: interval];
                                NSComparisonResult result2=[localeDate compare:date26];
                                //已过期的话就下一天看看下午有没有，有的话就选下午。
                                if(result2==NSOrderedAscending)
                                {
                                    YZLog(@"上午没过期");
                                    self.isclick=YES;
                                    //设置上午的时间
                                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][_dijitian][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                    //设置上午的颜色
                                    _on=NO;
                                    _btno.hidden=NO;
                                    _similateModel=_infoModel[@"simulate"][_dijitian][@"list"];
                                    
                                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                    //设置付款信息
                                    self.ShangWuChanPinID = _infoModel[@"simulate"][_dijitian][@"list"][0][@"id"];
                                    self.shangWuPrice = _infoModel[@"simulate"][_dijitian][@"list"][0][@"price"];
                                    //设置优惠活动
                                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"old_price"]];
                                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"price"]];
                                    if ([_infoModel[@"simulate"][_dijitian][@"list"][0][@"discount"] isEqualToString:@"1"])
                                    {
                                        _manjian=YES;
                                        self.manji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"] integerValue];
                                        self.songji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times2"] integerValue];
                                        self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                    }
                                    else
                                    {
                                        self.manji=0;
                                        self.songji=0;
                                        _manjian=NO;
                                        self.lab6.text=@"无";
                                    }
                                    YZLog(@"%@",self.lab6.text);
                                    YZLog(@"%@",self.lab1.text);
                                    YZLog(@"%@",self.lab2.text);
                                }
                            }
                        }
                        else
                        {
                            if (_on)
                            {
                                //先判断上午有没有课
                                //实例化一、、NSDateFormatter对象
                                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                                //设定时间格式,这里可以设置成自己需要的格式
                                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                NSDate *date2 =[dateFormat dateFromString:_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"]];
                                NSInteger interval = [zone secondsFromGMTForDate: date2];
                                date2= [date2  dateByAddingTimeInterval: interval];
                                NSComparisonResult result=[localeDate compare:date2];
                                //如果是上午的话就判断现在是否已经过了上午，如果没有过上午的话就选中上午，如果过了上午就选下午，如果没有下午就选明天
                                //下午
                                if(result!=NSOrderedAscending)
                                {
                                    //看看下午过期没
                                    NSDate *date4 =[dateFormat dateFromString:_infoModel[@"simulate"][_dijitian][@"list"][1][@"end_time"]];
                                    NSInteger interval4 = [zone secondsFromGMTForDate: date4];
                                    date4= [date4  dateByAddingTimeInterval: interval4];
                                    NSComparisonResult result4=[localeDate compare:date4];
                                    //没过期，选下午,过期的话就不用管直接循环下一次
                                    if(result4==NSOrderedAscending)
                                    {
                                        self.isclick=YES;
                                        _issw=YES;
                                        //设置下午的颜色
                                        _on=YES;
                                        _similateModel=_infoModel[@"simulate"][_dijitian][@"list"];
                                        [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                        _shangWuPrice=_infoModel[@"simulate"][_dijitian][@"list"][1][@"price"];
                                        [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                        _btnt.hidden=NO;
                                        //设置下午的时间
                                        [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][_dijitian][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][_dijitian][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                        //设置优惠活动
                                        self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][1][@"old_price"]];
                                        self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][1][@"price"]];
                                        if ([_infoModel[@"simulate"][_dijitian][@"list"][1][@"discount"] isEqualToString:@"1"])
                                        {
                                            _manjian=YES;
                                            self.manji=[_infoModel[@"simulate"][_dijitian][@"list"][1][@"times1"] integerValue];
                                            self.songji=[_infoModel[@"simulate"][_dijitian][@"list"][1][@"times2"] integerValue];
                                            self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][_dijitian][@"list"][1][@"times1"],_similateModel[1][@"times2"]];
                                        }
                                        else
                                        {
                                            self.manji=0;
                                            self.songji=0;
                                            _manjian=NO;
                                            self.lab6.text=@"无";
                                        }
                                        //设置付款信息
                                        self.XiaWuChanPinID = _infoModel[@"simulate"][_dijitian][@"list"][1][@"id"];
                                        self.XiaWuPrice = _infoModel[@"simulate"][_dijitian][@"list"][1][@"price"];
                                        self.lab1.text=_infoModel[@"simulate"][_dijitian][@"list"][1][@"price"];
                                        YZLog(@"%@",self.lab6.text);
                                        YZLog(@"%@",self.lab1.text);
                                        YZLog(@"%@",self.lab2.text);
                                    }
                                }                                
                            }
                            //上午
                            else
                            {
                                self.isclick=YES;
                                //设置上午的时间
                                [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][_dijitian][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][_dijitian][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                _similateModel=_infoModel[@"simulate"][_dijitian][@"list"];
                                //设置上午的颜色
                                _on=NO;
                                _btno.hidden=NO;
                                [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                                self.ShangWuChanPinID = _infoModel[@"simulate"][_dijitian][@"list"][0][@"id"];
                                self.shangWuPrice = _infoModel[@"simulate"][_dijitian][@"list"][0][@"price"];
                                //设置优惠活动
                                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"old_price"]];
                                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][_dijitian][@"list"][0][@"price"]];
                                if ([_infoModel[@"simulate"][_dijitian][@"list"][0][@"discount"] isEqualToString:@"1"])
                                {
                                    _manjian=YES;
                                    self.manji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"] integerValue];
                                    self.songji=[_infoModel[@"simulate"][_dijitian][@"list"][0][@"times2"] integerValue];
                                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][_dijitian][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                                }
                                else
                                {
                                    self.manji=0;
                                    self.songji=0;
                                    _manjian=NO;
                                    self.lab6.text=@"无";
                                }
                                YZLog(@"%@",self.lab6.text);
                                YZLog(@"%@",self.lab1.text);
                                YZLog(@"%@",self.lab2.text);
                                YZLog(@"上午没有过期");
                                _btnt.hidden=NO;
                                //设置下午的时间
                                [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][_dijitian][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][_dijitian][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                                [_btnt setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
                            }
                        }
                    }
            }
            
            UIView *sapdView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height - 1, KScreenWidth, 1)];
            sapdView1.backgroundColor = ZX_BG_COLOR;
            [cell.contentView addSubview:sapdView1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setUpCellWith:_keSanDetailModel];
            return cell;
        }
        else if (indexPath.row == 2)
        {
            //剩余多少人，当前排队人数，预计上车时间的cell
            ZXCarDetailTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCarDetailTableViewCell3ID" forIndexPath:indexPath];
            //剩余多少人的label
            self.lab3 = cell.label;
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height - 1, KScreenWidth, 1)];
            sapdView.backgroundColor = ZX_BG_COLOR;
            [cell.contentView addSubview:sapdView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //上午
            if (!_issw)
            {
                //设置预约的人数
                NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str = _similateModel[0][@"surplus"];
                NSString* hehe = [NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha = [NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
            }
            else
            {
                
                if (_similateModel.count>=2)
                {
                    //设置预约的人数
                    NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[1][@"surplus"],_similateModel[1][@"orderNum"],predictTime]];
                    self.str =_similateModel[1][@"surplus"];
                    NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[1][@"surplus"]];
                    NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[1][@"orderNum"]];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                    
                    self.lab3.attributedText =str;
                }
                else
                {
                    //设置预约的人数
                    NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                    self.str=_similateModel[0][@"surplus"];
                    NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                    NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                    
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                    self.lab3.attributedText =str;
                }
            }
            return cell;
        }
        else if (indexPath.row == 3)
        {
            ZXCarDetailTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCarDetailTableViewCell4ID" forIndexPath:indexPath];
            self.number = cell.numLabel;
            //购买数量点击事件
            [cell.addBtn addTarget:self action:@selector(num1:) forControlEvents:UIControlEventTouchDown];
            [cell.jianBtn addTarget:self action:@selector(num2:) forControlEvents:UIControlEventTouchDown];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height - 1, KScreenWidth, 1)];
            sapdView.backgroundColor = ZX_BG_COLOR;
            [cell.contentView addSubview:sapdView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6)
        {
            ZXCarDetailTableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCarDetailTableViewCell5ID" forIndexPath:indexPath];
            UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height - 1, KScreenWidth, 1)];
            sapdView.backgroundColor = ZX_BG_COLOR;
            [cell.contentView addSubview:sapdView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 4)
            {
                if (_ersan)
                {
                    cell.hidden=YES;
                }
                else
                {
                    cell.CoachName.text = [NSString stringWithFormat:@"教练:%@",_infoModel[@"teacher_name"]];
                    cell.headImage.image = [UIImage imageNamed:@"科三教练"];
                }
            }
            else if(indexPath.row == 5)
            {
                cell.CoachName.text = [NSString stringWithFormat:@"车型:%@",_infoModel[@"brand"]];
                cell.headImage.image = [UIImage imageNamed:@"车型"];
            }
            else
            {
                cell.CoachName.text = [NSString stringWithFormat:@"地址:%@",_infoModel[@"exam_address"]];
                cell.headImage.image = [UIImage imageNamed:@"考场地址"];
            }
            return cell;
        }
        else
        {
            ZXBuyNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Buy" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}


//设置日期
-(void)riqibeijing:(NSInteger)i
{
    //设置天数的颜色
    if (i==0)
    {
        [_btn1 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==1)
    {
        [_btn2 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==2)
    {
        
        [_btn3 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==3)
    {
        [_btn4 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==4)
    {
        [_btn5 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==5)
    {
        [_btn6 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
    else if(i==6)
    {
        [_btn7 setBackgroundImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
    }
}

//日期点击事件
-(void)kesandianjishijian:(UIButton*)btn
{
    _numOfbuy = 1;
    self.number.text = [NSString stringWithFormat:@"%d", _numOfbuy];
    _isshuaxin = YES;
    _dijitian = btn.tag;
    self.isclick = NO;
    [_btno setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
    [_btnt setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
    [_btnt setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_btno setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self setDateUI];
    _btno.hidden = YES;
    _btnt.hidden = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"Unknown"]forState:UIControlStateNormal];
    switch (btn.tag)
    {
        _similateModel = nil;
        case 1:
            _isshuaxin = NO;
            if([_infoModel[@"simulate"][0][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian = btn.tag - 1;
                
                _similateModel = _infoModel[@"simulate"][0][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][0][@"list"]).count == 1)
                {
                      //判断是上午还是下午
                      //实例化一、、NSDateFormatter对象
                      NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                      //设定时间格式,这里可以设置成自己需要的格式
                      [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                      NSArray* arr = [_infoModel[@"simulate"][0][@"list"][0][@"start_time"] componentsSeparatedByString:@" "];
                      NSDate *date = [dateFormat dateFromString:_infoModel[@"simulate"][0][@"list"][0][@"end_time"]];
                      NSDate *date2 = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ 12:00:00",arr[0]]];
                      NSTimeZone *zone = [NSTimeZone systemTimeZone];
                      NSInteger interval4 = [zone secondsFromGMTForDate: date];
                      date = [date  dateByAddingTimeInterval: interval4];
                      NSInteger interval3 = [zone secondsFromGMTForDate: date2];
                      date2 = [date2  dateByAddingTimeInterval: interval3];
                      NSComparisonResult result=[date compare:date2];
                      //下午
                      if(result != NSOrderedAscending)
                      {
                          NSDate* nowdate = [NSDate date];
                          NSInteger interval45 = [zone secondsFromGMTForDate: nowdate];
                          nowdate = [nowdate  dateByAddingTimeInterval: interval45];
                          NSComparisonResult result5 = [nowdate compare:date];
                          if(result5 == NSOrderedAscending)
                          {

//                            _ishaha = YES;
                            [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][0][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][0][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                              _btnt.hidden = NO;
                            [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                            [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                              _btno.hidden = YES;
                            _on = NO;
                              
                            self.isclick = YES;
                              //设置预约的人数
                              NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                              NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                              self.str = _similateModel[0][@"surplus"];
                              NSString* hehe = [NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                              NSString* haha = [NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                              self.lab3.attributedText =str;

                              
                          }
                      }
                      //上午
                      else
                      {
                          NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                          //设定时间格式,这里可以设置成自己需要的格式
                          [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                          //判断上午是否过期
                          //获取当前时间
                          NSDate* datenow=[NSDate date];
                          NSTimeZone *zone = [NSTimeZone systemTimeZone];
                          NSInteger interval2 = [zone secondsFromGMTForDate: datenow];
                          NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval2];
                          //取出上午时间
                          NSDate *date =[dateFormat dateFromString:_infoModel[@"simulate"][0][@"list"][0][@"end_time"]];
                          NSInteger interval4 = [zone secondsFromGMTForDate: date];
                          date = [date  dateByAddingTimeInterval: interval4];
                          //进行比对
                          NSComparisonResult result=[localeDate compare:date];
                          if (result==NSOrderedAscending)
                          {
                              _on=NO;
                              [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][0][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][0][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                              _btno.hidden = NO;
                              self.isclick=YES;
                              [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                              [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                             
                              _btnt.hidden = YES;
                              self.isclick=YES;
                              //设置预约的人数
                              NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                              NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                              self.str=_similateModel[0][@"surplus"];
                              NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                              NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                              self.lab3.attributedText =str;

                            }
                    }
                    //设置优惠活动
                    self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][0][@"list"][0][@"old_price"]];
                    self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][0][@"list"][0][@"price"]];
                    YZLog(@"%@",self.lab6.text);
                    YZLog(@"%@",self.lab1.text);
                    YZLog(@"%@",self.lab2.text);
                    //设置付款信息
                    self.ShangWuChanPinID = _infoModel[@"simulate"][0][@"list"][0][@"id"];
                    self.shangWuPrice = _infoModel[@"simulate"][0][@"list"][0][@"price"];
                    if ([_infoModel[@"simulate"][0][@"list"][0][@"discount"] isEqualToString:@"1"])
                    {
                        _manjian = YES;
                        self.manji = [_infoModel[@"simulate"][0][@"list"][0][@"times1"] integerValue];
                        self.songji = [_infoModel[@"simulate"][0][@"list"][0][@"times2"] integerValue];
                        self.lab6.text = [NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][0][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                    }
                    else
                    {
                        self.manji = 0;
                        self.songji = 0;
                        _manjian = NO;
                        self.lab6.text = @"无";
                    }
                  }
                  //上下午
                  else if(((NSArray*)_infoModel[@"simulate"][0][@"list"]).count==2)
                  {
                      NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                      //设定时间格式,这里可以设置成自己需要的格式
                      [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                      //判断上午是否过期
                      //获取当前时间
                      NSDate* datenow=[NSDate date];
                      NSTimeZone *zone = [NSTimeZone systemTimeZone];
                      NSInteger interval2 = [zone secondsFromGMTForDate: datenow];
                      NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval2];
                      //取出上午时间
                       NSDate *date =[dateFormat dateFromString:_infoModel[@"simulate"][0][@"list"][0][@"end_time"]];
                      NSInteger interval4 = [zone secondsFromGMTForDate: date];
                      date = [date  dateByAddingTimeInterval: interval4];
                      //进行比对
                      NSComparisonResult result=[localeDate compare:date];
                      if (result==NSOrderedAscending)
                      {
                          _on=NO;
                          [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][0][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][0][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                          _btno.hidden = NO;
                          self.isclick=YES;
                          [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                          [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                          self.XiaWuChanPinID = _infoModel[@"simulate"][0][@"list"][0][@"id"];
                          self.XiaWuPrice = _infoModel[@"simulate"][0][@"list"][0][@"price"];
                          [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][0][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][0][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                          _btnt.hidden = NO;
                          self.isclick=YES;
                          //设置预约的人数
                          NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                          NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                          self.str=_similateModel[0][@"surplus"];
                          NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                          NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                          [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                          [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                          [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                          self.lab3.attributedText =str;
                          //设置优惠活动
                          self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][0][@"list"][0][@"old_price"]];
                          self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][0][@"list"][0][@"price"]];
                          //设置付款信息
                          self.ShangWuChanPinID = _infoModel[@"simulate"][0][@"list"][0][@"id"];
                          self.shangWuPrice = _infoModel[@"simulate"][0][@"list"][0][@"price"];
                          if ([_infoModel[@"simulate"][0][@"list"][0][@"discount"] isEqualToString:@"1"])
                          {
                              _manjian=YES;
                              self.manji=[_infoModel[@"simulate"][0][@"list"][0][@"times1"] integerValue];
                              self.songji=[_infoModel[@"simulate"][0][@"list"][0][@"times2"] integerValue];
                              self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][0][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                          }
                          else
                          {
                              self.manji=0;
                              self.songji=0;
                              _manjian=NO;
                              self.lab6.text=@"无";
                          }
                      }
                      else
                      {
                          _btno.hidden = YES;
                          //判断下午是否过期
                          //取出下午时间
                          date =[dateFormat dateFromString:_infoModel[@"simulate"][0][@"list"][1][@"end_time"]];
                          interval4 = [zone secondsFromGMTForDate: date];
                          date = [date  dateByAddingTimeInterval: interval4];
                          //进行比对
                          result=[localeDate compare:date];
                          if (result==NSOrderedAscending)
                          {
                              [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][0][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][0][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                              [_btnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                              _btnt.hidden = NO;
                              _on=YES;
                              self.isclick=YES;
                              [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                              self.XiaWuChanPinID = _infoModel[@"simulate"][0][@"list"][1][@"id"];
                              self.XiaWuPrice = _infoModel[@"simulate"][0][@"list"][1][@"price"];
                              //设置预约的人数
                              NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                              NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                              self.str=_similateModel[0][@"surplus"];
                              NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[1][@"surplus"]];
                              NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[1][@"orderNum"]];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                              [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                              self.lab3.attributedText =str;
                              //设置优惠活动
                              self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][0][@"list"][1][@"old_price"]];
                              self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][0][@"list"][1][@"price"]];
                              //设置付款信息
                              self.XiaWuChanPinID = _infoModel[@"simulate"][0][@"list"][1][@"id"];
                              self.XiaWuPrice = _infoModel[@"simulate"][0][@"list"][1][@"price"];
                              if ([_infoModel[@"simulate"][0][@"list"][1][@"discount"] isEqualToString:@"1"])
                              {
                                  _manjian=YES;
                                  self.manji=[_infoModel[@"simulate"][0][@"list"][1][@"times1"] integerValue];
                                  self.songji=[_infoModel[@"simulate"][0][@"list"][1][@"times2"] integerValue];
                                  self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][0][@"list"][1][@"times1"],_similateModel[1][@"times2"]];
                              }
                              else
                              {
                                  self.manji=0;
                                  self.songji=0;
                                  _manjian=NO;
                                  self.lab6.text=@"无";
                              }

                          }
                          else
                          {
                              _btnt.hidden = YES;
                          }
                      }
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }
            break;
        case 2:
            if([_infoModel[@"simulate"][1][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][1][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][1][@"list"]).count==1)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][1][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][1][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden =  NO;
                    
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    _btnt.hidden = YES;
                    
                }
                //下午
                else if(((NSArray*)_infoModel[@"simulate"][1][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][1][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][1][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][1][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][1][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    _btno.hidden = NO;
                    _btnt.hidden = NO;
                }
                //设置预约的人数
                NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                _on=NO;
                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][1][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][1][@"list"][0][@"price"];
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][1][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][1][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                if ([_infoModel[@"simulate"][1][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][1][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][1][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][1][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }
            break;
        case 3:
            if([_infoModel[@"simulate"][2][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][2][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][2][@"list"]).count==1)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][2][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][2][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden =  NO;
                    _btnt.hidden = YES;
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                }
                //下午
                else if(((NSArray*)_infoModel[@"simulate"][2][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][2][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][2][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][2][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][2][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden = NO;
                    _btnt.hidden = NO;
                }
                _on=NO;
                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][2][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][2][@"list"][0][@"price"];
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][2][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][2][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                //设置预约的人数
                NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                if ([_infoModel[@"simulate"][2][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][2][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][2][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][2][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }

            break;
        case 4:
            if([_infoModel[@"simulate"][3][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][3][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][3][@"list"]).count==1)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][3][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][3][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden =  NO;
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    _btnt.hidden = YES;
                }
                //下午
                else if(((NSArray*)_infoModel[@"simulate"][3][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][3][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][3][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    
                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][3][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][3][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    
                    _btno.hidden = NO;
                    _btnt.hidden = NO;
                    
                }
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][3][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][3][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][3][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][3][@"list"][0][@"price"];
                _on=NO;

                //设置预约的人数
                NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                if ([_infoModel[@"simulate"][3][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][3][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][3][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][3][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }

            break;
        case 5:
            if([_infoModel[@"simulate"][4][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][4][@"list"];
                if (((NSArray*)_infoModel[@"simulate"][4][@"list"]).count ==1 )
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][4][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][4][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden =  NO;
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                   _btnt.hidden = YES;
                }
                else if(((NSArray*)_infoModel[@"simulate"][4][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][4][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][4][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    
                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][4][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][4][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                   
                    _btno.hidden = NO;
                    _btnt.hidden = NO;
                    
                }
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][4][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][4][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][4][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][4][@"list"][0][@"price"];
                _on=NO;
                //设置预约的人数
                NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                if ([_infoModel[@"simulate"][4][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][4][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][4][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][4][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }

            break;
        case 6:
            if([_infoModel[@"simulate"][5][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][5][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][5][@"list"]).count==1)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][5][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][5][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    _btno.hidden =  NO;
                    _btnt.hidden = YES;
                }
                //下午
                else if(((NSArray*)_infoModel[@"simulate"][5][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][5][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][5][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    
                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][5][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][5][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    _btno.hidden = NO;
                    _btnt.hidden = NO;
                    
                }

                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][5][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][5][@"list"][0][@"price"];
                _btnt.hidden = NO;
                _on=NO;
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][5][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][5][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                //设置预约的人数
                NSString *predictTime = [_similateModel[1][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                if ([_infoModel[@"simulate"][5][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][5][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][5][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][5][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }

            break;
        case 7:
           
            if([_infoModel[@"simulate"][6][@"list"] isKindOfClass:[NSArray class]])
            {
                self.dijitian=btn.tag-1;
                _similateModel=_infoModel[@"simulate"][6][@"list"];
                //上午
                if (((NSArray*)_infoModel[@"simulate"][6][@"list"]).count==1)
                {
                    _on=NO;
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][6][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][6][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    _btno.hidden =  NO;
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                   _btnt.hidden = YES;
                }
                //下午
                else if(((NSArray*)_infoModel[@"simulate"][6][@"list"]).count==2)
                {
                    [_btno setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][6][@"list"][0][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][6][@"list"][0][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    
                    [_btnt setTitle:[NSString stringWithFormat:@"%@至%@",[_infoModel[@"simulate"][6][@"list"][1][@"start_time"] substringWithRange:NSMakeRange(11, 5)],[_infoModel[@"simulate"][6][@"list"][1][@"end_time"] substringWithRange:NSMakeRange(11, 5)]] forState:UIControlStateNormal];
                    [_btno setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

                    _btno.hidden = NO;
                    self.isclick=YES;
                    [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
                }
                //设置付款信息
                self.ShangWuChanPinID = _infoModel[@"simulate"][6][@"list"][0][@"id"];
                self.shangWuPrice = _infoModel[@"simulate"][6][@"list"][0][@"price"];
                _on=NO;
                _btnt.hidden = NO;
                //设置优惠活动
                self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_infoModel[@"simulate"][6][@"list"][0][@"old_price"]];
                self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_infoModel[@"simulate"][6][@"list"][0][@"price"]];
                YZLog(@"%@",self.lab6.text);
                YZLog(@"%@",self.lab1.text);
                YZLog(@"%@",self.lab2.text);
                //设置预约的人数
                NSString *predictTime = [_similateModel[1][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
                if ([_infoModel[@"simulate"][6][@"list"][0][@"discount"] isEqualToString:@"1"])
                {
                    _manjian=YES;
                    self.manji=[_infoModel[@"simulate"][6][@"list"][0][@"times1"] integerValue];
                    self.songji=[_infoModel[@"simulate"][6][@"list"][0][@"times2"] integerValue];
                    self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_infoModel[@"simulate"][6][@"list"][0][@"times1"],_similateModel[0][@"times2"]];
                }
                else
                {
                    self.manji=0;
                    self.songji=0;
                    _manjian=NO;
                    self.lab6.text=@"无";
                }
            }
            else
            {
                _btnt.hidden = YES;
                _btno.hidden = YES;
            }
            break;
    }
}

//上下午时间点击事件
- (void)getDataSource:(UIButton *)Btn
{
    _numOfbuy = 1;
    self.number.text = [NSString stringWithFormat:@"%d", _numOfbuy];
    self.isclick=YES;
    [_lab3 setAdjustsFontSizeToFitWidth:YES];
    [_btnt setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_btno setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _isshuaxin=YES;
    
    //上午还是下午
    if (Btn.tag == 3333 || _ishaha)
    {
         _on=NO;
        if (_ishaha)
        {
            [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
            [_btno setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
            _ishaha=NO;
        }
        else
        {
            [_btno setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
            [_btnt setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
        }
        self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_similateModel[0][@"old_price"]];
        self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_similateModel[0][@"price"]];
        if ([_similateModel[0][@"discount"] isEqualToString:@"1"])
        {
            _manjian=YES;
            self.manji=[_similateModel[0][@"times1"] integerValue];
            self.songji=[_similateModel[0][@"times2"] integerValue];
            self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_similateModel[0][@"times1"],_similateModel[0][@"times2"]];
        }
        else
        {
            self.manji=0;
            self.songji=0;
            _manjian=NO;
            self.lab6.text=@"无";
        }
        NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
        
        if ([_similateModel[0][@"surplus"] isKindOfClass:[NSString class]])
        {
            self.str = _similateModel[0][@"surplus"];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
            self.str=_similateModel[0][@"surplus"];

            NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
            NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
            self.lab3.attributedText =str;
        }
        else
        {
            self.str = _similateModel[0][@"surplus"];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
            self.str=_similateModel[0][@"surplus"];

            NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
            NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
            self.lab3.attributedText =str;
        }
        self.lab4.text = [NSString stringWithFormat:@"%@分",_infoModel[@"score"]];
        self.lab5.text = [NSString stringWithFormat:@"已有%@人评价",_infoModel[@"commentNum"]];
        self.ShangWuChanPinID = _similateModel[0][@"id"];
        self.shangWuPrice = _similateModel[0][@"price"];
    }
    else
    {
        _on=YES;
        [_btnt setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:155/255.0 blue:221 / 255.0 alpha:1.0]];
        [_btno setBackgroundColor:[UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]];
        if (_similateModel.count==1)
        {
            
            self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_similateModel[0][@"old_price"]];
            self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_similateModel[0][@"price"]];
            if ([_similateModel[0][@"discount"] isEqualToString:@"1"])
            {
                _manjian=YES;
                self.manji=[_similateModel[0][@"times1"] integerValue];
                self.songji=[_similateModel[0][@"times2"] integerValue];
                self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_similateModel[0][@"times1"],_similateModel[0][@"times2"]];
            }
            else
            {
                self.manji=0;
                self.songji=0;
                _manjian=NO;
                self.lab6.text=@"无";
            }
            NSString *predictTime = [_similateModel[0][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
            if ([_similateModel[0][@"surplus"] isKindOfClass:[NSString class]])
            {
                self.str = _similateModel[0][@"surplus"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[0][@"surplus"],_similateModel[0][@"orderNum"],predictTime]];
                self.str=_similateModel[0][@"surplus"];
                
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
            }
            self.XiaWuChanPinID = _similateModel[0][@"id"];
            self.XiaWuPrice = _similateModel[0][@"price"];
        }
        else
        {
            
            self.lab1.text = [NSString stringWithFormat:@"原价￥%@/圈",_similateModel[1][@"old_price"]];
            self.lab2.text = [NSString stringWithFormat:@"￥%@/圈",_similateModel[1][@"price"]];
            if ([_similateModel[1][@"discount"] isEqualToString:@"1"])
            {
                _manjian=YES;
                self.manji=[_similateModel[1][@"times1"] integerValue];
                self.songji=[_similateModel[1][@"times2"] integerValue];
                self.lab6.text=[NSString stringWithFormat:@"满%@送%@",_similateModel[1][@"times1"],_similateModel[1][@"times2"]];
            }
            else
            {
                self.manji=0;
                self.songji=0;
                _manjian=NO;
                self.lab6.text=@"无";
            }
            NSString *predictTime = [_similateModel[1][@"goCarTime"] substringWithRange:NSMakeRange(11, 5)];
            if ([_similateModel[1][@"surplus"] isKindOfClass:[NSString class]])
            {
                self.str = _similateModel[1][@"surplus"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[1][@"surplus"],_similateModel[1][@"orderNum"],predictTime]];
                self.str=_similateModel[1][@"surplus"];
                
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[0][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[0][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
            }
            else
            {
                self.str = _similateModel[1][@"surplus"];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@张，当前排队人数%@人，预计%@上车",_similateModel[1][@"surplus"],_similateModel[1][@"orderNum"],predictTime]];
                self.str=_similateModel[1][@"surplus"];
                
                NSString* hehe=[NSString stringWithFormat:@"%@",_similateModel[1][@"surplus"]];
                NSString* haha=[NSString stringWithFormat:@"%@",_similateModel[1][@"orderNum"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:202/255.0 blue:141/255.0 alpha:1] range:NSMakeRange(2,[hehe length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+10,[haha length])];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:96/255.0 blue:128/255.0 alpha:1] range:NSMakeRange([hehe length]+[haha length]+14,5)];
                self.lab3.attributedText =str;
            }
            self.XiaWuChanPinID = _similateModel[1][@"id"];
            self.XiaWuPrice = _similateModel[1][@"price"];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, KScreenWidth, 60);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:@"立即购买" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(Buyction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        return button;
    }
    else
    {
        return 0;
    }
}

//跳转到选择购买张数的控制器
- (void)Buyction:(UIButton *)btn
{
    if (!_on)
    {
        if ([_similateModel[0][@"surplus"] integerValue] == 0)
        {
            return[MBProgressHUD showSuccess:@"卡券数量不足"];
        }
    }
    else
    {
        if ([_similateModel[1][@"surplus"] integerValue] == 0)
        {
            return[MBProgressHUD showSuccess:@"卡券数量不足"];
        }
    }
    
    if (self.isclick)
    {
        //先判断是否点击了时间按钮，决定是否跳转到下一个控制器
        ZX_TiJiaoDingDan_ViewController *TiJiaoVC = [[ZX_TiJiaoDingDan_ViewController alloc] init];
        
//      判断有没有上下午，然后决定传哪个id、forms、price
        if (!_on)
        {
            _chanPinID = _similateModel[0][@"id"];
            TiJiaoVC.priceValue = _shangWuPrice;
        }
        else if(_on)
        {
            _chanPinID = _similateModel[1][@"id"];
            TiJiaoVC.priceValue = _XiaWuPrice;
        }
        
        //赠送数量
        //是否有优惠活动
        if (_manjian)
        {
            TiJiaoVC.youhuihuodong = self.lab6.text;
            TiJiaoVC.zengsongshuliang = [NSString stringWithFormat:@"%ld",self.numOfbuy/self.manji*self.songji];
        }
        else
        {
            TiJiaoVC.youhuihuodong = @"无";
            TiJiaoVC.zengsongshuliang = @"0";
        }
        
        //购买数量
        TiJiaoVC.shuLiang = self.numOfbuy;
        //产品ID
        TiJiaoVC.productId = self.chanPinID;
        //产品名字
        TiJiaoVC.baocheleixing=@"科三模拟";
        //产品类型
        TiJiaoVC.goods_type = @"2";
        //跳转控制器
        [self.navigationController pushViewController:TiJiaoVC animated:YES];
    }
    else
    {
        UIAlertView *alertVC = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择日期及对应时间段买票" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertVC show];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }else {
        return 0;
    }
}

//点击购买数量
- (void)num1:(UIButton *)btn
{
    if (self.numOfbuy > 1)
    {
        --self.numOfbuy;
        self.number.text = [NSString stringWithFormat:@"%d", self.numOfbuy];
    }
    else
    {
         [MBProgressHUD showSuccess:@"最少购买一张"];
    }
}

- (void)num2:(UIButton *)btn
{
    NSInteger num = [self.str integerValue];
    if (self.numOfbuy < num )
    {
        if (!_on)
        {
            if (!_manjian)
            {
                _numOfbuy ++;
                _number.text = [NSString stringWithFormat:@"%d", _numOfbuy];
            }
            else
            {
               
                if ((_numOfbuy+1)*_songji/_manji + _numOfbuy + 1 > num)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"根据优惠活动您的所选数量已达最大值" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                              {
                                              }];
                    [alertController addAction:action1];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                else
                {
                    _numOfbuy ++;
                    _number.text = [NSString stringWithFormat:@"%d", _numOfbuy];
                }
            }
        }
        else if(_on)
        {
            if (!_manjian)
            {
                _numOfbuy ++;
                _number.text = [NSString stringWithFormat:@"%d", self.numOfbuy];
            }
            else
            {
                if ((_numOfbuy+1)*_songji/_manji + _numOfbuy + 1 > num)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"根据优惠活动您的所选数量已达最大值" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                              {
                                              }];
                    [alertController addAction:action1];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
                else
                {
                    _numOfbuy ++;
                    _number.text = [NSString stringWithFormat:@"%d", _numOfbuy];
                }
            }
        }
    }
    else
    {
        [MBProgressHUD showSuccess:@"购买数量已经最大"];
    }
}

@end

