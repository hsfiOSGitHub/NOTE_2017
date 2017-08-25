//
//  UIImage+Flip.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIImage+Flip.h"

@implementation UIImage (Flip)


- (UIImage * _Nonnull)flipImageHorizontally {
    return [[UIImage alloc] initWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationUpMirrored];
}

- (UIImage * _Nonnull)flipImageVertically {
    return [[UIImage alloc] initWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored];
}

- (UIImage * _Nullable)flipImageVerticallyAndHorizontally {
    return [[UIImage alloc] initWithCGImage:self.CGImage scale:self.scale orientation:UIImageOrientationLeftMirrored|UIImageOrientationUpMirrored];
}

@end
