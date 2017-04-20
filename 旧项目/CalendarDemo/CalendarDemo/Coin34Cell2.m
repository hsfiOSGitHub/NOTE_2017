//
//  Coin34Cell2.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "Coin34Cell2.h"

@interface Coin34Cell2 ()<StarRatingViewDelegate>

@property (nonatomic,strong) WSStarRatingView *starRatingView;

@end

@implementation Coin34Cell2

#pragma mark -懒加载
-(WSStarRatingView *)starRatingView{
    if (!_starRatingView) {
        _starRatingView = [[WSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, self.starBgView.width, self.starBgView.height) numberOfStar:5];
        _starRatingView.delegate = self;
        [self.starBgView addSubview:_starRatingView];
    }
    return _starRatingView;
}

-(void)setScore:(CGFloat)score{
    _score = score;
    [self.starRatingView setScore:score withAnimation:YES completion:^(BOOL finished) {
        
    }];
}
#pragma mark -StarRatingViewDelegate
- (void)starRatingView:(WSStarRatingView *)view score:(float)score{
    self.changedScore = score;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.evaluationTV.layer.masksToBounds = YES;
    self.evaluationTV.layer.borderWidth = 1;
    self.evaluationTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.evaluationTV.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
