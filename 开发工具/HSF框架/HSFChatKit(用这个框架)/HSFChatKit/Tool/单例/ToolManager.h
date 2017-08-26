//
//  ToolManager.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/25.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSFSingleton.h"

@interface ToolManager : NSObject

HSFSingleton_h(ToolManager)


/* 数据排空 */
+(id)noEmptyWithObject:(id)object;

@end
