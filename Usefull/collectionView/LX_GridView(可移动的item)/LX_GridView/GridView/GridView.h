//
//  GridView.h
//  LX_GridView
//
//  Created by chuanglong02 on 16/9/21.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridButton;
@protocol GridViewDelegate<NSObject>
-(void)updateHeight:(CGFloat)height;
-(void)clickGridView:(GridButton *)item;
@end
@interface GridView : UIView
-(instancetype)initWithFrame:(CGRect)frame showGridTitleArray:(NSMutableArray *)showGridTitleArray showImageGridArray:(NSMutableArray *) showImageGridArray showGridIDArray:(NSMutableArray *)showGridIDArray;
@property(nonatomic,assign)id<GridViewDelegate> gridViewDelegate;
-(void)updateNewFrame;
@end
