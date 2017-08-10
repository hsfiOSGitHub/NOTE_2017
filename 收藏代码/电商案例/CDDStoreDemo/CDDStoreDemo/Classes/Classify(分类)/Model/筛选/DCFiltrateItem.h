//
//  DCFiltrateItem.h
//  CDDMall
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCFiltrateItem : NSObject

@property (nonatomic , copy) NSString *title;
@property (nonatomic , strong) NSArray<NSString *> *header;
@property (nonatomic , strong) NSArray<NSString *> *content;
/** 用于判断当前cell是否展开*/
@property (nonatomic, assign,getter=isOpen) BOOL open;

@end
