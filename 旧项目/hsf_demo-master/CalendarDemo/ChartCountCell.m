//
//  ChartCountCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ChartCountCell.h"


@implementation ChartCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(void)setPercent:(CGFloat)percent{
    _percent = percent;
    //星星
    WSStarRatingView *starRatingView = [[WSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, self.starView.width, self.starView.height) numberOfStar:5];
    starRatingView.delegate = self;
    [self.starView addSubview:starRatingView];
    
    [starRatingView setScore:percent withAnimation:YES completion:^(BOOL finished) {
        
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
