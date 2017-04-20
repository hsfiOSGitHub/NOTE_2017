 //
//  KnowledgeVC.m
//  test
//
//  Created by yuntangyi on 16/10/11.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnowledgeVC.h"

#define WeakSelf __weak typeof(self) weakSelf = self;
//cell
#import "KnCellType1.h"
#import "KnCellType2.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "SystemNewsVC.h"
#import "SZBFmdbManager+meeting.h"
#import "SZBFmdbManager+news.h"
#import "KnMeetingListModel.h"
#import "KnNewsListModel.h"
#import "SZBNetDataManager+KnowLedgeNetData.h"
#import "KnCellType1VC.h"
#import "KnCellType2VC.h"
#import "ValueHelper.h"
#import "SZBFmdbManager+firstSource.h"


@interface KnowledgeVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,KnCellType2Delegate,KnCellType1VCDelegate>
@property (weak, nonatomic) IBOutlet UIButton *meetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn1;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn2;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn3;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UITableView *tableView4;
//底线
@property (strong, nonatomic) UIView *baseline;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (nonatomic,strong) UITableView *currentTableView;//当前tableView
@property (nonatomic,strong) NSString *currentPid;//当前资讯pid
@property (nonatomic,strong) NSMutableArray *pageArr;//
@property (nonatomic,strong) NSMutableArray *sourceArr;//数据源
@property (nonatomic,strong) NSMutableArray *sourceArrArr_meeting;//装数组到数据源
@property (nonatomic,strong) NSMutableArray *sourceArrArr_news1;
@property (nonatomic,strong) NSMutableArray *sourceArrArr_news2;
@property (nonatomic,strong) NSMutableArray *sourceArrArr_news3;
@property (nonatomic,strong) NSMutableArray *loadFirstTimeArr;//用于判断是否是第一次加载数据

//数据源
@property (nonatomic,strong) NSMutableArray *source_meeting;//
@property (nonatomic,strong) NSMutableArray *source_news1;//
@property (nonatomic,strong) NSMutableArray *source_news2;//
@property (nonatomic,strong) NSMutableArray *source_news3;//


@property (nonatomic,strong) LoadingView *loadingView1;//加载中动画
@property (nonatomic,strong) LoadingView *loadingView2;//加载中动画
@property (nonatomic,strong) LoadingView *loadingView3;//加载中动画
@property (nonatomic,strong) LoadingView *loadingView4;//加载中动画
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView1;//加载失败图片
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView2;//加载失败图片
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView3;//加载失败图片
@property (nonatomic,strong) NetworkLoadFailureView *loadFailureView4;//加载失败图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView1;//数据为空图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView2;//数据为空图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView3;//数据为空图片
@property (nonatomic, strong)KongPlaceHolderView *placeholdView4;//数据为空图片
//用于防止频繁请求数据
@property (nonatomic,assign) BOOL loadNew_meeting;
@property (nonatomic,assign) BOOL loadMore_meeting;
@property (nonatomic,assign) BOOL loadNew_news1;
@property (nonatomic,assign) BOOL loadMore_news1;
@property (nonatomic,assign) BOOL loadNew_news2;
@property (nonatomic,assign) BOOL loadMore_news2;
@property (nonatomic,assign) BOOL loadNew_news3;
@property (nonatomic,assign) BOOL loadMore_news3;

@property (nonatomic,strong) NSString *oldPage_meeting;
@property (nonatomic,strong) NSString *oldPage_news1;
@property (nonatomic,strong) NSString *oldPage_news2;
@property (nonatomic,strong) NSString *oldPage_news3;

@property (nonatomic,strong) UILabel *alertLabel;

//系统消息
@property (nonatomic,strong) UIButton *systemMessageBtn;//系统消息按钮
@property (nonatomic,strong) UILabel *numLabel;//系统消息个数

@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
@implementation KnowledgeVC
#pragma mark -懒加载
-(void)dismissAlertLabel{
    self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight, 150, 40)];
        _alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight + 20);
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.layer.cornerRadius = 5;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.backgroundColor = [UIColor darkGrayColor];
        _alertLabel.font = [UIFont systemFontOfSize:15];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_alertLabel];
    }
    return _alertLabel;
}
-(NSMutableArray *)pageArr{
    if (!_pageArr) {
        _pageArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];
    }
    return _pageArr;
}
//数据源
-(NSMutableArray *)source_meeting{
    if (!_source_meeting) {
        _source_meeting = [NSMutableArray array];
    }
    return _source_meeting;
}
-(NSMutableArray *)source_news1{
    if (!_source_news1) {
        _source_news1 = [NSMutableArray array];
    }
    return _source_news1;
}
-(NSMutableArray *)source_news2{
    if (!_source_news2) {
        _source_news2 = [NSMutableArray array];
    }
    return _source_news2;
}
-(NSMutableArray *)source_news3{
    if (!_source_news3) {
        _source_news3 = [NSMutableArray array];
    }
    return _source_news3;
}


-(NSMutableArray *)sourceArr{
    if (!_sourceArr) {
        NSArray *arr1 = [NSArray array];
        NSArray *arr2 = [NSArray array];
        NSArray *arr3 = [NSArray array];
        NSArray *arr4 = [NSArray array];
        _sourceArr = [NSMutableArray arrayWithObjects:arr1, arr2, arr3, arr4, nil];
    }
    return _sourceArr;
}
-(NSMutableArray *)sourceArrArr_meeting{
    if (!_sourceArrArr_meeting) {
        NSArray *arr = [NSArray array];
        _sourceArrArr_meeting = [NSMutableArray arrayWithObject:arr];
    }
    return _sourceArrArr_meeting;
}
-(NSMutableArray *)sourceArrArr_news1{
    if (!_sourceArrArr_news1) {
        NSArray *arr = [NSArray array];
        _sourceArrArr_news1 = [NSMutableArray arrayWithObject:arr];
    }
    return _sourceArrArr_news1;
}
-(NSMutableArray *)sourceArrArr_news2{
    if (!_sourceArrArr_news2) {
        NSArray *arr = [NSArray array];
        _sourceArrArr_news2 = [NSMutableArray arrayWithObject:arr];
    }
    return _sourceArrArr_news2;
}
-(NSMutableArray *)sourceArrArr_news3{
    if (!_sourceArrArr_news3) {
        NSArray *arr = [NSArray array];
        _sourceArrArr_news3 = [NSMutableArray arrayWithObject:arr];
    }
    return _sourceArrArr_news3;
}
-(NSMutableArray *)loadFirstTimeArr{
    if (!_loadFirstTimeArr) {
        _loadFirstTimeArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];
    }
    return _loadFirstTimeArr;
}

//oldPage
-(NSString *)oldPage_meeting{
    if (!_oldPage_meeting) {
        _oldPage_meeting = self.pageArr[1];
    }
    return _oldPage_meeting;
}
-(NSString *)oldPage_news1{
    if (!_oldPage_news1) {
        _oldPage_news1 = self.pageArr[0];
    }
    return _oldPage_news1;
}
-(NSString *)oldPage_news2{
    if (!_oldPage_news2) {
        _oldPage_news2 = self.pageArr[2];
    }
    return _oldPage_news2;
}
-(NSString *)oldPage_news3{
    if (!_oldPage_news3) {
        _oldPage_news3 = self.pageArr[3];
    }
    return _oldPage_news3;
}

#pragma mark -数据请求
//今日热点
-(void)loadNews1ListDataWithPage:(NSString *)page{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //用于防止频繁刷新
        self.loadNew_news1 = NO;
        self.loadMore_news1 = NO;
        [self.tableView1.mj_header endRefreshing];
        [self.tableView1.mj_footer endRefreshing];
        //加载失败的话page不增加
        [self.pageArr replaceObjectAtIndex:0 withObject:self.oldPage_news1];
        //移除空数据图片
        [_placeholdView1 removeFromSuperview];
        //停止加载中动画
        [self.loadingView1 dismiss];
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        [_loadFailureView1 removeFromSuperview];
        _loadFailureView1.userInteractionEnabled = NO;
        [_loadFailureView1.loadAgainBtn setBackgroundColor:[UIColor whiteColor]];
        [_loadFailureView1.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_loadFailureView1.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _loadFailureView1.userInteractionEnabled = YES;
            [_loadFailureView1.loadAgainBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
            [_loadFailureView1.loadAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loadFailureView1.loadAgainBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        });
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        NSLog(@"%@", [NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"1"]);
        manager.responseSerializer.acceptableContentTypes = set;
        [manager GET:[NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"1"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //用于防止频繁刷新
            self.loadNew_news1 = NO;
            self.loadMore_news1 = NO;
            //加载失败图片
            [_loadFailureView1 removeFromSuperview];
            //移除空数据图片
            [_placeholdView1 removeFromSuperview];
            //网络请求成功
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                //数据
                NSArray *listArr = responseObject[@"newslist"];
                if (listArr != nil && [listArr isKindOfClass:[NSArray class]] && ![listArr isEqual:@""] && listArr.count>0) {
                    //数据转模型
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in listArr) {
                        KnNewsListModel *listModel = [KnNewsListModel modelWithDict:dict];
                        [tempArr addObject:listModel];
                    }
                    if ([page isEqualToString:@"0"]) {
                        NSString *pageStr = self.pageArr[0];
                        NSInteger page = [pageStr integerValue];
                        page = 0;
                        [self.pageArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
                        [self.source_news1 removeAllObjects];
                        
                    }
                    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.source_news1 addObject:obj];
                    }];
                }else{
                    NSInteger newPage = [page integerValue];
                    newPage--;
                    [self.pageArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",newPage]];
                    //重置－－不可以加载数据了
                    self.loadMore_news1 = YES;
                }
                //数据源为空
                if (self.source_news1.count == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _placeholdView1 = [[KongPlaceHolderView alloc]initWithFrame:self.tableView1.frame];
                        _placeholdView1.label.text = @"暂无热点资讯";
                        [self.bgView addSubview:_placeholdView1];
                    });
                }
            }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //让用户重新登录
                    [ZXUD setObject:nil forKey:@"ident_code"];
                    LoginVC *VC = [[LoginVC alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                    [self presentViewController:navi animated:YES completion:nil];
                }];
                [alert addAction:anotherAction];
                [self presentViewController:alert animated:YES completion:^{}];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else{
                NSString *message = responseObject[@"msg"];
                [MBProgressHUD showError:message];
            }
            //加载中停止
            [_loadingView1 dismiss];
            
            
            [self.tableView1.mj_header endRefreshing];
            [self.tableView1.mj_footer endRefreshing];
            [self.tableView1 reloadData];//刷新UI
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络请求失败
            
            //用于防止频繁刷新
            self.loadNew_news1 = NO;
            self.loadMore_news1 = NO;
            [self.tableView1.mj_header endRefreshing];
            [self.tableView1.mj_footer endRefreshing];
            //加载失败的话page不增加
            [self.pageArr replaceObjectAtIndex:0 withObject:self.oldPage_news1];
            //移除空数据图片
            [_placeholdView1 removeFromSuperview];
            //停止加载中动画
            [self.loadingView1 dismiss];
            //加载失败图片
            if (self.source_news1.count == 0)  {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_loadFailureView1 removeFromSuperview];
                    _loadFailureView1 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView1.frame];
                    [self.bgView addSubview:self.loadFailureView1];
                    [self.loadFailureView1.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news1) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
            
            NSLog(@"%@",error);
        }];
    }
}
//点击重新加载
-(void)loadAgainBtnAction_news1{
    [self loadNews1ListDataWithPage:@"0"];
}
//医学会议
-(void)loadMeetingListDataWithPage:(NSString *)page{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //加载失败的话page不增加
        [self.pageArr replaceObjectAtIndex:1 withObject:self.oldPage_meeting];
        //移除空数据图片
        [_placeholdView2 removeFromSuperview];
        //加载中停止
        [_loadingView2 dismiss];
        self.loadNew_meeting = NO;
        self.loadMore_meeting = NO;
        [self.tableView2.mj_footer endRefreshing];
        [self.tableView2.mj_header endRefreshing];
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        [_loadFailureView2 removeFromSuperview];
        
        _loadFailureView2.userInteractionEnabled = NO;
        [_loadFailureView2.loadAgainBtn setBackgroundColor:[UIColor whiteColor]];
        [_loadFailureView2.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_loadFailureView2.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _loadFailureView2.userInteractionEnabled = YES;
            [_loadFailureView2.loadAgainBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
            [_loadFailureView2.loadAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loadFailureView2.loadAgainBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        });
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        NSLog(@"%@", [NSString stringWithFormat:SMeeting_list_Url,[ToolManager getCurrentTimeStamp] ,[ZXUD objectForKey:@"ident_code"] , page]);
        manager.responseSerializer.acceptableContentTypes = set;
        [manager GET:[NSString stringWithFormat:SMeeting_list_Url,[ToolManager getCurrentTimeStamp] ,[ZXUD objectForKey:@"ident_code"] , page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //加载失败图片
            [_loadFailureView2 removeFromSuperview];
            //移除空数据图片
            [_placeholdView2 removeFromSuperview];
            //用于防止频繁刷新
            self.loadNew_meeting = NO;
            self.loadMore_meeting = NO;
            
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                //数据
                NSArray *listArr = responseObject[@"list"];
                if (listArr != nil && ![listArr isEqual:@""] && [listArr isKindOfClass:[NSArray class]] && listArr.count > 0) {
                    //数据转模型
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in listArr) {
                        KnMeetingListModel *listModel = [KnMeetingListModel modelWithDict:dict];
                        [tempArr addObject:listModel];
                    }
                    if ([page isEqualToString:@"0"]) {
                        NSString *pageStr = self.pageArr[1];
                        NSInteger page = [pageStr integerValue];
                        page = 0;
                        [self.pageArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
                        //重新赋值第一页数据
                        [self.source_meeting removeAllObjects];
                    }
                    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.source_meeting addObject:obj];
                    }];
                }else{
                    NSInteger newPage = [page integerValue];
                    newPage--;
                    [self.pageArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",newPage]];
                    //重置－－不可以加载数据了
                    self.loadMore_meeting = YES;
                }
                //数据为空
                if (self.source_meeting.count == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _placeholdView2 = [[KongPlaceHolderView alloc]initWithFrame:self.tableView2.frame];
                        _placeholdView2.label.text = @"暂无医学会议";
                        [self.bgView addSubview:_placeholdView2];
                    });
                }
            }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //让用户重新登录
                    [ZXUD setObject:nil forKey:@"ident_code"];
                    LoginVC *VC = [[LoginVC alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                    [self presentViewController:navi animated:YES completion:nil];
                }];
                [alert addAction:anotherAction];
                [self presentViewController:alert animated:YES completion:^{}];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else if ([responseObject[@"res"] isEqualToString:@"100666"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _placeholdView2 = [[KongPlaceHolderView alloc]initWithFrame:self.tableView2.frame];
                    _placeholdView2.label.text = @"您还没有认证成功，无法查看该内容";
                    [self.bgView addSubview:_placeholdView2];
                });
            }else{
                NSString *message = responseObject[@"msg"];
                [MBProgressHUD showError:message];
            }
            //加载中停止
            [_loadingView2 dismiss];
            
            [self.tableView2.mj_footer endRefreshing];
            [self.tableView2.mj_header endRefreshing];
            [self.tableView2 reloadData];//刷新UI
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络请求失败
            //加载失败的话page不增加
            [self.pageArr replaceObjectAtIndex:1 withObject:self.oldPage_meeting];
            //移除空数据图片
            [_placeholdView2 removeFromSuperview];
            //加载中停止
            [_loadingView2 dismiss];
            self.loadNew_meeting = NO;
            self.loadMore_meeting = NO;
            [self.tableView2.mj_footer endRefreshing];
            [self.tableView2.mj_header endRefreshing];
            //加载失败图片
            if (self.source_meeting.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_loadFailureView2 removeFromSuperview];
                    _loadFailureView2 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView2.frame];
                    [self.bgView addSubview:self.loadFailureView2];
                    [self.loadFailureView2.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_meeting) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
            
            NSLog(@"%@",error);
        }];
    }
}
//点击重新加载
-(void)loadAgainBtnAction_meeting{
    [self loadMeetingListDataWithPage:@"0"];
}

//医学新闻
-(void)loadNews2ListDataWithPage:(NSString *)page{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //停止加载中动画
        [self.loadingView3 dismiss];
        //用于防止频繁刷新
        self.loadNew_news2 = NO;
        self.loadMore_news2 = NO;
        [self.tableView3.mj_header endRefreshing];
        [self.tableView3.mj_footer endRefreshing];
        //加载失败的话page不增加
        [self.pageArr replaceObjectAtIndex:2 withObject:self.oldPage_news2];
        //移除空数据图片
        [_placeholdView3 removeFromSuperview];
        
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        [_loadFailureView3 removeFromSuperview];
        //移除空数据图片
        [_placeholdView3 removeFromSuperview];
        
        _loadFailureView3.userInteractionEnabled = NO;
        [_loadFailureView3.loadAgainBtn setBackgroundColor:[UIColor whiteColor]];
        [_loadFailureView3.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_loadFailureView3.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _loadFailureView3.userInteractionEnabled = YES;
            [_loadFailureView3.loadAgainBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
            [_loadFailureView3.loadAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loadFailureView3.loadAgainBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        });
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        NSLog(@"%@", [NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"2"]);
        manager.responseSerializer.acceptableContentTypes = set;
        [manager GET:[NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"2"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //用于防止频繁刷新
            self.loadNew_news2 = NO;
            self.loadMore_news2 = NO;
            //加载失败图片
            [_loadFailureView3 removeFromSuperview];
            //移除空数据图片
            [_placeholdView3 removeFromSuperview];
            //网络请求成功
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                //数据
                NSArray *listArr = responseObject[@"newslist"];
                if (listArr != nil && [listArr isKindOfClass:[NSArray class]] && ![listArr isEqual:@""] && listArr.count>0) {
                    //数据转模型
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in listArr) {
                        KnNewsListModel *listModel = [KnNewsListModel modelWithDict:dict];
                        [tempArr addObject:listModel];
                    }
                    if ([page isEqualToString:@"0"]) {
                        NSString *pageStr = self.pageArr[2];
                        NSInteger page = [pageStr integerValue];
                        page = 0;
                        [self.pageArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
                        [self.source_news2 removeAllObjects];
                    }
                    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.source_news2 addObject:obj];
                    }];
                }else{
                    NSInteger newPage = [page integerValue];
                    newPage--;
                    [self.pageArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",newPage]];
                    //重置－－不可以加载数据了
                    self.loadMore_news2 = YES;
                }
                //数据源为空
                if (self.source_news2.count == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _placeholdView3 = [[KongPlaceHolderView alloc]initWithFrame:self.tableView3.frame];
                        _placeholdView3.label.text = @"暂无医学新闻";
                        [self.bgView addSubview:_placeholdView3];
                    });
                }
            }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //让用户重新登录
                    [ZXUD setObject:nil forKey:@"ident_code"];
                    LoginVC *VC = [[LoginVC alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                    [self presentViewController:navi animated:YES completion:nil];
                }];
                [alert addAction:anotherAction];
                [self presentViewController:alert animated:YES completion:^{}];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else{
                NSString *message = responseObject[@"msg"];
                [MBProgressHUD showError:message];
            }
            //加载中停止
            [_loadingView3 dismiss];
            
            [self.tableView3.mj_header endRefreshing];
            [self.tableView3.mj_footer endRefreshing];
            [self.tableView3 reloadData];//刷新UI
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络请求失败
            //停止加载中动画
            [self.loadingView3 dismiss];
            //用于防止频繁刷新
            self.loadNew_news2 = NO;
            self.loadMore_news2 = NO;
            [self.tableView3.mj_header endRefreshing];
            [self.tableView3.mj_footer endRefreshing];
            //加载失败的话page不增加
            [self.pageArr replaceObjectAtIndex:2 withObject:self.oldPage_news2];
            //移除空数据图片
            [_placeholdView3 removeFromSuperview];
            //加载失败图片
            if (self.source_news2.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_loadFailureView3 removeFromSuperview];
                    _loadFailureView3 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView3.frame];
                    [self.bgView addSubview:self.loadFailureView3];
                    [self.loadFailureView3.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news2) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
            
            NSLog(@"%@",error);
        }];
    }
}
//点击重新加载
-(void)loadAgainBtnAction_news2{
    [self loadNews2ListDataWithPage:@"0"];
}

//医学指南
-(void)loadNews3ListDataWithPage:(NSString *)page{
    //判断网络状态，网络不可用时直接显示网络状态
    if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
        //用于防止频繁刷新
        self.loadNew_news3 = NO;
        self.loadMore_news3 = NO;
        [self.tableView4.mj_header endRefreshing];
        [self.tableView4.mj_footer endRefreshing];
        //加载失败的话page不增加
        [self.pageArr replaceObjectAtIndex:3 withObject:self.oldPage_news3];
        //移除空数据图片
        [_placeholdView4 removeFromSuperview];
        //停止加载中动画
        [self.loadingView4 dismiss];
        
        [MBProgressHUD showError:@"请检查您的网络"];
    }else{
        [_loadFailureView4 removeFromSuperview];
        
        _loadFailureView4.userInteractionEnabled = NO;
        [_loadFailureView4.loadAgainBtn setBackgroundColor:[UIColor whiteColor]];
        [_loadFailureView4.loadAgainBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
        [_loadFailureView4.loadAgainBtn setTitle:@"努力加载中.." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _loadFailureView4.userInteractionEnabled = YES;
            [_loadFailureView4.loadAgainBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
            [_loadFailureView4.loadAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_loadFailureView4.loadAgainBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        });
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        NSLog(@"%@", [NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"3"]);
        manager.responseSerializer.acceptableContentTypes = set;
        [manager GET:[NSString stringWithFormat:SNews_list_Url, [ToolManager getCurrentTimeStamp] , page, [ZXUD objectForKey:@"ident_code"], @"3"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //用于防止频繁刷新
            self.loadNew_news3 = NO;
            self.loadMore_news3 = NO;
            //加载失败图片
            [_loadFailureView4 removeFromSuperview];
            //移除空数据图片
            [_placeholdView4 removeFromSuperview];
            //网络请求成功
            if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                //数据
                NSArray *listArr = responseObject[@"newslist"];
                if (listArr != nil && [listArr isKindOfClass:[NSArray class]] && ![listArr isEqual:@""] && listArr.count>0) {
                    //数据转模型
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (NSDictionary *dict in listArr) {
                        KnNewsListModel *listModel = [KnNewsListModel modelWithDict:dict];
                        [tempArr addObject:listModel];
                    }
                    if ([page isEqualToString:@"0"]) {
                        NSString *pageStr = self.pageArr[3];
                        NSInteger page = [pageStr integerValue];
                        page = 0;
                        [self.pageArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
                        [self.source_news3 removeAllObjects];
                    }
                    [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.source_news3 addObject:obj];
                    }];
                }else{
                    NSInteger newPage = [page integerValue];
                    newPage--;
                    [self.pageArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",newPage]];
                    //重置－－不可以加载数据了
                    self.loadMore_news3 = YES;
                }
                //数据源为空
                if (self.source_news3.count == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _placeholdView4 = [[KongPlaceHolderView alloc]initWithFrame:self.tableView4.frame];
                        _placeholdView4.label.text = @"暂无医学指南";
                        [self.bgView addSubview:_placeholdView4];
                    });
                }
            }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //让用户重新登录
                    [ZXUD setObject:nil forKey:@"ident_code"];
                    LoginVC *VC = [[LoginVC alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                    [self presentViewController:navi animated:YES completion:nil];
                }];
                [alert addAction:anotherAction];
                [self presentViewController:alert animated:YES completion:^{}];
            }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
                
            }else{
                NSString *message = responseObject[@"msg"];
                [MBProgressHUD showError:message];
            }
            //加载中停止
            [_loadingView4 dismiss];
            
            [self.tableView4.mj_header endRefreshing];
            [self.tableView4.mj_footer endRefreshing];
            [self.tableView4 reloadData];//刷新UI
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络请求失败
            
            //用于防止频繁刷新
            self.loadNew_news3 = NO;
            self.loadMore_news3 = NO;
            [self.tableView4.mj_header endRefreshing];
            [self.tableView4.mj_footer endRefreshing];
            //加载失败的话page不增加
            [self.pageArr replaceObjectAtIndex:3 withObject:self.oldPage_news3];
            //移除空数据图片
            [_placeholdView4 removeFromSuperview];
            //停止加载中动画
            [self.loadingView4 dismiss];
            //加载失败图片
            if (self.source_news3.count == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_loadFailureView4 removeFromSuperview];
                    _loadFailureView4 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView4.frame];
                    [self.bgView addSubview:self.loadFailureView4];
                    [self.loadFailureView4.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news3) forControlEvents:UIControlEventTouchUpInside];
                });
            }else{
                [MBProgressHUD showError:@"网络请求失败！"];
            }
            
            NSLog(@"%@",error);
        }];
    }
}
//点击重新加载
-(void)loadAgainBtnAction_news3{
    [self loadNews3ListDataWithPage:@"0"];
}

#pragma mark  -添加系统消息
-(void)addSystemNewsBtn{
    //添加系统消息
    _systemMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_systemMessageBtn addTarget:self action:@selector(systemNews) forControlEvents:UIControlEventTouchUpInside];
    [_systemMessageBtn   setImage:[UIImage imageNamed:@"系统消息"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_systemMessageBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)systemNews{
    if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
        SystemNewsVC *systemNews_VC = [[SystemNewsVC alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:systemNews_VC];
        [self presentViewController:navi animated:YES completion:nil];
        
    }else {
        [MBProgressHUD showError:@"当前没有消息"];
    }
}
#pragma mark -viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //添加系统消息个数
    [self getSystemMessageNum];
    //
    if ([ValueHelper sharedHelper].updateKn) {
        self.loadFirstTimeArr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", nil];
        [ValueHelper sharedHelper].updateKn = NO;
    }
    
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ZXUD setObject:self.pageArr forKey:@"pageArr"];
    [ZXUD synchronize];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加系统消息
    [self addSystemNewsBtn];
    //配置scrollVie
    [self setUpScrollView];
    //配置tableView
    [self setUpTableView];
    //添加baseline
    [self addBaseline];
    //加载数据(加载第一页数据) --今日热点
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.currentPid = @"1";
    self.currentTableView = self.tableView1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.loadFirstTimeArr[0] isEqualToString:@"0"]) {
            //判断网络状态，网络不可用时直接显示网络状态
            if ([ZXUD boolForKey:@"NetDataState"]) {
                _loadingView1 = [[LoadingView alloc]initWithFrame:self.tableView1.frame];
                [self.bgView addSubview:_loadingView1];
                [self loadNews1ListDataWithPage:@"0"];
            }else{
                //加载失败图片
                [_loadFailureView1 removeFromSuperview];
                _loadFailureView1 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView1.frame];
                [self.bgView addSubview:self.loadFailureView1];
                [self.loadFailureView1.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news1) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [self.loadFirstTimeArr replaceObjectAtIndex:0 withObject:@"1"];
    });
}



- (void)viewDidAppear:(BOOL)animated {
    NSString *isMeeting = [ZXUD objectForKey:@"isMeeting"];
    if ([isMeeting isEqualToString:@"0"]) {
        [self titleBtnClick:self.meetingBtn];
    }else if ([isMeeting isEqualToString:@"1"]) {
        [self titleBtnClick:self.newsBtn1];
        [ZXUD setObject:@"0" forKey:@"isMeeting"];
    }


}
//配置scrollVie
-(void)setUpScrollView{
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
//配置tableView
-(void)setUpTableView{
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView3.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView4.dataSource = self;
    self.tableView4.delegate = self;
    
    //注册cell
    [self.tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView3 registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView4 registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    
    //高度
    self.tableView1.estimatedRowHeight = 44;
    self.tableView1.rowHeight = UITableViewAutomaticDimension;
    self.tableView2.estimatedRowHeight = 44;
    self.tableView2.rowHeight = UITableViewAutomaticDimension;
    self.tableView3.estimatedRowHeight = 44;
    self.tableView3.rowHeight = UITableViewAutomaticDimension;
    self.tableView4.estimatedRowHeight = 44;
    self.tableView4.rowHeight = UITableViewAutomaticDimension;
    
    //添加上拉 下拉动画
    [self addRefreshView];
}
//添加上拉 下拉动画
-(void)addRefreshView{
    //下啦刷新tableView1
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew_news1) {
            self.loadNew_news1 = YES;
            self.oldPage_news1 = @"0";
            [self loadNews1ListDataWithPage:@"0"];
        }else{
            [self.tableView1.mj_header endRefreshing];
        }
    }];
    //上拉加载tableView1
    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore_news1) {
            self.loadMore_news1 = YES;
            self.oldPage_news1 = self.pageArr[0];
            NSString *pageStr = self.pageArr[0];
            NSInteger page = [pageStr integerValue];
            page++;
            [self.pageArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
            [self loadNews1ListDataWithPage:self.pageArr[0]];
        }else{
            [self.tableView1.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多热点了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
    }];
    
    //下啦刷新tableView2
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew_meeting) {
            self.loadNew_meeting = YES;
            self.oldPage_meeting = @"0";
            [self loadMeetingListDataWithPage:@"0"];
        }else{
            [self.tableView2.mj_header endRefreshing];
        }
    }];
    //上拉加载tableView2
    self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore_meeting) {
            self.loadMore_meeting = YES;
            self.oldPage_meeting = self.pageArr[1];
            NSString *pageStr = self.pageArr[1];
            NSInteger page = [pageStr integerValue];
            page++;
            [self.pageArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
            [self loadMeetingListDataWithPage:self.pageArr[1]];
        }else{
            [self.tableView2.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多医学会议了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
    }];
    
    //下啦刷新tableView3
    self.tableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew_news2) {
            self.loadNew_news2 = YES;
            self.oldPage_news2 = @"0";
            [self loadNews2ListDataWithPage:@"0"];
        }else{
            [self.tableView3.mj_header endRefreshing];
        }
    }];
    //上拉加载tableView3
    self.tableView3.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore_news2) {
            self.loadMore_news2 = YES;
            self.oldPage_news2 = self.pageArr[2];
            NSString *pageStr = self.pageArr[2];
            NSInteger page = [pageStr integerValue];
            page++;
            [self.pageArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
            [self loadNews2ListDataWithPage:self.pageArr[2]];
        }else{
            [self.tableView3.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多医学新闻了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
    }];
    
    //下啦刷新tableView4
    self.tableView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.loadNew_news3) {
            self.loadNew_news3 = YES;
            self.oldPage_news3 = @"0";
            [self loadNews3ListDataWithPage:@"0"];
        }else{
            [self.tableView4.mj_header endRefreshing];
        }
    }];
    //上拉加载tableView4
    self.tableView4.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!self.loadMore_news3) {
            self.loadMore_news3 = YES;
            self.oldPage_news3 = self.pageArr[3];
            NSString *pageStr = self.pageArr[3];
            NSInteger page = [pageStr integerValue];
            page++;
            [self.pageArr replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%ld",(long)page]];
            [self loadNews3ListDataWithPage:self.pageArr[3]];
        }else{
            [self.tableView4.mj_footer endRefreshing];
            self.alertLabel.text = @"没有更多医学指南了";
            [UIView animateWithDuration:0.1 animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                self.alertLabel.center = CGPointMake(self.view.center.x, KScreenHeight - 80);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(dismissAlertLabel) withObject:nil afterDelay:1];
                
            }];
        }
    }];
}
//添加baseline
-(void)addBaseline{
    self.baseline = [[UIView alloc]initWithFrame:CGRectMake(0, 42, KScreenWidth/4, 2)];
    self.baseline.backgroundColor = KRGB(0, 172, 204, 1);
    [self.baseView addSubview:self.baseline];
}
//点击标题
- (IBAction)titleBtnClick:(UIButton *)sender {
    //内容的scrollView滑动
    switch (sender.tag) {
        case 100:{//今日热点
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.currentPid = @"1";
            self.currentTableView = self.tableView1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[0] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView1 = [[LoadingView alloc]initWithFrame:self.tableView1.frame];
                        [self.bgView addSubview:_loadingView1];
                        [self loadNews1ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView1 removeFromSuperview];
                        _loadFailureView1 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView1.frame];
                        [self.bgView addSubview:self.loadFailureView1];
                        [self.loadFailureView1.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news1) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:0 withObject:@"1"];
            });
        }
            break;
        case 101:{//医学会议
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            
            self.currentPid = @"0";
            self.currentTableView = self.tableView2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[1] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView2 = [[LoadingView alloc]initWithFrame:self.tableView2.frame];
                        [self.bgView addSubview:_loadingView2];
                        [self loadMeetingListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView2 removeFromSuperview];
                        _loadFailureView2 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView2.frame];
                        [self.bgView addSubview:self.loadFailureView2];
                        [self.loadFailureView2.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_meeting) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:1 withObject:@"1"];
            });
            
        }
            break;
        case 102:{//医学新闻
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 2, 0) animated:YES];
            self.currentPid = @"2";
            self.currentTableView = self.tableView3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[2] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView3 = [[LoadingView alloc]initWithFrame:self.tableView3.frame];
                        [self.bgView addSubview:_loadingView3];
                        [self loadNews2ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView3 removeFromSuperview];
                        _loadFailureView3 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView3.frame];
                        [self.bgView addSubview:self.loadFailureView3];
                        [self.loadFailureView3.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news2) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:2 withObject:@"1"];
            });
        }
            break;
        case 103:{//医学指南
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 3, 0) animated:YES];
            self.currentPid = @"3";
            self.currentTableView = self.tableView4;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[3] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView4 = [[LoadingView alloc]initWithFrame:self.tableView4.frame];
                        [self.bgView addSubview:_loadingView4];
                        [self loadNews3ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView4 removeFromSuperview];
                        _loadFailureView4 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView4.frame];
                        [self.bgView addSubview:self.loadFailureView4];
                        [self.loadFailureView4.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news3) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:3 withObject:@"1"];
            });
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -UIScrollViewDelegate
//滑动内容
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        //标题的底线滑动
        for (int i = 100; i < 104; i++) {
            UIButton *btn = [self.baseView viewWithTag:i];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        if (scrollView.contentOffset.x <= KScreenWidth/2) {
            [UIView animateWithDuration:0.3 animations:^{
                UIButton *btn = [self.baseView viewWithTag:100];
                [btn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
                self.baseline.frame = CGRectMake(0, 42, KScreenWidth/4, 2);
            }];
        }else if (scrollView.contentOffset.x > KScreenWidth/2 && scrollView.contentOffset.x <= KScreenWidth/2 * 3) {
            [UIView animateWithDuration:0.3 animations:^{
                self.baseline.frame = CGRectMake(KScreenWidth/4, 42, KScreenWidth/4, 2);
                UIButton *btn = [self.baseView viewWithTag:101];
                [btn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
            }];
        }else if (scrollView.contentOffset.x > KScreenWidth/2 * 3 && scrollView.contentOffset.x <= KScreenWidth/2 * 5) {
            [UIView animateWithDuration:0.3 animations:^{
                self.baseline.frame = CGRectMake(KScreenWidth/4 * 2, 42, KScreenWidth/4, 2);
                UIButton *btn = [self.baseView viewWithTag:102];
                [btn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
            }];
        }else if (scrollView.contentOffset.x > KScreenWidth/2 * 5 && scrollView.contentOffset.x <= KScreenWidth/2 * 7) {
            [UIView animateWithDuration:0.3 animations:^{
                self.baseline.frame = CGRectMake(KScreenWidth/4 * 3, 42, KScreenWidth/4, 2);
                UIButton *btn = [self.baseView viewWithTag:103];
                [btn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
            }];
        }
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        //用于更换数据
        if (scrollView.contentOffset.x <= 30) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.currentPid = @"1";
            self.currentTableView = self.tableView1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[0] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView1 = [[LoadingView alloc]initWithFrame:self.tableView1.frame];
                        [self.bgView addSubview:_loadingView1];
                        [self loadNews1ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView1 removeFromSuperview];
                        _loadFailureView1 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView1.frame];
                        [self.bgView addSubview:self.loadFailureView1];
                        [self.loadFailureView1.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news1) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:0 withObject:@"1"];
            });
        }else if (scrollView.contentOffset.x >= KScreenWidth - 30 && scrollView.contentOffset.x < KScreenWidth + 30) {
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
            self.currentPid = @"0";
            self.currentTableView = self.tableView2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[1] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView2 = [[LoadingView alloc]initWithFrame:self.tableView2.frame];
                        [self.bgView addSubview:_loadingView2];
                        [self loadMeetingListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView2 removeFromSuperview];
                        _loadFailureView2 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView2.frame];
                        [self.bgView addSubview:self.loadFailureView2];
                        [self.loadFailureView2.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_meeting) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:1 withObject:@"1"];
            });
            
        }else if (scrollView.contentOffset.x >= KScreenWidth * 2 - 30 && scrollView.contentOffset.x < KScreenWidth * 2 + 30) {
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 2, 0) animated:YES];
            self.currentPid = @"2";
            self.currentTableView = self.tableView3;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[2] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView3 = [[LoadingView alloc]initWithFrame:self.tableView3.frame];
                        [self.bgView addSubview:_loadingView3];
                        [self loadNews2ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView3 removeFromSuperview];
                        _loadFailureView3 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView3.frame];
                        [self.bgView addSubview:self.loadFailureView3];
                        [self.loadFailureView3.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news2) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:2 withObject:@"1"];
            });
            
        }else if (scrollView.contentOffset.x >= KScreenWidth * 3 - 30 && scrollView.contentOffset.x < KScreenWidth * 3 + 30) {
            [self.scrollView setContentOffset:CGPointMake(KScreenWidth * 3, 0) animated:YES];
            self.currentPid = @"3";
            self.currentTableView = self.tableView4;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.loadFirstTimeArr[3] isEqualToString:@"0"]) {
                    //判断网络状态，网络不可用时直接显示网络状态
                    if ([ZXUD boolForKey:@"NetDataState"]) {
                        _loadingView4 = [[LoadingView alloc]initWithFrame:self.tableView4.frame];
                        [self.bgView addSubview:_loadingView4];
                        [self loadNews3ListDataWithPage:@"0"];
                    }else{
                        //加载失败图片
                        [_loadFailureView4 removeFromSuperview];
                        _loadFailureView4 = [[NetworkLoadFailureView alloc]initWithFrame:self.tableView4.frame];
                        [self.bgView addSubview:self.loadFailureView4];
                        [self.loadFailureView4.loadAgainBtn addTarget:self action:@selector(loadAgainBtnAction_news3) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                [self.loadFirstTimeArr replaceObjectAtIndex:3 withObject:@"1"];
            });
        }
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    if (tableView == self.tableView1) {
        num = [self.source_news1 count];
    }else if (tableView == self.tableView2) {
        num = [self.source_meeting count];
    }else if (tableView == self.tableView3) {
        num = [self.source_news2 count];
    }else if (tableView == self.tableView4) {
        num = [self.source_news3 count];
    }
    return num;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView1) {
        KnCellType2 *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        KnNewsListModel *newsListModel = self.source_news1[indexPath.section];
        cell2.listModel = newsListModel;
        return cell2;
    }else if (tableView == self.tableView2) {
        KnCellType1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
        KnMeetingListModel *meetingListModel = self.source_meeting[indexPath.section];
        cell1.listModel = meetingListModel;
        return cell1;
    }else if (tableView == self.tableView3) {
        KnCellType2 *cell3 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        KnNewsListModel *newsListModel = self.source_news2[indexPath.section];
        cell3.listModel = newsListModel;
        return cell3;
    }else if (tableView == self.tableView4) {
        KnCellType2 *cell4 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        KnNewsListModel *newsListModel = self.source_news3[indexPath.section];
        cell4.listModel = newsListModel;
        return cell4;
    }
    return nil;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView2) {
        KnMeetingListModel *meetingListModel = self.source_meeting[indexPath.section];
        KnCellType1VC *cellType1_VC = [[KnCellType1VC alloc]init];
        cellType1_VC.doType = meetingListModel.dotype;
        cellType1_VC.meetingID = meetingListModel.knID;

        cellType1_VC.index = indexPath.section;
        cellType1_VC.delegate = self;

        [self.navigationController pushViewController:cellType1_VC animated:YES];
    }else{
        KnNewsListModel *newsListModel;
        KnCellType2VC *cellType2_VC = [[KnCellType2VC alloc]init];
        if (tableView == self.tableView1) {
            newsListModel = self.source_news1[indexPath.section];
            cellType2_VC.newsIndex = 1;
        }else if (tableView == self.tableView3) {
            newsListModel = self.source_news2[indexPath.section];
            cellType2_VC.newsIndex = 2;
        }else if (tableView == self.tableView4) {
            newsListModel = self.source_news3[indexPath.section];
            cellType2_VC.newsIndex = 3;
        }
        cellType2_VC.newsID = newsListModel.KnID;
        cellType2_VC.BT=newsListModel.title;
        cellType2_VC.NR=newsListModel.content;
        cellType2_VC.TPurl=newsListModel.pic;

        cellType2_VC.url = newsListModel.url;
        cellType2_VC.ispraise = newsListModel.ispraise;
        cellType2_VC.iscollect = newsListModel.iscollect;
        cellType2_VC.delegate = self;
        cellType2_VC.index = indexPath.section;
        [self.navigationController pushViewController:cellType2_VC animated:YES];
        
        [ValueHelper sharedHelper].updateCollect = YES;
    }
}
//section高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

//    if (section == 0) {
//        return 0.1;
//    }
    return 10;
}
#pragma mark -KnCellType2Delegate  从资讯页面返回
//改变收藏状态
-(void)changeIsCollectStateWith:(NSString *)iscollect andNewsIndex:(NSInteger)newsIndex andIndex:(NSInteger)index{
    //把对应的模型中的收藏状态改了
    KnNewsListModel *newsModel;
    if (newsIndex == 1) {
        newsModel = self.source_news1[index];
        newsModel.iscollect = iscollect;
        [self.source_news1 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news1.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"iscollect":iscollect} withDBName:dbName whereCondition:condition];
    }else if (newsIndex == 2) {
        newsModel = self.source_news2[index];
        newsModel.iscollect = iscollect;
        [self.source_news2 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news2.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"iscollect":iscollect} withDBName:dbName whereCondition:condition];
    }else if (newsIndex == 3) {
        newsModel = self.source_news3[index];
        newsModel.iscollect = iscollect;
        [self.source_news3 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news3.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"iscollect":iscollect} withDBName:dbName whereCondition:condition];
    }
    
    [self.currentTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}
//改变点赞状态
-(void)changeIsPraiseStateWith:(NSString *)ispraise andNewsIndex:(NSInteger)newsIndex andIndex:(NSInteger)index{
    //把对应的模型中的收藏状态改了
    KnNewsListModel *newsModel;
    if (newsIndex == 1) {
        newsModel = self.source_news1[index];
        newsModel.ispraise = ispraise;
        [self.source_news1 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news1.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"ispraise":ispraise} withDBName:dbName whereCondition:condition];
    }else if (newsIndex == 2) {
        newsModel = self.source_news2[index];
        newsModel.ispraise = ispraise;
        [self.source_news2 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news2.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"ispraise":ispraise} withDBName:dbName whereCondition:condition];
    }else if (newsIndex == 3) {
        newsModel = self.source_news3[index];
        newsModel.ispraise = ispraise;
        [self.source_news3 replaceObjectAtIndex:index withObject:newsModel];
        //修改数据库中的对应数据收藏状态
        NSString *dbName = @"news3.sqlite";
        NSDictionary *condition = @{@"id":newsModel.KnID};
        [[SZBFmdbManager sharedManager] modifyNewsDataAtDBWith:@{@"ispraise":ispraise} withDBName:dbName whereCondition:condition];
    }
    
    [self.currentTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}

//获取消息数量
- (void)getSystemMessageNum {
    [[SZBNetDataManager manager] remindNumRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"res"] isEqualToString:@"1002"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //让用户重新登录
                [ZXUD setObject:nil forKey:@"ident_code"];
                LoginVC *VC = [[LoginVC alloc] init];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [alert addAction:anotherAction];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            [_numLabel removeFromSuperview];
            _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 - 15, 15/3, 16, 16)];
            [_numLabel setFont:[UIFont systemFontOfSize:10]];
            _numLabel.textColor = [UIColor whiteColor];
            _numLabel.textAlignment = NSTextAlignmentCenter;
            _numLabel.layer.cornerRadius = 8;
            _numLabel.layer.masksToBounds = YES;
            _numLabel.backgroundColor = [UIColor redColor];
            _numLabel.text = responseObject[@"num"];
            if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
                [self.systemMessageBtn addSubview:_numLabel];
            }
        }else if ([responseObject[@"res"] isEqualToString: @"1005"] || [responseObject[@"res"] isEqualToString: @"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failed:^(NSURLSessionTask *task, NSError *error) {
        
    }];
}




#pragma mark -KnCellType1VCDelegate
-(void)updateMeetingWithDoType:(NSString *)doTpye andIndex:(NSInteger)index{
    KnMeetingListModel *meetingListModel = self.source_meeting[index];
    meetingListModel.dotype = doTpye;
    
    [self.tableView2 reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}
-(void)updateMeetingUIWithIndex:(NSInteger)index{
    [self.tableView2 reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
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
