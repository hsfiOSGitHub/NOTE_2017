//
//  StarsView.m
//  StarScoreDemo
//
//  Created by StarLord on 15/7/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

#import "StarsView.h"
#import "StarView.h"

@interface StarsView()
@property (nonatomic, strong) NSMutableArray *starViewArr;
@end


@implementation StarsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}


- (instancetype)initWithStarSize:(CGSize)size space:(CGFloat)space numberOfStar:(NSInteger)number{
    self = [super init];
    if (self) {
        _selectable = YES;
        _starViewArr = [NSMutableArray array];
        self.frame = CGRectMake(0, 0, size.width * number + (number - 1)*space, size.height);
        for (int i = 0; i < number; i ++) {
            StarView *starView = [[StarView alloc] initWithFrame:CGRectMake((space + size.width) * i, 0, size.width, size.height)];
            starView.percent = 1.0;
            starView.backgroundColor = [UIColor clearColor];
            [self addSubview:starView];
            [_starViewArr addObject:starView];
        }
    }
    return self;
}

- (void)setScore:(CGFloat)score{
    _score = score;
    if (score >= _starViewArr.count) {
        _score = _starViewArr.count;
    }else if(score <= 0){
        _score = 0;
    }
    
    NSInteger index = (NSInteger)_score;
    StarView *starView = index == _starViewArr.count?nil:_starViewArr[index];
    
    for (int i = 0; i < _starViewArr.count; i ++) {
        StarView *star = _starViewArr[i];
        if (i < index) {
            star.percent = 1.0;
        }else if(i > index){
            star.percent = 0.0;
        }else{
            CGFloat percent = _score - index;
            starView.percent = percent;
        }
    }

}

- (void)handleTouches:(NSSet *)touches{
    if (!_selectable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    StarView *starView;
    for (StarView *star in _starViewArr) {
        if (star.frame.origin.x <= point.x && star.frame.origin.x + star.frame.size.width >= point.x) {
            starView = star;
            break;
        }
    }
    
    if (!starView) {
        return;
    }
    
    NSInteger index = [_starViewArr indexOfObject:starView];
    for (int i = 0; i < _starViewArr.count; i ++) {
        StarView *star = _starViewArr[i];
        if (i < index) {
            star.percent = 1.0;
        }else if(i > index){
            star.percent = 0.0;
        }else{
            if(_supportDecimal){
                CGFloat percent = (point.x - starView.frame.origin.x)/starView.frame.size.width;
                starView.percent = percent;
            }else{
                starView.percent = 1.0;
            }
      
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self handleTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self handleTouches:touches];
}


@end
