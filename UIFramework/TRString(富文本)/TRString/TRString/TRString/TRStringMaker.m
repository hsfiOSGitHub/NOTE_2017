//
//  TRString.m
//  TRKit
//
//  Created by cry on 2017/7/19.
//  Copyright © 2017年 EGOVA. All rights reserved.
//

#import "TRStringMaker.h"

@interface TRStringMaker()

@property (nonatomic, strong) NSMutableArray<NSString *> *stringArray;

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *attributedArray;

@property (nonatomic, strong) NSMutableArray<NSString *> *defaultStrings;

@end

@implementation TRStringMaker

+ (TRStringMaker * (^)(id))string{
    
    return ^(id str){
        return [TRStringMaker stringWithString:str];
    };
}

+ (TRStringMaker * (^)(NSString *, ...))stringWithFormat{
    
    return ^(NSString *format, ...){
        
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format
                                               arguments:args];
        va_end(args);
        return [TRStringMaker stringWithString:str];
    };
}

+ (TRStringMaker *)stringWithString:(id)string{
    
    TRStringMaker *trString = [[TRStringMaker alloc] init];
    return [trString addString:string];
}

#pragma mark - Method - append()
- (TRStringMaker * (^)(id))append{
    
    return ^(id str){
        return [self addString:str];
    };
}
- (TRStringMaker * (^)(NSString *, ...))format{
    
    return ^(NSString *format, ...){
        
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format
                                               arguments:args];
        va_end(args);
        return [self addString:str];
    };
}
///  --- ROOT ---
- (TRStringMaker *)addString:(id)str{
    
    if (self.stringArray == nil) {
        self.stringArray = [NSMutableArray array];
    }
    if (self.attributedArray == nil) {
        self.attributedArray = [NSMutableArray array];
    }
    if (self.defaultStrings == nil) {
        self.defaultStrings = [NSMutableArray array];
    }
    [self.stringArray addObject:[self isNullWithString:str]?@"":[NSString stringWithFormat:@"%@",str]];
    [self.attributedArray addObject:[NSMutableDictionary dictionary]];
    [self.defaultStrings addObject:@""];
    return self;
}
#pragma mark - Method - addAttribute()
- (TRStringMaker * (^)(NSString *attr, id value))addAttribute{
    
    return ^(NSString *attr, id value){
        [self.attributedArray.lastObject setValue:value forKey:attr];
        return self;
    };
}

- (TRStringMaker * (^)(NSDictionary<NSString *, id> *))addAttributes{
    
    return ^(NSDictionary<NSString *, id> *attrs){
        [self.attributedArray.lastObject setValuesForKeysWithDictionary:attrs];
        return self;
    };
}

- (TRStringMaker * (^)(UIColor *))color{
    
    return ^(UIColor *color){
        self.addAttribute(NSForegroundColorAttributeName, color);
        return self;
    };
}

- (TRStringMaker * (^)(NSInteger))fontSize{
    
    return ^(NSInteger fontSize){
        self.addAttribute(NSFontAttributeName, [UIFont systemFontOfSize:fontSize]);
        return self;
    };
}

- (TRStringMaker * (^)(NSString *, NSInteger))font{
    
    return ^(NSString *fontName, NSInteger fontSize){
        self.addAttribute(NSFontAttributeName, [UIFont fontWithName:fontName size:fontSize]);
        return self;
    };
}

#pragma mark - Method - null()
- (TRStringMaker * (^)(NSString *))null{
    
    return ^(NSString *str){

        if (![self isNullWithString:str]) {
            self.defaultStrings[self.defaultStrings.count - 1]  = str;
        }
        return self;
    };
}

- (BOOL)isNullWithString:(NSString *)str{
    
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    if (str == nil) {
        return YES;
    }
    if ([str isKindOfClass:[NSString class]] && str.length == 0) {
        return YES;
    }
    return NO;
}
#pragma mark - Method - ln()
- (TRStringMaker * (^)())ln{
    
    return ^(){
        return [self addString:@"\n"];
    };
}
#pragma mark - Method - toString
- (NSString *)toString{
    
    NSMutableString *fetchString = [NSMutableString string];
    [self.stringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]) {
            [fetchString appendString:self.defaultStrings[idx].length?self.defaultStrings[idx]:DEFAULT_STR];
        }else{
            [fetchString appendString:obj];
        }
    }];
    return [NSString stringWithString:fetchString];
}
#pragma mark - Method - toAttributedString
- (NSAttributedString *)toAttributedString{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [self.stringArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString *string = obj.length == 0?(self.defaultStrings[idx].length?self.defaultStrings[idx]:DEFAULT_STR):obj;
        [attributedString appendAttributedString:[self attributedString:string attributes:self.attributedArray[idx]]];
    }];
    return attributedString;
}

- (NSAttributedString *)attributedString:(NSString *)string attributes:(NSDictionary *)attributes{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    if (attributes.count > 0) {
        [attributedString addAttributes:attributes range:range];
    }
    return attributedString;
}

@end

@implementation TRStringMaker (ObjcMethod)

+ (NSString *)format:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2){
    
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format
                                           arguments:args];
    va_end(args);
    return str;
}

- (TRStringMaker *)tr_format:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2){
    
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format
                                           arguments:args];
    va_end(args);
    return [self addString:str];
}

@end
