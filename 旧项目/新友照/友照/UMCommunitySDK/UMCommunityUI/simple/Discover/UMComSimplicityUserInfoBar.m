//
//  UMComUserInfoBar.m
//  UMCommunity
//
//  Created by umeng on 1/21/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimplicityUserInfoBar.h"
#import "UMComResouceDefines.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComMedalImageView.h"
#import <UMComDataStorage/UMComMedal.h>
#import "UMComLoginManager.h"
#import <UMComFoundation/UMComKit+Autolayout.h>
#import <UMComFoundation/UMComKit+Color.h>
#import "UMComNotificationMacro.h"


@interface UMComSimplicityUserInfoBar ()<UMComImageViewDelegate, UMImageViewDelegate>

//单个勋章显示
//@property(nonatomic,strong)UMComMedalImageView* medalView;

////多勋章布局
//@property(nonatomic,assign)NSInteger curMedalCount;//勋章的数量(最大5个)
//@property(nonatomic,strong)NSMutableArray* medalViewArray;//包含勋章控件
//-(void) createMedalViews;
//-(void) requestIMGForMedalViews:(UMComUser*)user;
//-(void) clearRequestForMedalViews;
//-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView;
//-(void) layoutMedalViews;

@end

@implementation UMComSimplicityUserInfoBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self createMedalViews];
    
    self.layer.borderColor = UMComColorWithHexString(@"#dfdfdf").CGColor;
    self.layer.borderWidth = 1.f;
    
    self.name.textColor = UMComColorWithHexString(@"#666666");
    self.name.font = UMComFontNotoSansLightWithSafeSize(15);
    
    __weak typeof(self) ws = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kUserLoginSucceedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [ws refresh];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kUserUpdateAvatarSucceedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [ws refresh];
    }];
    
}

- (void)refresh
{
    UMComUser *user = [UMComSession sharedInstance].loginUser;
    if (user) {
         _name.text = user.name;
        
        if (user.gender.integerValue == 0) {
            _genderIcon.image = UMComSimpleImageWithImageName(@"um_com_female");
        }
        else{
            _genderIcon.image = UMComSimpleImageWithImageName(@"um_com_male");
        }
        
        if (user.medal_list.count > 0) {
            UMComMedal* medal =  user.medal_list.firstObject;
            if (medal && [medal isKindOfClass:[UMComMedal class]]) {
                self.medalView.delegate = self;
                self.medalView.isAutoStart = YES;
                [self.medalView setImageURL:medal.icon_url placeHolderImage:UMComSimpleImageWithImageName(@"um_com_authorized_smal")];
            }
            else{
                [self.medalView setImageURL:nil placeHolderImage:UMComSimpleImageWithImageName(@"um_com_authorized_smal")];
            }
        }
        else
        {
            [self.medalView removeFromSuperview];
        }
        
        UMComColorWithHexString(@"34C035").CGColor;
        [_avatar setImageURL:[user.icon_url small_url_string] placeHolderImage:UMComSimpleImageWithImageName(@"um_default_avatar")];
        _loginTip.hidden = YES;
        _userInfoBar.hidden = NO;
    } else {
        _loginTip.hidden = NO;
        _userInfoBar.hidden = YES;
        [_avatar setImage:UMComSimpleImageWithImageName(@"um_default_avatar")];
    }
}

//- (void)hideInfoSubviews:(BOOL)hide
//{
//    _name.hidden = hide;
//    if (hide) {
//        [self clearRequestForMedalViews];
//    }
//}

-(void) updateMedalWithImageView:(UMImageView *)imageView;
{
    CGFloat width =  imageView.bounds.size.width;
    CGFloat height =  imageView.bounds.size.height;
    CGSize imageSize =  imageView.image.size;
    width = imageSize.width * height/ imageSize.height;
    
    [UMComKit ALView:imageView setConstraintConstant:width forAttribute:NSLayoutAttributeWidth];
}

- (void)imageViewLoadedImage:(UMImageView*)imageView
{
    [self updateMedalWithImageView:imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//#pragma mark - 勋章相关
//-(void) createMedalViews
//{
//    //创建默认的medalViewArray队列
//    self.medalViewArray = [NSMutableArray arrayWithCapacity:[UMComMedalImageView maxMedalCount]];
//    
//    //创建勋章
//    for(NSInteger i = 0; i < [UMComMedalImageView maxMedalCount]; i++)
//    {
//        UMComMedalImageView* medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
//        medalView.tag = i;
//        medalView.contentMode =  UIViewContentModeScaleAspectFit;
//        [self.medalViewArray addObject:medalView];
//        [self addSubview:medalView];
//    }
//}
//
//-(void) requestIMGForMedalViews:(UMComUser*)user
//{
//    if (user.medal_list.count > 0) {
//        //确认当前勋章不能超过[UMComMedalImageView maxMedalCount]
//        self.curMedalCount = user.medal_list.count;
//        if (self.curMedalCount > [UMComMedalImageView maxMedalCount]) {
//            self.curMedalCount = [UMComMedalImageView maxMedalCount];
//        }
//        
//        for(int i = 0;i < self.curMedalCount; i++)
//        {
//            UMComMedalImageView* medalView  = self.medalViewArray[i];
//            if (medalView) {
//                medalView.hidden = NO;
//                UMComMedal* umcomMedal = (UMComMedal*)user.medal_list[i];
//                if (umcomMedal && umcomMedal.icon_url) {
//                    medalView.imageLoaderDelegate =  nil;
//                    medalView.isAutoStart = YES;
//                    [medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
//                    medalView.imageLoaderDelegate =  self;
//                }
//                else{
//                    medalView.hidden = YES;
//                }
//                
//            }
//        }
//        
//        [self layoutMedalViews];
//    }
//}
//
//-(void) clearRequestForMedalViews
//{
//    for(int i = 0;i < self.medalViewArray.count; i++)
//    {
//        UMComMedalImageView* medalView  = self.medalViewArray[i];
//        if (medalView) {
//            medalView.hidden = YES;
//            medalView.imageLoaderDelegate = nil;
//        }
//    }
//}
//
//-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView
//{
//    if (!medalView) {
//        return CGSizeMake(0, 0);
//    }
//    
//    //先确定勋章图片的宽度和高度；
//    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
//    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
//    
//    CGSize cellSize = self.bounds.size;
//    
//    if (medalView.image) {
//        
//        CGSize  tempSize = medalView.image.size;
//        
//        if (tempSize.height <= medalHeight) {
//            medalHeight = tempSize.height;
//        }
//        else{
//            //目前只是简单的判断图片的高度是否超过self.nameLabel.frame的高度
//            if (tempSize.height < self.name.frame.size.height) {
//                medalHeight = tempSize.height;
//            }
//            else
//            {
//                medalHeight = self.name.frame.size.height;
//            }
//        }
//        
//        if (tempSize.width <= medalWidth) {
//            medalWidth = tempSize.width;
//        }
//        else{
//            //根据图片的宽高比，算勋章的宽度
//            medalWidth =  medalHeight * tempSize.width /  tempSize.height;
//            if (medalWidth >= cellSize.width) {
//                //如果宽度大于cell的宽度就设置为默认值(此处只是简单判断)
//                medalWidth = [UMComMedalImageView defaultWidth];
//            }
//        }
//    }
//    
//    medalView.bounds = CGRectMake(0, 0, medalWidth, medalHeight);
//    return medalView.bounds.size;
//}
//
//-(void) layoutMedalViews
//{
//    //先确定勋章图片的宽度和高度
//    CGFloat totalMedalWidth = 0;
//    for (int i = 0; i < self.curMedalCount; i++) {
//        
//        //先计算图片的宽高
//        UMComMedalImageView* medalView  = self.medalViewArray[i];
//        if (medalView) {
//            CGSize medalViewSize = [self computeMedalViewSize:medalView];
//            totalMedalWidth += medalViewSize.width + [UMComMedalImageView spaceBetweenMedalViews];
//        }
//    }
//
//    //计算nameLabel的宽度
//    CGFloat nameLabelWidth = 0;
//    CGFloat nameLabelMaxWidth = self.bounds.size.width -  self.name.frame.origin.x  - totalMedalWidth - 10;
//    CGSize nameLabelSize = [self.name.text sizeWithFont:self.name.font];
//    if (nameLabelSize.width > nameLabelMaxWidth) {
//        nameLabelWidth = nameLabelMaxWidth;
//    }
//    else{
//        nameLabelWidth = nameLabelSize.width;
//    }
//    
//    //确定nameLabel的范围
//    CGRect nameLabelFrame = self.name.frame;
//    nameLabelFrame.size.width = nameLabelWidth;
//    self.name.frame = nameLabelFrame;
//    
//    //确定medalViews的范围
//    CGFloat offsetX = self.name.frame.origin.x + self.name.frame.size.width + 5;
//    CGFloat offsetY = self.name.frame.origin.y;
//    for (int i = 0; i < self.curMedalCount; i++) {
//        
//        UMComMedalImageView* medalView  = self.medalViewArray[i];
//        if (medalView) {
//            CGRect medalViewFrame =  medalView.frame;
//            medalViewFrame.origin.x = offsetX;
//            medalViewFrame.origin.y = offsetY;
//            medalView.frame = medalViewFrame;
//            offsetX += medalViewFrame.size.width + [UMComMedalImageView spaceBetweenMedalViews];
//        }
//    }
//}
//
//- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView
//{
//    [self layoutMedalViews];
//}

@end
