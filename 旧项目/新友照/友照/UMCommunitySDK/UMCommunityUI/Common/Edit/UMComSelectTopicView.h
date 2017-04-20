//
//  UMComSelectTopicView.h
//  UMCommunity
//
//  Created by 张军华 on 16/3/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SelectedTopicViewBlock)();

/**
 *  编辑界面显示选择话题控件
 */
@interface UMComSelectTopicView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *indicatorView;

@property(nonatomic,strong) UIColor* locationbackgroudColor;//背景色

@property(nonatomic,readwrite,copy)SelectedTopicViewBlock seletctedTopicBlock;

@property(nonatomic,readwrite,assign)BOOL isDimed;//YES 不会有点击效果 NO 有点击效果
/**
 *  重新布局子控件,
 *  1.如果topicName为空或者空字符串就显示提示控件
 *  2.反之就隐藏提示控件，显示位置控件
 */
-(void) relayoutChildControlsWithTopicName:(NSString*)topicName;

@end
