//
//  HSFTagView.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/30.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "HSFTagView.h"
#define spaceV 10 //垂直间距
#define spaceH 10 //水平间距
#define TF_height 50 //标签输入框高度

@interface HSFTagView ()<UITextFieldDelegate>

@property (nonatomic,assign) CGFloat maxHeight; //scrollView内容视图的高度
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *tf_bgView;
@property (nonatomic,strong) UITextField *TF;
@property (nonatomic,strong) UIView *keyboardTool;
@property (nonatomic,strong) UILabel *placeholder;
@property (nonatomic,assign) NSInteger currentMenuIndex;

@end

@implementation HSFTagView
#pragma mark -懒加载

-(NSMutableDictionary *)bgViewDic_color{
    if (!_bgViewDic_color) {
        _bgViewDic_color = [NSMutableDictionary  dictionary];
    }
    return _bgViewDic_color;
}
-(UILabel *)placeholder{
    if (!_placeholder) {
        _placeholder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        _placeholder.text = @"您还没有标签哦，快快添加吧^_^";
        _placeholder.textColor = [UIColor lightGrayColor];
        _placeholder.font = [UIFont systemFontOfSize:15];
        _placeholder.textAlignment = NSTextAlignmentCenter;
    }
    return _placeholder;
}
-(CGFloat)maxTagViewHeight{
    if (_maxTagViewHeight > 200) {
        _maxTagViewHeight = 200;
    }
    return _maxTagViewHeight;
}
//键盘附view
-(UIView *)keyboardTool{
    if (!_keyboardTool) {
        _keyboardTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [okBtn setImage:[UIImage imageNamed:@"keyboard_selete_common"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool addSubview:okBtn];
    }
    return _keyboardTool;
}
//点击选择
-(void)okBtnACTION:(UIButton *)sender{
    [self.TF resignFirstResponder];//取消第一响应，回收键盘
    if (![self.TF.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(addTag:)]) {
            [self.delegate addTag:self.TF.text];
        }
    }
    self.TF.text = @"";
}


//固定宽度为屏幕宽度
-(void)setFrame:(CGRect)frame{
    CGRect newFrame = frame;
    newFrame.size = CGSizeMake(KScreenWidth, frame.size.height);
    [super setFrame:newFrame];
}

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _maxTagViewHeight = 50 + TF_height;
        //创建scrolliew
        [self createScrollViewWith:frame];
        //创建添加标签输入框
        [self createTFWith:frame];
    }
    return self;
}


//创建scrolliew
-(void)createScrollViewWith:(CGRect)FRAME{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, FRAME.size.width, FRAME.size.height - TF_height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
}
//创建添加标签输入框
-(void)createTFWith:(CGRect)FRAME{
    _tf_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, FRAME.size.height - TF_height, KScreenWidth, TF_height)];
    _tf_bgView.backgroundColor = KRGB(235, 235, 235, 1);
    [self addSubview:_tf_bgView];
    
    _TF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, TF_height)];
    [_tf_bgView addSubview:_TF];
    _TF.placeholder = @"添加标签";
    _TF.textColor = [UIColor darkGrayColor];
    _TF.font = [UIFont systemFontOfSize:15];
    _TF.borderStyle = UITextBorderStyleNone;
    _TF.backgroundColor = [UIColor clearColor];
    _TF.delegate = self;
    _TF.inputAccessoryView = self.keyboardTool;
    _TF.returnKeyType = UIReturnKeyDone;
    _TF.clearButtonMode = UITextFieldViewModeWhileEditing;
}
//添加tags
-(void)setTagsArr:(NSArray *)tagsArr{
    _tagsArr = tagsArr;
    [self createTagsWith:tagsArr];
    //设置scrollView的内容视图大小
    self.scrollView.contentSize = CGSizeMake(KScreenWidth, self.maxHeight + spaceH);
    //重新布局self
    if ((self.maxHeight + spaceH) <= 50) {
        self.maxTagViewHeight = 50 + TF_height;
    }else{
        self.maxTagViewHeight = (self.maxHeight + spaceH + TF_height);
    }
    self.frame = CGRectMake(self.x, self.y, self.width, self.maxTagViewHeight);
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.maxTagViewHeight - TF_height);
    self.tf_bgView.frame = CGRectMake(0, self.scrollView.height, self.width, TF_height);
    
    //滑动到最底部
    [self.scrollView scrollRectToVisible:CGRectMake(0, (self.maxHeight + spaceH) - self.scrollView.height, self.scrollView.width, self.scrollView.height) animated:YES];
}
-(void)createTagsWith:(NSArray *)tagsArr{
    if (self.scrollView.subviews.count>0) {
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    if (tagsArr.count <= 0) {
        [self.scrollView addSubview:self.placeholder];
        return;
    }
    
    CGFloat lastLineH = 0.0;
    CGFloat x = spaceH;
    CGFloat y = spaceV;
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    CGFloat padding = 10;
    for (int i = 0; i < tagsArr.count; i++) {
        //创建bgView
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(0, 0, 100, 30);
        [self.scrollView addSubview:bgView];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 15;
        bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bgView.layer.borderWidth = 1;
        bgView.backgroundColor = [UIColor whiteColor];
            //给bgView添加长按弹出菜单删除手势
        [bgView setTag:(i + 100)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressACTION:)];
        longPress.minimumPressDuration = 1.0;
        [bgView addGestureRecognizer:longPress];
        //创建titleLabel
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(padding, 0, 0, 30);
        [bgView addSubview:titleLabel];
        titleLabel.text = tagsArr[i];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 0;
        //创建deleteBtn
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        [bgView addSubview:deleteBtn];
        [deleteBtn setImage:[UIImage imageNamed:@"delete_tag"] forState:UIControlStateNormal];
        [deleteBtn setTag:i];
        [deleteBtn addTarget:self action:@selector(deleteBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //重新布局
        NSString *title= tagsArr[i];
        
        deleteBtn.height = 30;
        deleteBtn.width = 30;
        titleLabel.height = 30;
        bgView.height = 30;
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; 
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15]; 
        CGSize size = [title boundingRectWithSize:CGSizeMake( MAXFLOAT,titleLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

        titleLabel.width = size.width;
        bgView.width = titleLabel.width + padding*2 + deleteBtn.width;
        
        if (bgView.width > (KScreenWidth - spaceH * 2)) {
            bgView.width = (KScreenWidth - spaceH * 2);
            titleLabel.width = (KScreenWidth - spaceH * 2 - padding*2 - deleteBtn.width);
            CGSize size2 = [title boundingRectWithSize:CGSizeMake(titleLabel.width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            titleLabel.height = size2.height + 10;
            bgView.height = size2.height + 10;
            if (titleLabel.height < 30) {
                titleLabel.height = 30;
                bgView.height = 30;
            }
        }
        //布局titleLabel和deleteBtn
        titleLabel.frame = CGRectMake(padding, 0, titleLabel.width, titleLabel.height);
        deleteBtn.frame = CGRectMake(padding + titleLabel.width, 0, deleteBtn.width, deleteBtn.height);
        deleteBtn.centerY = titleLabel.centerY;
        
        //布局bgView
        w = bgView.width;
        h = bgView.height;
        if (x+w > (KScreenWidth - spaceH * 2)) {
            y += spaceV +lastLineH;
            x = spaceH;
        }
        bgView.frame = CGRectMake(x, y, w, h);
        
        x += spaceH + w;
        lastLineH = bgView.height;
        
        
        //计算总高度
        if (i == tagsArr.count - 1) {
            self.maxHeight = y + h;
        }
        
        //bgViewDic_color(美化颜色)
        __block NSInteger index = i;
        UIView *bgView_copy = bgView;
        [self.bgViewDic_color enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key integerValue] == index) {
                NSString *RGB = obj;
                NSArray *RGB_arr = [RGB componentsSeparatedByString:@","];
                bgView_copy.backgroundColor = [UIColor colorWithRed:[RGB_arr[0] integerValue] green:[RGB_arr[1] integerValue] blue:[RGB_arr[2] integerValue] alpha:1];
            }
        }];
    }

}

//长按弹出菜单
-(void)longPressACTION:(UILongPressGestureRecognizer *)longPress{
    UIView *bgView = longPress.view;
    self.currentMenuIndex = bgView.tag - 100;
    //弹出菜单
    [self becomeFirstResponder];
    UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteFunc:)];
//    UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"美化" action:@selector(colorFunc:)];
    [[UIMenuController sharedMenuController] setTargetRect:[bgView frame] inView:self];
    [UIMenuController sharedMenuController].menuItems = @[item];
    [UIMenuController sharedMenuController].menuVisible = YES;
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(deleteFunc:) || action == @selector(colorFunc:)) {
        return YES;
    }
    return NO;
}
//点击菜单中的删除
-(void)deleteFunc:(id)sender{
    if ([self.delegate respondsToSelector:@selector(removeTagAtIndex:)]) {
        [self.delegate removeTagAtIndex:self.currentMenuIndex];
    }
}
//点击菜单中的美化
-(void)colorFunc:(id)sender{
    if ([self.delegate respondsToSelector:@selector(showColorCardAtIndex:)]) {
        [self.delegate showColorCardAtIndex:self.currentMenuIndex];
    }
}
//点击deleteBtn
-(void)deleteBtnACTION:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(removeTagAtIndex:)]) {
        [self.delegate removeTagAtIndex:sender.tag];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应，回收键盘
    if (![textField.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(addTag:)]) {
            [self.delegate addTag:textField.text];
        }
    }
    textField.text = @"";
    return YES;
}







@end
