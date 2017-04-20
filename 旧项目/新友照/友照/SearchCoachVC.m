//
//  SearchCoachVC.m
//  友照
//
//  Created by chaoyang on 16/11/29.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SearchCoachVC.h"
#import "CoachListTableViewCell.h"
#import "ZXDeleteHistorySeachTableViewCell.h"
#import "ZXNetDataManager+CoachData.h"
#import "ZXCoachDetailVC.h"
@interface SearchCoachVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *searchHistoryArr;
@property (nonatomic) NSMutableArray *searchResultArr;
@property (nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL isSearchHistoryData;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSString *page;
@end

@implementation SearchCoachVC
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    [self ShownavigationItem];
    [self createTableView];

}
- (void) goToBack {
    [self.navigationController popViewControllerAnimated:NO];
}
//tableView的显示
#define searchHistoryCell @"searchHistoryCell"
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.page=[NSString stringWithFormat:@"%ld",[_page integerValue]+1];
        [self seachCoach:[[UIButton alloc]init]];
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchHistoryCell];
    [_tableView registerNib:[UINib nibWithNibName:@"CoachListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CoachListTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ZXDeleteHistorySeachTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXDeleteHistorySeachTableViewCell"];
    [self.view addSubview:_tableView];
}
//导航栏的定制
- (void)ShownavigationItem {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 80, 0)];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"请输入要搜索教练的名字";
    _searchResultArr = [NSMutableArray array];
    _isSearchHistoryData = YES;
    _page = @"0";
    [self getSearchHistoryData];
    self.navigationItem.titleView = _searchBar;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [searchBtn addTarget:self action:@selector(searchCoachAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}
//获取搜索历史的数据源
- (void)getSearchHistoryData {
    //从plist文件获取
    NSArray *arr;
    if([_subject isEqualToString:@"2"])
    {
         arr = [ZXUD objectForKey:@"SearchHistoryCoach2"];
    }
    else
    {
         arr = [ZXUD objectForKey:@"SearchHistoryCoach3"];
    }
    _searchHistoryArr = arr;
    
}
- (void)searchCoachAction:(UIButton*)btn
{
    if ([self.searchBar.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入教练名字"];
        return;
    }
    //取消键盘的第一响应
    [_searchBar endEditing:YES];
    //要改变tableView的样式
    _isSearchHistoryData = NO;
    [_searchResultArr removeAllObjects];
    _page=@"0";
    //搜索教龄
    [self seachCoach:btn];
  
}

- (void)seachCoach:(UIButton*)btn {
    btn.userInteractionEnabled=YES;
    __weak typeof(self) MYSelf = self;
    [[ZXNetDataManager manager]JiaoLianListWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andSubject:self.subject andPage:_page andSort:@"" andName:_searchBar.text andSid:@"" andCity:[ZXUD objectForKey:@"city"] success:^(NSURLSessionDataTask *task, id responseObject) {
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
        if ([jsonDict[@"res"] isEqualToString:@"1001"]) {
          
            if ([jsonDict[@"teacher_list"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *dic in jsonDict[@"teacher_list"]) {
                    [_searchResultArr addObject:dic];
                }
            }
          [MYSelf.tableView reloadData];
            
        }else  if ([jsonDict[@"res"] isEqualToString:@"1002"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            [MYSelf presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:jsonDict[@"msg"]];
            
        }
        [_tableView.mj_footer endRefreshing];
        btn.userInteractionEnabled=NO;
        
    } failed:^(NSURLSessionTask *task, NSError *error) {
        btn.userInteractionEnabled=NO;
        [MBProgressHUD showError:@"网络错误"];
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
            CoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoachListTableViewCell" forIndexPath:indexPath];
            cell.imageV.layer.cornerRadius = 30;
            cell.imageV.layer.masksToBounds = YES;
            //配置cell
            
            NSDictionary *dic = [_searchHistoryArr objectAtIndex:indexPath.row];
            [cell setModel:dic];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _isSearchHistoryData = YES;
            return cell;
        }
    }
    else
    {
        CoachListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoachListTableViewCell" forIndexPath:indexPath];
        cell.imageV.layer.cornerRadius = 30;
        cell.imageV.layer.masksToBounds = YES;
        //配置cell
        NSDictionary *Dic = self.searchResultArr[indexPath.row];
        [cell setModel:Dic];
      
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
            ZXCoachDetailVC *coachVC = [[ZXCoachDetailVC alloc]init];
            NSDictionary *Dic = self.searchHistoryArr[indexPath.row];
            if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
            {
                coachVC.benxiao=YES;
                if ([_subject isEqualToString:@"3"] && [[ZXUD objectForKey:@"usersubject"] isEqualToString:@"3"])
                {
                    coachVC.kesan=YES;
                }
                else
                {
                    coachVC.kesan=NO;
                }
            }
            else
            {
                coachVC.benxiao=NO;
            }
            coachVC.tid = Dic[@"id"];
            coachVC.name = Dic[@"name"];
            [self.navigationController pushViewController:coachVC animated:YES];
        }
    }
    else
    {
        ZXCoachDetailVC *coachVC = [[ZXCoachDetailVC alloc]init];;
        NSDictionary *Dic = self.searchResultArr[indexPath.row];
        if ([Dic[@"school_name"] isEqualToString:[ZXUD objectForKey:@"S_NAME"]])
        {
            coachVC.benxiao=YES;
        }
        else
        {
            coachVC.benxiao=NO;
        }
        if ([_subject isEqualToString:@"3"])
        {
            coachVC.kesan=YES;
        }
        else
        {
            coachVC.kesan=NO;
        }
        coachVC.tid = Dic[@"id"];
        coachVC.name = Dic[@"name"];
        [self.navigationController pushViewController:coachVC animated:YES];
        if ([_subject isEqualToString:@"2"])
        {
            //搜索历史的处理
            NSArray *oldHistoryArr = [ZXUD arrayForKey:@"SearchHistoryCoach2"];
            NSMutableArray *newHistoryArr = [NSMutableArray array];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in oldHistoryArr) {
                
                [arr addObject:dic[@"id"]];
            }
            if (![arr containsObject:Dic[@"id"]]) {
                [newHistoryArr addObject:Dic];
                [newHistoryArr addObjectsFromArray:oldHistoryArr];
                while (newHistoryArr.count > 10) {
                    [newHistoryArr removeLastObject];
                }
                NSArray *saveArr = [NSArray arrayWithArray:newHistoryArr];
                [ZXUD setObject:saveArr forKey:@"SearchHistoryCoach2"];
                [ZXUD synchronize];
            }
        }
        else
        {
            //搜索历史的处理
            NSArray *oldHistoryArr = [ZXUD arrayForKey:@"SearchHistoryCoach3"];
            NSMutableArray *newHistoryArr = [NSMutableArray array];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in oldHistoryArr) {
                
                [arr addObject:dic[@"id"]];
            }
            if (![arr containsObject:Dic[@"id"]]) {
                [newHistoryArr addObject:Dic];
                [newHistoryArr addObjectsFromArray:oldHistoryArr];
                while (newHistoryArr.count > 10) {
                    [newHistoryArr removeLastObject];
                }
                NSArray *saveArr = [NSArray arrayWithArray:newHistoryArr];
                [ZXUD setObject:saveArr forKey:@"SearchHistoryCoach3"];
                [ZXUD synchronize];
            }
        }
    }
}

//清空历史记录
- (void)deleteHistorySearch {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清空历史记录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //清空搜索记录
        NSArray *arr = [[NSArray alloc] init];
        if ([_subject isEqualToString:@"2"])
        {
            [ZXUD setObject:arr forKey:@"SearchHistoryCoach2"];
        }
        else
        {
            [ZXUD setObject:arr forKey:@"SearchHistoryCoach3"];
        }
     
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
        if(indexPath.row==_searchHistoryArr.count)
        {
            return 44;
        }
        else
        {
            return 100;
        }
    }
    else
    {
        return 100;
    }
}

#pragma mark-搜索框的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchCoachAction:[[UIButton alloc]init]];
    
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    
//    if ([searchText isEqualToString:@""]) {
//        _isSearchHistoryData = YES;
//    } else {
//        _isSearchHistoryData = NO;
//    }
//    [self.tableView reloadData];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
