//
//  SchoolImageListModel.h
//  友照
//
//  Created by monkey2016 on 16/12/1.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "id": "36",
 "name": "考场一",
 "num": "0",
 "images": []
 },
 */

@interface SchoolImageListModel : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSArray *images;


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;


@end
