//
//  one_ViewController.h
//  友照
//
//  Created by ZX on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface one_ViewController : UIViewController

@property(nonatomic,strong)NSString* jingdu;//当前所在经度
@property(nonatomic,strong)NSString* weidu;//当前所在纬度
@property(nonatomic,strong)NSString* city;//当前所在纬度
@property (nonatomic, strong)NSMutableArray *dataSource;//消息数据源
@property (nonatomic)NSInteger messageNum;//消息数量


@end
