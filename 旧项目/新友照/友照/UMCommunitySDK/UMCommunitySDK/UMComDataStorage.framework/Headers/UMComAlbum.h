//
//  UMComAlbum.h
//  UMCommunity
//
//  Created by umeng on 15/9/23.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

@class UMComUser, UMComImageUrl;

@interface UMComAlbum : UMComModelObject

/**
 相册创建时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 相册唯一ID
 */
@property (nonatomic, retain) NSString * id;

@property (nonatomic,retain)NSString* feed_id;
/**
 保留字段（暂不使用）
 */
@property (nonatomic, retain) NSNumber * seq;
/**
 相册封面
 */
@property (nonatomic, retain) UMComImageUrl *cover;
/**
 相册所有者
 */
@property (nonatomic, retain) UMComUser *user;
/**
 相册图片列表
 */
@property (nonatomic, retain) NSArray<UMComImageUrl *> *image_urls;


@end
