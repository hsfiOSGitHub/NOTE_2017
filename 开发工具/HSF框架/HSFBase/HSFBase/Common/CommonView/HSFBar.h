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

//类方法
+(instancetype)barWithFrame:(CGRect)frame delegate:(id<HSFBarDelegate>)delegate itemsArr:(NSArray *)itemsArr titleNorColor:(UIColor *)titleNorColor titleHdColor:(UIColor *)titleHdColor isHavePaddingView:(BOOL)ishave paddingViewColor:(UIColor *)paddingColor paddingInsert:(CGFloat)paddingInsert;


/**
 *用法：
 <HSFBarDelegate>
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
     //HSFBar
    NSArray *bar_arr = @[@{@"title":@"设置",@"icon":@"setting"},
    @{@"title":@"我的",@"icon":@"people"},
    @{@"title":@"苹果",@"icon":@"iphone"},
    @{@"title":@"心跳",@"icon":@"heart"},
    @{@"title":@"休闲",@"icon":@"tea"}];
    HSFBar *bar = [HSFBar barWithFrame:CGRectMake(5, 100, 400, 50) delegate:self itemsArr:bar_arr titleNorColor:[UIColor lightGrayColor] titleHdColor:[UIColor redColor] isHavePaddingView:YES paddingViewColor:[UIColor groupTableViewBackgroundColor] paddingInsert:10];
    bar.backgroundColor = [UIColor brownColor];
    bar.layer.masksToBounds = YES;
    bar.layer.cornerRadius = 5;
    bar.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    bar.layer.borderWidth = 1;

    [self.view addSubview:bar];
 
}

#pragma mark -HSFBarDelegate
-(void)clickItemAtIndex:(NSInteger)index{
    
}

 */


@end
