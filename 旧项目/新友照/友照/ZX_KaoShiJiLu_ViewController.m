//
//  ZX_KaoShiJiLu_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_KaoShiJiLu_ViewController.h"
#import "ZXRecordTableViewCell1.h"
#import "ZXKongKaQuanView.h"

@interface ZX_KaoShiJiLu_ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *kaoShiJiLuTabV;
@property(nonatomic, strong) NSArray *kaoShiJiLuArr;
@property (nonatomic) ZXKongKaQuanView *KongKaQuanView;
@end

@implementation ZX_KaoShiJiLu_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"考试记录";
    self.view.backgroundColor=ZX_BG_COLOR;
    [self creatKaoShiJiLuTabV];
    [self getKaoShiJiLuData];
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:self.view.bounds];
    }
    return _KongKaQuanView;
}

- (void)creatKaoShiJiLuTabV
{
    _kaoShiJiLuTabV = [[UITableView alloc]initWithFrame:self.view.frame];
    _kaoShiJiLuTabV.delegate = self;
    _kaoShiJiLuTabV.dataSource = self;
    _kaoShiJiLuTabV.backgroundColor=ZX_BG_COLOR;
    [self.view addSubview:_kaoShiJiLuTabV];
    _kaoShiJiLuTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _kaoShiJiLuTabV.showsVerticalScrollIndicator = NO;
    //注册cell
    [_kaoShiJiLuTabV registerNib:[UINib nibWithNibName:@"ZXRecordTableViewCell1" bundle:Nil] forCellReuseIdentifier:@"cellID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_kaoShiJiLuArr && _kaoShiJiLuArr.count == 0)
    {
        [self KongKaQuanView];
        _KongKaQuanView.label.text = @"您还没有成绩哦";
        [self.view addSubview:_KongKaQuanView];
    }
    
    return _kaoShiJiLuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 222;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXRecordTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.contentView.backgroundColor=ZX_BG_COLOR;
    cell.keMuLabel.text = _kaoShiJiLuArr[indexPath.row][@"subject"];
    cell.kaoShiTimeLabel.text = _kaoShiJiLuArr[indexPath.row][@"exam_time"];
    cell.kaoShiStateLabel.text = _kaoShiJiLuArr[indexPath.row][@"status"];
    cell.kaoShiScoreLabel.text = _kaoShiJiLuArr[indexPath.row][@"score"];
    if ([_kaoShiJiLuArr[indexPath.row][@"address"] isEqualToString:@""])
    {
        cell.kaoShiAddressLabel.text = @"--";
    }
    else
    {
        cell.kaoShiAddressLabel.text = _kaoShiJiLuArr[indexPath.row][@"address"];
    }
    if ([_kaoShiJiLuArr[indexPath.row][@"status"] isEqualToString:@"未通过"])
    {
        cell.kaoShiScoreLabel.textColor=[UIColor colorWithRed:146/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        cell.kaoShiStateLabel.textColor=[UIColor colorWithRed:146/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    else
    {
         cell.kaoShiScoreLabel.textColor=[UIColor colorWithRed:0/255.0 green:150/255.0 blue:100/255.0 alpha:1];
         cell.kaoShiStateLabel.textColor=[UIColor colorWithRed:0/255.0 green:150/255.0 blue:100/255.0 alpha:1];
    }
    cell.selectionStyle = NO;
    return cell;
}

//获取考试记录数据
- (void)getKaoShiJiLuData
{
    _animationView=[[ZXAnimationView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [self.view addSubview:_animationView];
    
    [[ZXNetDataManager manager] kaoShiJiLuDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
            if ([jsonDict[@"exam_list"] isKindOfClass:[NSArray class]])
            {
                if (_kaoShiJiLuArr)
                {
                    _kaoShiJiLuArr = [NSArray arrayWithArray:jsonDict[@"exam_list"]];
                }
                else
                {
                    _kaoShiJiLuArr = jsonDict[@"exam_list"];
                }
            }

            [_kaoShiJiLuTabV reloadData];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_animationView removeFromSuperview];
        });

    } failed:^(NSURLSessionTask *task, NSError *error)
    {
        [_animationView removeFromSuperview];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
