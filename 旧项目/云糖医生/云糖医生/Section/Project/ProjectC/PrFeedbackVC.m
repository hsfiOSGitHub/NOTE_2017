//
//  PrFeedbackVC.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/6.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "PrFeedbackVC.h"
#import "PrFeedbackCell.h"
#import "PrFeedbackDetailVC.h"
#import "SZBNetDataManager+ProjectNetData.h"
#import "PrAnswerListModel.h"

@interface PrFeedbackVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;//数据源
@end

static NSString *identifierFeedbackCell = @"identifierFeedbackCell";
@implementation PrFeedbackVC
#pragma mark -网络请求
-(void)loadAnswer_listData{
    SZBNetDataManager *manager = [SZBNetDataManager manager];
    [manager answer_listWithActivity_id:self.activity_id AndRndstring:[ToolManager getCurrentTimeStamp] AndIdent_code:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        //网络请求成功
        //数据转模型
        NSArray *list = responseObject[@"list"];
        NSMutableArray *temp = [NSMutableArray array];
        if (![list isKindOfClass:[NSArray class]]) {
            return ;
        }
        for (NSDictionary *dict  in list) {
            PrAnswerListModel *answerListModel = [PrAnswerListModel modelWithDict:dict];
            [temp addObject:answerListModel];
        }
        self.source = temp;
        //刷新UI
        [self.tableView reloadData];
    } failed:^(NSURLSessionTask *task, NSError *error) {
        //网络请求失败
        NSLog(@"%@",error);
    }];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置tableView
    [self setUpTableView];
    //加载数据
    [self loadAnswer_listData];
}
//配置tableView
-(void)setUpTableView{
    //设置数据源代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册dell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PrFeedbackCell class]) bundle:nil] forCellReuseIdentifier:identifierFeedbackCell];
    //高度
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.source count];

}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFeedbackCell];
    return cell;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PrFeedbackDetailVC *feedbackDetail_VC = [[PrFeedbackDetailVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackDetail_VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
