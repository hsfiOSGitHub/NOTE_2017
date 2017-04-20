//
//  MeBaseChatVC.h
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/8.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeBaseChatVC : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *sourceArr;//数据源
@end
