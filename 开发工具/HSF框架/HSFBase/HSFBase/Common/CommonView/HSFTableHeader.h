//
//  HSFTableHeader.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/17.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_headerHeight 200


@interface HSFTableHeader : UIView

@property (nonatomic,strong) UIImageView *bgPic;//背景图片
@property (nonatomic,strong) UIView *titleBgView;
@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) UIButton *titleBtn;

/**
 #pragma mark -UIScrollViewDelegate
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 if (scrollView == self.tableView) {
 CGFloat offset_y = scrollView.contentOffset.y;
 NSLog(@"offset_y = %f",offset_y);
 CGFloat deta = ABS(offset_y + 64);
 if (offset_y < -64) {
 self.bgImgView.frame = CGRectMake(0, -deta, kScreenWidth, k_Header_Height + deta);
 }
 //渐变色
 CGFloat changeSpace = 100;//颜色变化的范围 必须 <= k_headerHeight
 CGFloat start_y = k_Header_Height - 64 - changeSpace;
 CGFloat alpha = 0;
 alpha = (offset_y - start_y)/changeSpace;
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[k_themeColor colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
 //标题
 if (offset_y > start_y) {
 self.navigationItem.title = @"我的";
 }else{
 self.navigationItem.title = @"";
 }
 }
 }
 */

@end
