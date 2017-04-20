//
//  UMComDataParseModelManager.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/6.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataParserModeConfig.h"

@interface UMComDataParseModelManager : NSObject


/**
 *  单例对象
 *
 *  @return UMComDataParseModelManager的实例
 */
+(instancetype)shareManager;


-(void) parserDataWithRespondData:(NSDictionary*)respondData withUMComDataType:(UMComDataType)umComDataType withCompleteBlock:(void(^)(id,NSError*))completeBlock;

-(void) parserDataWithRespondDataArray:(NSArray *)respondData withUMComDataType:(UMComDataType)umComDataType withCompleteBlock:(void(^)(id,NSError*))completeBlock;

-(void) parserDataWithRespondData:(NSDictionary*)respondData withClass:(Class)umcomDataClass withCompleteBlock:(void(^)(id,NSError*))completeBlock;
-(id) parserSyncDataWithRespondData:(NSDictionary*)respondData withClass:(Class)umcomDataClass;

-(void) parserDataWithRespondDataArray:(NSArray*)respondDataArray withItemClass:(Class)itemUMComDataClass withCompleteBlock:(void(^)(id,NSError*))completeBlock;
-(NSArray*) parserSyncDataWithRespondDataArray:(NSArray*)respondDataArray withItemClass:(Class)itemUMComDataClass;

@end
