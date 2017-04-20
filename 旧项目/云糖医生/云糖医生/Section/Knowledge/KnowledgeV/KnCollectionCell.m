//
//  KnCollectionCell.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/8/30.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "KnCollectionCell.h"

#import "KnCellType1.h"
#import "KnCellType2.h"
#import "KnMeetingListModel.h"
#import "KnNewsListModel.h"

@interface KnCollectionCell ()
@property (nonatomic,assign) NSInteger m;//news_list
@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
@implementation KnCollectionCell

#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    //设置数据源代理
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    //注册cell
    [self registerCell];
    //高度
    self.myTableView.estimatedRowHeight = 44;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
}
//不断调用setter方法注册cell
-(void)setCurrentTableViewCellType:(KnTableViewCellType)currentTableViewCellType{
    _currentTableViewCellType = currentTableViewCellType;
    [self registerCell];
}
//注册cell
-(void)registerCell{
    switch (self.currentTableViewCellType) {
        case KnCellTypeA:
            [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
            break;
        case KnCellTypeB:
            [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KnCellType2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
            break;
        default:
            break;
    }
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.KnListModelArr count];
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentTableViewCellType) {
        case KnCellTypeA:{
            KnCellType1 *cellA = [tableView dequeueReusableCellWithIdentifier:identifierCell1];
            //获取模型
            KnMeetingListModel *meetingModel = self.KnListModelArr[indexPath.section];
            //将模型传到cell里
            cellA.listModel = meetingModel;
            return cellA;
        }
            break;
        case KnCellTypeB:{
            KnCellType2 *cellB = [tableView dequeueReusableCellWithIdentifier:identifierCell2];
            //获取模型
            KnNewsListModel *meetingModel = self.KnListModelArr[indexPath.section];
            //将模型传到cell里
            cellB.listModel = meetingModel;
            return cellB;
        }
            break;
        default:
            break;
    }
    return nil;
}
////行高
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat rowHeight;
//    switch (self.currentTableViewCellType) {
//        case KnCellTypeA:
//            rowHeight = 180;
//            break;
//        case KnCellTypeB:
//            rowHeight = 120;
//            break;
//        default:
//            break;
//    }
//    return rowHeight;
//}
//header高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}
//footer高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    switch (self.currentTableViewCellType) {
        case KnCellTypeA:{
            //获取模型
            KnMeetingListModel *meetingModel = self.KnListModelArr[indexPath.section];
            NSString *ID = meetingModel.knID;
            [self.agency seletedCellIntoVC1WithID:ID];
        }
            break;
        case KnCellTypeB:{
            KnNewsListModel *newsModel = self.KnListModelArr[indexPath.section];
            NSLog(@"%ld",(long)indexPath.section);
            [self.agency seletedCellIntoVC2WithModel:newsModel andIndex:indexPath.section];
        }
            break;
        default:
            break;
    }
}


@end
