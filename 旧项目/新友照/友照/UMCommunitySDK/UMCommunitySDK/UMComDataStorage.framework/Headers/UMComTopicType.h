//
//  UMComTopicType.h
//  UMCommunity
//
//  Created by umeng on 15/11/24.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

@class UMComTopic;

@interface UMComTopicType : UMComModelObject

/**
 话题组别唯一ID
 */
@property (nonatomic, retain) NSString * category_id;
/**
 话题组的创建时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 话题组的名称
 */
@property (nonatomic, retain) NSString * name;
/**
 话题组的描述
 */
@property (nonatomic, retain) NSString * category_description;
/**
 话题组的icon_url
 */
@property (nonatomic, retain) NSString * icon_url;

@end

