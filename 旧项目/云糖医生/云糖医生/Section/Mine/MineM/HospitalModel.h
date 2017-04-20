//
//  HospitalModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalModel : NSObject
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,strong) NSNumber *state;
@property (nonatomic,strong) NSNumber *seq;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;


@end
