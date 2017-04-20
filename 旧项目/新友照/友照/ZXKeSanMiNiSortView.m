//
//  ZXKeSanMiNiSortView.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/13.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXKeSanMiNiSortView.h"
@interface ZXKeSanMiNiSortView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) UIView *bgView;
@property (nonatomic) UITableView *sortTableView;
@property (nonatomic, copy) NSArray *dataSoure;
@property (nonatomic) CGRect rect;
@end
@implementation ZXKeSanMiNiSortView

- (instancetype)initWithFrame:(CGRect)frame andSortType:(ZXKeSanMoNiSortType)sortType
{
        self = [super initWithFrame:frame];
        if (self)
        {
            
            _rect = frame;
            _sortType = sortType;
            
            if (_sortType == ZXKeSanMoNiSortTypeAll)
            {
                _dataSoure = @[@"所有车辆",@"皮卡",@"捷达"];
            }
            else if (_sortType == ZXKeSanMoNiSortTypeDefault)
            {
                _dataSoure = @[@"默认排序",@"好评优先",@"排队人数",@"价格最优"];
            }
            [self showUI];
            self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
            
        }
        return self;
}
- (void)showUI
{
    [self addSubview:self.sortTableView];
    [self addSubview:self.bgView];

}
- (void)setSortType:(ZXKeSanMoNiSortType)sortType {
    _sortType = sortType;
    
    if (_sortType == ZXKeSanMoNiSortTypeAll)
    {
        _sortTableView.frame = CGRectMake(_rect.origin.x,0, _rect.size.width, 132);
        _dataSoure = @[@"所有车辆",@"皮卡",@"轿车"];
    }
    else if (_sortType == ZXKeSanMoNiSortTypeDefault)
    {
        _sortTableView.frame = CGRectMake(_rect.origin.x,0, _rect.size.width, 176);

        _dataSoure = @[@"默认排序",@"好评优先",@"价格最优"];
    }
    [_sortTableView reloadData];
}

- (UITableView *)sortTableView
{
    if (_sortTableView == nil)
    {
        _sortTableView = [[UITableView alloc] initWithFrame:CGRectMake(_rect.origin.x,0, _rect.size.width, 160) style:UITableViewStylePlain];
        _sortTableView.dataSource = self;
        _sortTableView.delegate = self;
        [_sortTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _sortTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSoure count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = _dataSoure[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //用block回传值将排序类型传递出去
    if (self.SelectedTypeAll)
    {
        self.SelectedTypeAll(_dataSoure[indexPath.row],_sortType);
    }
    //
    //移除自身
    [self removeFromSuperview];
}


    


@end
