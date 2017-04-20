//
//  UMComFeedDetailViewHtmlBodyCell.m
//  UMCommunity
//
//  Created by 张军华 on 16/3/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedDetailViewHtmlBodyCell.h"
#import <UMCommunitySDK/UMComSession.h>
#import "UMComClickActionDelegate.h"
#import <UMComDataStorage/UMComTopic.h>
#import <UMComDataStorage/UMComFeed.h>
#import "UMComMutiStyleTextView.h"
#import "UMComImageView.h"
#import "UMComGridView.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComMedal.h>
#import <UMComDataStorage/UMComLocation.h>
#import "UMComMedalImageView.h"
#import "UMComWebView.h"
#import "UMComHtmlFeedStyle.h"
#import <UMComDataStorage/UMComUser.h>
#import "UMComUserDataController.h"
#import "UMComTopicDataController.h"
#import <UMComFoundation/UMComKit+Color.h>
#import <UMComFoundation/UMComKit+String.h>

@interface UMComFeedDetailViewHtmlBodyCell ()<UMComClickActionDelegate,UMComImageViewDelegate,UMComWebViewDelegate>

-(void) createSubViews;
-(void) initSubViews;
-(void) createWebView;



//表示UIWebView的加载完成标志
@property(nonatomic,readwrite,assign)BOOL isWebViewLoadingFinished;

//布局并返回WebView上面控件的高度
-(CGFloat)doLayoutWebViewAboveWithFeedStyle:(UMComHtmlFeedStyle *)feedStyle viewWidth:(CGFloat)viewWidth;
//布局并返回webview的高度
-(CGFloat)doLayoutWebViewWithFeedStyle:(UMComHtmlFeedStyle *)feedStyle viewWidth:(CGFloat)viewWidth;

//布局头像
- (void)doLayoutAvatarImageViewWithFeed:(UMComFeed *)feed;



//多勋章布局
@property(nonatomic,assign)NSInteger curMedalCount;//勋章的数量(最大5个)
@property(nonatomic,strong)NSMutableArray* medalViewArray;//包含勋章控件(UMComMedalImageView)
-(void) createMedalViews;
-(void) requestIMGForMedalViews:(UMComUser*)user;
-(void) clearRequestForMedalViews;
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView;
-(void) layoutMedalViews;
@end

@implementation UMComFeedDetailViewHtmlBodyCell

#pragma mark - overide method from NSObject

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self initSubViews];
        [self createMedalViews];
    }
    return  self;
}

#pragma mark - new method

-(void) createSubViews
{
    self.feedBgView =  [[UIView alloc] init];
    [self.contentView addSubview:self.feedBgView];
    //self.feedBgView = self.contentView;
    
    self.topImage = [[UIImageView alloc] init];
    self.eletImage = [[UIImageView alloc] init];
    self.publicImage = [[UIImageView alloc] init];
    
    [self.feedBgView addSubview:self.topImage];
    [self.feedBgView addSubview:self.eletImage];
    [self.feedBgView addSubview:self.publicImage];
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.portrait = [[UMComImageView alloc] init];
    
    self.createTime = [[UILabel alloc] init];
    self.createTime.backgroundColor = [UIColor clearColor];
    
    self.loacationIMG = [[UMComImageView alloc] init];
    self.loacationName = [[UILabel alloc] init];
    
    [self.feedBgView addSubview:self.nameLabel];
    [self.feedBgView addSubview:self.portrait];
    [self.feedBgView addSubview:self.createTime];
    [self.feedBgView addSubview:self.loacationIMG];
    [self.feedBgView addSubview:self.loacationName];

    [self createWebView];
}

-(void) initSubViews
{
    //设置控件属性
    self.contentView.backgroundColor = UMComColorWithHexString(UMCom_Micro_Feed_CellBgCollor);
    self.feedBgView.layer.cornerRadius = 5;
    self.feedBgView.layer.borderWidth = 1;
    self.feedBgView.layer.borderColor = UMComColorWithHexString(@"#EEEFF3").CGColor;
    self.feedBgView.clipsToBounds = YES;
    self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(UMCom_Micro_Feed_Avata_LeftEdge, UMCom_Micro_Feed_Avata_TopEdge, UMCom_Micro_Feed_Avata_Width, UMCom_Micro_Feed_Avata_Width)];
    self.portrait.userInteractionEnabled = YES;
    [self.feedBgView addSubview:self.portrait];
    
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPortrait)];
    [self.portrait addGestureRecognizer:tapPortrait];
    
    self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    self.nameLabel.textColor = UMComColorWithHexString(UMCom_Micro_Feed_NameCollor);
    
    self.createTime.font = UMComFontNotoSansLightWithSafeSize(10);
    self.createTime.textColor = UMComColorWithHexString(UMCom_Micro_Feed_CreateTimeCollor);
    
    self.loacationIMG.contentMode = UIViewContentModeScaleAspectFit;
    self.loacationIMG.image = UMComImageWithImageName(@"um_forum_location");
    self.loacationName.font = UMComFontNotoSansLightWithSafeSize(14);
    self.loacationName.textColor = UMComColorWithHexString(UMCom_Micro_Feed_LocationCollor);
    

    self.topImage.image = UMComImageWithImageName(@"um_micro_feed_top");
    self.eletImage.image = UMComImageWithImageName(@"um_micro_feed_elite");
    self.publicImage.image = UMComImageWithImageName(@"um_forum_post_bulletin");
    
    //设置置顶，精华，和公告的位置（公告的位置在最右端可能会变）
    self.topImage.frame = CGRectMake(10, 0, 13, 13);
    self.eletImage.frame = CGRectMake(31, 0, 13, 13);
    self.publicImage.frame = CGRectMake(336, 0, 29, 29);
    
}

-(void) createWebView
{
    CGFloat contentWidth = self.contentView.bounds.size.width - UMCom_Micro_FeedContent_LeftEdge - UMCom_Micro_FeedContent_RightEdge;
    self.webView = [[UMComWebView alloc]initWithFrame:CGRectMake(UMCom_Micro_FeedContent_LeftEdge, self.portrait.frame.origin.y + self.portrait.frame.size.height + UMCom_Micro_Feed_SpaceBetweenAvataAndWebView, contentWidth, UMCom_Micro_Feed_WebViewDefaultHeight)];
    
    self.webView.UMComWebViewDelegate = self;
    [self.feedBgView addSubview:self.webView];
}

#pragma mark -
- (void)layoutFeedWithfeedStyle:(UMComHtmlFeedStyle *)feedStyle tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.feedBgView.frame;
    frame.origin.y = self.cellBgViewTopEdge;
    frame.size.width = self.contentView.frame.size.width - frame.origin.x*2;
    frame.size.height = feedStyle.totalHeight;
    self.feedBgView.frame = frame;
    self.feed = feedStyle.feed;
    self.indexPath = indexPath;
    self.feedStyle = feedStyle;
    
    CGFloat totalHeight = 0;
    totalHeight += [self doLayoutWebViewAboveWithFeedStyle:self.feedStyle viewWidth:self.feedBgView.frame.size.width];
    
   totalHeight += [self doLayoutWebViewWithFeedStyle:self.feedStyle viewWidth:self.feedBgView.frame.size.width];
}

#pragma mark - back method
/**
 *  布局uiwebview上面显示的控件
 *
 *  @param feedStyle
 *  @param viewWidth
 *
 *  @return 返回uiwebview上面控件的高度
 */
-(CGFloat)doLayoutWebViewAboveWithFeedStyle:(UMComHtmlFeedStyle *)feedStyle viewWidth:(CGFloat)viewWidth
{
    UMComFeed *feed = feedStyle.feed;
    self.nameLabel.text = feed.creator.name;
    
    //刷新头像
    [self doLayoutAvatarImageViewWithFeed:feed];
    
    CGRect eletImageFrame = self.eletImage.frame;
    if ([feed.type intValue] == 1) {
        if (feedStyle.isShowTopImage) {
            eletImageFrame.origin.x = self.topImage.frame.origin.x + self.topImage.frame.size.width + 8;
        }else{
            eletImageFrame.origin.x = self.topImage.frame.origin.x;
        }

        //设置公告的位置
        CGRect publicImage = self.publicImage.frame;
        CGFloat publicImageOrginx = viewWidth - publicImage.size.width;
        publicImage.origin.x = publicImageOrginx;
        self.publicImage.frame = publicImage;
        self.publicImage.hidden = NO;
    }else{
        self.publicImage.hidden = YES;
    }
    
    if (feedStyle.isShowTopImage) {
        self.topImage.hidden = NO;
    }else{
        self.topImage.hidden = YES;
    }
    
    if ([feed.tag integerValue] == 1) {
        CGRect eletImageFrame = self.eletImage.frame;
        if (self.topImage.hidden == NO) {
            eletImageFrame.origin.x = self.topImage.frame.origin.x + self.topImage.frame.size.width + 10;
        }else{
            eletImageFrame.origin.x = self.topImage.frame.origin.x;
        }
        self.eletImage.frame = eletImageFrame;
        self.eletImage.hidden = NO;
    }else{
        self.eletImage.hidden = YES;
    }
    
    CGFloat maxNameWidth = 0;
    //布局location
    NSString* locationName = feedStyle.locationModel.name;
    locationName = nil;//此处不显示location
    if (!locationName) {
        locationName = @"";
        self.loacationName.text = locationName;
        self.loacationIMG.hidden = YES;
        self.loacationName.hidden = YES;
        
        maxNameWidth = feedStyle.contentWidth - (UMCom_Micro_FeedContent_LeftEdge + UMCom_Micro_Feed_Avata_Width + UMCom_Micro_Feed_SpaceBetweenNameAndAvata);
    }
    else
    {
        self.loacationIMG.hidden = NO;
        self.loacationName.hidden = NO;
        CGSize textSize = [locationName sizeWithFont:self.loacationName.font];
        if (textSize.width > UMCom_Micro_Feed_LocationNameMaxWidth) {
            textSize.width = UMCom_Micro_Feed_LocationNameMaxWidth;
        }
        self.loacationName.frame = CGRectMake(feedStyle.contentWidth - textSize.width,UMCom_Micro_Feed_LocationNameTopMargin , textSize.width, UMCom_Micro_Feed_LocationNameMaxHeight);
        
        self.loacationName.text = locationName;
        
        self.loacationIMG.frame = CGRectMake(feedStyle.contentWidth - textSize.width - UMCom_Micro_Feed_LocationIMGWidth -UMCom_Micro_Feed_SpaceBetweenLocationNameAndIMG,UMCom_Micro_Feed_LocationNameTopMargin,UMCom_Micro_Feed_LocationIMGWidth,UMCom_Micro_Feed_LocationIMGHeight);
       
        maxNameWidth = feedStyle.contentWidth - (UMCom_Micro_FeedContent_LeftEdge + UMCom_Micro_Feed_Avata_Width + UMCom_Micro_Feed_SpaceBetweenNameAndAvata + textSize.width + UMCom_Micro_Feed_LocationIMGWidth);
        
    }
    
    


    self.nameLabel.frame = CGRectMake(UMCom_Micro_FeedContent_LeftEdge + UMCom_Micro_Feed_Avata_Width + UMCom_Micro_Feed_SpaceBetweenNameAndAvata, UMCom_Micro_FeedContent_TopEdge, feedStyle.contentWidth, UserNameLabelViewHeight);
    
    self.createTime.frame = CGRectMake(UMCom_Micro_FeedContent_LeftEdge + UMCom_Micro_Feed_Avata_Width + UMCom_Micro_Feed_SpaceBetweenNameAndAvata,self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + UMCom_Micro_Feed_SpaceBetweenNameAndTime, feedStyle.contentWidth,UMCom_Micro_Feed_CreateTimeHeight);
    self.createTime.text = createTimeString(feed.create_time);
    
    //布局勋章(包括重新布局nameLabel的宽度)---begin
    UMComUser* user = feed.creator;
    if (user.medal_list.count > 0) {
        [self clearRequestForMedalViews];
        [self requestIMGForMedalViews:feed.creator];
    }
    else{
        [self clearRequestForMedalViews];
    }
    //布局勋章(包括重新布局nameLabel的宽度)---end
    
    CGFloat totalHeight = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height;
    
    return totalHeight;
}

/**
 *  布局并返回webview的高度
 *
 *  @param feedStyle
 *  @param viewWidth
 *
 *  @return 返回高度
 */
-(CGFloat)doLayoutWebViewWithFeedStyle:(UMComHtmlFeedStyle *)feedStyle viewWidth:(CGFloat)viewWidth
{
    UMComFeed *feed = feedStyle.feed;
    if (feed) {
        NSString* orginRichText = feed.rich_text;
        if (!orginRichText) {
            orginRichText = @"<html>                     \
            <head>  \
            </head> \
            <body>                           \
            <p>内容为空。</p>            \
            </body>                     \
            </html>                     \
            ";
        }
        
      NSString* htmlString = nil;
      if (![orginRichText hasPrefix:@"<html>"] || ![orginRichText hasSuffix:@"</html>"]) {
            NSMutableString* realRichText =  [NSMutableString stringWithCapacity:10];
            
            [realRichText appendString:@"<html><head></head><body>"];
            [realRichText appendString:orginRichText];
            [realRichText appendString:@"</body></html>"];
            htmlString = realRichText;
        }
        else
        {
            htmlString = orginRichText;
        }

       
        //test1
        /*
           htmlString = @"<html>                     \
            <head>  \
            <script type=\"text/javascript\"> \
            function disp_alert()           \
            {                           \
                alert(\"我是警告框！！\") \
            }                               \
            </script>   \
            </head> \
                                    <body>                      \
                                    <p>这是段落1。</p>            \
                                    <p>这是段落2。</p>            \
                                                                \
                                <input type=\"button\" onclick=\"disp_alert()\" value=\"显示警告框\" /> \
                                    <p>这是段落3。</p>            \
                                                                \
                                    <img src=\"http://img.ivsky.com/img/tupian/t/201512/11/weimei_hongye-001.jpg\" />                                   \
                                    <p>这是段落4是大图，显示不了。</p>\
                                    <img src=\"http://p3.so.qhimg.com/t0180d87c6f3cdccaa8.jpg\" /> \
        <p>这是段落5是大图，壁纸。</p>    \
        <img src=\"http://pics.sc.chinaz.com/files/pic/pic9/201602/apic18885.jpg\"> \
                                    <p>这是段落5。</p> \
                                            <img src=\"http://n.sinaimg.cn/news/20160308/BAgi-fxqafha0461772.jpg\" /> \
                                    <p>这是淘宝网。</p> \
                                    <a href=\"https://www.taobao.com\">淘宝网站</a> \
                                    <p>这是优酷。</p> \
                                    <a href =\"http://www.youku.com\">优酷</a> \
                                    <p>段落元素由 p 标签定义。</p> \
                                    </body>                     \
                                    </html>                     \
                                    ";
         */
        
        NSError* error;
        [self.webView loadHTMLString:htmlString baseURL:nil error:&error];
        if (error) {
        }
    }
    else{}
    
    CGRect webViewFrame = self.webView.frame;
    webViewFrame.origin.x = UMCom_Micro_FeedContent_LeftEdge;
    webViewFrame.origin.y = self.portrait.frame.origin.y + self.portrait.frame.size.height+UMCom_Micro_Feed_SpaceBetweenAvataAndWebView;
    webViewFrame.size.width = self.feedStyle.contentWidth;
    self.feedBgView.backgroundColor = [UIColor clearColor];
    
    self.webView.frame = webViewFrame;
    
    CGFloat totalHeight = UMCom_Micro_Feed_SpaceBetweenAvataAndWebView + self.webView.frame.size.height;
    return totalHeight;
}



- (void)doLayoutAvatarImageViewWithFeed:(UMComFeed *)feed
{
    NSString *iconString = [feed.creator iconUrlStrWithType:UMComIconSmallType];
    UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[feed.creator.gender integerValue]];
    [self.portrait setImageURL:iconString placeHolderImage:placeHolderImage];
    self.portrait.clipsToBounds = YES;
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
}


/****************************reload subViews views end *****************************/
#pragma mark - UMComClickActionDelegate
- (void)didTapPortrait
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:self.feed.creator];
    }
}


- (void)clickInUrl:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.delegate customObj:self clickOnURL:text];
    }
}

- (void)goToForwardDetailView
{
    if ([self.feed.origin_feed.status intValue] >= FeedStatusDeleted) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnOriginFeedText:)]) {
        [self.delegate customObj:self clickOnOriginFeedText:self.feed.origin_feed];
    }
}

- (void)goToFeedDetailView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.feed];
    }
}

- (void)tapOnImageGridView
{
    if (self.feed.origin_feed) {
        [self goToForwardDetailView];
    }else{
        [self goToFeedDetailView];
    }
}

- (void)clickInUserWithUserNameString:(NSString *)nameString
{
    NSString *name = [nameString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSMutableArray *relatedUsers = [NSMutableArray arrayWithArray:self.feed.related_user];
    if (self.feed.origin_feed.creator) {
        [relatedUsers addObject:self.feed.origin_feed.creator];
    }
    for (UMComUser * user in relatedUsers) {
        if ([name isEqualToString:user.name]) {
            [self turnToUserCenterWithUser:user];
            break;
        }
    }
}


- (void)clickInTopicWithTopicNameString:(NSString *)topicNameString
{
    NSString *topicName = [topicNameString substringWithRange:NSMakeRange(1, topicNameString.length -2)];
    for (UMComTopic * topic in self.feed.topics) {
        if ([topicName isEqualToString:topic.name]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {
                [self.delegate customObj:self clickOnTopic:topic];
            }
            break;
        }
    }
}

- (void)turnToUserCenterWithUser:(UMComUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:user];
    }
}

-(void)onClickUserProfile:(id)sender
{
    UMComUser *feedCreator = self.feed.creator;
    [self turnToUserCenterWithUser:feedCreator];
}

- (void)goToFeedDetaiView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.feed];
    }
}

- (IBAction)didClickOnForwardButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnForward:)]) {
        [self.delegate customObj:self clickOnForward:self.feed];
    }
}

- (IBAction)didClickOnLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnLikeFeed:)]) {
        [self.delegate customObj:self  clickOnLikeFeed:self.feed];
    }
}

- (IBAction)didClickOnCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnComment:feed:)]) {
        [self.delegate customObj:self clickOnComment:nil feed:self.feed];
    }
}

- (IBAction)onClickOnMoreButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clikeOnMoreButton:)]) {
        [self.delegate customObj:self clikeOnMoreButton:sender];
    }
}


#pragma mark - 勋章相关
-(void) createMedalViews
{
    //创建默认的medalViewArray队列
    self.medalViewArray = [NSMutableArray arrayWithCapacity:[UMComMedalImageView maxMedalCount]];
    
    //创建勋章
    for(NSInteger i = 0; i < [UMComMedalImageView maxMedalCount]; i++)
    {
        UMComMedalImageView* medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
        medalView.tag = i;
        medalView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.medalViewArray addObject:medalView];
        [self.feedBgView addSubview:medalView];
    }
}

-(void) requestIMGForMedalViews:(UMComUser*)user
{
    if (user.medal_list.count > 0) {
        //确认当前勋章不能超过[UMComMedalImageView maxMedalCount]
        self.curMedalCount = user.medal_list.count;
        if (self.curMedalCount > [UMComMedalImageView maxMedalCount]) {
            self.curMedalCount = [UMComMedalImageView maxMedalCount];
        }
        
        for(int i = 0;i < self.curMedalCount; i++)
        {
            UMComMedalImageView* medalView  = self.medalViewArray[i];
            if (medalView) {
                medalView.hidden = NO;
                UMComMedal* umcomMedal = (UMComMedal*)user.medal_list[i];
                if (umcomMedal && umcomMedal.icon_url) {
                    medalView.imageLoaderDelegate =  nil;
                    medalView.isAutoStart = YES;
                    [medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
                    medalView.imageLoaderDelegate =  self;
                }
                else{
                    medalView.hidden = YES;
                }
                
            }
        }
        
        [self layoutMedalViews];
    }
}

-(void) clearRequestForMedalViews
{
    for(int i = 0;i < self.medalViewArray.count; i++)
    {
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            medalView.hidden = YES;
            medalView.imageLoaderDelegate = nil;
        }
    }
}

//计算一个medalview的size
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView
{
    if (!medalView) {
        return CGSizeMake(0, 0);
    }
    
    //先确定勋章图片的宽度和高度；
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
    
    CGSize cellSize = self.contentView.bounds.size;
    
    if (medalView.image) {
        
        CGSize  tempSize = medalView.image.size;
        
        if (tempSize.height <= medalHeight) {
            medalHeight = tempSize.height;
        }
        else{
            //目前只是简单的判断图片的高度是否超过self.nameLabel.frame的高度
            if (tempSize.height < self.nameLabel.frame.size.height) {
                medalHeight = tempSize.height;
            }
            else
            {
                medalHeight = self.nameLabel.frame.size.height;
            }
        }
        
        if (tempSize.width <= medalWidth) {
            medalWidth = tempSize.width;
        }
        else{
            //根据图片的宽高比，算勋章的宽度
            medalWidth =  medalHeight * tempSize.width /  tempSize.height;
            if (medalWidth >= cellSize.width) {
                //如果宽度大于cell的宽度就设置为默认值(此处只是简单判断)
                medalWidth = [UMComMedalImageView defaultWidth];
            }
        }
    }
    
    medalView.bounds = CGRectMake(0, 0, medalWidth, medalHeight);
    return medalView.bounds.size;
}

-(void)layoutMedalViews
{
    //先确定勋章图片的宽度和高度
    CGFloat totalMedalWidth = 0;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        //先计算图片的宽高
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGSize medalViewSize = [self computeMedalViewSize:medalView];
            totalMedalWidth += medalViewSize.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
    
    //计算nameLabel的宽度
    CGFloat nameLabelWidth = 0;
    CGFloat nameLabelMaxWidth = self.nameLabel.frame.size.width  - totalMedalWidth - 10;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font];
    if (nameLabelSize.width > nameLabelMaxWidth) {
        nameLabelWidth = nameLabelMaxWidth;
    }
    else{
        nameLabelWidth = nameLabelSize.width;
    }
    
    //确定nameLabel的范围
    CGRect nameLabelFrame = self.nameLabel.frame;
    nameLabelFrame.size.width = nameLabelWidth;
    self.nameLabel.frame = nameLabelFrame;
    
    //确定medalViews的范围
    CGFloat offsetX = self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5;
    CGFloat offsetY = self.nameLabel.frame.origin.y;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGRect medalViewFrame =  medalView.frame;
            medalViewFrame.origin.x = offsetX;
            medalViewFrame.origin.y = offsetY;
            medalView.frame = medalViewFrame;
            offsetX += medalViewFrame.size.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
}

#pragma mark - UMComWebViewDelegate

-(void) adjustCellWithWebviewLoadingFinish
{
    CGRect result_webViewframe = CGRectZero;
    CGRect org_webViewframe = self.webView.frame;
    
    CGRect frame = self.webView.frame;
    frame.size.height = 1;
    self.webView.frame = frame;
    
    //设置webview的范围
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    
    CGSize webviewContentSize = self.webView.scrollView.contentSize;
//    NSLog(@"fittingSize = %f:%f,webviewContentSize= %f:%f",fittingSize.width,fittingSize.height,webviewContentSize.width,webviewContentSize.height);
    result_webViewframe.size = fittingSize;
    result_webViewframe.origin = org_webViewframe.origin;
    self.webView.frame = result_webViewframe;
    //设置其不能滑动
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.fullHeight = result_webViewframe.size.height;
    
    //设置父窗口的范围
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat contentViewHeight =  contentViewFrame.size.height + result_webViewframe.size.height;
    contentViewFrame.size.height = contentViewHeight;
    self.contentView.frame = contentViewFrame;
    
    CGRect feedBgViewFrame  = self.feedBgView.frame;
    feedBgViewFrame.size.height = contentViewHeight;
    self.feedBgView.frame = feedBgViewFrame;
    
    
    self.feedStyle.webViewHeight = self.webView.fullHeight;
    self.feedStyle.totalHeight += result_webViewframe.size.height;
    //NSLog(@"webViewDidFinishLoad>>>self.feedStyle.totalHeight = %f",self.feedStyle.totalHeight);
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = self.feedStyle.totalHeight;
    self.frame = cellFrame;
}

- (void)UMComWebViewDidFinishLoad:(UIWebView *)webView;
{
    [self adjustCellWithWebviewLoadingFinish];
    
    if (self.UMComHtmlBodyCellDelegate && [self.UMComHtmlBodyCellDelegate respondsToSelector:@selector(UMComHtmlBodyCellDidFinishLoad:)]) {
        [self.UMComHtmlBodyCellDelegate UMComHtmlBodyCellDidFinishLoad:self];
    }
}

- (void)UMComWebView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

- (BOOL)UMComWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* hrefString =  request.URL.absoluteString;
    //微博版本详情的点击事件，如果需要在此处处理
    //解析成字典类型
    NSDictionary* dic =  [UMComKit parseWebViewRequestString:hrefString];
    //通过字典类型的数据（topic_id 或者 uuid）判断跳转指定的话题还是指定的用户的个人中心
    NSString* topicID  = dic[@"topic_id"];
    NSString* uuid = dic[@"user_id"];
    __weak typeof(self) weakself = self;
    if (topicID) {
        [UMComTopicDataController getTopicWithTopicId:topicID completion:^(id responseObject, NSError *error) {
            if ([responseObject isKindOfClass:[UMComTopic class]]) {
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {
                    [weakself.delegate customObj:weakself clickOnTopic:responseObject];
                }
            }
        }];
    }
    else if (uuid){
        [UMComUserDataController getUserWithUserID:uuid completion:^(id responseObject, NSError *error) {
            if ([responseObject isKindOfClass:[UMComUser class]]) {
                [weakself turnToUserCenterWithUser:responseObject];
            }
        }];
        

    }
    else if(navigationType == UIWebViewNavigationTypeLinkClicked){
        [self clickInUrl:hrefString];
    }
    else{}
    
    return NO;
}

@end
