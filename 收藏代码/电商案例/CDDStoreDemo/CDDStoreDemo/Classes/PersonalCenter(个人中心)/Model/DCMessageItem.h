//
//  DCMessageItem.h
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCMessageItem : NSObject

/** 标题 */
@property (nonatomic, copy , readonly) NSString *title;
/** 图片 */
@property (nonatomic, copy , readonly) NSString *imageName;
/** 消息 */
@property (nonatomic, copy , readonly) NSString *message;

@end
