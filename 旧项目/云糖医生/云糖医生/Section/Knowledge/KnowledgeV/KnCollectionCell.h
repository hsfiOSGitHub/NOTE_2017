//
//  KnCollectionCell.h
//  SZB_doctor
//
//  Created by monkey2016 on 16/8/30.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KnTableViewCellType) {
    KnCellTypeA = 0,
    KnCellTypeB,
};

@class KnNewsListModel;
@protocol SeletedCellIntoVC <NSObject>

-(void)seletedCellIntoVC1WithID:(NSString *)meetingID;
-(void)seletedCellIntoVC2WithModel:(KnNewsListModel *)model andIndex:(NSInteger)index;
-(void)seletedCellIntoVC3WithID:(NSString *)NewsID;


@end

@interface KnCollectionCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,assign) KnTableViewCellType currentTableViewCellType;//cell类型
@property (nonatomic,assign) id<SeletedCellIntoVC> agency;//代理
@property (nonatomic,strong) NSArray *KnListModelArr;//网络请求回调后的模型数组//数据源

@end
