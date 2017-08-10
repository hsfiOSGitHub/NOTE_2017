//
//  DCSettingCell.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCSettingCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCSettingCell ()
/* 日期上方工具条 */
@property(nonatomic,strong)UIToolbar* textFieldToolbar;
/* 日期DatePicker */
@property(nonatomic,strong)UIDatePicker* dataPicker;


@end

@implementation DCSettingCell

#pragma mark - loadLazy

- (UIDatePicker *)dataPicker{
    if (!_dataPicker) {
        
        _dataPicker = [[UIDatePicker alloc]init];
        _dataPicker.backgroundColor = [UIColor whiteColor];
        //设置显示模式，只显示日期
        _dataPicker.datePickerMode = UIDatePickerModeDate;
        //本地化
        _dataPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    }
    return _dataPicker;
}

-(UIView *)textFieldToolbar{
    
    if (!_textFieldToolbar) {
        
        _textFieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        _textFieldToolbar.backgroundColor = [UIColor whiteColor];
        //设置按钮
        UIBarButtonItem *fixSpaceBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishBirthChange)];
        [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
        _textFieldToolbar.items = @[fixSpaceBtn,doneBtn];
    }
    return _textFieldToolbar;
}


#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR15Font;
  
    _setSwitch = [[UISwitch alloc]init];
    [_setSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _setSwitch.onTintColor = [UIColor redColor]; // 在oneSwitch开启的状态显示的颜色 默认是blueColor
//    _setSwitch.tintColor = [UIColor lightGrayColor]; // 设置关闭状态的颜色
//    _setSwitch.thumbTintColor = [UIColor whiteColor]; // 设置开关上左右滑动的小圆点的颜色
    
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor darkGrayColor];
    _contentLabel.font = PFR13Font;
    
    _birthField = [[UITextField alloc]init];
    _birthField.borderStyle = UITextBorderStyleNone;
    //设置文本输入框的输入辅助视图为自定义的视图
    _birthField.inputAccessoryView = self.textFieldToolbar;
    //设置文本输入框的输入视图为自定义的dataPicker;
    _birthField.inputView = self.dataPicker;
    _birthField.textColor = [UIColor darkGrayColor];
    _birthField.font = PFR13Font;

}

#pragma mark - Setter Getter Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        make.centerY.mas_equalTo(self);
    }];
    if (_type == cellTypeOne) {
        [self addSubview:_indicateButton];
        [self addSubview:_contentLabel];
        
        [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self)setOffset:-DCMargin];
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.mas_equalTo(self);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_indicateButton.mas_left);
            make.centerY.mas_equalTo(self);
        }];

    }else if (_type == cellTypeTwo){
        
        [self addSubview:_setSwitch];
        [_setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self)setOffset:-DCMargin];
            make.size.mas_equalTo(CGSizeMake(60, 35));
            make.centerY.mas_equalTo(self);
        }];
    }else if (_type == cellTypeThree){
        
        [self addSubview:_birthField];
        [self addSubview:_indicateButton];
        [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            [make.right.mas_equalTo(self)setOffset:-DCMargin];
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.mas_equalTo(self);
        }];
        
        [_birthField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_indicateButton.mas_left);
            make.centerY.mas_equalTo(self);
        }];
    }
    
    
}
#pragma mark - 点击事件
- (void)switchAction:(UISwitch *)sender
{
    NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
}

#pragma mark - 跟换生气结束
- (void)finishBirthChange
{
    DCUserInfo *userInfo = UserInfoData;
    NSDate* choosedDate = self.dataPicker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init]; //设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *birthDayStr = [formatter stringFromDate:choosedDate];
    
    if (![birthDayStr isEqualToString:_birthField.text]) { //跟换日期
        userInfo.birthDay = birthDayStr;
        [userInfo save];
        _birthField.text = birthDayStr;
    }
    [_birthField resignFirstResponder];
}


@end
