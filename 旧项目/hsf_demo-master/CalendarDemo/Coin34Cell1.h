//
//  Coin34Cell1.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/11.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Coin34Cell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (nonatomic,assign) NSInteger coinsCount;

@end
