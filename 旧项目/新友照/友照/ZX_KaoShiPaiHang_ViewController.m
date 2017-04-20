//
//  ZX_KaoShiPaiHang_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/18.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_KaoShiPaiHang_ViewController.h"
#import "ZXRankTableViewCell.h"

@interface ZX_KaoShiPaiHang_ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *kaoShiPaiHangTabV;
@property (nonatomic) NSMutableArray *kaoShiPaiHangArr;
@end

@implementation ZX_KaoShiPaiHang_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.subject isEqualToString:@"1"])
    {
        self.title = [NSString stringWithFormat:@"科目一考试排行"];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"科目四考试排行"];
    }
    
    [self getKaoShiPaiHangData];
    [self creatKaoShiPaiHangTabV];
    [self.view addSubview:_kaoShiPaiHangTabV];
}
- (void)creatKaoShiPaiHangTabV
{
    _kaoShiPaiHangTabV = [[UITableView alloc] initWithFrame:self.view.bounds];
    _kaoShiPaiHangTabV.delegate = self;
    _kaoShiPaiHangTabV.dataSource = self;
    _kaoShiPaiHangTabV.showsVerticalScrollIndicator = NO;
    [_kaoShiPaiHangTabV registerNib:[UINib nibWithNibName:@"ZXRankTableViewCell"  bundle:nil] forCellReuseIdentifier:@"cellID"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kaoShiPaiHangArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    [cell setCellWith:_kaoShiPaiHangArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)getKaoShiPaiHangData
{
    [[ZXNetDataManager manager] recordsPaiHangDataWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andSubjects:_subject success:^(NSURLSessionDataTask *task, id responseObject)
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
             if(!_kaoShiPaiHangArr)
             {
                 _kaoShiPaiHangArr = [NSMutableArray arrayWithArray:jsonDict[@"list"]];
             }
             else
             {
                 [_kaoShiPaiHangArr addObjectsFromArray:jsonDict[@"list"]];
             }
         }
         [_kaoShiPaiHangTabV reloadData];
     } failed:^(NSURLSessionTask *task, NSError *error)
    {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
     }];
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
