//
//  UMComLabel.h
//  UMCommunity
//
//  Created by umeng on 16/5/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComLabel : UILabel

@property (nonatomic) CGFloat lineSpace;

@property (nonatomic, copy) NSString *textForAttribute;

- (void)refreshAttributedString;

@end
