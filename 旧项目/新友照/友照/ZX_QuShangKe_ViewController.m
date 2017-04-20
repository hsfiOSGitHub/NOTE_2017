//
//  ZX_QuShangKe_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_QuShangKe_ViewController.h"
#import "FyCalendarView.h"
#import "ZXTableViewCell_yuyuejiaolian.h"
#import "ZXTableViewCell_haha.h"
#import "ZXYuYueTableViewCell.h"
#import "ZXNetDataManager+CoachData.h"
#import "ZX_GouMaiMoNiKa_ViewController.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ZX_QuShangKe_ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *teacherArr;
@property (nonatomic,strong)NSMutableArray *classArr;
@property (nonatomic,strong)NSMutableArray *classListArr;
@property (strong,nonatomic) FyCalendarView *rili;
@property (nonatomic, strong) NSDate *xindate;
@property (nonatomic,strong)UIView* uiv;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic,strong)UIView* xinrili;
@property (nonatomic,strong)NSString* phone;
@property (nonatomic) BOOL isshangxia;
@property (nonatomic,strong)UIButton* btnBG;
@property (nonatomic) NSInteger p;
@property (nonatomic) NSInteger btnTag;
@property (nonatomic) BOOL isNextMonth;
@end

@implementation ZX_QuShangKe_ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_btnBG removeFromSuperview];
   
    
    if (_isPaySuccess)
    {
        [self yuYueXueCheData];
    }
    else
    {
        [self getJiaoLianDetailData];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;

    self.title = _jiaoLianName;
    //设置页面
    [self shezhiyemian];
}

//设置页面
-(void)shezhiyemian
{
    _quShangKeTabv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _quShangKeTabv.delegate = self;
    _quShangKeTabv.dataSource = self;
    _quShangKeTabv.showsVerticalScrollIndicator = NO;
    
    [_quShangKeTabv registerNib:[UINib nibWithNibName:@"ZXTableViewCell_yuyuejiaolian" bundle:nil] forCellReuseIdentifier:@"cellIDtt"];
    [_quShangKeTabv registerNib:[UINib nibWithNibName:@"ZXTableViewCell_haha" bundle:nil] forCellReuseIdentifier:@"cellIDttt"];
    [_quShangKeTabv registerNib:[UINib nibWithNibName:@"ZXYuYueTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIDtttt"];
    
    _quShangKeTabv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_quShangKeTabv];
}

//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return _classListArr.count+1;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)
        {
            return 104;
        }
        else if(indexPath.row==1)
        {
            return 220;
        }
        else if(indexPath.row==2)
        {
            return 60;
        }
    }
    else
    {
        if (indexPath.row==0)
        {
            return 60;
        }
        else
        {
            return 65;
        }
    }
    return 0;
}

//每行的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            ZXTableViewCell_yuyuejiaolian *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDtt" forIndexPath:indexPath];
            cell.jiaxiaomingzi.text = _teacherArr[0][@"school_name"];
            cell.jiaolianmingzi.text = _teacherArr[0][@"name"];
            _phone = _teacherArr[0][@"phone"];
            [cell.liaotian addTarget:self action:@selector(liaotian) forControlEvents:UIControlEventTouchDown];
            [cell.touxiang sd_setImageWithURL:[NSURL URLWithString:_teacherArr[0][@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang.jpg"]];
            [cell.datu addTarget:self action:@selector(datu) forControlEvents:UIControlEventTouchDown];
            [cell.dianhua addTarget:self action:@selector(daDianHua) forControlEvents:UIControlEventTouchDown];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.row == 1)
        {
            UITableViewCell* cell = [[UITableViewCell alloc] init];
            _xinrili = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
            [self shezhixinrili];
            [cell.contentView addSubview:_xinrili];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.row == 2)
        {
            ZXTableViewCell_haha *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDttt" forIndexPath:indexPath];
            cell.bukeyu.layer.masksToBounds = YES;
            cell.bukeyu.layer.cornerRadius = 10;
            cell.keyiyue.clipsToBounds = YES;
            cell.keyiyue.layer.cornerRadius = 10;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
            la.backgroundColor = ZX_BG_COLOR;
            [cell addSubview:la];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, KScreenWidth, 50)];
            [cell addSubview:lab];
            lab.backgroundColor = [UIColor whiteColor];
            lab.text = [NSString stringWithFormat:@"日期: %@", _selectDate];
            lab.textColor = [UIColor colorWithRed:205/255.0 green:40/255.0 blue:90/255.0 alpha:1];
            return cell;
        }
        else
        {
            ZXYuYueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDtttt" forIndexPath:indexPath];
            [cell setUpCell:_classListArr[indexPath.row-1]];
            _p = indexPath.row-1;
            cell.yuYueButton.tag = [_classListArr[indexPath.row-1][@"id"] integerValue];
            [cell.yuYueButton addTarget:self action:@selector(yuYuekeshi:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    return [[UITableViewCell alloc] init];
}
//聊天
-(void)liaotian
{

    
}

//大图
-(void)datu
{
    _uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _uiv.backgroundColor = [UIColor whiteColor];
    UIImageView* uiimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth/4*3)];
    uiimage.centerY = _uiv.centerY-60;
    [uiimage sd_setImageWithURL:[NSURL URLWithString:_teacherArr[0][@"big_pic"]] placeholderImage:[UIImage imageNamed:@"jiaxiaobg.jpg"]];
    [_uiv addSubview:uiimage];
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [btn addTarget:self action:@selector(yichu) forControlEvents:UIControlEventTouchDown];
    [_uiv addSubview:btn];
    [self.view addSubview:_uiv];
}

//购买课程
-(void)goumai:(UIButton*)btn
{
    ZX_GouMaiMoNiKa_ViewController *gouMaiMoNiKaVC = [[ZX_GouMaiMoNiKa_ViewController alloc] init];
    gouMaiMoNiKaVC.goods_type = _goods_type;
    [self.navigationController pushViewController:gouMaiMoNiKaVC animated:YES];
}

-(void)yichubeijing:(UIButton*)btn
{
    [btn removeFromSuperview];
}
//移除大图
-(void)yichu
{
    [_uiv removeFromSuperview];
}

//设置新日历
-(void)shezhixinrili
{
    //获取当前日期
    self.xindate = [NSDate date];
    //设置位置和大小
    
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.xinrili.frame.size.height)];
    self.rili.leftBtn.userInteractionEnabled=NO;
    self.rili.leftBtn.alpha=0.5;
    self.rili.zxV = self;
    //加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rili addGestureRecognizer: self.leftSwipeGestureRecognizer];
    [self.rili addGestureRecognizer: self.rightSwipeGestureRecognizer];
    //日期状态
    self.rili.allDaysArr = [NSMutableArray array];
    self.rili.partDaysArr = [NSMutableArray array];
    //对日期进行判断
    for (int i = 0; i<_classArr.count; i++)
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-d"];
        NSDate* inputDate = [inputFormatter dateFromString:_classArr[i][@"day"]];
        
        int total = [_classArr[i][@"total_num"] intValue];
        int real = [_classArr[i][@"real_num"] intValue];
        
        NSDateFormatter*df =[[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        _selectDate = [df stringFromDate: self.xindate];
        
        NSInteger num=0;
        if ([_classArr[i][@"day"] isEqual:_selectDate])
        {
            for (int i=0; i<_classListArr.count; i++)
            {
                num+=[_classListArr[i][@"num"] integerValue]-[_classListArr[i][@"book_num"]integerValue];
            }
            if (num==0)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.partDaysArr addObject:str];
            }
            else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.allDaysArr addObject:str];
            }
        }
        else
        {
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
    }
    self.xinrili.backgroundColor=[UIColor whiteColor];
    [self.xinrili addSubview:self.rili];
    if ([_selectDate isEqualToString:@""] || !_selectDate)
    {
        NSDateFormatter*df =[[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        _selectDate = [df stringFromDate: self.xindate];
        self.rili.date = [NSDate date];
    }
    else
    {
        NSDateFormatter *inputFormatter =[[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        self.rili.date = [inputFormatter dateFromString:_selectDate];
    }
    WS(weakSelf)
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
        _selectDate = [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
        [weakSelf getClassNetdata];
    };
    
    self.rili.nextMonthBlock = ^()
    {
        [weakSelf setupNextMonth];
    };
    self.rili.lastMonthBlock = ^()
    {
        [weakSelf setupLastMonth];
    };
}

//新日历下一月
- (void)setupNextMonth
{
    self.xindate = [self.rili nextMonth:self.xindate];
    self.rili.date = self.xindate;
    [self xinrilishuaxin];
    self.rili.leftBtn.userInteractionEnabled=YES;
    self.rili.leftBtn.alpha=1;
    self.rili.rightBtn.userInteractionEnabled=NO;
    self.rili.rightBtn.alpha=0.5;
    _isshangxia = !_isshangxia;
}

//新日历上一月
- (void)setupLastMonth
{
    self.xindate = [self.rili lastMonth:self.xindate];
    self.rili.date = self.xindate;
    _isNextMonth=NO;
    NSDateFormatter*df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    _selectDate = [df stringFromDate: self.xindate];
    [self getJiaoLianDetailData];
     [self xinrilishuaxin];
    self.rili.leftBtn.userInteractionEnabled=NO;
    self.rili.leftBtn.alpha=0.5;
    self.rili.rightBtn.userInteractionEnabled=YES;
    self.rili.rightBtn.alpha=1;
    _isshangxia = !_isshangxia;
}

//手势
- (void)handleSwipes:(UISwipeGestureRecognizer *)btn
{
    if (btn.direction == UISwipeGestureRecognizerDirectionLeft && !_isshangxia) {
        [self setupNextMonth];
    }
    if (btn.direction == UISwipeGestureRecognizerDirectionRight && _isshangxia) {
        [self setupLastMonth];
    }
}

//新日历刷新
-(void)xinrilishuaxin
{
    //刷新界面
    [self.rili removeFromSuperview];
    self.rili = [[FyCalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.xinrili.frame.size.height)];
    [self.xinrili addSubview:self.rili];
    self.rili.zxV=self;
    self.rili.allDaysArr = [NSMutableArray array];
    self.rili.partDaysArr = [NSMutableArray array];
    //加手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rili addGestureRecognizer: self.leftSwipeGestureRecognizer];
    [self.rili addGestureRecognizer: self.rightSwipeGestureRecognizer];
    //对日期进行判断
    for (int i = 0; i<_classArr.count; i++)
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-d"];
        NSDate* inputDate = [inputFormatter dateFromString:_classArr[i][@"day"]];
        
        int total = [_classArr[i][@"total_num"] intValue];
        int real = [_classArr[i][@"real_num"] intValue];
        
        NSDateFormatter*df =[[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        _selectDate = [df stringFromDate: self.xindate];
        
        NSInteger num=0;
        if ([_classArr[i][@"day"] isEqual:_selectDate])
        {
            for (int i=0; i<_classListArr.count; i++)
            {
                num+=[_classListArr[i][@"num"] integerValue]-[_classListArr[i][@"book_num"]integerValue];
            }
            if (num==0)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.partDaysArr addObject:str];
            }
            else
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"d"];
                NSString* str=[formatter stringFromDate:inputDate];
                [self.rili.allDaysArr addObject:str];
            }
            
        }
        else
        {
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
    }
    WS(weakSelf)
    [self.rili createCalendarViewWith:self.xindate];
    self.rili.date=self.xindate;
    
    self.rili.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
        _selectDate = [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
        [weakSelf getClassNetdata];
    };
    
    self.rili.lastMonthBlock = ^(){
    [weakSelf setupLastMonth];
    };
    self.rili.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
}

//打电话
-(void)daDianHua
{
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phone]]])
    {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phone]]];
}

//教练详情
-(void)getJiaoLianDetailData
{
    if (!_teacherArr)
    {
        _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [self.view addSubview:_animationView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });
    }
    
    [[ZXNetDataManager manager] JiaoLianDetailWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andTid:_subId success:^(NSURLSessionDataTask *task, id responseObject)
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
             if ([jsonDict[@"teacher"] isKindOfClass:[NSArray class]] && ((NSArray *)jsonDict[@"teacher"]).count > 0)
             {
                 _teacherArr = [NSMutableArray arrayWithArray:jsonDict[@"teacher"]];
             }
         }
         //进行日历比对
         _classArr = [[NSMutableArray alloc] initWithArray:_teacherArr[0][@"class"]];
         //再接着请求当天课程信息
         [self getClassNetdata];
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
         YZLog(@"请求教练信息失败。");
     }];
}

//我预约的课程
- (void)getClassNetdata
{
    [[ZXNetDataManager manager] myClassListWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] anddate:_selectDate andtid:_subId andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
        [_btnBG removeFromSuperview];
        
        if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
        {
            //请求成功
            _classListArr = [NSMutableArray arrayWithArray:jsonDict[@"class_list"]];
            
            
            //没有课程,弹出提示，告诉用户
            if (_classListArr.count == 0)
            {
                [MBProgressHUD showSuccess:@"今天没有课程哦！"];
            }
           
            if (_isNextMonth)
            {
                NSIndexSet *index = [[NSIndexSet alloc]initWithIndex:1];
                [_quShangKeTabv reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                [_quShangKeTabv reloadData];
                _isNextMonth = YES;
            }
        }
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
}

//预约课程
-(void)yuYuekeshi:(UIButton *)btn
{
    _btnTag = btn.tag;
    if (![ZXUD boolForKey:@"IS_LOGIN"])
    {
        ZX_Login_ViewController *loginVC = [[ZX_Login_ViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        [[ZXNetDataManager manager] keChengYuEDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andsubject:_subject success:^(NSURLSessionDataTask *task, id responseObject)
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
                 //没有课时,弹出提醒，购买课时
                 if ([jsonDict[@"class_num"] isEqualToString:@"0"])
                 {
                     _btnBG = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                     [_btnBG addTarget:self action:@selector(yichubeijing:) forControlEvents:UIControlEventTouchDown];
                     [_btnBG setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
                     [self.view addSubview:_btnBG];
                     
                     UIView* uiv = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-KScreenWidth/10*4, KScreenHeight/2-KScreenHeight/8-64, KScreenWidth/10*8, KScreenHeight/4)];
                     uiv.backgroundColor=[UIColor whiteColor];
                     uiv.layer.cornerRadius = 8;
                     uiv.layer.masksToBounds = YES;
                     
                     UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/10*8, KScreenHeight/16-1)];
                     lab.textColor = ZX_DarkGray_Color;
                     lab.text=  @"提示";
                     [lab setFont:[UIFont systemFontOfSize:16]];
                     lab.textAlignment = NSTextAlignmentCenter;
                     
                     UILabel* lab2=[[UILabel alloc]initWithFrame:CGRectMake(0,KScreenHeight/16-1, KScreenWidth/10*8, 1)];
                     lab2.backgroundColor = ZX_BG_COLOR;
                     
                     UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10,KScreenHeight/16, KScreenWidth/10*8-20, KScreenHeight/8)];
                     lab3.textColor = ZX_DarkGray_Color;
                     lab3.text = [NSString stringWithFormat:@"您还剩余 0 课时,确认购买课时吗？"];
                     lab3.numberOfLines=0;
                     [lab3 setFont:[UIFont systemFontOfSize:14]];
                     
                     [uiv addSubview:lab];
                     [uiv addSubview:lab2];
                     [uiv addSubview:lab3];
                     
                     UIButton* bn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight/16*3, KScreenWidth/10*8, KScreenHeight/16)];
                     [bn2 setBackgroundColor:[UIColor orangeColor]];
                     [bn2 setTintColor:[UIColor whiteColor]];
                     [bn2 setTitle:@"购买课时" forState:0];
                     bn2.tag = btn.tag;
                     [bn2 addTarget:self action:@selector(goumai:) forControlEvents:UIControlEventTouchDown];
                     [uiv addSubview:bn2];
                     [_btnBG addSubview:uiv];
                 }
                 else
                 {
                     _btnBG = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
                     [_btnBG addTarget:self action:@selector(yichubeijing:) forControlEvents:UIControlEventTouchDown];
                     [_btnBG setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
                     [self.view addSubview:_btnBG];
                     
                     UIView* uiv = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2-KScreenWidth/10*4, KScreenHeight/2-KScreenHeight/8-64, KScreenWidth/10*8, KScreenHeight/4)];
                     uiv.backgroundColor = [UIColor whiteColor];
                     uiv.layer.cornerRadius = 8;
                     uiv.layer.masksToBounds = YES;
                     
                     UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/10*8, KScreenHeight/16-1)];
                     lab.textColor = ZX_Black_Color;
                     lab.text = @"提示";
                     [lab setFont:[UIFont systemFontOfSize:16]];
                     lab.textAlignment = NSTextAlignmentCenter;
                     
                     UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,KScreenHeight/16-1, KScreenWidth/10*8, 1)];
                     lab2.backgroundColor = ZX_BG_COLOR;
                     
                     UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10,KScreenHeight/16, KScreenWidth/10*8-20, KScreenHeight/8)];
                     lab3.textColor = ZX_DarkGray_Color;
                     lab3.text = [NSString stringWithFormat:@"您已有 %@ 个课时，无需购买，可直接预约学习",jsonDict[@"class_num"]];
                     lab3.numberOfLines = 0;
                     [lab3 setFont:[UIFont systemFontOfSize:14]];
                     
                     [uiv addSubview:lab];
                     [uiv addSubview:lab2];
                     [uiv addSubview:lab3];
                     
                     UIButton* bn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight/16*3, KScreenWidth/10*8, KScreenHeight/16)];
                     bn2.tag = btn.tag;
                     [bn2 setBackgroundColor:dao_hang_lan_Color];
                     [bn2 setTintColor:[UIColor whiteColor]];
                     [bn2 setTitle:@"预约学车" forState:0];
                     [bn2 addTarget:self action:@selector(yuyuexueche:) forControlEvents:UIControlEventTouchDown];
                     [uiv addSubview:bn2];
                     [_btnBG addSubview:uiv];
                 }
             }
        } failed:^(NSURLSessionTask *task, NSError *error)
         {
             
         }];
    }
}

//预约学车
-(void)yuyuexueche:(UIButton*)btn
{
    [[ZXNetDataManager manager] yuYueKeChengDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andTcpid:[NSString stringWithFormat:@"%ld",(long)btn.tag] success:^(NSURLSessionDataTask *task, id responseObject)
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
             [ZXDriveGOHelper persentAlertView:self andMessage:[jsonDict objectForKey:@"msg"]];
             [self getClassNetdata];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

//购买课时付款成功后自动预约
-(void)yuYueXueCheData
{
    [[ZXNetDataManager manager] yuYueKeChengDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andTcpid:[NSString stringWithFormat:@"%ld",(long)_btnTag] success:^(NSURLSessionDataTask *task, id responseObject)
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
             [self getClassNetdata];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
     {
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue btn:(id)btn {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
