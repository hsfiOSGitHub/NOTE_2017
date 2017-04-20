//
//  UMComMutiText.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComMutiTextRun.h"

@interface UMComMutiText : NSObject

@property (nonatomic,copy)   NSString              *text;       // default is nil
@property (nonatomic,strong) UIFont                *font;       // default is nil (system font 17 plain)
@property (nonatomic,strong) UIColor               *textColor;  // default is nil (text draws black)
@property (nonatomic,strong) UIColor               *textHighLightColor;

@property (nonatomic,assign) CGFloat               lineSpace;
@property (nonatomic,assign) NSInteger             lineNumbers;
@property (nonatomic,assign) CGSize                textSize;
@property (nonatomic,assign) CGPoint               pointOffset;
@property (nonatomic,assign) NSLineBreakMode       lineBreakMode;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy)   NSMutableAttributedString *attributedText;

@property (nonatomic) id framesetterRef;

@property (nonatomic,strong) NSArray<UMComMutiTextRun *> *runs;

- (instancetype)initWithString:(NSString *)string;

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString;
- (void)setTextColor:(UIColor *)color forRange:(NSRange)range;

- (void)setTextFont:(UIFont *)font forRange:(NSRange)range;


+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords;

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor;

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
                     highLightColor:(UIColor *)highLightColor;

@end