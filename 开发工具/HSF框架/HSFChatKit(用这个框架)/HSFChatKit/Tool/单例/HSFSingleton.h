//
//  HSFSingleton.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/25.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#ifndef HSFSingleton_h
#define HSFSingleton_h


#define HSFSingleton_h(name)  +(instancetype)shared##name;


#if __has_feature(objc_arc) // arc环境
#define HSFSingleton_m(name)  +(instancetype)shared##name{ \
static id instance = nil; \
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[self alloc] init];\
});\
return instance;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static id instance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone];\
});\
return instance;\
}\
\
- (id)copyWithZone:(nullable NSZone *)zone{\
return self;\
}
#else // 非arc环境

#define HSFSingleton_m(name)  +(instancetype)shared##name{ \
static id instance = nil; \
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [[self alloc] init];\
});\
return instance;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
static id instance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance = [super allocWithZone:zone];\
});\
return instance;\
}\
\
+ (id)copyWithZone:(nullable NSZone *)zone{\
return self;\
}\
+ (oneway void)release {\
}\
\
+ (instancetype)autorelease {\
return self;\
}\
\
+ (instancetype)retain {\
return self;\
}\
\
+ (NSUInteger)retainCount {\
return 1;\
}
#endif


#endif /* HSFSingleton_h */
