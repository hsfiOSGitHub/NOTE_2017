//
//  UMComKit+Image.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"
#import <UIKit/UIKit.h>

typedef void (^FetchImageBlock)(UIImagePickerController *picker, NSDictionary *info);


@interface UMComKit (Image)
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) FetchImageBlock completion;

- (void)fetchImageFromAlbum:(UIViewController *)rootViewController
                 completion:(FetchImageBlock)completion;

+ (UIImage *)fixOrientation:(UIImage *)sourceImage;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
