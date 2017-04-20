//
//  UMComKit+Color.h
//  UMComFoundation
//
//  Created by wyq.Cloudayc on 7/21/16.
//  Copyright © 2016 umeng. All rights reserved.
//

#import "UMComKit.h"
#import <UIKit/UIKit.h>


#define UMComRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define UMComColorWithHexString(colorValueString) [UMComKit colorWithHexString:colorValueString]


@interface UMComKit (Color)

+ (UIColor *)colorWithHexString:(NSString *)string;

@end
