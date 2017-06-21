//
//  HSFKeyboard.h
//  PwdDemo
//
//  Created by JuZhenBaoiMac on 2017/6/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HSFKeyboardType) {
    HSFKeyboardType_Number,  //
    HSFKeyboardType_Decimal  //
};

@protocol HSFKeyboardDelegate <NSObject>

@optional

-(void)keyboardACTIONWith:(NSString *)str atIndex:(NSInteger)index;

@end

@interface HSFKeyboard : UIView

@property (nonatomic,assign) HSFKeyboardType curKeyboardType;

@property (nonatomic,assign) id<HSFKeyboardDelegate>delegate;

//类方法
+(instancetype)keyboardWithFrame:(CGRect)frame delegate:(id<HSFKeyboardDelegate>)delegate keyboardType:(HSFKeyboardType) keyboardType;

@end
