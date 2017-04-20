//
//  UMComBriefEditView.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComBriefEditView.h"

@interface UMComBriefEditView ()

@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用

@end

@implementation UMComBriefEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        //self.backgroundColor= [UIColor clearColor];
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        placeholderLabel.backgroundColor= [UIColor clearColor];
        
        //只设置一行
        placeholderLabel.numberOfLines=1; //设置可以输入多行文字时可以自动换行
        [self addSubview:placeholderLabel];
        self.placeholderLabel= placeholderLabel; //赋值保存
        self.placeholderLabel.frame = CGRectMake(5, 0, frame.size.width, 30);
        
        self.placeholderLabel.textColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        self.placeholderLabel.font = [UIFont systemFontOfSize:14]; //设置默认的字体
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
    }
    return self;
}

#pragma mark -监听文字改变

- (void)textDidChange {
    
    if (self.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }
    else
    {
        self.placeholderLabel.hidden = NO;
    }
    
    //self.hasText频繁调用会崩溃(原因还没有查到!!!)
    //self.placeholderLabel.hidden = self.hasText;
    
}

//- (void)setText:(NSString*)text{
//    [super setText:text];
//    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
//    
//}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
    
}


#pragma mark - 设置属性

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder= [placeholder copy];
    self.placeholderLabel.text = placeholder;
}

-(void) setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor= placeholderColor;
}

-(void) setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    
    self.placeholderLabel.font = placeholderFont;
}

@end
