//
//  ZX_JiaoJingShouShi_ViewController.m
//  友照
//
//  Created by cleloyang on 2016/12/12.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_JiaoJingShouShi_ViewController.h"
#import "ZXPoliceGestureTableViewCell.h"
#import "ZX_TuPian_ViewController.h"
#import "ZX_kao_chang_shi_pai_TableViewCell.h"

@interface ZX_JiaoJingShouShi_ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSDictionary *dataSourceDic;
@property (nonatomic, strong) UITableView *jiaoJingShouShiTabV;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableDictionary *imgsDic;
@property (nonatomic, strong) NSMutableArray *imgsArr;
@property (nonatomic, strong) NSMutableArray *fenShuArr;
@end

@implementation ZX_JiaoJingShouShi_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _jiaoJingShouShiTabV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _jiaoJingShouShiTabV.delegate = self;
    _jiaoJingShouShiTabV.dataSource = self;
    _jiaoJingShouShiTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jiaoJingShouShiTabV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_jiaoJingShouShiTabV];
    if(!_isJiaXiaoTuPian)
    {
        if (_isJiaoTongBiaoZhi)
        {
            self.title = _biaoZhiTitle;
        }
        NSString *file = [[NSBundle mainBundle] pathForResource:_fileName ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        _dataSourceDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _jiaoJingShouShiTabV.showsVerticalScrollIndicator = NO;
        [_jiaoJingShouShiTabV registerNib:[UINib nibWithNibName:@"ZXPoliceGestureTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXPoliceGestureTableViewCellID"];
    }
    else
    {
        self.title = @"驾校图片";
        _jiaoJingShouShiTabV.showsVerticalScrollIndicator = NO;
        [_jiaoJingShouShiTabV registerNib:[UINib nibWithNibName:@"ZX_kao_chang_shi_pai_TableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXPoliceGestureTableViewCellID2"];
    }
    _nameArr = [NSMutableArray array];
    _imgsDic = [NSMutableDictionary dictionary];
    _fenShuArr = [NSMutableArray array];
    _imgsArr = [NSMutableArray array];
    _titleArr = [NSMutableArray array];
    for (NSDictionary *dic in _tupianArr)
    {
        [_nameArr addObject:dic[@"name"]];
        [_imgsDic setObject:dic[@"images"] forKey:dic[@"name"]];
        
        NSInteger i = 0;
        for (NSDictionary *dict in dic[@"images"])
        {
            i++;
            [_titleArr addObject:dic[@"name"]];
            [_imgsArr addObject:dict[@"big_pic"]];
            [_fenShuArr addObject:[NSString stringWithFormat:@"%ld/%@", i, dic[@"num"]]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!_isJiaXiaoTuPian)
    {
        return 1;
    }
    else
    {
        return _tupianArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_isJiaXiaoTuPian)
    {
        if ([_dataSourceDic[@"biaozhilist"] count] % 2)
        {
            return  [_dataSourceDic[@"biaozhilist"] count] / 2+1;
        }
        else
        {
            return  [_dataSourceDic[@"biaozhilist"] count] / 2;
        }
    }
    else
    {
        if ([_tupianArr[section][@"images"] count] % 2)
        {
             return  [_tupianArr[section][@"images"] count] / 2+1;
        }
        else
        {
             return  [_tupianArr[section][@"images"] count] / 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isJiaXiaoTuPian)
    {
        return KScreenWidth / 2;
    }
    else
    {
        return KScreenWidth / 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isJiaXiaoTuPian)
    {
        return 50;
    }
    else
    {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isJiaXiaoTuPian)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KScreenWidth/4, 49)];
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth/4+20, 0, KScreenWidth/4, 49)];
        nameLab.textAlignment = NSTextAlignmentLeft;
        numLab.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:nameLab];
        [headerView addSubview:numLab];
        nameLab.text = _tupianArr[section][@"name"];
        numLab.text = _tupianArr[section][@"num"];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *fenGeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, KScreenWidth, 1)];
        fenGeLab.backgroundColor = ZX_BG_COLOR;
        [headerView addSubview:fenGeLab];
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isJiaXiaoTuPian)
    {
        ZXPoliceGestureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXPoliceGestureTableViewCellID" forIndexPath:indexPath];
        NSDictionary *dict1 = _dataSourceDic[@"biaozhilist"][indexPath.row * 2];
        cell.imageVC1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", dict1[@"imageurl"] ]];
        cell.name1.text = dict1[@"title"];
        cell.imageVC1.tag = 300 + indexPath.row * 2;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];

        if (indexPath.row * 2 +1 < [_dataSourceDic[@"biaozhilist"] count])
        {
            NSDictionary *dict2 = _dataSourceDic[@"biaozhilist"][indexPath.row * 2 + 1];
            cell.imageVC2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", dict2[@"imageurl"] ]];
             cell.name2.text = dict2[@"title"];
            cell.imageVC2.tag = 300 + indexPath.row * 2 + 1;
            [cell.imageVC1 addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [cell.imageVC2 addGestureRecognizer:tap2];
        }
        else
        {
            cell.imageVC2.hidden=YES;
            cell.name2.text = @"";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        ZX_kao_chang_shi_pai_TableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"ZXPoliceGestureTableViewCellID2" forIndexPath:indexPath];
        
        NSDictionary *dict1 = _tupianArr[indexPath.section][@"images"][indexPath.row * 2];
        [cell2.imageVC1 sd_setImageWithURL:dict1[@"pic"] placeholderImage:[UIImage imageNamed:@"jiaxiaobg.jpg"]];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.imageVC1.tag = 300 *(indexPath.section+1) + (indexPath.row+1) * 2;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [cell2.imageVC1 addGestureRecognizer:tap1];

        if (indexPath.row * 2 +1 < [_tupianArr[indexPath.section][@"images"] count])
        {
            NSDictionary *dict2 = _tupianArr[indexPath.section][@"images"][indexPath.row * 2 + 1];
            [cell2.imageVC2 sd_setImageWithURL:dict2[@"pic"] placeholderImage:[UIImage imageNamed:@"jiaxiaobg.jpg"]];
            cell2.imageVC2.tag = 300 * (indexPath.section+1) + (indexPath.row+1) * 2 + 1;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            cell2.imageVC2.hidden = NO;
            [cell2.imageVC2 addGestureRecognizer:tap2];
        }
        else
        {
            cell2.imageVC2.hidden = YES;
        }
        
        return cell2;
    }
}

//点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    ZX_TuPian_ViewController *tuPianVC = [[ZX_TuPian_ViewController alloc] init];
    
    
    if(!_isJiaXiaoTuPian)
    {
        tuPianVC.isJiaXiaoTuPian = NO;
        tuPianVC.title = self.title;
        tuPianVC.dataSourceDic = _dataSourceDic;
        NSIndexPath * indexPathdd = [NSIndexPath indexPathForRow:tap.view.tag - 300 inSection:0];
        tuPianVC.contentIndexPath = indexPathdd;
    }
    else
    {
        NSMutableArray *arr = _imgsDic[_nameArr[tap.view.tag / 300-1]];
        NSDictionary *dic = arr[tap.view.tag % 300-2];
        NSInteger order = [dic[@"num"] integerValue] - 1;
        NSIndexPath * indexPathdd = [NSIndexPath indexPathForRow:order inSection:0];
        
        tuPianVC.contentIndexPath = indexPathdd;
        tuPianVC.isJiaXiaoTuPian = YES;
        tuPianVC.title =@"驾校图片";
        tuPianVC.fenShuArr = _fenShuArr;
        tuPianVC.imgsArr = _imgsArr;
        tuPianVC.titleArr = _titleArr;
    }
    
    [self.navigationController pushViewController:tuPianVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
