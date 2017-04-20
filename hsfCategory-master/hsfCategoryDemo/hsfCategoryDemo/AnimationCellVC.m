//
//  AnimationCellVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/23.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "AnimationCellVC.h"

#import "AnimationCell.h"

@interface AnimationCellVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *identifierCell = @"identifierCell";
@implementation AnimationCellVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UITableViewCell+CellAnimation";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //配置tableView
    [self setUpTableView];
}
//配置tableView
-(void)setUpTableView{
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnimationCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.num.text = [NSString stringWithFormat:@"%ld",indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//>>>>>>>>>>>关键在这<<<<<<<<<<<<<<<<<
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell extendAnimation];
//    [cell shutterAnimation];
    [cell graduatedAnimation];
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
