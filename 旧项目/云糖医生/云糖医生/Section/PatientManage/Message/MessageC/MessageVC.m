//
//  MessageVC.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/8/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "MessageVC.h"
#import "MessageListCell.h"


@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;//消息列表
@end

@implementation MessageVC

static NSString *identifierMessageCell = @"identifierMessageCell";


#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    //初始化tableView
    [self initTableView];
    
}

//初始化tableView
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 110)style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    //设置数据源代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListCell class]) bundle:nil] forCellReuseIdentifier:identifierMessageCell];
    
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMessageCell];
    //config cell
    //....
    
    return cell;
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EaseMessageViewController *chat_VC = [[EaseMessageViewController alloc]initWithConversationChatter:@"monkey002" conversationType:EMConversationTypeChat];
//    [self.navigationController pushViewController:chat_VC animated:YES];
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
