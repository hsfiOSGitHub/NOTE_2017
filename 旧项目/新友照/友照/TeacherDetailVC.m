//
//  TeacherDetailVC.m
//  友照
//
//  Created by monkey2016 on 16/11/25.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "TeacherDetailVC.h"

#import "TeacherDetailCell1.h"
#import "TeacherDetailCell2.h"
#import "TeacherDetailHeader.h"
#import "TeacherDetailCell3.h"

@interface TeacherDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;//预约教练

@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
static NSString *identifierHeader = @"identifierHeader";
@implementation TeacherDetailVC
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置tableView
    [self setUpTableView];
}
//配置tableView
-(void)setUpTableView{
    //数据源代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 44;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherDetailCell1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherDetailCell2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherDetailHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierHeader];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeacherDetailCell3 class]) bundle:nil] forCellReuseIdentifier:identifierCell3];
    
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TeacherDetailCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
        return cell1;
    }else if (indexPath.section == 1) {
        TeacherDetailCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        return cell2;
    }else if (indexPath.section == 2) {
        TeacherDetailCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:identifierCell3 forIndexPath:indexPath];
        return cell3;
    }
    return nil;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
//自定义 section header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        TeacherDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierHeader];
        return header;
    }
    return nil;
}


#pragma mark -点击预约教练
- (IBAction)appointmentBtnAction:(UIButton *)sender {
}

#pragma mark -didReceiveMemoryWarning
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
