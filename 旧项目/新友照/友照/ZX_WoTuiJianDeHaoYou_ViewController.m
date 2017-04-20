//
//  ZX_WoTuiJianDeHaoYou_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_WoTuiJianDeHaoYou_ViewController.h"
#import "tuiJianHaoYouCell.h"

@interface ZX_WoTuiJianDeHaoYou_ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tabV;
@property (nonatomic, strong) NSArray *tuiJianHaoYouArr;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;
@end

@implementation ZX_WoTuiJianDeHaoYou_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我推荐的好友";
    [self creatTabV];
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:self.view.frame];
        _KongKaQuanView.label.text = @"暂无课程记录";
    }
    return _KongKaQuanView;
}

- (void)creatTabV
{
    _tabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    _tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tabV];
    _tabV.delegate = self;
    _tabV.dataSource = self;
    [_tabV registerNib:[UINib nibWithNibName:@"tuiJianHaoYouCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self getTuiJianHaoYouListData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tuiJianHaoYouArr && _tuiJianHaoYouArr.count == 0)
    {
        [self KongKaQuanView];
        _KongKaQuanView.label.text = @"您还没有推荐好友哦";
        [self.view addSubview:_KongKaQuanView];
    }
    else
    {
       return _tuiJianHaoYouArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tuiJianHaoYouCell *cell = [_tabV dequeueReusableCellWithIdentifier:@"cellID"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, KScreenWidth, 1)];
    label.backgroundColor = ZX_BG_COLOR;
    [cell addSubview:label];
    cell.selectionStyle = NO;
    cell.paiXuLabel.text = [NSString stringWithFormat:@"%ld.",indexPath.row + 1];
    if ([_tuiJianHaoYouArr isKindOfClass:[NSArray class]])
    {
        //设置头像
        NSString *picStr = _tuiJianHaoYouArr[indexPath.row][@"pic"];
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        
        //推荐人的名字
        cell.TuiJianNameLabel.text = _tuiJianHaoYouArr[indexPath.row][@"nickname"];
        
        //推荐的时间(截取字符串,显示时间)
        NSString *timeStr = _tuiJianHaoYouArr[indexPath.row][@"addtime"];
        NSString *xxStr = [timeStr substringWithRange:NSMakeRange(0, 10)];
        cell.timeLabel.text = xxStr;
    }
    
    return cell;
}

//获取推荐好友列表
- (void)getTuiJianHaoYouListData
{
    [[ZXNetDataManager manager] tuiJianXueYuanListDataWitnRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
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
         
         if(err) {
             
             NSLog(@"json解析失败：%@",err);
         }
         if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
         {
             //获取推荐好友列表成功
             if ([jsonDict[@"list"] isKindOfClass:[NSArray class]])
             {
                 if (_tuiJianHaoYouArr)
                 {
                     _tuiJianHaoYouArr = [NSArray arrayWithArray:jsonDict[@"list"]];
                 }
                 else
                 {
                     _tuiJianHaoYouArr = jsonDict[@"list"];
                 }
             }
             
             [_tabV reloadData];
         }
     }failed:^(NSURLSessionTask *task, NSError *error)
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
