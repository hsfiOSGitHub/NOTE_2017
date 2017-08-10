//
//  DCAddressItem.h
//  CDDMall
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "JKDBModel.h"

@interface DCAddressItem : JKDBModel

@property (nonatomic, copy) NSString *adName;

@property (nonatomic, copy) NSString *adPhone;

@property (nonatomic, copy) NSString *adCity;

@property (nonatomic, copy) NSString *adDetail;

/** 是否是默认地址 */
@property (nonatomic,assign)BOOL isDefault;


/** cell行高 */
@property (nonatomic , assign) CGFloat cellHeight;

@end
