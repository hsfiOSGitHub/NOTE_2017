//
//  ZX_XuanZeKaoChang_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_XuanZeKaoChang_ViewController.h"
#import "ZX_ke_er_xuan_kao_chang_TableViewCell.h"

@interface ZX_XuanZeKaoChang_ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *xuanZeKaoChangTabV;
@property (nonatomic, strong) NSMutableArray* kaoChangListArr;
@property (nonatomic, copy) NSString *page;
@end

@implementation ZX_XuanZeKaoChang_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择考场";
    [self getKaoChangListData];
    [self creatXuanZeKaoChangTabV];
}

//创建选择考场tableview
- (void)creatXuanZeKaoChangTabV
{
    _xuanZeKaoChangTabV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _xuanZeKaoChangTabV.delegate = self;
    _xuanZeKaoChangTabV.dataSource = self;
    _xuanZeKaoChangTabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_xuanZeKaoChangTabV];
    //注册cell
    [_xuanZeKaoChangTabV registerNib:[UINib nibWithNibName:@"ZX_ke_er_xuan_kao_chang_TableViewCell" bundle:nil] forCellReuseIdentifier:@"cellkaochang"];
}

//返回的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//返回每组的cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kaoChangListArr.count;
}

//每组的headerView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headerView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth/2, 20)];
    lab.text = @"请选择考场";
    [headerView addSubview:lab];
    return headerView;
}

//每组的headerView高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}

//返回的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZX_ke_er_xuan_kao_chang_TableViewCell *cell=[_xuanZeKaoChangTabV dequeueReusableCellWithIdentifier:@"cellkaochang"];
    cell.name.text = _kaoChangListArr[indexPath.row][@"name"];
    return cell;
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _gouMaiMoNiKaVC.kaoChangId = _kaoChangListArr[indexPath.row][@"id"];
    [_gouMaiMoNiKaVC gouMaiMoNiKaData];
    [self.navigationController popViewControllerAnimated:YES];
}

//获取考场列表
- (void)getKaoChangListData
{
    [[ZXNetDataManager manager] gouMaiMoNiKaKaoChangListDataWithRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andPage:_page success:^(NSURLSessionDataTask *task, id responseObject)
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
             if (!_kaoChangListArr)
             {
                 _kaoChangListArr = [NSMutableArray arrayWithArray:jsonDict[@"klist"]];
             }
             else
             {
                 [_kaoChangListArr addObjectsFromArray:jsonDict[@"klist"]];
             }
         }
         [_xuanZeKaoChangTabV reloadData];
        
    } failed:^(NSURLSessionTask *task, NSError *error)
     {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
