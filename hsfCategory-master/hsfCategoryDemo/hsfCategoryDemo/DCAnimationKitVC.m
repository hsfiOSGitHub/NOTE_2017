
//
//  DCAnimationKitVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "DCAnimationKitVC.h"

#import "CoordinateManipulationVC.h"
#import "AttentionGrabbersVC.h"
#import "DCAnimationKitIntoVC.h"
#import "DCAnimationKitShowVC.h"

@interface DCAnimationKitVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *source;
@end

@implementation DCAnimationKitVC

#pragma mark -懒加载
-(NSArray *)source{
    if (!_source) {
        _source = @[
                    @"Attention grabbers",
                    @"Intros",
                    @"Outros"];
    }
    return _source;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIView+DCAnimationKit";
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
    self.tableView.rowHeight = 60;
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.source[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        CoordinateManipulationVC *vc = [[CoordinateManipulationVC alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else 
    if (indexPath.row == 0) {
        AttentionGrabbersVC *vc = [[AttentionGrabbersVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        DCAnimationKitIntoVC *vc = [[DCAnimationKitIntoVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        DCAnimationKitShowVC *vc = [[DCAnimationKitShowVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
