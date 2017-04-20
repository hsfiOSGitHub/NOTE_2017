//
//  ZXCityTableViewController.m
//  ZXJiaXiao
//
//  Created by ZX on 16/1/18.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCityTableViewController.h"

@interface ZXCityTableViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong,nonatomic) UITableView* tab;
@property (nonatomic, strong) UISearchController *searchCV;
@property (strong,nonatomic) NSMutableArray* suoyoufenlei;
@property (strong,nonatomic) NSMutableArray* AZ;
@property (nonatomic)BOOL *ss;
//用来储存需要查找的总资源
@property (nonatomic, strong)NSMutableArray *dataSource;
//用来储存查找结果
@property (nonatomic, strong)NSMutableArray *resultArr;

@end

@implementation ZXCityTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择城市";
    
    NSString *plistPathAZ = [[NSBundle mainBundle] pathForResource:@"AZ" ofType:@"plist"];
    _AZ = [[NSMutableArray alloc] initWithContentsOfFile:plistPathAZ];
    [_AZ insertObject:@"🔍" atIndex:0];
    //读取所有城市的名字
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    _suoyoufenlei = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    for (int i = 0; i < _suoyoufenlei.count; i ++)
    {
        for (int j = 0; j < ((NSMutableArray*)_suoyoufenlei[i]).count; j ++)
        {
            if (_dataSource)
            {
                [_dataSource addObject:_suoyoufenlei[i][j]];
            }
            else
            {
                _dataSource=[NSMutableArray array];
                [_dataSource addObject:_suoyoufenlei[i][j]];
            }
        }
    }
    //创建tabview
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    _tab.sectionIndexBackgroundColor = [UIColor clearColor];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tab.showsVerticalScrollIndicator = NO;
    //创建搜索栏
    self.searchCV = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置tableView的表头视图为searchBar
    UIView* uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    //设置大小
    self.searchCV.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 44);
    [self.searchCV.searchBar sizeToFit];
    [uiv addSubview:self.searchCV.searchBar];
    _tab.tableHeaderView = uiv;
    //设置背景颜色
    //设置开始搜索时背景是否显示,默认为yes
    self.searchCV.dimsBackgroundDuringPresentation = NO;
    self.searchCV.delegate = self;
    self.searchCV.searchResultsUpdater = self;
    [self.view addSubview:_tab];
}

//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if (self.searchCV.active)
     {
         return 1;
     }
    return _suoyoufenlei.count+1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.searchCV.active)
    {
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth-20, 30)];
        lab.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        if(section == 0)
        {
             lab.text = @"当前城市";
        }
        else
        {
            lab.text = [NSString stringWithFormat:@"    %@",_AZ[section]];
        }
        lab.textColor = [UIColor darkTextColor];
        lab.textAlignment = NSTextAlignmentLeft;
        return lab;
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.searchCV.active)
    {
        return 30;
    }
    else
    {
        return 1;
    }
}

//几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if (self.searchCV.active)
     {
         return _resultArr.count;
     }
    if (section == 0)
    {
        return 1;
    }
    return ((NSMutableArray*)_suoyoufenlei[section-1]).count;
}

//内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
     if (self.searchCV.active)
     {
         cell.textLabel.text = _resultArr[indexPath.row];
         return cell;
     }
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [ZXUD objectForKey:@"city"];
    }
    else
    {
        cell.textLabel.text = _suoyoufenlei[indexPath.section-1][indexPath.row];
    }
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchCV.active)
    {
        if (_isPersonalData)
        {
            [ZXUD setObject:_resultArr[indexPath.row] forKey:@"personalCity"];
        }
        else
        {
            [ZXUD setObject:_resultArr[indexPath.row] forKey:@"city"];
        }
    }
    else if (indexPath.section == 0)
    {
        if (_isPersonalData)
        {
            [ZXUD setObject:[ZXUD objectForKey:@"city"] forKey:@"personalCity"];
        }
        else
        {
            [ZXUD setObject:[ZXUD objectForKey:@"city"] forKey:@"city"];
         
        }
    }
    else if(indexPath.section != 0)
    {
        if (_isPersonalData)
        {
            [ZXUD setObject:_suoyoufenlei[indexPath.section-1][indexPath.row]forKey:@"personalCity"];
        }
        else
        {
            [ZXUD setObject:_suoyoufenlei[indexPath.section-1][indexPath.row]forKey:@"city"];
           
        }
    }
    self.searchCV.active = NO;
  
    [self.navigationController popViewControllerAnimated:YES];
}

//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!self.searchCV.active)
    {
        return _AZ;
    }
    else
    {
        return nil;
    }
}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:@"🔍"])
    {
        [tableView setContentOffset:CGPointMake(0, -64) animated:YES];
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [_resultArr removeAllObjects];
    NSString *str = [self.searchCV.searchBar text];
    //创建为此对象
    //CONTAINS:检查是否包含指定字符串
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS %@", str];
    //给datasource数组添加谓词
    _resultArr = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];
    [_tab reloadData];
}

-(void)goBackToFrontPages
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
