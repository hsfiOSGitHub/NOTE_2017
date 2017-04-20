//
//  UMComResourceManager.h
//  UMCommunity
//
//  Created by 张军华 on 16/6/12.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIImage;

typedef NS_ENUM(NSInteger, UMComResourceType)
{
    UMComResourceType_WeiBo,            //< 微博版的资源类型
    UMComResourceType_Forum,            //< 论坛版的资源类型
    UMComResourceType_Simplicity,       //< 简版的资源类型
};

/**
 *  资源管理类
 */
@interface UMComResourceManager : NSObject

/**
 *  设置资源的版本，用于表示当前资源在哪获得
 *
 *  @param resourceType 资源的所属类型
 *  @see UMComResourceType
 *  @discuss 该函数必须在进入获得第一个资源文件之前调用，用来通知获得资源的位置
 */
+(void) setResourceType:(UMComResourceType)resourceType;


/**
 *  获得image的对象
 *
 *  @param imageName image的名字
 *
 *  @return 如果setResourceType的路径有效，即可获得资源
 *  @discuss see setResourceType:
 */
+(UIImage*)UMComImageWithImageName:(NSString*)imageName;

@end
