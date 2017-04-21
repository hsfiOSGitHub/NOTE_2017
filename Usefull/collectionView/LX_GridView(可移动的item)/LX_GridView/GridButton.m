//
//  GridButton.m
//  DemoSummary
//
//  Created by chuanglong02 on 16/9/20.
//  Copyright © 2016年 chuanglong02. All rights reserved.
//

#import "GridButton.h"
@interface GridButton()
@property(nonatomic,strong)UIButton *deleteBtn;
@end
@implementation GridButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage girdId:(NSInteger)gridId atIndex:(NSInteger)index isAddDelete:(BOOL)isAddDelete deleteImage:(UIImage *)deleteImage withIconImageString:(NSString *)iconImageString
{
    self = [super initWithFrame:frame];
    if (self) {
        //计算每个格子的坐标
        CGFloat pointX = (index % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;
        //计算每个格子的Y坐标
        CGFloat pointY = (index / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        self.frame = CGRectMake(pointX, pointY, GridWidth+1, GridHeight +1);
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        // 图片icon
        UIImageView * imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-18, 34, 36, 36)];
        imageIcon.image = [UIImage imageNamed:iconImageString];
        [self addSubview:imageIcon];
        
        // 标题
        UILabel * title_label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-42, 75, 84, 20)];
        title_label.text = title;
        title_label.textAlignment = NSTextAlignmentCenter;
        title_label.font = [UIFont systemFontOfSize:14];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.textColor = [UIColor hexStringToColor:@"#3c454c"];
        [self addSubview:title_label];
        
        self.gridId = gridId;
        self.gridIndex = index;
        self.gridCenterPoint = self.center;
        self.gridImageString = iconImageString;
        self.gridTitle = title;
        //判断是否要添加删除图标
        if (isAddDelete) {
            //当长按是添加删除按钮图标
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(self.frame.size.width-30, 10, 20, 20)];
            [deleteBtn setBackgroundColor:[UIColor clearColor]];
            [deleteBtn setBackgroundImage:deleteImage forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.hidden = YES;
            deleteBtn.tag = self.gridId ;
            NSLog(@"%ld",deleteBtn.tag);
            [self addSubview:deleteBtn];
            self.deleteBtn = deleteBtn;
            //添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
            longPressGesture = nil;
        }
    }
    return self;
}
-(void)setIsShowRemove:(BOOL)isShowRemove
{
    _isShowRemove = isShowRemove;
    self.deleteBtn.hidden = _isShowRemove;
}
//响应格子点击事件
- (void)gridClick:(GridButton *)clickItem
{
    [self.delegate gridItemDidClicked:clickItem];
}
//响应格子删除事件
- (void)deleteGrid:(UIButton *)deleteButton
{
    [self.delegate gridItemDidDeleteClicked:deleteButton];
}
//响应格子的长安手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            [self.delegate pressGestureStateChangedWithPoint:newPoint grigItem:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate pressGestureStateEnded:self];
            break;
        }
        default:
            break;
    }
}
//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0;i< gridListArray.count;i++)
    {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn)
        {
            if (CGRectContainsPoint(appButton.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}
@end
