//
//  CalecdarCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/22.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalecdarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *todayCircle;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunar;
@property (weak, nonatomic) IBOutlet UIView *spot;

@end
