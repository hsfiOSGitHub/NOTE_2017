//
//  PuzzleCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/17.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "PuzzleCell.h"

#define space 5

@implementation PuzzleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    
    self.answerBtn.layer.masksToBounds = YES;
    self.answerBtn.layer.cornerRadius = 6;
    self.answerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.answerBtn.layer.borderWidth = 1;
        
    [self layoutIfNeeded];
}

-(void)setPuzzlePicArr:(NSArray *)puzzlePicArr{
    _puzzlePicArr = puzzlePicArr;
    
    [self.btn1 setImage:puzzlePicArr[0] forState:UIControlStateNormal];
    [self.btn2 setImage:puzzlePicArr[1] forState:UIControlStateNormal];
    [self.btn3 setImage:puzzlePicArr[2] forState:UIControlStateNormal];
    [self.btn4 setImage:puzzlePicArr[3] forState:UIControlStateNormal];
    [self.btn5 setImage:puzzlePicArr[4] forState:UIControlStateNormal];
    [self.btn6 setImage:puzzlePicArr[5] forState:UIControlStateNormal];
    [self.btn7 setImage:puzzlePicArr[6] forState:UIControlStateNormal];
    [self.btn8 setImage:puzzlePicArr[7] forState:UIControlStateNormal];
    [self.btn9 setImage:puzzlePicArr[8] forState:UIControlStateNormal];
}


@end
