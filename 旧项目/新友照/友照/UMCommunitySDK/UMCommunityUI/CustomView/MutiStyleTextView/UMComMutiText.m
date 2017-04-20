//
//  UMComMutiText.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComMutiText.h"
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+Color.h>


CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    return ctFont;
}



@interface UMComMutiText ()

@property (nonatomic, copy) void (^configTextCompletion)();

@property (nonatomic, copy) void (^configTextArrayCompletion)(NSArray *mutiTextArray);


@end



@implementation UMComMutiText

- (instancetype)init
{
    self = [super init];
    if (self) {
        _text        = nil;
        _font        = [UIFont systemFontOfSize:13.0f];
        _textColor   = [UIColor blackColor];
        _lineSpace   = 2.0f;
        _attributedText = nil;
        _pointOffset = CGPointZero;
        //private
        _runs        = [NSMutableArray array];
        _framesetterRef = NULL;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    NSMutableAttributedString *attString = nil;
    if (string && string.length > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    _text = string;
    self = [self initWithAttributedString:attString];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString
{
    self = [self init];
    if (self) {
        _attributedText = attributedString;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setTextFont:font forRange:NSMakeRange(0,self.attributedText.length)];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTextColor:textColor forRange:NSMakeRange(0,self.attributedText.length)];
}

- (void)setTextFont:(UIFont *)font forRange:(NSRange)range
{
    NSMutableAttributedString *attString = self.attributedText;
    if ([attString isKindOfClass:[NSMutableAttributedString class]] && attString.length > 0) {
        //设置字体
        CTFontRef fontRef = CTFontCreateFromUIFont(font);//CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
    }
}

- (void)setTextColor:(UIColor *)color forRange:(NSRange)range
{
    if ([_attributedText isKindOfClass:[NSMutableAttributedString class]] && _attributedText.length > 0 && color) {
        //设置颜色
        [_attributedText addAttribute:(NSString*)kCTForegroundColorAttributeName value:color range:NSMakeRange(0,_attributedText.length)];
    }
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
}


- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    [self setLineBreakMode:lineBreakMode forRange:NSMakeRange(0, [_attributedText length])];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode forRange:(NSRange)range
{
    
}


+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    [mutiText setMutiTextWithSize:size  font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    mutiText.textColor = textColor;
    [mutiText setMutiTextWithSize:size font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
                     highLightColor:(UIColor *)highLightColor
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    mutiText.textHighLightColor = highLightColor;
    mutiText.textColor = textColor;
    [mutiText setMutiTextWithSize:size font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

- (void)setMutiTextWithSize:(CGSize)size
                       font:(UIFont *)font
                     string:(NSString *)string
                  lineSpace:(CGFloat)lineSpace
                 checkWords:(NSArray *)checkWords
{
    self.font = font;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    self.lineSpace = lineSpace;
    [self reloadTextDataforRange:NSMakeRange(0, _attributedText.length)];
    [self setHightLightAttributedTextWithSize:size checkWords:checkWords];
}

- (void)reloadTextDataforRange:(NSRange)range
{
    if ([_attributedText isKindOfClass:[NSMutableAttributedString class]] && _attributedText.length > 0) {
        CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
        switch (_lineBreakMode) {
            case NSLineBreakByCharWrapping:
                lineBreak = kCTLineBreakByCharWrapping;
                break;
            case NSLineBreakByClipping:
                lineBreak = kCTLineBreakByClipping;
                break;
            case NSLineBreakByTruncatingHead:
                lineBreak = kCTLineBreakByTruncatingHead;
                break;
            case NSLineBreakByTruncatingTail:
                lineBreak = kCTLineBreakByTruncatingTail;
                break;
            case NSLineBreakByTruncatingMiddle:
                lineBreak = kCTLineBreakByTruncatingMiddle;
                break;
            default:
                lineBreak = kCTLineBreakByWordWrapping;
                break;
        }


        CTParagraphStyleSetting settings[] = {
            {kCTParagraphStyleSpecifierLineSpacing,sizeof(_lineSpace),&_lineSpace}, //行间距
            { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &_lineSpace },//调整行间距
            { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &_lineSpace },//最大行间距
            { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &_lineSpace },//最小行间距
            {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreak),&lineBreak},//换行模式
        };
        
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
        CFRelease(style);
        [_attributedText addAttributes:attributes range:range];
    }
}

- (void)setHightLightAttributedTextWithSize:(CGSize)size checkWords:(NSArray *)checkWords
{
    NSMutableAttributedString *attString = self.attributedText;
    if (!attString || attString.length == 0) {
        return;
    }
    CFIndex lineIndex = 0;
    int lineCount = 0;
    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
    CGFloat linespace = 0;
    
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
    UIColor *blueColor = UMComColorWithHexString(@"#507DAF");
    if (!self.textHighLightColor) {
        self.textHighLightColor = blueColor;
    }
    NSArray *runs = [[self class] createTextRunsWithAttString:attString font:_font highLightColor:self.textHighLightColor checkWords:checkWords];
    self.runs = runs;
    
    CFAttributedStringRef attStringRef = (__bridge CFAttributedStringRef)attString;
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString(attStringRef);
    self.framesetterRef = (__bridge_transfer id)(CFRetain(setterRef));
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil);
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(setterRef, CFRangeMake(0, (CFIndex)[attString length]), NULL, size, NULL);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    lineIndex = CFArrayGetCount(lines);
    lineCount = (int)lineIndex;
    self.lineNumbers = lineCount;
    CTLineRef lineRef;
    if (lineCount > 0) {
        lineRef= CFArrayGetValueAtIndex(lines, lineCount-1);
        CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
        if (lineCount == 1) {
            textSize.width = rect.size.width+2;//宽度加两个像素以纠偏
        }else{
            textSize.width = size.width;
        }
        textSize.height += linespace;//高度加一行高度以纠偏
    }
    _textSize = textSize;
    _attributedText = attString;
    CGPathRelease(pathRef);
    CFRelease(setterRef);
    CFRelease(frameRef);
}

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString
                                    font:(UIFont *)font
                          highLightColor:(UIColor *)color
                              checkWords:(NSArray *)checkWords
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *subRunArray = [UMComMutiTextRunURL runsWithAttributedString:attString font:font textColor:color];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    subRunArray = [UMComMutiTextRunTopic runsWithAttributedString:attString font:font textColor:color checkWords:checkWords];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    subRunArray = [UMComMutiTextRunClickUser runsWithAttributedString:attString font:font textColor:color checkWords:checkWords];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    return  array;
}


@end
