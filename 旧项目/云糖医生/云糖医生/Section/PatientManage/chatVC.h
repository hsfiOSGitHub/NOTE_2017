//
//  chatVC.h
//  云糖医生
//
//  Created by yuntangyi on 16/8/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatVC : UIViewController
@property(nonatomic,strong)UITableView* tab;
- (NSMutableArray *)loadDataSource;
-(void)hehe;
@end
