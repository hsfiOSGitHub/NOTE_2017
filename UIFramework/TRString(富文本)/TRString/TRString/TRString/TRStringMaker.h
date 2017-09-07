//
//  TRString.h
//  TRKit
//
//  Created by cry on 2017/7/19.
//  Copyright © 2017年 EGOVA. All rights reserved.
//

#define TRBoxValue(value)           _trBoxValue(@encode(__typeof__((value))), (value))

#define TRString(...)               TRStringMaker.string(TRBoxValue((__VA_ARGS__)))
#define TRStringWithFormat(f, ...)  TRStringMaker.stringWithFormat(f, __VA_ARGS__)
#define append(...)                 append(TRBoxValue((__VA_ARGS__)))
#define format(f, ...)              format(f, __VA_ARGS__)
/// construct a NSString
#define String(...)                 TRString((__VA_ARGS__)).toString
#define Format(f, ...)              [TRStringMaker format:f, __VA_ARGS__]
#define DEFAULT_STR                 @""

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline id _getValue(const char *type, va_list v);
static inline id _trBoxValue(const char *type, ...) {
    
    va_list v;
    va_start(v, type);
    id obj = _getValue(type, v);
    va_end(v);
    return obj;
}

static inline id _getValue(const char *type, va_list v){
    
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = NSStringFromCGPoint(actual);
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = NSStringFromCGSize(actual);
    } else if (strcmp(type, @encode(CGRect)) == 0) {
        
        CGRect actual = (CGRect)va_arg(v, CGRect);
        obj = NSStringFromCGRect(actual);
    } else if (strcmp(type, @encode(double)) == 0) {
        
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    return obj;
}

@interface TRStringMaker : NSObject
/// 输出字符串
@property (nonatomic, copy, readonly) NSString *toString;
/// 输出富文本
@property (nonatomic, copy, readonly) NSAttributedString *toAttributedString;

+ (TRStringMaker * (^)(id))string;
+ (TRStringMaker * (^)(NSString *, ...))stringWithFormat;
/**
    append(@"")
 */
- (TRStringMaker * (^)(id))append;
/**
    format(@"hello %@", @"world!")
 */
- (TRStringMaker * (^)(NSString *, ...))format;
/**
    处理空字符串默认显示，包含为NSNull，nil，长度为0
 */
- (TRStringMaker * (^)(NSString *))null;
/**
    换行,相当于添加了"\n" ln()
 */
- (TRStringMaker * (^)())ln;

/**
    添加颜色 color([UIColor redColor])
 */
- (TRStringMaker * (^)(UIColor *))color;
/**
    设置字体大小 fontSize(fontSize)
 */
- (TRStringMaker * (^)(NSInteger))fontSize;
/**
    设置字体 font(@"fontName", fontSize)
 */
- (TRStringMaker * (^)(NSString *, NSInteger))font;

/**
    添加富文本属性 addAttribute(NSForegroundColorAttributeName, [UIColor redColor])
 */
- (TRStringMaker * (^)(NSString *attr, id value))addAttribute;
/**
    添加多个富文本属性 addAttributes()
 */
- (TRStringMaker * (^)(NSDictionary<NSString *, id> *))addAttributes;

@end

@interface TRStringMaker (ObjcMethod)

+ (NSString *)format:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
