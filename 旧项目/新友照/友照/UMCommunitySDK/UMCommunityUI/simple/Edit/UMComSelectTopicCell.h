//
//  UMComSelectTopicCell.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/25.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComChangeBorderBtn;

@protocol UMComSelectTopicTableViewCellDelegate <NSObject>

@optional
/**
 *  点击cell的内部的左右控件回调
 *
 *  @param dataRowIndex 代表tableview的datasource的索引
 */
-(void) handleClickedTopicTableViewCell:(NSInteger)dataRowIndex;

@end


@interface UMComSelectTopicCell : UITableViewCell

//对应cell行
@property(nonatomic,assign)NSInteger cellRow;

//左边的话题控件
@property (nonatomic, strong) UMComChangeBorderBtn *leftLabelBtn;

//右边的话题
@property (nonatomic, strong) UMComChangeBorderBtn *rightLabelBtn;

@property (nonatomic,weak)id<UMComSelectTopicTableViewCellDelegate> selectTopicTableViewCellDelegate;


-(void)refresCellWithLeftTopicName:(NSString*)leftTopicName
                withRightTopicName:(NSString*)rightTopicName
                       withCellRow:(NSInteger)cellRow;

@end
