//
//  SearchSchoolVC.m
//  友照
//
//  Created by chaoyang on 16/11/29.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SearchSchoolVC.h"
#import "NearbySchoolCell.h"
#import "ZXDeleteHistorySeachTableViewCell.h"
#import "ZXNetDataManager+SchoolList.h"
#import "SchoolDetailVC.h"

@interface SearchSchoolVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchHistoryArr;
@property (nonatomic, strong) NSMutableArray *searchResultArr;
@property (nonatomic, strong) NSMutableArray *juli;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, assign) BOOL isSearchHistoryData;

@end

@implementation SearchSchoolVC

- (void)viewDidLoad
{
    _juli = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"jl"]];
    [super viewDidLoad];
    _page = @"0";
    [self ShownavigationItem];
    [self createTableView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

//tableView的显示
#define searchHistoryCell @"searchHistoryCell"
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchHistoryCell];
    [_tableView registerNib:[UINib nibWithNibName:@"NearbySchoolCell" bundle:nil] forCellReuseIdentifier:@"NearbySchoolCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ZXDeleteHistorySeachTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXDeleteHistorySeachTableViewCell"];
    
    //上拉加载
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                      {
                          _page=[NSString stringWithFormat:@"%ld",[_page integerValue]+1];
                          [self seachSchool];
                      }];
    
    [self.view addSubview:_tableView];
}
//导航栏的定制
- (void)ShownavigationItem {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 0)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"请输入要搜索驾校的名字";
    _searchResultArr = [NSMutableArray array];
    _isSearchHistoryData = YES;
    _page = @"0";
    [self getSearchHistoryData];
    self.navigationItem.titleView = _searchBar;
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [searchBtn addTarget:self action:@selector(searchSchoolAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}
//获取搜索历史的数据源
- (void)getSearchHistoryData {
    //从plist文件获取
    _searchHistoryArr = [NSMutableArray arrayWithArray:[ZXUD objectForKey:@"SearchHistorySchool"]];
}
- (void)searchSchoolAction:(UIButton*)btn
{
    btn.userInteractionEnabled=YES;
    if ([self.searchBar.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请输入驾校名字"];
        return;
    }
    //取消键盘的第一响应
    [_searchBar endEditing:YES];
    //要改变tableView的样式
    _isSearchHistoryData = NO;
    [_searchResultArr removeAllObjects];
    //搜索教龄
    _page=@"0";
    [self seachSchool];
}

- (void)seachSchool {
    [[ZXNetDataManager manager]schoolListDataWithM:@"school_list" andRndstring:[ZXDriveGOHelper getCurrentTimeStamp] andSort:@"" andPage:_page andName:_searchBar.text andSchool_ids:@"" andCity:[ZXUD objectForKey:@"city"] success:^(NSURLSessionDataTask *task, id responseObject) {
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
        [_tableView.mj_footer endRefreshing];
        if(err)
        {
            NSLog(@"json解析失败：%@",err);
        }
        if ([jsonDict[@"res"] isEqualToString:@"1001"]) {
            
            if ([jsonDict[@"school_list"] isKindOfClass:[NSArray class]]) {
                
                NSArray *arr = jsonDict[@"school_list"];
                //数据转模型
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in arr)
                {
                    SchoolListModel *model = [SchoolListModel modelWithDic:dic];
                    [tempArr addObject:model];
                }
                //给数据源赋值
                [self.searchResultArr addObjectsFromArray:tempArr];
            }
            [_tableView reloadData];
        }
        else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:jsonDict[@"msg"]];
            
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        
    }];
}

#pragma mark-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearchHistoryData) {
        if(_searchHistoryArr.count != 0){
            return _searchHistoryArr.count + 1;
        } else {
            return 0;
        }
    }
    return _searchResultArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSearchHistoryData)
    {
        if ( indexPath.row == _searchHistoryArr.count)
        {
            ZXDeleteHistorySeachTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ZXDeleteHistorySeachTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteHistorySearch)];
            [cell.deleteHistorySearchActionView addGestureRecognizer:tap];
            return cell;
        }
        else
        {
            NearbySchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbySchoolCell" forIndexPath:indexPath];
            //配置cell
            SchoolListModel *model = [SchoolListModel modelWithDic:_searchHistoryArr[indexPath.row]];;
            cell.schoolListModel = model;
            cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _isSearchHistoryData = YES;
            return cell;
        }
    }
    else
    {
        NearbySchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbySchoolCell" forIndexPath:indexPath];
        //配置cell
        SchoolListModel *model = self.searchResultArr[indexPath.row];
        cell.schoolListModel = model;
        cell.distance.text = [self getOtherTypeSchoolistanceWithSchoolID:model.school_id];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [_searchBar resignFirstResponder];
    if (_isSearchHistoryData)
    {
        if (indexPath.row != _searchHistoryArr.count)
        {
            SchoolDetailVC *schoolVC = [[SchoolDetailVC alloc]init];;
            schoolVC.sid = self.searchHistoryArr[indexPath.row][@"school_id"];
            [self.navigationController pushViewController:schoolVC animated:YES];
        }
    }
    else
    {
        SchoolDetailVC *schoolVC = [[SchoolDetailVC alloc]init];;
        schoolVC.sid = [NSString stringWithFormat:@"%@",[self.searchResultArr[indexPath.row] school_id]];
        [self.navigationController pushViewController:schoolVC animated:YES];
        //搜索历史的处理
        NSArray *oldHistoryArr = [ZXUD arrayForKey:@"SearchHistorySchool"];
        NSMutableArray *newHistoryArr = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSMutableDictionary *model in oldHistoryArr)
        {
            [arr addObject:model[@"school_id"]];
        }
        if (![arr containsObject:[NSString stringWithFormat:@"%@",[self.searchResultArr[indexPath.row] school_id]]])
        {
            
            SchoolListModel *model = self.searchResultArr[indexPath.row];
            NSMutableDictionary* dict=[NSMutableDictionary dictionary];
            [dict setValue:model.avg_days forKey:@"avg_days"];
            [dict setValue:model.avg_rate forKey:@"avg_rate"];
            [dict setValue:model.school_id forKey:@"school_id"];
            [dict setValue:model.name forKey:@"name"];
            [dict setValue:model.pic forKey:@"pic"];
            [dict setValue:model.score forKey:@"score"];
            [dict setValue:model.price forKey:@"price"];
            [newHistoryArr addObject:dict];
            [newHistoryArr addObjectsFromArray:oldHistoryArr];
            while (newHistoryArr.count > 10)
            {
                [newHistoryArr removeLastObject];
            }
            [ZXUD setValue:newHistoryArr forKey:@"SearchHistorySchool"];
            [ZXUD synchronize];
        }
    }
}

//清空历史记录
- (void)deleteHistorySearch {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空历史记录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //清空搜索记录
        NSArray *arr = [[NSArray alloc] init];
        [ZXUD setObject:arr forKey:@"SearchHistorySchool"];
        [self getSearchHistoryData];
        [self.tableView reloadData];
    }];
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alert addAction:anotherAction];
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 25)];
    headerLabel.center = CGPointMake(KScreenWidth / 2, 0);
    if (_isSearchHistoryData)
    {
        if (_searchHistoryArr.count != 0)
        {
            headerLabel.text = @"历史搜索";
        }
        else
        {
            headerLabel.text = @"";
        }
    }
    else
    {
        if (_searchResultArr.count == 0)
        {
            headerLabel.text = @"没有搜索结果";
        } else
        {
            headerLabel.text = @"搜索结果";
        }
    }
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isSearchHistoryData)
    {
        if (indexPath.row==_searchHistoryArr.count)
        {
            return 44;
        }
        
        return 90;
    }
    else
    {
        return 90;
    }
}

#pragma mark-搜索框的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchSchoolAction:[[UIButton alloc]init]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if ([searchText isEqualToString:@""])
    {
        _isSearchHistoryData = YES;
        [self.tableView reloadData];
    }
    else
    {
        _isSearchHistoryData = NO;
    }
}


//驾校距离
-(NSString *)getOtherTypeSchoolistanceWithSchoolID:(id)ID{
    
    for (int i=0; i<self.juli.count; i++)
    {
        if ([self.juli[i][@"bh"] isEqualToString:ID])
        {
            if([self.juli[i][@"jl"] integerValue]==0)
            {
                return @"--";
            }
            if ([self.juli[i][@"jl"] floatValue]>1000)
            {
                return [NSString stringWithFormat:@"%0.2f千米",[self.juli[i][@"jl"] floatValue]/1000.0];
            }
            else
            {
                return [NSString stringWithFormat:@"%.2f米",[self.juli[i][@"jl"] floatValue]];
            }
        }
    }
    return @"--";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
