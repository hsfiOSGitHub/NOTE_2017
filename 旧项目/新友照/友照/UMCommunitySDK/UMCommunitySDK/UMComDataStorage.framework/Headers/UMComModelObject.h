//
//  UMComModelObject.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/28.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataParseModel.h"


@interface UMComModelObject : UMComJSONModel<UMComDataParseModelProtocol>


+ (id)objectWithObjectId:(NSString *)objectId;

/***********************************************/
/* 以下函数为新版的函数(since 2.6.0) ---begin */
/***********************************************/

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError **)err;

/**
 *  获得对应的relationName的class类型
 *
 *  @param relationName relationName的属性名字
 *
 *  @return 一relationName的class类型
 */
-(Class)relationNameClassTypeWithRelationName:(NSString*)relationName;

#pragma mark - UMComDataParseModelProtocol

/**
 *  返回对象的基本属性的key的数组
 *
 *  @return 返回对象的基本属性的key的数组
 */
-(NSArray*)attributeKeys;

/**
 *  返回对象的relation属性的key的数组
 *
 *  @return 返回对象的relation属性的key的数组
 */-(NSArray*)relationAttributeKeys;

/**
 *  返回基本属性的映射字典
 *
 *  @return 返回基本属性的映射字典
 */
-(NSDictionary *)mappingJsonKeyByAttributeKey;

/**
 *  返回relation属性的映射字典
 *
 *  @return 返回relation属性的映射字典
 */
-(NSDictionary *)mappingJsonKeyByrelationAttributeKey;


/**
 *  基本属性都做好后，最后在调整一次dic
 *
 *  @param dic 通过json整理好的属性dic
 *
 *  @return 调整后的属性dic 默认返回传入dic
 */
-(NSDictionary*)additonAttributeKeyWithDic:(NSDictionary*)dic;

/**
 *  返回一个relationname和relationname对应的class字符串的字典
 *
 *  @return 返回一个relationname和relationname对应的class的字典
 */
-(NSDictionary*)relationClassNameByRelationAttributeKey;


/**
 *  返回一个唯一标示的uniquedKey的数组
 *
 *  @return 返回一个唯一标示的属性数组
 *  @discuss uniquedKey用在如下两个情景(本地和网络，本地的数据的uniquedKey为feedID,网络数据uniquedKey为id)
 *
 */
+(NSArray*)uniquedKeys;

/***********************************************/
/* 以下函数为新版的接口函数(since 2.6.0) ---end */
/***********************************************/

@end
