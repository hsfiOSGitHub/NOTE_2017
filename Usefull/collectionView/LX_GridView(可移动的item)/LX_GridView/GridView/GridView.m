//
//  GridView.m
//  LX_GridView
//
//  Created by chuanglong02 on 16/9/21.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "GridView.h"
#import "GridButton.h"
@interface GridView()<GridButtonDelegate>
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID
@property(nonatomic, strong)NSMutableArray *gridListArray;// 包括model的数组；

@end
@implementation GridView

{
    BOOL isSelected;
    BOOL contain;
    //是否可跳转应用对应的详细页面
    BOOL isOrigin;//位置是否变动
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始中心坐标位置
    CGPoint originPoint;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIImage *deleteIconImage;
  
    
}

-(instancetype)initWithFrame:(CGRect)frame showGridTitleArray:(NSMutableArray *)showGridTitleArray showImageGridArray:(NSMutableArray *)showImageGridArray showGridIDArray:(NSMutableArray *)showGridIDArray
{
    self  = [super initWithFrame:frame];
    if (self) {
        
        self.showGridTitleArray = showGridTitleArray;
        self.showImageGridArray = showImageGridArray;
        self.showGridIDArray = showGridIDArray;
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    normalImage = [UIImage imageNamed:@"app_item_bg"];
    highlightedImage = [UIImage imageNamed:@"app_item_bg"];
    deleteIconImage = [UIImage imageNamed:@"app_item_plus"];
    
    for (NSInteger index = 0; index < self.showGridTitleArray.count; index++) {
        NSString *gridTitle = _showGridTitleArray[index];
        NSString *gridImage = self.showImageGridArray[index];
        NSInteger gridID = [self.showGridIDArray[index] integerValue];
        BOOL isAddDelete = YES;
        if ([gridTitle isEqualToString:@"更多"]) {
            isAddDelete = NO;
        }
        GridButton *gridItem =[[GridButton alloc]initWithFrame:CGRectZero title:gridTitle normalImage:normalImage highlightedImage:highlightedImage girdId:gridID atIndex:index isAddDelete:isAddDelete deleteImage:deleteIconImage withIconImageString:gridImage];
        gridItem.delegate = self;
        [self addSubview:gridItem];
        [self.gridListArray addObject:gridItem];
    }
    
}
#pragma mark---点击格子---
-(void)gridItemDidClicked:(GridButton *)clickItem
{
    NSLog(@"您点击的格子Tag是：%ld", (long)clickItem.gridId);
    
    //查看是否有选中的格子，并且比较点击的格子是否就是选中的格子
    for (NSInteger i = 0; i < [_gridListArray count]; i++) {
        GridButton *item = _gridListArray[i];
        if (item.isChecked) {
            item.isChecked = NO;
            item.isMove = NO;
            isSelected = NO;
            
            //隐藏删除图标
            item.isShowRemove = YES;
            [item setBackgroundImage:normalImage forState:UIControlStateNormal];
           
        }
    }
  
        [self itemAction:clickItem];

}
-(void)gridItemDidDeleteClicked:(UIButton *)deleteButton
{
    NSLog(@"您删除的格子是GridId：%ld", (long)deleteButton.tag);
    
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        GridButton *removeGrid = _gridListArray[i];
        if (removeGrid.gridId == deleteButton.tag) {
            [removeGrid removeFromSuperview];
            NSInteger count = _gridListArray.count - 1;
            for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                GridButton *preGrid = _gridListArray[index];
                GridButton *nextGrid = _gridListArray[index+1];
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }
            //排列格子顺序和更新格子坐标信息
            [self sortGridList];
            
            [_gridListArray removeObjectAtIndex:removeGrid.gridIndex];
            
            
            
        }
    }
    // 保存更新后数组
//    [self saveArray];
    
    //更新页面
    [self updateNewFrame];

}
-(void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(GridButton *)gird
{
    NSLog(@"长按.........");
    NSLog(@"isSelected: %d", isSelected);
    
    //判断格子是否已经被选中并且是否可移动状态,如果选中就加一个放大的特效
    if (isSelected && gird.isChecked) {
        gird.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    
    //没有一个格子选中的时候
    if (!isSelected) {
        
        NSLog(@"没有一个格子选中............");
        gird.isChecked = YES;
        gird.isMove = YES;
        isSelected = YES;
        
        //选中格子的时候显示删除图标
        gird.isShowRemove = NO;
        
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = gird.center;
        
        //给选中的格子添加放大的特效
        [UIView animateWithDuration:0.5 animations:^{
            gird.transform = CGAffineTransformMakeScale(1.1, 1.1);
            gird.alpha = 1;
            [gird setBackgroundImage:highlightedImage forState:UIControlStateNormal];
        }];
    }

}
-(void)pressGestureStateChangedWithPoint:(CGPoint)gridPoint grigItem:(GridButton *)girdItem
{
    if (isSelected && girdItem.isChecked) {
        //        NSLog(@"UIGestureRecognizerStateChanged.........");
        
        [self bringSubviewToFront:girdItem];
        //应用移动后的X坐标
        CGFloat deltaX = gridPoint.x - startPoint.x;
        //应用移动后的Y坐标
        CGFloat deltaY = gridPoint.y - startPoint.y;
        //拖动的应用跟随手势移动
        girdItem.center = CGPointMake(girdItem.center.x + deltaX, girdItem.center.y + deltaY);
        
        //移动的格子索引下标
        NSInteger fromIndex = girdItem.gridIndex;
        //移动到目标格子的索引下标
        NSInteger toIndex = [GridButton indexOfPoint:girdItem.center withButton:girdItem gridArray:_gridListArray];
        if (toIndex == -1) {
            isOrigin = YES;
        }else
        {
            isOrigin = NO;
        }
        NSInteger borderIndex = [_showGridIDArray indexOfObject:@"0"];
        NSLog(@"borderIndex: %ld", (long)borderIndex);
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            contain = NO;
        }else{
            
            //获取移动到目标格子
            GridButton *targetGrid = _gridListArray[toIndex];
            girdItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            girdItem.gridIndex = toIndex;
            
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                //                NSLog(@"从后往前拖动格子.......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++) {
                    GridButton *lastGrid = _gridListArray[lastGridIndex];
                    GridButton *preGrid = _gridListArray[lastGridIndex-1];
                    [UIView animateWithDuration:0.5 animations:^{
                        preGrid.center = lastGrid.gridCenterPoint;
                    }];
                    //实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
                
            }else if((fromIndex - toIndex) < 0){
                //从前往后拖动格子
                //                NSLog(@"从前往后拖动格子.......");
                //从移动格子到目标格子之间的所有格子向前移动一格
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    GridButton *topOneGrid = _gridListArray[i];
                    GridButton *nextGrid = _gridListArray[i+1];
                    //实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
    }

}
-(void)pressGestureStateEnded:(GridButton *)gridItem
{
        NSLog(@"拖动格子结束.........");
    if (isSelected && gridItem.isChecked) {
        //撤销格子的放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            isSelected = NO;
            if (!contain) {
                gridItem.center = originPoint;
            }
        }];
        
        if (!isOrigin) {
            //排列格子顺序和更新格子坐标信息
            [self sortGridList];
            isOrigin = NO;
        }
    }

}
- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [_gridListArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GridButton *tempGrid1 = (GridButton *)obj1;
        GridButton *tempGrid2 = (GridButton *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        GridButton *gridItem = _gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    [self updateNewFrame];
}

#pragma mark ---点击 按钮----
- (void)itemAction:(GridButton *)item
{
      [self.gridViewDelegate clickGridView:item];
}
#pragma mark --- 更新页面
-(void)updateNewFrame
{
    CGFloat gridHeight;
    if (self.gridListArray.count % PerRowGridCount== 0) {
        gridHeight = GridHeight * self.gridListArray.count/PerRowGridCount;
    }
    else{
        gridHeight = GridHeight * (self.gridListArray.count/PerRowGridCount+1);
    }
    
    [self.gridViewDelegate updateHeight:gridHeight];
}

- (NSMutableArray *)showGridTitleArray {
	if(_showGridTitleArray == nil) {
		_showGridTitleArray = [[NSMutableArray alloc] init];
	}
	return _showGridTitleArray;
}

- (NSMutableArray *)showImageGridArray {
	if(_showImageGridArray == nil) {
		_showImageGridArray = [[NSMutableArray alloc] init];
	}
	return _showImageGridArray;
}

- (NSMutableArray *)showGridIDArray {
	if(_showGridIDArray == nil) {
		_showGridIDArray = [[NSMutableArray alloc] init];
	}
	return _showGridIDArray;
}

- (NSMutableArray *)gridListArray {
	if(_gridListArray == nil) {
		_gridListArray = [[NSMutableArray alloc] init];
	}
	return _gridListArray;
}

@end
