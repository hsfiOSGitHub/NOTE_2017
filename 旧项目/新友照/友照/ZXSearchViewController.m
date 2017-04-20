//
//  ZXSearchViewController.m
//  ZXJiaXiao
//
//  Created by ZX on 16/4/22.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXSearchViewController.h"
#import "ZXNetDataManager+CoachData.h"
#import "ZXDriveGOHelper.h"
#import "CoachListTableViewCell.h"
@interface ZXSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray *searchHistoryArr;
@property (nonatomic) NSMutableArray *searchResultArr;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL isSearchHistoryData;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSString *page;


@end

@implementation ZXSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = ZX_SPAD_COLOR;
    self.view.backgroundColor = [UIColor whiteColor];
    [self ShownavigationItem];
    
    [self createTableView];
}

//得到距离文件路径
-(NSString *)getjuli
{
    //1.获取library目录
    NSString *libraryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //2.创建文件夹
    NSString *dirPath=[libraryPath stringByAppendingPathComponent:@"juli"];
    //创建文件夹
    //文件管理器对象
    NSFileManager *fileManger=[NSFileManager defaultManager];
    if(![fileManger createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:0 error:nil])
    {
        return nil;
    }
    //3.合闭文件路径
    NSString *filePath=[dirPath stringByAppendingPathComponent:@"jlCS"];
    return filePath;
}


//导航栏的定制
- (void)ShownavigationItem {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 0)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    if (_isSearchCoach) {
        _searchBar.placeholder = @"请输入搜索教练的名字";
    } else {
        _searchBar.placeholder = @"请输入搜索驾校的名字";
    }
    _searchResultArr = [NSMutableArray array];
    _isSearchHistoryData = YES;
    _page = @"0";
    [self getSearchHistoryData];
    self.navigationItem.titleView = _searchBar;
    
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [searchBtn addTarget:self action:@selector(searchCoachOrSchoolAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}

//获取搜索历史的数据源
- (void)getSearchHistoryData {
    //从plist文件获取
//    NSArray *arr;
//    if (self.isSearchCoach) {
//        arr = [ZXUD objectForKey:ZXSearchHistory_Coach];
//        
//    } else {
//        arr = [ZXUD arrayForKey:ZXSearchHistory_School];
//    }
//    _searchHistoryArr = arr;
}
//tableView的显示
#define searchHistoryCell @"searchHistoryCell"
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchHistoryCell];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CoachListTableViewCell.h" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZXDeleteHistorySeachTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXDeleteHistorySeachTableViewCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ZXJiaoXiaoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXJiaoXiaoTableViewCell"];
    [self.view addSubview:_tableView];
    
}


- (void)searchCoachOrSchoolAction
{
    //取消键盘的第一响应
    [_searchBar endEditing:YES];
    //要改变tableView的样式
    _isSearchHistoryData = NO;
    [_searchResultArr removeAllObjects];
    if (_isSearchCoach)
    {
        [self seachCoach];
    }
    else
    {
        [self searchSchool];
    }
}

- (void)seachCoach {
    
}

- (void)searchSchool {
    
}

#pragma mark-
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
//    if (_isSearchHistoryData)
//    {
//        if ( indexPath.row == _searchHistoryArr.count)
//        {
//            ZXDeleteHistorySeachTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ZXDeleteHistorySeachTableViewCell" forIndexPath:indexPath];
//            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell.deleteHistorySearchActionBtn addTarget:self action:@selector(deleteHistorySearch) forControlEvents:UIControlEventTouchUpInside];
//            return cell;
//        }
//        else
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchHistoryCell forIndexPath:indexPath];
//            cell.textLabel.text = [_searchHistoryArr objectAtIndex:indexPath.row];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            _isSearchHistoryData = YES;
//            return cell;
//        }
//    }
//    else if (_isSearchCoach)
//    {
//       CoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCoachTableViewCell" forIndexPath:indexPath];
//        //配置cell
//        ZXCoachList *coachList = [_searchResultArr objectAtIndex:indexPath.row];
//        [cell setCoachCellWith:coachList];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    else
//    {
//        ZXJiaoXiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXJiaoXiaoTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        //配置驾校视图
//        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        NSMutableArray* hahaha=[NSMutableArray arrayWithContentsOfFile:[self getjuli]];
//        BOOL hehe=NO;
//        for(int i=0; i<hahaha.count; i++)
//        {
//            NSMutableDictionary* dict5=[NSMutableDictionary dictionary];
//            dict5=hahaha[i];
//            if ([dict5[@"bh"] isEqualToString:_searchResultArr[indexPath.row][@"id"]])
//            {
//                hehe=YES;
//                [cell setJiaoXiaoCellWith: [_searchResultArr objectAtIndex:indexPath.row] andjl:[dict5[@"jl"]doubleValue]];
//                return cell;
//            }
//        }
//        if (!hehe)
//        {
//            DLog(@"没有距离");
//            [cell setJiaoXiaoCellWith:[_searchResultArr objectAtIndex:indexPath.row] andjl:0.1];
//            return cell;
//        }
//        
//        return cell;
//    }
    return nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isSearchHistoryData)
    {
        return 44;
    }
    else
    {
        return 90;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.view endEditing:YES];
//    [_searchBar resignFirstResponder];
//    if (_isSearchHistoryData)
//    {
//        if ([ZXUD boolForKey:@"NetDataState"])
//        {
//            if (indexPath.row != _searchHistoryArr.count)
//            {
//                _searchBar.text = _searchHistoryArr[indexPath.row];
//                [self searchCoachOrSchoolAction];
//            }
//        }
//        else
//        {
//            [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
//        }
//        _isSearchHistoryData = YES;
//        
//    }
//    else if (_isSearchCoach)
//    {
//       ZXViewController_dierban_jiaxiaoxiangqing *jiaoXiaoVC = [[ZXViewController_dierban_jiaxiaoxiangqing alloc] init];
//        jiaoXiaoVC.hidesBottomBarWhenPushed = YES;
//        ZXCoachList *list = [_searchResultArr objectAtIndex:indexPath.row];
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        jiaoXiaoVC.sid = list.id;
//        [self.navigationController pushViewController:jiaoXiaoVC animated:YES];
//        
//        //搜索历史的处理
//        NSArray *oldHistoryArr = [ZXUD arrayForKey:ZXSearchHistory_Coach];
//        NSMutableArray *newHistoryArr = [NSMutableArray array];
//        if (![oldHistoryArr containsObject:list.name]) {
//            [newHistoryArr addObject:list.name];
//            [newHistoryArr addObjectsFromArray:oldHistoryArr];
//            while (newHistoryArr.count > 10) {
//                [newHistoryArr removeLastObject];
//            }
//            NSArray *saveArr = [NSArray arrayWithArray:newHistoryArr];
//            [ZXUD setObject:saveArr forKey:ZXSearchHistory_Coach];
//            [ZXUD synchronize];
//        }
//        _isSearchHistoryData = NO;
//    }
//    else
//    {
//        ZXViewController_dierban_jiaxiaoxiangqing *jiaoXiaoVC = [[ZXViewController_dierban_jiaxiaoxiangqing alloc] init];
//        
//        jiaoXiaoVC.sid = _searchResultArr[indexPath.row][@"id"];
//        jiaoXiaoVC.hidesBottomBarWhenPushed = YES;
//        //#warning 传入驾校的模型
//        [self.navigationController pushViewController:jiaoXiaoVC animated:YES];
//        
//        //搜索历史的处理
//        NSArray *oldHistoryArr = [ZXUD arrayForKey:ZXSearchHistory_School];
//        NSMutableArray *newHistoryArr = [NSMutableArray array];
//        
//        if (![oldHistoryArr containsObject:_searchResultArr[indexPath.row][@"name"]]) {
//            [newHistoryArr addObject:_searchResultArr[indexPath.row][@"name"]];
//            [newHistoryArr addObjectsFromArray:oldHistoryArr];
//            while (newHistoryArr.count > 10) {
//                [newHistoryArr removeLastObject];
//            }
//            NSArray *saveArr = [NSArray arrayWithArray:newHistoryArr];
//            [ZXUD setObject:saveArr forKey:ZXSearchHistory_School];
//            [ZXUD synchronize];
//        }
//         _isSearchHistoryData = NO;
//    }
//   
//    
//}
//- (void)deleteHistorySearch {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空历史记录" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        //清空搜索记录
//        NSArray *arr = [[NSArray alloc] init];
//        if (_isSearchCoach) {
//            [ZXUD setObject:arr forKey:ZXSearchHistory_Coach];
//        } else {
//            [ZXUD setObject:arr forKey:ZXSearchHistory_School];
//        }
//        [self getSearchHistoryData];
//        [self.tableView reloadData];
//    }];
//    
//    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }];
//    
//    [alert addAction:alertAction];
//    [alert addAction:anotherAction];
//    [self presentViewController:alert animated:YES completion:^{
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark-搜索框的代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        _isSearchHistoryData = YES;
        
    } else {
        _isSearchHistoryData = NO;
    }
    [self.tableView reloadData];
}

- (void)setIsSearchHistoryData:(BOOL)isSearchHistoryData {
    _isSearchHistoryData = isSearchHistoryData;
    [self getSearchHistoryData];
    [_tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchCoachOrSchoolAction];
    [_searchBar endEditing:YES];
}

@end
