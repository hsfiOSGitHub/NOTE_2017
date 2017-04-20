//
//  UMComAddedImageCellView.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/17.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMComActionDeleteView.h"
@class UMComAddedImageCellView;
@class UMComBriefAddedImageCellView;

typedef void (^DeleteHandle)(UMComAddedImageCellView *iv);
typedef void (^BriefDeleteHandle)(UMComBriefAddedImageCellView *iv);

@interface UMComAddedImageCellView : UIImageView

@property (nonatomic) NSUInteger curIndex;
@property (nonatomic,copy) DeleteHandle handle;
@property (nonatomic,readwrite,assign)UMComActionDeleteViewType deleteViewType;//设置删除的类型

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad;

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth;

@end



@interface UMComBriefAddedImageCellView : UIImageView
@property (nonatomic) NSUInteger curIndex;
@property (nonatomic,copy) BriefDeleteHandle handle;
@property (nonatomic,readwrite,assign)UMComActionDeleteViewType deleteViewType;//设置删除的类型

//设置UMComBriefAddedImageCellView的delete的img的图片
@property(nonatomic,readwrite,strong)UIImage* deleteImg;
@end
