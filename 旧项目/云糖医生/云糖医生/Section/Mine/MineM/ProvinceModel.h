//
//  ProvinceModel.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/21.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *province_id;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSNumber *seq;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
