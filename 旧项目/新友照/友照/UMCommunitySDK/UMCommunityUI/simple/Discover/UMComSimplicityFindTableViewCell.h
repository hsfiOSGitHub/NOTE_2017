//
//  UMComSimplicityFindTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComTableViewCell.h"

typedef NS_ENUM(NSUInteger, UMComSimplicityCellLineStyle) {
    UMComSimplicityCellLineStyleTop = 1,
    UMComSimplicityCellLineStyleMiddle = 1 << 1L,
    UMComSimplicityCellLineStyleBottom = 1 << 2L,
};
@interface UMComSimplicityFindTableViewCell : UMComTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellStyleForLine:(UMComSimplicityCellLineStyle)style;

@end
