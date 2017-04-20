//
//  ZXTableViewCell.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/16.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXMyClassViewController;

@interface ZXTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *jiaoLianHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *JiaoLianLabel;
//@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;

/*数据源不同 按钮功能不同
 评分功能 取消预约功能 删除功 能
 按钮事件在代理方法里添加
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonInfo;

- (void)setCellWith:(NSDictionary *)model andDataType:(NSString*)dataType;

- (void)setUpButtonState:(NSDictionary *)model;
@end
