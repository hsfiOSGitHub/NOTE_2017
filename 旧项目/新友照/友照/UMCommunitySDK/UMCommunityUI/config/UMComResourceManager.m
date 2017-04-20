//
//  UMComResourceManager.m
//  UMCommunity
//
//  Created by 张军华 on 16/6/12.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComResourceManager.h"

static NSString* g_UMComIMGResourcePath = nil;

typedef struct st_UMComIMGResourcePathStruct{
    char* s_IMGResourcePath;
}st_UMComIMGResourcePathStruct;

static st_UMComIMGResourcePathStruct g_UMComIMGResourcePathStruct[] = {
    {"UMComSDKResources.bundle/images/%@"},
    {"UMComSDKResources.bundle/images/%@"},
    {"UMComSimpleSDKResources.bundle/images/%@"},
};

@implementation UMComResourceManager

+(void) setResourceType:(UMComResourceType)resourceType
{
    NSInteger count = sizeof(g_UMComIMGResourcePathStruct)/sizeof(st_UMComIMGResourcePathStruct);
    if (resourceType >= 0 && resourceType < count) {
        
        g_UMComIMGResourcePath =@(g_UMComIMGResourcePathStruct[resourceType].s_IMGResourcePath);
    }
    else{
        g_UMComIMGResourcePath = nil;
    }
}

+(UIImage*)UMComImageWithImageName:(NSString*)imageName
{
    if (g_UMComIMGResourcePath) {
       return  [UIImage imageNamed:[NSString stringWithFormat:g_UMComIMGResourcePath,imageName]];
    }
    else{
        return [UIImage imageNamed:imageName];
    }
}

@end
