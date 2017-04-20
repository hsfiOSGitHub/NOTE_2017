//
//  MoreCommentVC.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "MoreCommentVC.h"

#import "ZXCommentTableViewCell.h"

@interface MoreCommentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//数据源
@property (nonatomic,strong) NSMutableArray *source;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic) NSInteger page;
@property (nonatomic) BOOL isNoMore;

@end

static NSString *identifierCell = @"identifierCell";
@implementation MoreCommentVC
#pragma mark -懒加载
-(NSMutableArray *)source
{
    if (!_source)
    {
        _source = [NSMutableArray array];
    }
    return _source;
}

#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"驾校全部评价";
    //配置tableView
    [self setUpTableView];
    //加载所有驾校评论
    [self loadDataAllSchoolComment];
    
}

//配置tablView
-(void)setUpTableView
{
    //数据源代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    //上拉加载
    _tableView.mj_footer = [HSFRefreshAutoGifFooter footerWithRefreshingBlock:^{
        _page += 1;
        if (!_isNoMore)
        {
            [self loadDataAllSchoolComment];
        }
    }];
    
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    NSDictionary *dic = _arr[indexPath.row];
    [cell resetContentLabelFrame:dic];
    [cell setUpCellWith:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _arr[indexPath.row];
    return [ZXCommentTableViewCell calculateContentHeight:dic];
}
#pragma mark -网络请求
-(void)loadDataAllSchoolComment
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSDictionary *parameters = @{@"m":@"school_comment",
                                 @"rndstring":[ZXDriveGOHelper getCurrentTimeStamp],
                                 @"page":[NSString stringWithFormat:@"%ld",(long)_page],
                                 @"sid":self.sid};
    [manager POST:ZX_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_tableView.mj_footer endRefreshing];
        //网络请求成功
        NSString *res = responseObject[@"res"];
        NSString *msg = responseObject[@"msg"];
        if ([res isEqualToString:@"1001"]) {
            //请求成功
            if (!_arr)
            {
                _arr = [NSMutableArray arrayWithArray:responseObject[@"list"]];
            }
            else
            {
                [_arr addObjectsFromArray:responseObject[@"list"]];
            }
            if ([responseObject[@"list"] count] == 0)
            {
                _isNoMore = YES;
            }
            //数据转模型
            NSMutableArray *mtArr = [NSMutableArray array];
            for (NSDictionary *dic in _arr)
            {
                SchoolCommentModel *model = [SchoolCommentModel modelWithDic:dic];
                [mtArr addObject:model];
            }
            //给数据源赋值
            self.source = mtArr;
            //刷表
            [self.tableView reloadData];
        }else if ([res isEqualToString:@"1004"]) {//请求过于频繁
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1005"]) {//缺少必选参数
            [MBProgressHUD showError:msg];
        }else if ([res isEqualToString:@"1006"]) {//排序参数错误
            [MBProgressHUD showError:msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [_tableView.mj_footer endRefreshing];
        //网络请求失败!
        [MBProgressHUD showError:@"网络请求失败!"];
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
