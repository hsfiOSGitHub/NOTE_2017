//
//  Coin34Cell2.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Coin34Cell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *evaluationTV;
@property (weak, nonatomic) IBOutlet UISegmentedControl *feelingSegC;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,assign) CGFloat score;
@property (nonatomic,assign) CGFloat changedScore;

@end
