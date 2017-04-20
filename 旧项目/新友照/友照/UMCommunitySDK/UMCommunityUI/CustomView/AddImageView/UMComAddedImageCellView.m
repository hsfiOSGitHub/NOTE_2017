//
//  UMComAddedImageCellView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/17.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComAddedImageCellView.h"
#import "UMComActionDeleteView.h"

#define IMAGE_WIDTH 73.75

#define YPAD 5

#define TAG_PAD 99


static inline CGRect getRectForIndex(NSUInteger index, float cellPad)
{
    return CGRectMake((cellPad+IMAGE_WIDTH)*(index%4)+cellPad, (YPAD+IMAGE_WIDTH)*(index/4)+YPAD, IMAGE_WIDTH, IMAGE_WIDTH);
}


@interface UMComAddedImageCellView()
@property (nonatomic,strong) UMComActionDeleteView *deleteView;
@end

@implementation UMComAddedImageCellView


- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if(self)
    {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad
{
    self.curIndex = index;
    
    [self setFrame:getRectForIndex(index,cellPad)];
    [self setTag:index + TAG_PAD];
    
    if(!self.deleteView)
    {
        self.deleteView = [[UMComActionDeleteView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 24, 0, 24, 24)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [self.deleteView addGestureRecognizer:tapGesture];
        [self addSubview:self.deleteView];
    }

}

- (void)setIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth
{
    self.curIndex = index;
    
    [self setFrame:[self getRectForIndex:index cellPad:cellPad imageWidth:imageWidth]];
    [self setTag:index + TAG_PAD];
    if(!self.deleteView)
    {
        self.deleteView = [[UMComActionDeleteView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 24, 0, 24, 24)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [self.deleteView addGestureRecognizer:tapGesture];
        [self addSubview:self.deleteView];
    }
    
}

- (void)setCurIndex:(NSUInteger)curIndex
{
    _curIndex = curIndex;
    if (!self.deleteView) {
        self.deleteView = [[UMComActionDeleteView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 24, 0, 24, 24)];
        self.deleteView.deleteViewType = self.deleteViewType;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [self.deleteView addGestureRecognizer:tapGesture];
        [self addSubview:self.deleteView];
    }
}

-(CGRect)getRectForIndex:(NSUInteger)index cellPad:(float)cellPad imageWidth:(CGFloat)imageWidth
{
    return CGRectMake((cellPad+imageWidth)*(index%4)+cellPad, (YPAD+imageWidth)*(index/4)+YPAD, imageWidth, imageWidth);
}

- (void)deleteAction:(UITapGestureRecognizer *)tapGesture
{   
    if(self.handle)
    {
        self.handle(self);
    }
}

@end


//点击高亮的图片，只需要生成一次
static UIImage* g_btnImgForBriefAddedImageCell = nil;
@interface UMComBriefAddedImageCellView()
@property (nonatomic,strong) UIView *deleteView;
@property (nonatomic,strong) UIButton* clickButton;

- (void)deleteAction:(UITapGestureRecognizer *)tapGesture;
@end
@implementation UMComBriefAddedImageCellView

+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0,0,5,5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    
    if(self)
    {
        self.userInteractionEnabled = YES;
        

    }
    
    return self;
}

- (void)deleteAction:(UITapGestureRecognizer *)tapGesture
{
    if(self.handle)
    {
        self.handle(self);
    }
}

-(void) handleClickButton:(id)target
{
    if(self.handle)
    {
        self.handle(self);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rc =  _deleteView.frame;
    if(CGRectContainsPoint(rc,point))
    {
        return YES;
    }
   return  [super pointInside:point withEvent:event];
}

- (void)setCurIndex:(NSUInteger)curIndex
{
    _curIndex = curIndex;
    if (!_deleteView) {
        
        //method 1 只是显示一张删除图片
//        _deleteView = [[UIImageView alloc] initWithImage:UMComSimpleImageWithImageName(@"um_com_edit_delete")];
//        _deleteView.frame = CGRectMake(0, 0, 20, 22);
//        _deleteView.center = CGPointMake(0, 0);
        
        //method2 显示点击删除图片的高亮
        UIButton* deleteView = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteView.frame = CGRectMake(0, 0, 20, 22);
        deleteView.center = CGPointMake(0, 0);
        if (self.deleteImg) {
            [deleteView setImage:self.deleteImg forState:UIControlStateNormal];
        }
        [deleteView addTarget:self action:@selector(handleClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _deleteView = deleteView;
        _deleteView.exclusiveTouch = YES;
        [self addSubview:deleteView];
        
        
        
        //method 1 (没有点击效果)
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
//        [self addGestureRecognizer:tapGesture];
        
        
        //method 2 (加入button，有点击效果)
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _clickButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _clickButton.exclusiveTouch = YES;
        [_clickButton addTarget:self action:@selector(handleClickButton:) forControlEvents:UIControlEventTouchUpInside];
        _clickButton.backgroundColor = [UIColor clearColor];
        
        if(!g_btnImgForBriefAddedImageCell)
        {
          UIColor* btnColor =   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            
           g_btnImgForBriefAddedImageCell =  [UMComBriefAddedImageCellView buttonImageFromColor:btnColor];
        }
        [_clickButton setBackgroundImage:g_btnImgForBriefAddedImageCell forState:UIControlStateHighlighted];
        [self addSubview:_clickButton];
    }
}


@end
