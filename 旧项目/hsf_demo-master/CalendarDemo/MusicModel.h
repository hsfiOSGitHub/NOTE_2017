//
//  MusicModel.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic,strong) NSString *musicName;
@property (nonatomic,strong) NSString *singerName;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *singerPic;
@property (nonatomic,strong) NSString *is_playing;
@property (nonatomic,strong) NSString *isLike;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
