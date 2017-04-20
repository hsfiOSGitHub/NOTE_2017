//
//  UMComDataParseModelProtocol.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/6.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol UMComDataParseModelProtocol <NSObject>

@optional

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
 *  @return 调整后的属性dic
 */
-(NSDictionary*)additonAttributeKeyWithDic:(NSDictionary*)dic;

/**
 *  返回一个relationname和relationname对应的class字符串的字典
 *
 *  @return 返回一个relationname和relationname对应的class的字典
 */
-(NSDictionary*)relationClassNameByRelationAttributeKey;


/**
 *  返回一个唯一标示的属性字符串
 *
 *  @return 返回一个唯一标示的属性字符串
 */
+(NSString*)uniquedKey;


/**
 *  预处理的相关的属性
 *
 *  @param dic json的源dic
 *
 *  @return 调整后的属性
 *  @discuss 默认返回jsonDic
 */
+(NSDictionary*)prepareAttributeKeyWithDic:(NSDictionary*)jsonDic;

@end