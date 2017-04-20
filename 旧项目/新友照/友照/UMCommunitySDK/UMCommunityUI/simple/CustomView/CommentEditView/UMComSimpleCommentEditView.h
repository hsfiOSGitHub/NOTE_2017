//
//  UMComCommentEditView.h
//  UMCommunity
//
//  Created by umeng on 15/7/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComSimpleCommentEditView : NSObject

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UITextField *commentTextField;

@property (nonatomic, assign) NSInteger maxTextLenght;

@property (nonatomic, strong) UIView *commentInputView;

@property (nonatomic, strong) UIButton *favoriteButton;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) BOOL isReply;

@property (nonatomic, copy) void (^SendCommentHandler)(NSString *content);

@property (nonatomic, copy) void (^clickOnLikeButtonBlock)(UIButton *likeButton);

@property (nonatomic, copy) void (^clickOnFavoriteButtonBlock)(UIButton *favoriteButton);

- (instancetype)initWithSuperView:(UIView *)view;

-(void)presentEditView;

- (void)dismissKeyboard;

- (void)addAllEditView;
- (void)removeAllEditView;



@end
