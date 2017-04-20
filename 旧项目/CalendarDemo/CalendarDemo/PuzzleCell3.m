//
//  PuzzleCell3.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/18.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "PuzzleCell3.h"

@implementation PuzzleCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    [self.btn10 setImage:puzzlePicArr[9] forState:UIControlStateNormal];
    [self.btn11 setImage:puzzlePicArr[10] forState:UIControlStateNormal];
    [self.btn12 setImage:puzzlePicArr[11] forState:UIControlStateNormal];
    [self.btn13 setImage:puzzlePicArr[12] forState:UIControlStateNormal];
    [self.btn14 setImage:puzzlePicArr[13] forState:UIControlStateNormal];
    [self.btn15 setImage:puzzlePicArr[14] forState:UIControlStateNormal];
    [self.btn16 setImage:puzzlePicArr[15] forState:UIControlStateNormal];
    [self.btn17 setImage:puzzlePicArr[16] forState:UIControlStateNormal];
    [self.btn18 setImage:puzzlePicArr[17] forState:UIControlStateNormal];
    [self.btn19 setImage:puzzlePicArr[18] forState:UIControlStateNormal];
    [self.btn20 setImage:puzzlePicArr[19] forState:UIControlStateNormal];
    [self.btn21 setImage:puzzlePicArr[20] forState:UIControlStateNormal];
    [self.btn22 setImage:puzzlePicArr[21] forState:UIControlStateNormal];
    [self.btn23 setImage:puzzlePicArr[22] forState:UIControlStateNormal];
    [self.btn24 setImage:puzzlePicArr[23] forState:UIControlStateNormal];
    [self.btn25 setImage:puzzlePicArr[24] forState:UIControlStateNormal];
    
}


@end
