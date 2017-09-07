//
//  HWGuideView.h
//  HWGuideView
//
//  Created by Lee on 2017/3/30.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWGuideView : UIView

@end


static inline UIColor * hexColor(long hexColor){

    return [UIColor colorWithRed:((hexColor>>24)&0xFF)/255.0 green:((hexColor>>16)&0xFF)/255.0 blue:((hexColor>>8)&0xFF)/255.0 alpha:((hexColor)&0xFF)/255.0];
}
