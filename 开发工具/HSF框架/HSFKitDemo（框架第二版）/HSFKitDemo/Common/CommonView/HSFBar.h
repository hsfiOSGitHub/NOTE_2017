//
//  HSFBar.h
//  UserfullUIKit
//
//  Created by JuZhenBaoiMac on 2017/6/16.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_padding_width 1

@protocol HSFBarDelegate <NSObject>

@optional

-(void)clickItemAtIndex:(NSInteger)index;

@end

@interface HSFBar : UIView

@property (nonatomic,assign) id<HSFBarDelegate>delegate;
@property (nonatomic,strong) NSArray *itemsArr;
@property (nonatomic,strong) UIColor *titleNorColor;
@property (nonatomic,strong) UIColor *titleHdColor;
@property (nonatomic,assign) BOOL isHavePaddingView;
@property (nonatomic,strong) UIColor *paddingViewColor;
@property (nonatomic,assign) CGFloat paddingInsert;
@property (nonatomic,assign) BOOL isHaveBaseline;
@property (nonatomic,strong) UIColor *baselineColor;
@property (nonatomic,assign) CGFloat baselineInsert;
@property (nonatomic,assign) CGFloat baselineHeight;
@property (nonatomic,assign) NSInteger currentSeleteIndex;//当前baseline的位置


//在最后，必须要实现的方法
-(void)setUp;





@end
