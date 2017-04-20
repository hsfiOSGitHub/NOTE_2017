
//
//  DatePicker24HoursView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "DatePicker24HoursView.h"

@interface DatePicker24HoursView ()

@property (nonatomic,strong) NSMutableArray *hoursArr;

@end

@implementation DatePicker24HoursView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (DatePicker24HoursView *)[self loadNibView];
        self.frame = frame;
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}

#pragma mark -awakeFromNib
-(void)awakeFromNib{
    [super awakeFromNib];
    //配置subViews
    [self setUpSubViews];
}
//配置subViews
-(void)setUpSubViews{
    self.date24Picker.dataSource = self;
    self.date24Picker.delegate = self;
}
#pragma mark -懒加载
-(NSMutableArray *)hoursArr{
    if (!_hoursArr) {
        _hoursArr = [NSMutableArray array];
        [_hoursArr addObject:@"07:00"];[_hoursArr addObject:@"07:30"];
        [_hoursArr addObject:@"08:00"];[_hoursArr addObject:@"08:30"];
        [_hoursArr addObject:@"09:00"];[_hoursArr addObject:@"09:30"];
        [_hoursArr addObject:@"10:00"];[_hoursArr addObject:@"10:30"];
        [_hoursArr addObject:@"11:00"];[_hoursArr addObject:@"11:30"];
        [_hoursArr addObject:@"12:00"];[_hoursArr addObject:@"12:30"];
        [_hoursArr addObject:@"13:00"];[_hoursArr addObject:@"13:30"];
        [_hoursArr addObject:@"14:00"];[_hoursArr addObject:@"14:30"];
        [_hoursArr addObject:@"15:00"];[_hoursArr addObject:@"15:30"];
        [_hoursArr addObject:@"16:00"];[_hoursArr addObject:@"16:30"];
        [_hoursArr addObject:@"17:00"];[_hoursArr addObject:@"17:30"];
        [_hoursArr addObject:@"18:00"];[_hoursArr addObject:@"18:30"];
        [_hoursArr addObject:@"19:00"];[_hoursArr addObject:@"19:30"];
        [_hoursArr addObject:@"20:00"];[_hoursArr addObject:@"20:30"];
        [_hoursArr addObject:@"21:00"];[_hoursArr addObject:@"21:30"];
        [_hoursArr addObject:@"22:00"];[_hoursArr addObject:@"22:30"];
        [_hoursArr addObject:@"23:00"];[_hoursArr addObject:@"23:30"];
        [_hoursArr addObject:@"00:00"];
    }
    return _hoursArr;
}
#pragma mark -UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 35;
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *hourStr = self.hoursArr[row];
    self.descLabel.text = [NSString stringWithFormat:@"%@:%@",self.dateType,hourStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:hourStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:30.0f]
                    range:NSMakeRange(0, 5)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:KRGB(255, 147, 18, 1)
                    range:NSMakeRange(0, 5)];
    
    return attrStr;
}

//show
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyboardView.frame = CGRectMake(0, KScreenHeight - 280, KScreenWidth, 280);
    }];
}
//点击maskBtn
- (IBAction)maskBtnACTION:(UIButton *)sender {
    [self removeFromSuperview];
}
//点击rightBtn
- (IBAction)rightBtnACTION:(UIButton *)sender {
    //发通知
    NSString *hour = [self.descLabel.text substringFromIndex:5];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDatePicker24HoursView" object:nil userInfo:@{@"dateType":self.dateType,@"hour":hour}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.keyboardView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 280);
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}



@end
