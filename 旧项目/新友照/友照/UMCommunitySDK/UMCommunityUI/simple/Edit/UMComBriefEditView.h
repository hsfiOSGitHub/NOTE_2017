//
//  UMComBriefEditView.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComBriefEditView : UITextView

@property(nonatomic,copy) NSString *placeholder;  //文字

@property(nonatomic,strong) UIColor *placeholderColor; //文字颜色

@property(nonatomic,strong) UIFont *placeholderFont; //文字颜色

@end
