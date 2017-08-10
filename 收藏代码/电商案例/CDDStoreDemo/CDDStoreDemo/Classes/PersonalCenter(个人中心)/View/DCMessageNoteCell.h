//
//  DCMessageNoteCell.h
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCMessageItem;
@interface DCMessageNoteCell : UITableViewCell

/* 消息模型 */
@property (strong , nonatomic)DCMessageItem *messageItem;

@end
