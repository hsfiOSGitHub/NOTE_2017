//
//  BaseTableVC.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseTableVC.h"

//cell
#import "BaseCell.h"

@interface BaseTableVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@end

@implementation BaseTableVC


//下拉刷新
//self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    
//}];
//[self.tableView.mj_header endRefreshing];
//上啦加载更多
//self.tableView.mj_footer  = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//    
//}];
//[self.tableView.mj_footer endRefreshing];

#pragma mark -懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.backgroundColor = k_bgViewColor_normal;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
//tableView 的 footer
-(HSFTableFooter *)footer{
    if (!_footer) {
        _footer = [[HSFTableFooter alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    }
    return _footer;
}
//header
-(HSFTableHeader *)header{
    if (!_header) {
        _header = [[HSFTableHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, k_headerHeight)];
    }
    return _header;
}
//搜索
-(HSFSearchTF *)searchTF{
    if (!_searchTF) {
        _searchTF = [HSFSearchTF searchViewWithFrame:CGRectMake(0, 0, kScreenWidth - 150, 40) delegate:self placeholder:@"请输入品牌关键字" placeholderColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] titleColor:[UIColor blackColor] font:15 leftImgName:@"search" isHaveBaseline:YES];
//        _searchTF.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _searchTF;
}


//数据源
-(NSMutableArray *)source{
    if (!_source) {
        _source = [NSMutableArray array];
    }
    return _source;
}


#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableView
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerClass:[BaseCell class] forCellReuseIdentifier:[BaseCell getCellReuseIdentifier]];
    
}


//注册cell cellClassArr
-(void)registerCellWithCellClassArray:(NSArray *)cellClassArr{
    for (int i = 0; i < cellClassArr.count; i++) {
        NSString *cellClassName = cellClassArr[i];
        [self.tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
    }
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseCell getCellReuseIdentifier]];
    return cell;
}
//间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
