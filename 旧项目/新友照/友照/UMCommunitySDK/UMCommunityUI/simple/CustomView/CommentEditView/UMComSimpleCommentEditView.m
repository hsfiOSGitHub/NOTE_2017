//
//  UMComCommentEditView.m
//  UMCommunity
//
//  Created by umeng on 15/7/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComSimpleCommentEditView.h"
#import "UMComResouceDefines.h"
#import "UMComShowToast.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComFoundation/UMComKit+Color.h>


@interface UMComSimpleCommentEditView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) NSString *lastText;

@property (nonatomic, strong) UIView *mySuperView;


@end


@implementation UMComSimpleCommentEditView

- (instancetype)initWithSuperView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc]initWithFrame:view.bounds];
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
        [view addSubview:self.view];
        self.view.hidden = YES;
        self.mySuperView = view;
        [self creatCommentTextField];
        self.isReply = NO;
//        NSString *chContent = [NSString stringWithFormat:UMComLocalizedString(@"um_com_commentLimit_template", @"评论内容不能超过%d个字符"),(int)self.maxTextLenght];
        NSString *chContent = [NSString stringWithFormat:UMComLocalizedString(@"um_com_input_content", @"输入内容"),(int)self.maxTextLenght];
        self.commentTextField.placeholder = chContent;

    }
    return self;
}

- (void)creatCommentTextField
{
    NSArray *commentInputNibs = [[NSBundle mainBundle]loadNibNamed:@"UMComSimpleCommentInput" owner:self options:nil];
    self.maxTextLenght = [UMComSession sharedInstance].comment_length;
    //得到第一个UIView
    UIView *commentInputView = [commentInputNibs objectAtIndex:0];
    self.commentInputView = commentInputView;
//    [self.commentInputView addSubview:[self creatSpaceLineWithWidth:self.mySuperView.frame.size.width]];
    
    self.commentTextField = [commentInputView.subviews objectAtIndex:0];
    self.favoriteButton = [commentInputView.subviews objectAtIndex:1];
    self.likeButton = [commentInputView.subviews objectAtIndex:2];
    self.sendButton = [commentInputView.subviews objectAtIndex:3];
    self.sendButton.hidden = YES;
    self.sendButton.backgroundColor = UMComColorWithHexString(@"#469ef8");
    self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height/2;
    self.sendButton.clipsToBounds = YES;
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commentTextField.delegate = self;
    self.commentTextField.delegate = self;
    self.commentInputView.frame = CGRectMake(0,  self.view.frame.size.height-self.commentInputView.frame.size.height, self.view.frame.size.width, self.commentInputView.frame.size.height);
    [self.mySuperView addSubview:self.commentInputView];
    [self.mySuperView bringSubviewToFront:self.commentInputView];
    [self.favoriteButton addTarget:self action:@selector(clickOnFavorite) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton addTarget:self action:@selector(clickOnLike) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self action:@selector(sendCommend) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.commentTextField addTarget:self action:@selector(onChangeTextField) forControlEvents:UIControlEventEditingChanged];
}

- (void)sendCommend
{
    if (self.commentTextField.text.length > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        return;
    }
    if (self.SendCommentHandler) {
        self.SendCommentHandler(self.commentTextField.text);
    }
    self.commentTextField.text = @"";
    self.commentTextField.placeholder = @"";
    [self dismissKeyboard];
}

- (void)clickOnFavorite
{
    if (self.clickOnFavoriteButtonBlock) {
        self.clickOnFavoriteButtonBlock(self.favoriteButton);
    }
}

- (void)clickOnLike
{
    if (self.clickOnLikeButtonBlock) {
        self.clickOnLikeButtonBlock(self.likeButton);
    }
}

- (UIView *)creatSpaceLineWithWidth:(CGFloat)width
{
    UIView *spaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 0.5)];
    spaceLine.backgroundColor = UMComTableViewSeparatorColor;
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return spaceLine;
}

-(void)presentEditView
{
    self.commentTextField.text = @"";
    if (self.commentTextField.placeholder.length == 0) {
        NSString *chContent = [NSString stringWithFormat:UMComLocalizedString(@"um_com_input_content", @"输入内容"),(int)self.maxTextLenght];
        self.commentTextField.placeholder = chContent;
    }
    self.commentTextField.hidden = NO;
    self.commentInputView.hidden = NO;
    self.view.hidden = NO;
    [self.commentTextField becomeFirstResponder];
}

- (void)dismissKeyboard
{
    self.view.hidden = YES;
    if ([self.commentTextField becomeFirstResponder]) {
        [self.commentTextField resignFirstResponder];
    }
    NSString *chContent = [NSString stringWithFormat:UMComLocalizedString(@"um_com_input_content", @"输入内容"),(int)self.maxTextLenght];
    self.commentTextField.placeholder = chContent;
    self.commentTextField.text = @"";
}

- (void)addAllEditView
{
    if (self.view.superview != self.mySuperView) {
        [self.mySuperView addSubview:self.view];
        [self.mySuperView addSubview:self.commentInputView];
    }
}

- (void)removeAllEditView
{
    [self.commentInputView removeFromSuperview];
    [self.view removeFromSuperview];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= self.maxTextLenght && [string isEqualToString:@""]) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.commentTextField.text.length > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        return NO;
    }
    if (self.SendCommentHandler) {
        self.SendCommentHandler(textField.text);
    }
    [self dismissKeyboard];
    return YES;
}

- (void)onChangeTextField
{
    NSInteger textLenght = self.commentTextField.text.length;
    if (textLenght > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        NSString *sunString = [self.commentTextField.text substringWithRange:NSMakeRange(0, self.maxTextLenght)];
        self.commentTextField.text = sunString;
        return;
    }
    self.lastText = self.commentTextField.text;
}


- (void)hidenNoticeLabel
{
    self.noticeLabel.hidden = YES;
    self.commentTextField.hidden = NO;
}


- (void)keyboardWillShow:(NSNotification*)notification {
    
    [self.mySuperView bringSubviewToFront:self.commentInputView];
    self.view.hidden = NO;
    self.sendButton.hidden = NO;
    self.favoriteButton.hidden = YES;
    self.likeButton.hidden = YES;

    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect commentInputViewFrame = self.commentInputView.frame;
    commentInputViewFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + commentInputViewFrame.size.height);
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.commentInputView.frame = commentInputViewFrame;
    
    
    for (NSLayoutConstraint *constraint in self.commentInputView.constraints) {
        if (constraint.firstItem == self.sendButton && constraint.secondItem == self.commentTextField && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.priority = 900;
        }
        if (constraint.firstItem == self.favoriteButton && constraint.secondItem == self.commentTextField && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.priority = 750;
            
        }
    }
//    [self.commentInputView updateConstraintsIfNeeded];

    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    self.sendButton.hidden = YES;
    self.favoriteButton.hidden = NO;
    self.likeButton.hidden = NO;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect commentInputViewFrame = self.commentInputView.frame;
    commentInputViewFrame.origin.y = self.view.bounds.size.height - commentInputViewFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.view.hidden = YES;
    // set views with new info
    self.commentInputView.frame = commentInputViewFrame;

    for (NSLayoutConstraint *constraint in self.commentInputView.constraints) {
        if (constraint.firstItem == self.sendButton && constraint.secondItem == self.commentTextField && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.priority = 750;
        }
        if (constraint.firstItem == self.favoriteButton && constraint.secondItem == self.commentTextField && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.priority = 900;
            
        }
    }
    //    [self.commentInputView updateConstraintsIfNeeded];
    [UIView commitAnimations];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.commentInputView = nil;
    self.view = nil;
    self.mySuperView = nil;
    self.commentTextField = nil;
    self.noticeLabel = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
