//
//  NSDictionary+Json.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/31.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json)


//主要方法
//类型识别:将所有的NSNull类型转化成@""
+(id)safeJsonDicWith:(id)myObj;

@end
