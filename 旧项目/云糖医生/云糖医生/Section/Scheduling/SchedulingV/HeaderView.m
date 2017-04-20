//
//  HeaderView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/12.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lable];
        [self addSubview:self.numLable];
        [self addSubview:self.imageV];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width - 100, self.frame.size.height)];
    }
    return _lable;
}
-(UIImageView *)imageV {
    if (!_imageV) {
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 35, 8, 25, 25)];
    }
    _imageV.image = [UIImage imageNamed:@"下一步-拷贝"];
    return _imageV;
}
- (UILabel *)numLable {
    if (!_numLable) {
        _numLable = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 75, 0, 40, self.frame.size.height)];
    }
    _numLable.textAlignment = NSTextAlignmentRight;
    
    return _numLable;
}
@end
