//
//  ZX_JiaoTongBiaoZhi_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/12.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_JiaoTongBiaoZhi_ViewController.h"
#import "ZX_JiaoJingShouShi_ViewController.h"

@interface ZX_JiaoTongBiaoZhi_ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *jiaoTongBiaoZhiTabV;
@property (nonatomic, copy) NSArray *nameArray;
@property (nonatomic, copy) NSArray *fileNames;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ZX_JiaoTongBiaoZhi_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"交通标志";
    
    _nameArray = @[@"辅助标志",@"禁令标志",@"禁止标线",@"旅游区标志",@"道路施工安全标志",@"道路安全设施设置",@"警告标线",@"警告标志",@"指路标志",@"指示标线",@"指示标志",@"车辆按钮",@"仪表盘指示灯",@"色觉识别鉴定"];
    
    _fileNames = @[@"biaozhi_grid_2_fuzhu_sign",@"biaozhi_grid_2_jinling_sign",@"biaozhi_grid_2_jinzhi_biaoxian",@"biaozhi_grid_2_lvyouqu_sign",@"biaozhi_grid_2_road_construct",@"biaozhi_grid_2_road_safe",@"biaozhi_grid_2_warning_biaoxian",@"biaozhi_grid_2_warning_sign",@"biaozhi_grid_2_zhilu_sign",@"biaozhi_grid_2_zhishi_biaoxian",@"biaozhi_grid_2_zhishi_sign",@"biaozhi_grid_car_fouction",@"biaozhi_grid_car_panel_light",@"biaozhi_grid_color_blind"];
    
    _dataSource = [NSMutableArray array];
    
    for (NSString *str in _fileNames)
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:str ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:fileName];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [_dataSource addObject:dict];
    }
    
    [self creatJiaoTongBiaoZhiTabV];
}

- (void)creatJiaoTongBiaoZhiTabV
{
    _jiaoTongBiaoZhiTabV = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _jiaoTongBiaoZhiTabV.delegate = self;
    _jiaoTongBiaoZhiTabV.dataSource = self;
    _jiaoTongBiaoZhiTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jiaoTongBiaoZhiTabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_jiaoTongBiaoZhiTabV];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiaoTongBiaoZhi"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"jiaoTongBiaoZhi"];
    }
    
    cell.textLabel.text = _nameArray[indexPath.row];
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%lu张", (unsigned long)[_dataSource[indexPath.row][@"biaozhilist"] count]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_dataSource[indexPath.row][@"biaozhilist"][0][@"imageurl"]]];
    CGSize itemSize = CGSizeMake(60, 60);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    [cell.imageView.image drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //辅助视图
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *sapdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    sapdView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [cell.contentView addSubview:sapdView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZX_JiaoJingShouShi_ViewController *jiaoJingShouShiVC = [[ZX_JiaoJingShouShi_ViewController alloc]init];
    jiaoJingShouShiVC.fileName = _fileNames[indexPath.row];
    jiaoJingShouShiVC.biaoZhiTitle = _nameArray[indexPath.row];
    jiaoJingShouShiVC.isJiaoTongBiaoZhi = YES;
    [self.navigationController pushViewController:jiaoJingShouShiVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
