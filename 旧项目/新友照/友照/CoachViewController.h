//
//  CoachViewController.h
//  友照
//
//  Created by chaoyang on 16/11/22.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachViewController : ZXSeconBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *passingRateBtn;//通过率高按钮
@property (weak, nonatomic) IBOutlet UIButton *estimateBtn;//评价最好
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;//教龄最长
@property (weak, nonatomic) IBOutlet UIButton *quickerBtn;//拿证最快
@property (weak, nonatomic) IBOutlet UIView *animationView1;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UITableView *tableView4;
@property (nonatomic, copy) NSString *CoachType;//科几的教练
@property (nonatomic, copy) NSString *subject;//科几的教练
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *sid;

@end
