//
//  LogInApi.h
//  MobileProject 登录请求API
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogInApi : BaseRequestService

- (id)initWithUsername:(NSString *)username password:(NSString *)password;
@end
