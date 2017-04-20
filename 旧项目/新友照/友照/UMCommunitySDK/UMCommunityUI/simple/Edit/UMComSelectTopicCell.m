//
//  UMComSelectTopicCell.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/25.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSelectTopicCell.h"
#import "UMComChangeBorderBtn.h"
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+Color.h>


const CGFloat g_template_selectTopic_labelWidth = 120;//cell的宽度
const CGFloat g_template_selectTopic_labeleHeight = 32;//cell的高度
const CGFloat g_template_selectTopic_labelHorizonSpace = 10;//同一行cell的间隔
const CGFloat g_template_selectTopic_labelVerticalSpace = 10;//同一列cell的间隔

@interface UMComSelectTopicCell ()

@end

@implementation UMComSelectTopicCell


-(void)handleClickTopicCollectionCell:(UIButton*)target
{
   NSInteger dataRowIndex =  target.tag;
    
    if(self.selectTopicTableViewCellDelegate &&
       [self.selectTopicTableViewCellDelegate respondsToSelector:@selector(handleClickedTopicTableViewCell:)]){
        [self.selectTopicTableViewCellDelegate handleClickedTopicTableViewCell:dataRowIndex];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor* normalColor = UMComColorWithHexString(@"#999999");
        UIColor* highlightedColor  = UMComColorWithHexString(@"#469ef8");
        
        self.leftLabelBtn = [UMComChangeBorderBtn buttonWithType:UIButtonTypeCustom];
        self.leftLabelBtn.frame = self.bounds;
        [self.leftLabelBtn.layer setCornerRadius:6];
        [self.leftLabelBtn.layer setBorderWidth:1];
        self.leftLabelBtn.tag = -1;

        self.leftLabelBtn.normalBorderColor  = normalColor;
        self.leftLabelBtn.highlightedBorderColor = highlightedColor;
        [self.leftLabelBtn setTitleColor:normalColor  forState:UIControlStateNormal];
        [self.leftLabelBtn setTitleColor:highlightedColor  forState:UIControlStateHighlighted];
        self.leftLabelBtn.backgroundColor = [UIColor clearColor];
        [self.leftLabelBtn.layer setBorderColor:normalColor.CGColor];
        [self.contentView addSubview:self.leftLabelBtn];
        
        [self.leftLabelBtn addTarget:self action:@selector(handleClickTopicCollectionCell:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.leftLabelBtn];
        
        self.leftLabelBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        self.rightLabelBtn = [UMComChangeBorderBtn buttonWithType:UIButtonTypeCustom];
        self.rightLabelBtn.frame = self.bounds;
        [self.rightLabelBtn.layer setCornerRadius:6];
        [self.rightLabelBtn.layer setBorderWidth:1];
        
        self.rightLabelBtn.normalBorderColor  = normalColor;
        self.rightLabelBtn.highlightedBorderColor = highlightedColor;
        
        [self.rightLabelBtn setTitleColor:normalColor  forState:UIControlStateNormal];
        [self.rightLabelBtn setTitleColor:highlightedColor  forState:UIControlStateHighlighted];
        self.rightLabelBtn.backgroundColor = [UIColor clearColor];
        
        [self.rightLabelBtn.layer setBorderColor:normalColor.CGColor];
        [self.contentView addSubview:self.rightLabelBtn];
        self.rightLabelBtn.tag = -1;
        
        
        [self.contentView addSubview:self.rightLabelBtn];
        
        self.rightLabelBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        CGFloat cellWidth =  [UIScreen mainScreen].bounds.size.width;
        CGFloat halfWidth =  cellWidth/2;
        CGFloat leftX =  halfWidth - g_template_selectTopic_labelHorizonSpace/2 - g_template_selectTopic_labelWidth;
        self.leftLabelBtn.frame = CGRectMake(leftX, 0, g_template_selectTopic_labelWidth, g_template_selectTopic_labeleHeight);
        
        CGFloat rightX =  halfWidth - g_template_selectTopic_labelHorizonSpace/2;
        self.rightLabelBtn.frame = CGRectMake(rightX, 0, g_template_selectTopic_labelWidth, g_template_selectTopic_labeleHeight);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIColor* normalColor = UMComColorWithHexString(@"#999999");
        UIColor* highlightedColor  = UMComColorWithHexString(@"#469ef8");
        
        self.leftLabelBtn = [UMComChangeBorderBtn buttonWithType:UIButtonTypeCustom];
        self.leftLabelBtn.frame = self.bounds;
        [self.leftLabelBtn.layer setCornerRadius:6];
        [self.leftLabelBtn.layer setBorderWidth:1];
        self.leftLabelBtn.tag = -1;
        
        self.leftLabelBtn.normalBorderColor  = normalColor;
        self.leftLabelBtn.highlightedBorderColor = highlightedColor;
        [self.leftLabelBtn setTitleColor:normalColor  forState:UIControlStateNormal];
        [self.leftLabelBtn setTitleColor:highlightedColor  forState:UIControlStateHighlighted];
        self.leftLabelBtn.backgroundColor = [UIColor clearColor];
        [self.leftLabelBtn.layer setBorderColor:normalColor.CGColor];
        [self.contentView addSubview:self.leftLabelBtn];
        
        [self.leftLabelBtn addTarget:self action:@selector(handleClickTopicCollectionCell:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftLabelBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.leftLabelBtn];
        
        
        self.rightLabelBtn = [UMComChangeBorderBtn buttonWithType:UIButtonTypeCustom];
        self.rightLabelBtn.frame = self.bounds;
        [self.rightLabelBtn.layer setCornerRadius:6];
        [self.rightLabelBtn.layer setBorderWidth:1];
        
        self.rightLabelBtn.normalBorderColor  = normalColor;
        self.rightLabelBtn.highlightedBorderColor = highlightedColor;
        
        [self.rightLabelBtn setTitleColor:normalColor  forState:UIControlStateNormal];
        [self.rightLabelBtn setTitleColor:highlightedColor  forState:UIControlStateHighlighted];
        self.rightLabelBtn.backgroundColor = [UIColor clearColor];
        
        [self.rightLabelBtn.layer setBorderColor:normalColor.CGColor];
        [self.contentView addSubview:self.rightLabelBtn];
        self.rightLabelBtn.tag = -1;
        
        [self.rightLabelBtn addTarget:self action:@selector(handleClickTopicCollectionCell:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightLabelBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.rightLabelBtn];
        
        
        CGFloat cellWidth =  [UIScreen mainScreen].bounds.size.width;
        CGFloat halfWidth =  cellWidth/2;
        CGFloat leftX =  halfWidth - g_template_selectTopic_labelHorizonSpace/2 - g_template_selectTopic_labelWidth;
        self.leftLabelBtn.frame = CGRectMake(leftX, 0, g_template_selectTopic_labelWidth, g_template_selectTopic_labeleHeight);
        
        CGFloat rightX =  halfWidth + g_template_selectTopic_labelHorizonSpace/2;
        self.rightLabelBtn.frame = CGRectMake(rightX, 0, g_template_selectTopic_labelWidth, g_template_selectTopic_labeleHeight);
    }
    return self;
}

-(void)refresCellWithLeftTopicName:(NSString*)leftTopicName
                withRightTopicName:(NSString*)rightTopicName
                       withCellRow:(NSInteger)cellRow
{
    self.cellRow = cellRow;
    if (leftTopicName) {
        self.leftLabelBtn.hidden = NO;
        
        self.leftLabelBtn.tag = cellRow*2;
        [self.leftLabelBtn setTitle:leftTopicName forState:UIControlStateNormal];
    }
    else
    {
        self.leftLabelBtn.tag = -1;
        self.leftLabelBtn.hidden = YES;
    }
    
    if (rightTopicName) {
        self.rightLabelBtn.hidden = NO;
        self.rightLabelBtn.tag = cellRow*2 + 1;
        [self.rightLabelBtn setTitle:rightTopicName forState:UIControlStateNormal];
    }
    else
    {
        self.rightLabelBtn.tag = -1;
        self.rightLabelBtn.hidden = YES;
    }
}

@end
