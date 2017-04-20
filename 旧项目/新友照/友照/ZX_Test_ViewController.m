//
//  ZX_Test_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/18.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_Test_ViewController.h"
#import "ZXRecordTableViewCell.h"

@interface ZX_Test_ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *kaoShiJiLuTabV;
@property (nonatomic, copy) NSMutableArray *kaoShiJiLuArr;
@property (nonatomic, copy) NSMutableArray *recordArr;
@property (nonatomic, strong) ZXKongKaQuanView *KongKaQuanView;
@end

@implementation ZX_Test_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_subject isEqualToString:@"1"])
    {
        self.title = @"科一考试记录";
    }
    else
    {
        self.title = @"科四考试记录";
    }
    
    //首先读取本地考试记录，而且科一和科四分开
//     if ([ZXUD boolForKey:@"IS_LOGIN"])
//     {
//         [self getKaoShiJiLuData];
//     }
//    else
//    {
        [self duqubendijilu];
//    }
    
    _kaoShiJiLuTabV = [[UITableView alloc] initWithFrame:self.view.bounds];
    _kaoShiJiLuTabV.delegate = self;
    _kaoShiJiLuTabV.dataSource = self;
    _kaoShiJiLuTabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_kaoShiJiLuTabV];
    [_kaoShiJiLuTabV registerNib:[UINib nibWithNibName:@"ZXRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
}

//得到考试记录文件路径
-(NSString *)getFilePath
{
    //1.获取library目录
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //2.创建文件夹
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"kaoshijiluwenjian"];
    //创建文件夹
    //文件管理器对象
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(![fileManger createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:0 error:nil])
    {
        return nil;
    }
    //3.合闭文件路径
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"kaoshijilu"];
    return filePath;
}

//读取本地考试记录
-(void)duqubendijilu
{
    _recordArr = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
    //遍历出科一或科四的考试记录
    for (int i = 0; i < _recordArr.count; i++)
    {
        //如果科几和当前的科几一样的话就取出来
        if ([_recordArr[i][@"keji"] isEqualToString:_subject])
        {
            if (!_kaoShiJiLuArr)
            {
                _kaoShiJiLuArr = [NSMutableArray arrayWithObject:_recordArr[i]];
            }
            else
            {
                [_kaoShiJiLuArr addObject:_recordArr[i]];
            }
        }
    }
}

//懒加载空卡券视图
-(ZXKongKaQuanView *)KongKaQuanView
{
    if (!_KongKaQuanView)
    {
        _KongKaQuanView = [[ZXKongKaQuanView alloc]initWithFrame:self.view.frame];
        _KongKaQuanView.label.text = @"您还没有考试记录";
    }
    return _KongKaQuanView;
}

#pragma mark--代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_kaoShiJiLuArr.count == 0)
    {
        [self KongKaQuanView];
        [self.view addSubview:_KongKaQuanView];
    }
    return _kaoShiJiLuArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    //字典里的元素 id score use_time addtime
    NSMutableDictionary *dict = _kaoShiJiLuArr[indexPath.row];
    
    NSString *score = dict[@"score"];
    
    NSString *use_time = dict[@"use_time"];
    
    NSString *addtime = dict[@"addtime"];
    
    NSArray *addTimes = [addtime componentsSeparatedByString:@" "];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.scoreLabel.text = [NSString stringWithFormat:@"分数: %@分",score];
    NSArray *arr = [use_time componentsSeparatedByString:@":"];
    cell.useTimeLabel.text = [NSString stringWithFormat:@"使用时间: %@分%@秒",arr[0],arr[1]];
    cell.dateLabel.text = addTimes[0];
    cell.timelabel.text = addTimes[1];
    return cell;
}

//- (void)getKaoShiJiLuData
//{
//    [[ZXNetDataManager manager] recordsWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andSubjects:_subject success:^(NSURLSessionDataTask *task, id responseObject)
//    {
//        NSError *err;
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
//        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
//        
//        if(err)
//        {
//            NSLog(@"json解析失败：%@",err);
//        }
//        
//        if([[ZXwangLuoDanLi WangLuoDanLi] resIsTrue:jsonDict andAlertView:self])
//        {
//            if(!_kaoShiJiLuArr)
//            {
//                _kaoShiJiLuArr = [NSMutableArray arrayWithArray:jsonDict[@"list"]];
//            }
//            else
//            {
//                [_kaoShiJiLuArr addObjectsFromArray:jsonDict[@"list"]];
//            }
//            [_kaoShiJiLuTabV reloadData];
//        }
//        if (_kaoShiJiLuArr.count == 0)
//        {
////            [self KongKaQuanView];
////            [self.view addSubview:_KongKaQuanView];
//        }
//    } failed:^(NSURLSessionTask *task, NSError *error)
//    {
//        [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
//    }];
//}

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
