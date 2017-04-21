//
//  GridButton.h
//  DemoSummary
//
//  Created by chuanglong02 on 16/9/20.
//  Copyright © 2016年 chuanglong02. All rights reserved.
//

#import <UIKit/UIKit.h>
//每个格子的高度
#define GridHeight 123
//每行显示格子的列数
#define PerRowGridCount 3
//每列显示格子的行数
#define PerColumGridCount 6
//每个格子的宽度
#define GridWidth (KScreenW/PerRowGridCount)
//每个格子的X轴间隔
#define PaddingX 0
//每个格子的Y轴间隔
#define PaddingY 0
@protocol GridButtonDelegate;
@interface GridButton : UIButton
//格子的ID
@property(nonatomic,assign)NSInteger gridId;
//格子的title
@property(nonatomic,strong)NSString *gridTitle;
//格子的图片
@property(nonatomic,strong)NSString *gridImageString;
//格子的选中状态
@property(nonatomic,assign)BOOL     isChecked;
//格子的移动状态
@property(nonatomic,assign)BOOL     isMove;
//格子的排列索引位置
@property(nonatomic,assign)NSInteger  gridIndex;
//格子的位置中心坐标
@property(nonatomic,assign)CGPoint    gridCenterPoint;
//代理方法
@property(nonatomic,assign)id<GridButtonDelegate> delegate;
@property(nonatomic,assign)BOOL isShowRemove;
/**
 *  创建网格button
 *
 *  @param frame
 *  @param title            button title
 *  @param normalImage      正常图片
 *  @param highlightedImage 高亮图片
 *  @param gridId           button id
 *  @param index            button 所在位置的索引下标
 *  @param isAddDelete      是否增加删除按钮
 *  @param deleteImage      删除按钮图标
 *  @param iconImageString  icon 图片
 *
 *  @ret
 */
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage girdId:(NSInteger)gridId atIndex:(NSInteger)index isAddDelete:(BOOL)isAddDelete deleteImage:(UIImage *)deleteImage withIconImageString:(NSString *)iconImageString;
+(NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)button gridArray:(NSMutableArray *)girdListArray;

@end
@protocol GridButtonDelegate <NSObject>
//响应格子的点击事件

-(void)gridItemDidClicked:(GridButton *)clickItem;
//响应格子删除事件

-(void)gridItemDidDeleteClicked:(UIButton *)deleteButton;
//响应格子的长安手势事件

-(void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(GridButton*)gird;
-(void)pressGestureStateChangedWithPoint:(CGPoint)gridPoint grigItem:(GridButton *)girdItem;
- (void)pressGestureStateEnded:(GridButton *) gridItem;

@end