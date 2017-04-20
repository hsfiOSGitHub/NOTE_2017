//
//  UMComBriefEditViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/16.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComBriefEditViewController.h"
#import "UINavigationBar+ChangeBackgroundColor.h"
#import "UMComBriefEditView.h"
#import "UMComResouceDefines.h"
#import "UMComAddedImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UMImagePickerController.h"
#import "UMComNavigationController.h"
#import "UMComEditTextView.h"
#import <UMComDataStorage/UMComTopic.h>
#import "UMComProgressHUD.h"
#import "UMComShowToast.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComFeedEditDataController.h"
#import "UMComSelectTopicViewController.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComFeed.h>
#import <UMComFoundation/UMComKit+Color.h>
#import <UMComFoundation/UMComDefines.h>
#import "UMComNotificationMacro.h"

#define MinTextLength 5

const CGFloat g_template_LeftMargin = 10;//左间距

const CGFloat g_template_SelectedTopicView_Height = 44;//话题控件的高度
const CGFloat g_template_SelectedTopicView_TopicLabel_LeftMargin = 10;//话题控件的子控件topicLabel的左边距
const CGFloat g_template_SelectedTopicView_TopicLabel_indicatorBtnRightMargin = 15;//话题控件的子控件的indicatorBtn右边距
const CGFloat g_template_SelectedTopicView_TopicLabel_indicatorBtnWidth = 22;//话题控件的子控件的indicatorBtn宽度
const CGFloat g_template_SelectedTopicView_TopicLabel_indicatorBtnHeight = 22;//话题控件的子控件的indicatorBtn宽度

const CGFloat g_template_briefeditView_LeftMargin = 10;//编辑控件的左边距
const CGFloat g_template_briefeditView_RightMargin = 10;//编辑控件的右边距
const CGFloat g_template_briefeditView_Height = 190;//编辑控件的高度


const CGFloat g_template_selectIMGBtn_LeftMargin = 15;//menu控件的中selectIMGBtn的左边距
const CGFloat g_template_selectIMGBtn_Height = 28;//menu控件的中selectIMGBtn的高度
const CGFloat g_template_selectIMGBtn_Width = 28;//menu控件的中selectIMGBtn的宽度
const CGFloat g_template_menuView_Height = 50;//menu控件的高度

const CGFloat g_template_AddImageViewHeight = 90.f;//添加图片控件的高度
const CGFloat g_template_AddImageViewItemSize = 60.f;//添加图片控件的高度
const CGFloat g_template_AddImageViewImageSpace = 15.f;//添加图片控件中item间的距离
const CGFloat g_template_AddImageViewLeftMargin = 15.f;//添加图片控件中item的相对左边距
const CGFloat g_template_AddImageViewRightMargin = 0.f;//添加图片控件的item的相对右边距
const CGFloat g_template_AddImageViewTopMargin = 10.f;//添加图片控件的item的相对上边距
const CGFloat g_template_AddImageViewBottomMargin = 10.f;//添加图片控件的item的相对下边距

const CGFloat g_template_TipAddImageHeight = 28.f;//添加图片控件的item的相对下边距

const CGFloat g_template_MaxImageCount = 9;//添加图片控件的item的相对下边距

#define g_selectedTopictemplate @"发送内容到%@版块"

#define g_tipAddImagetemplate @"还可以上传%lu张图片"


typedef NS_ENUM(NSInteger, UMComBriefEditViewType){
    UMComBriefEditViewType_ModifiedTopic,
    UMComBriefEditViewType_NOModifiedTopic,
};

typedef NS_ENUM(NSInteger,UMComCreateFeedType)
{
    UMComCreateFeedType_Normal = 0,//普通请求
    UMComCreateFeedType_Announcement = 1,//公告(全局管理员才能发公告)
};

static UIImage* g_HighlightedImgForPostBTN;
static UIImage* g_HighlightedImgForSelectedTopicIndicator;

@interface UIButtonImageTool : UIView
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
@end
@implementation UIButtonImageTool

//利用纯色生成一个图片
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

@end

typedef void (^SelectedTopicAction)();
typedef void (^SelectedTopicFinishedAction)(UMComTopic* topic,NSError* error);

@interface UMComSelectedTopicView : UIView

@property(nonatomic,readwrite,strong) UIButton* backgroudBtn;
@property(nonatomic,readwrite,strong) UILabel* topicLabel;
@property(nonatomic,readwrite,strong) UIButton* indicatorBtn;
@property(nonatomic,readwrite,strong) UMComBriefAddedImageView* addImgView;
@property(nonatomic,copy)SelectedTopicAction selectedTopicAction;
@property(nonatomic,copy)SelectedTopicFinishedAction  selectedTopicFinishedAction;


-(void) createBackgroudBtn;
-(void) createTopicLabel;
-(void) createIndicatorBtn;

-(void) disableUnClickedBtns;//去掉点击效果

-(void) handleSelectedTopicBtn:(id)target;

-(void) setTopicTitle:(NSString*)topicName;

@end

@interface UMComSelectedTopicView ()

@end

@implementation UMComSelectedTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createBackgroudBtn];
        [self createTopicLabel];
        [self createIndicatorBtn];
    }
    return self;
}

-(void) createBackgroudBtn
{
    self.backgroudBtn = [[UIButton alloc] initWithFrame:self.bounds];
    self.backgroudBtn.backgroundColor = UMComColorWithHexString(@"#F6f7f9");
    [self addSubview:self.backgroudBtn];
    
    if (!g_HighlightedImgForSelectedTopicIndicator) {
        g_HighlightedImgForSelectedTopicIndicator =  [UIButtonImageTool buttonImageFromColor:[UIColor lightGrayColor]];
    }
    [self.backgroudBtn setBackgroundImage:g_HighlightedImgForSelectedTopicIndicator forState:UIControlStateHighlighted];
    
    [self.backgroudBtn addTarget:self action:@selector(handleSelectedTopicBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) createTopicLabel
{
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(g_template_SelectedTopicView_TopicLabel_LeftMargin, 0, self.bounds.size.width - g_template_SelectedTopicView_TopicLabel_LeftMargin - g_template_SelectedTopicView_TopicLabel_indicatorBtnWidth-g_template_SelectedTopicView_TopicLabel_indicatorBtnRightMargin - 2, self.bounds.size.height)];//需要减2个单位的间隔
    
    self.topicLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    self.topicLabel.textColor = UMComColorWithHexString(@"#999999");
    self.topicLabel.backgroundColor = [UIColor clearColor];
    [self.backgroudBtn addSubview:self.topicLabel];
}

-(void) createIndicatorBtn
{
    self.indicatorBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.indicatorBtn.frame = CGRectMake(self.bounds.size.width - g_template_SelectedTopicView_TopicLabel_indicatorBtnWidth - g_template_SelectedTopicView_TopicLabel_indicatorBtnRightMargin, (g_template_SelectedTopicView_Height - g_template_SelectedTopicView_TopicLabel_indicatorBtnHeight)/2, g_template_SelectedTopicView_TopicLabel_indicatorBtnWidth,g_template_SelectedTopicView_TopicLabel_indicatorBtnHeight);
    
    [self.indicatorBtn setImage:UMComSimpleImageWithImageName(@"um_edit_more") forState:UIControlStateNormal];
    if (!g_HighlightedImgForSelectedTopicIndicator) {
        g_HighlightedImgForSelectedTopicIndicator =  [UIButtonImageTool buttonImageFromColor:[UIColor lightGrayColor]];
    }
    [self.indicatorBtn setBackgroundImage:g_HighlightedImgForSelectedTopicIndicator forState:UIControlStateHighlighted];
    [self.backgroudBtn addSubview:self.indicatorBtn];
    
    [self.indicatorBtn addTarget:self action:@selector(handleSelectedTopicBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) handleSelectedTopicBtn:(id)target
{
    if (self.selectedTopicAction) {
        self.selectedTopicAction();
    }
}

-(void) setTopicTitle:(NSString*)topicName
{
    if (topicName) {
        NSString* topicTitle = [[NSString alloc] initWithFormat:g_selectedTopictemplate,topicName];
        self.topicLabel.text = topicTitle;
    }
    else
    {
        NSString* topicTitle = [[NSString alloc] initWithFormat:g_selectedTopictemplate,@"XXX"];
        self.topicLabel.text = topicTitle;
    }
}

-(void) disableUnClickedBtns
{
    [self.backgroudBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.backgroudBtn removeTarget:self action:@selector(handleSelectedTopicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.indicatorBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.backgroudBtn addSubview:self.indicatorBtn];
    
    [self.indicatorBtn removeTarget:self action:@selector(handleSelectedTopicBtn:) forControlEvents:UIControlEventTouchUpInside];
}

@end

@interface UMComBriefEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UMComEditTextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,readwrite, strong)UIScrollView* backgroudScrollView;//可滑动的背景控件
@property (nonatomic,readwrite,strong)UMComSelectedTopicView* selectedTopicView;//选择话题的控件
@property(nonatomic,readwrite,strong)UMComEditTextView *briefeditView;//内容
@property(nonatomic,readwrite,strong)UIView* menuView;//显示显示图片选取的控件
@property(nonatomic,readwrite,strong)UMComBriefAddedImageView* addImgView;//增加图片的控
@property(nonatomic,readwrite,strong)UILabel* tipAddImage;//提示增加图片
@property(nonatomic,readwrite,strong)UIView* tipAddImageBackGroud;//提示增加图片提示的

@property (nonatomic, strong) NSMutableArray *originImages;

@property(nonatomic,assign)UMComBriefEditViewType  briefEditViewType;
@property(nonatomic,weak)UIViewController* popToViewController;

@property (nonatomic, strong) UMComTopic *topic;

@property (nonatomic, strong) UMComFeedEditDataController *editDataController;

//创建navigation
-(void) createNavigationItems;
-(void) handleBackBtn:(id)target;
-(void) handlePostBtn:(id)target;
-(void) doPostWithType:(UMComCreateFeedType)type;
-(void) alertCreateFeedType;
-(BOOL) checkShowprompting;
-(void) handleClickCloseForprompting:(id)sender;

//创建背景控件
-(void) createBackgroudScrollView;

//创建显示话题的控件
-(void) createSelectedTopicionView;

//创建话题控件下方的分割线
-(void) createSeparateLineBelowSelectedTopicionView;

//创建UMComBriefEditView
-(void) createBriefEditView;

//创建话题控件下方的分割线
-(void) createSeparateLineBelowBriefEditView;

//创建导航条
-(void) createMenuView;
-(void) handleSelectIMGAndCamera:(id)target;
-(void) handleSelectIMG:(id)target;
-(void) handleSelectCamera:(id)target;


-(void) createAddedImageView;
-(void) popActionSheetForAddImageView; //用户点击+添加事件
- (void)setUpPicker;
-(void)takePhoto:(id)sender;
- (void)dealWithAssets:(NSArray *)assets;
- (void)handleOriginImages:(NSArray *)images;
- (UIImage *)compressImage:(UIImage *)image;
- (void)updateImageAddedImageView;

-(void) createTipAddImage;


-(void)viewsFrameChange;

@end

@implementation UMComBriefEditViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editDataController = [[UMComFeedEditDataController alloc] init];
    }
    return self;
}

-(id)initNOModifiedTopic:(UMComTopic*)topic withPopToViewController:(UIViewController*)popToViewController
{
    if (self = [self init]) {
        
        _topic = topic;
        
        _popToViewController = popToViewController;
        
        _briefEditViewType = UMComBriefEditViewType_NOModifiedTopic;
    }
    
    return self;
}

-(id)initModifiedTopic:(UMComTopic*)topic withPopToViewController:(UIViewController*)popToViewController
{
    if (self = [self init]) {
        
        _topic = topic;
        
        _popToViewController = popToViewController;
        
        _briefEditViewType = UMComBriefEditViewType_ModifiedTopic;
    }
    
    return self;
}


#pragma mark - overide UIViewController
-(void) dealloc
{
    //YZLog(@"UMComBriefEditViewController_dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originImages = [NSMutableArray arrayWithCapacity:9];
    
    [self createNavigationItems];
    [self createBackgroudScrollView];
    [self createSelectedTopicionView];
    [self createSeparateLineBelowSelectedTopicionView];
    [self createBriefEditView];
    [self createSeparateLineBelowBriefEditView];
    [self createMenuView];
    [self createAddedImageView];
    [self createTipAddImage];
    
    [self viewsFrameChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar umcom_setBackgroundColor:UMComColorWithHexString(@"#469ef8")];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar umcom_reset];
}

#pragma mark - private method

-(void) createNavigationItems
{
    //设置NavigationItem的Leftitem
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame = CGRectMake(0, 0, 44,24);
    [backBtn setTitle:UMComLocalizedString(@"um_com_edit_back",@"取消")  forState:UIControlStateNormal];
    backBtn.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    
    [backBtn setTitleColor:UMComColorWithHexString(@"#F6f7f9") forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    backBtn.backgroundColor = [UIColor clearColor];
    
    [backBtn addTarget:self action:@selector(handleClickCloseForprompting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = backBtnItem;    //设置NavigationItem的rightitem
    UIButton* postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(0, 0, 44,24);
    [postBtn setTitle:UMComLocalizedString(@"um_com_edit_post",@"发布")  forState:UIControlStateNormal];
    postBtn.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);

    [postBtn setTitleColor:UMComColorWithHexString(@"#469ef8") forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    postBtn.backgroundColor = UMComColorWithHexString(@"#F6F7F9");
    
    if (!g_HighlightedImgForPostBTN) {
        g_HighlightedImgForPostBTN = [UIButtonImageTool buttonImageFromColor:[UIColor lightGrayColor]];
    }
    [postBtn setBackgroundImage:g_HighlightedImgForPostBTN forState:UIControlStateHighlighted];
    postBtn.layer.cornerRadius = 6;
    postBtn.clipsToBounds = YES;
    
    [postBtn addTarget:self action:@selector(handlePostBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* postBtnItem =  [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    self.navigationItem.rightBarButtonItem = postBtnItem;
    
    //设置中间文本
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    titleLabel.text = UMComLocalizedString(@"um_com_Edit_TitleText", @"新鲜事");  
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    titleLabel.textColor =  UMComColorWithHexString(@"FFFFFF");
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView:titleLabel];

}

-(void) handleBackBtn:(id)target
{
    [self.navigationController.navigationBar umcom_reset];
    
    if (self.briefEditViewType == UMComBriefEditViewType_ModifiedTopic) {
        if (self.popToViewController) {
            
            [self.navigationController popToViewController:self.popToViewController animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.briefEditViewType == UMComBriefEditViewType_NOModifiedTopic)
    {
        if (self.popToViewController) {
            
            [self.navigationController popToViewController:self.popToViewController animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  判断用户是否修改了编辑页面
 *
 *  @return YES 表示修改了,NO 表示没有修改
 */
-(BOOL) checkShowprompting
{
    if (self.briefeditView.text.length > 0 || self.originImages.count > 0) {
        
        return YES;
    }
    
    return NO;
}

#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
- (void)handleClickCloseForprompting:(id)sender
{
    if (![self checkShowprompting]) {
        [self handleBackBtn:nil];
        return;
    }
    
    if (SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:UMComLocalizedString(@"um_com_prompting", @"提示")   message:UMComLocalizedString(@"um_com_emptyContentWhenGoBack",@"退出此次编辑,内容将丢失!") preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakself = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:UMComLocalizedString(@"um_com_makesure", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself handleBackBtn:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:UMComLocalizedString(@"um_com_cancel", @"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        [self.briefeditView resignFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_prompting", @"提示")  message:UMComLocalizedString(@"um_com_emptyContentWhenGoBack",@"退出此次编辑,内容将丢失!") delegate:self cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消") otherButtonTitles:UMComLocalizedString(@"um_com_makesure", @"确定"),nil];
        alertView.tag = 11111;
        [alertView show];
    }
}


- (void)dealWhenPostFeedFinish:(NSArray *)responseObject error:(NSError *)error
{
    if (error) {
        [UMComShowToast showFetchResultTipWithError:error];
    } else if([responseObject isKindOfClass:[NSArray class]] && responseObject.count > 0) {
        UMComFeed *feed = responseObject.firstObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPostFeedResultNotification object:feed];
        [UMComShowToast createFeedSuccess];
    }
}

-(void) handlePostBtn:(id)target
{
    //对话题检测
    if (!self.topic) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_selectionTopicPrompt",@"请选择所属话题") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
   // 检查内容的最大长度
    if (!self.briefeditView.text || [self.briefeditView getRealTextLength] > self.briefeditView.maxTextLenght) {
        NSString *tooLongNotice = [NSString stringWithFormat:@"内容过长,超出%d个字符",(int)[self.briefeditView getRealTextLength] - (int)self.briefeditView.maxTextLenght];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"The content is too long",tooLongNotice) delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil];
        [alertView show];
        //[self.briefeditView becomeFirstResponder];
        return;
    }
    
    if (([self.briefeditView getRealTextLength] < MinTextLength) && (self.originImages.count == 0)) {
        NSString *tooShortNotice = [NSString stringWithFormat:@"发布的内容太少啦，再多写点内容。"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"The content is too long",tooShortNotice) delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    //准备发送请求

    if ([[UMComSession sharedInstance] isPermissionBulletin]) {

        //说明是全局管理员，需要询问是否发送公告还是普通请求
        
        [self alertCreateFeedType];
    }
    else{
        [self doPostWithType:UMComCreateFeedType_Normal];
    }
}

-(void) doPostWithType:(UMComCreateFeedType)type
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //加入等待框
    UMComProgressHUD *hud = [UMComProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = UMComLocalizedString(@"um_com_postingContent",@"发送中...");
    hud.label.backgroundColor = [UIColor clearColor];
    
    
    [self.briefeditView resignFirstResponder];
    __weak typeof(self) weakself = self;
    //设置
    self.editDataController.text = self.briefeditView.text;
    if (self.topic) {
        self.editDataController.topics = [NSArray arrayWithObject:self.topic];
    }
    self.editDataController.images = self.originImages;
    self.editDataController.type = @(type);
    
    [self.editDataController createFeedWithCompletion:^(id responseObject, NSError *error) {
        [hud hideAnimated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (responseObject && [responseObject isKindOfClass:[UMComFeed class]] && !error) {
            [weakself dealWhenPostFeedFinish:@[responseObject] error:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                //如果没有错误就返回
                [weakself handleBackBtn:nil];
            });
        }
        else{
            
            [UMComShowToast showFetchResultTipWithError:error];
        }
    }];
}

-(void) alertCreateFeedType
{
    if (SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:UMComLocalizedString(@"um_com_prompting", @"提示") message:UMComLocalizedString(@"um_com_announcementPrompting",@"是否需要将本条内容标记为公告?") preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakself = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:UMComLocalizedString(@"um_com_yes", @"是") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself doPostWithType:UMComCreateFeedType_Announcement];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:UMComLocalizedString(@"um_com_no", @"否") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself doPostWithType:UMComCreateFeedType_Normal];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        [self.briefeditView resignFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_prompting", @"提示")  message:UMComLocalizedString(@"um_com_announcementPrompting",@"是否需要将本条内容标记为公告?") delegate:self cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消") otherButtonTitles:UMComLocalizedString(@"um_com_makesure", @"确定"),nil];
        alertView.tag = 11112;
        [alertView show];
    }
}


-(void) createBackgroudScrollView
{
    self.backgroudScrollView =  [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.backgroudScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    self.backgroudScrollView.backgroundColor = UMComColorWithHexString(@"#e8eaee");
    self.view.backgroundColor = UMComColorWithHexString(@"#e8eaee");
    
    self.backgroudScrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:self.backgroudScrollView];
}

-(void) createSelectedTopicionView
{
    self.selectedTopicView = [[UMComSelectedTopicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, g_template_SelectedTopicView_Height)];
    [self.backgroudScrollView addSubview:self.selectedTopicView];
    
    if (self.briefEditViewType == UMComBriefEditViewType_NOModifiedTopic) {
        
        [self.selectedTopicView disableUnClickedBtns];
        
    }
    __weak typeof(self) weakself = self;
    self.selectedTopicView.selectedTopicAction = ^(){
        
        [weakself.briefeditView resignFirstResponder];
        UMComSelectTopicViewController* selectTopicViewController = [[UMComSelectTopicViewController alloc] init];
        [weakself presentViewController:selectTopicViewController animated:YES completion:nil];
        
        selectTopicViewController.closeTopicViewAction = ^(){
            
            [weakself dismissViewControllerAnimated:YES completion:nil];
        };
        
        selectTopicViewController.selectTopicViewFinishAction =  ^(UMComTopic* topic){
            
            weakself.topic = topic;
            [weakself.selectedTopicView setTopicTitle:weakself.topic.name];
            [weakself dismissViewControllerAnimated:YES completion:nil];
            
        };
    };
}

-(void) createSeparateLineBelowSelectedTopicionView
{
    UIView* separateLine =  [[UIView alloc] initWithFrame:CGRectMake(0, self.selectedTopicView.frame.origin.y +self.selectedTopicView.frame.size.height , self.view.bounds.size.width, 1)];
    separateLine.backgroundColor = UMComColorWithHexString(@"#dfdfdf");
    
    [self.backgroudScrollView addSubview:separateLine];
}

-(void) createBriefEditView
{
    //此view是为了覆盖briefeditView的偏移的10像素的背景
    UIView* briefeditViewBackgroud = [[UIView alloc] initWithFrame:CGRectMake(0, self.selectedTopicView.frame.origin.y + self.selectedTopicView.frame.size.height + 1, [UIScreen mainScreen].bounds.size.width, g_template_briefeditView_Height)];
    //briefeditViewBackgroud.backgroundColor = UMComColorWithHexString(@"#f6f7f9");
    briefeditViewBackgroud.backgroundColor = [UIColor whiteColor];
    [self.backgroudScrollView addSubview:briefeditViewBackgroud];
    
    NSArray *regexArray = [NSArray arrayWithObjects:UserRulerString, TopicRulerString,UrlRelerSring, nil];
    self.briefeditView  = [[UMComEditTextView alloc]initWithFrame:CGRectMake(g_template_briefeditView_LeftMargin, self.selectedTopicView.frame.origin.y + self.selectedTopicView.frame.size.height + 1, self.view.bounds.size.width - g_template_briefeditView_LeftMargin - g_template_briefeditView_RightMargin, g_template_briefeditView_Height) checkWords:nil regularExStrArray:regexArray];
    self.briefeditView.editDelegate = self;
    self.briefeditView.maxTextLenght = [UMComSession sharedInstance].maxFeedLength;
    [self.briefeditView setFont:UMComFontNotoSansLightWithSafeSize(14)];
    [self.backgroudScrollView addSubview:self.briefeditView];
    self.briefeditView.placeholderLabel.text = UMComLocalizedString(@"um_com_briefeditView_placeholder", @"说点什么吧");
    
    //[self.briefeditView becomeFirstResponder];
    
    //http://stackoverflow.com/questions/19046969/uitextview-content-size-different-in-ios7
    //此问题出现在copy paste超过一页数据的时候，输入就会出现文字先跳动顶端再回到底端的问题
    //设置连续布局属性(并且只能在外面设置才有效，在UMComEditTextView的内部函数中设置无效)
    if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0"))
    {
        self.briefeditView.layoutManager.allowsNonContiguousLayout = NO;
    }
}

-(void) createSeparateLineBelowBriefEditView
{
    UIView* separateLine =  [[UIView alloc] initWithFrame:CGRectMake(0, self.briefeditView.frame.origin.y +self.briefeditView.frame.size.height , self.view.bounds.size.width, 1)];
    separateLine.backgroundColor = UMComColorWithHexString(@"#dfdfdf");
    
    [self.backgroudScrollView addSubview:separateLine];
}

-(void) createMenuView
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.briefeditView.frame.origin.y + self.briefeditView.frame.size.height + 1, self.view.bounds.size.width, g_template_menuView_Height)];
    
    //self.menuView.backgroundColor= UMComColorWithHexString(@"#f6f7f9");
     self.menuView.backgroundColor= [UIColor whiteColor];
    [self.backgroudScrollView addSubview:self.menuView];
    
    
    //相册入口
    UIButton* selectIMGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectIMGBtn.frame = CGRectMake(g_template_selectIMGBtn_LeftMargin,(self.menuView.frame.size.height - g_template_selectIMGBtn_Height)/2 , g_template_selectIMGBtn_Width, g_template_selectIMGBtn_Height);

    [selectIMGBtn setImage:UMComSimpleImageWithImageName(@"um_edit_pic") forState:UIControlStateNormal];
    [selectIMGBtn addTarget:self action:@selector(handleSelectIMGAndCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:selectIMGBtn];
    
    //相机入口
    /*
    UIButton* cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(g_template_selectIMGBtn_LeftMargin + g_template_selectIMGBtn_Width + g_template_selectIMGBtn_LeftMargin,(self.menuView.frame.size.height - g_template_selectIMGBtn_Height)/2 , g_template_selectIMGBtn_Width, g_template_selectIMGBtn_Height);
    
    [cameraBtn setImage:UMComSimpleImageWithImageName(@"um_edit_pic") forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(handleSelectCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:cameraBtn];
     */
}

-(void) handleSelectIMGAndCamera:(id)target
{
    [self.briefeditView resignFirstResponder];
    [self popActionSheetForAddImageView];
}

-(void) handleSelectIMG:(id)target
{
   [self.briefeditView resignFirstResponder];
   [self setUpPicker];
}

-(void) handleSelectCamera:(id)target
{
    [self.briefeditView resignFirstResponder];
    [self takePhoto:nil];
}


-(void) createAddedImageView
{
    self.addImgView = [[UMComBriefAddedImageView alloc] initWithFrame:CGRectMake(0, self.menuView.frame.origin.y + self.menuView.frame.size.height, self.view.bounds.size.width, g_template_AddImageViewHeight)];
    [self.backgroudScrollView addSubview:self.addImgView];
    
    self.addImgView.itemSize = CGSizeMake(g_template_AddImageViewItemSize, g_template_AddImageViewItemSize);
    self.addImgView.imageSpace = g_template_AddImageViewImageSpace;
    
    self.addImgView.isAddImgViewShow = YES;
    self.addImgView.normalAddImg = UMComSimpleImageWithImageName(@"um_com_edit_add");
    self.addImgView.highlightedAddImg = UMComSimpleImageWithImageName(@"um_com_edit_add_click");
    self.addImgView.deleteImg =  UMComSimpleImageWithImageName(@"um_com_edit_delete");
    [self.addImgView addImages:[NSArray array]];
    
    __weak typeof(self) weakSelf = self;
    [self.addImgView setPickerAction:^{
        [weakSelf.briefeditView resignFirstResponder];
        [weakSelf popActionSheetForAddImageView];
    }];
    self.addImgView.imagesChangeFinish = ^(){
        [weakSelf updateImageAddedImageView];
    };
    self.addImgView.imagesDeleteFinish = ^(NSInteger index){
        [weakSelf.originImages removeObjectAtIndex:index];
    };
}

- (void)updateImageAddedImageView
{
    [self viewsFrameChange];
}


-(void) popActionSheetForAddImageView
{
    //[self setUpPicker];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:UMComLocalizedString(@"um_com_selectImageSource",@"请选择图片源:")
                                                       delegate:self
                                              cancelButtonTitle:UMComLocalizedString(@"um_com_cancel", @"取消")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:UMComLocalizedString(@"um_com_camera",@"拍照"),UMComLocalizedString(@"um_com_album", @"相册"),nil];
    
    [sheet showInView:self.view];
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
            [self takePhoto:nil];
            break;
        case 1://相册
            [self setUpPicker];
            break;
        case 2://取消
        {
        }
            break;
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *tempImage = nil;
    if (selectImage.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContext(selectImage.size);
        [selectImage drawInRect:CGRectMake(0, 0, selectImage.size.width, selectImage.size.height)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        tempImage = selectImage;
    }
    if (self.originImages.count < 9) {
        [self.originImages addObject:tempImage];
        [self handleOriginImages:@[tempImage]];
    }
}

-(void)takePhoto:(id)sender
{
    if(self.originImages.count >= 9){
        [[[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_selectTooManyImages",@"图片最多只能选9张") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil] show];
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"um_com_photoAlbumAuthentication", @"本应用无访问照片的权限，如需访问，可在设置中修改") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil, nil] show];
            return;
        }
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"um_com_photoAlbumAuthentication", @"本应用无访问照片的权限，如需访问，可在设置中修改") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok",@"好") otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}

- (void)setUpPicker
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"um_com_photoAlbumAuthentication", @"本应用无访问照片的权限，如需访问，可在设置中修改") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if([UMImagePickerController isAccessible])
    {
        UMImagePickerController *imagePickerController = [[UMImagePickerController alloc] initWithBackImage:UMComSimpleImageWithImageName(@"um_forum_back_gray")];
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 9 - [self.addImgView.arrayImages count];
        
        [imagePickerController setFinishHandle:^(BOOL isCanceled,NSArray *assets){
            if(!isCanceled)
            {
                [self dealWithAssets:assets];
            }
        }];
        
        UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

- (void)dealWithAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for(ALAsset *asset in assets)
        {
            UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
            if (image) {
                [array addObject:image];
            }
            if ([asset defaultRepresentation]) {
                //这里把图片压缩成fullScreenImage分辨率上传，可以修改为fullResolutionImage使用原图上传
                UIImage *originImage = [UIImage
                                        imageWithCGImage:[asset.defaultRepresentation fullScreenImage]
                                        scale:[asset.defaultRepresentation scale]
                                        orientation:UIImageOrientationUp];
                if (originImage) {
                    [self.originImages addObject:originImage];
                }
            } else {
                UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                image = [self compressImage:image];
                if (image) {
                    [self.originImages addObject:image];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleOriginImages:array];
        });
    });
}

- (UIImage *)compressImage:(UIImage *)image
{
    UIImage *resultImage  = image;
    if (resultImage.CGImage) {
        NSData *tempImageData = UIImageJPEGRepresentation(resultImage,0.9);
        if (tempImageData) {
            resultImage = [UIImage imageWithData:tempImageData];
        }
    }
    return image;
}

- (void)handleOriginImages:(NSArray *)images{
    
    //[self.originImages addObjectsFromArray:images];//zhangjunhua_删除，回调前，已经加入
    [self.addImgView addImages:images];
    [self viewsFrameChange];

}


-(void) createTipAddImage
{
    self.tipAddImageBackGroud = [[UIView alloc] initWithFrame:CGRectMake(0, self.addImgView.frame.origin.y + self.addImgView.frame.size.height + 1, self.view.bounds.size.width, g_template_TipAddImageHeight)];
    self.tipAddImageBackGroud.backgroundColor = UMComColorWithHexString(@"#F6F7F9");
    [self.backgroudScrollView addSubview:self.tipAddImageBackGroud];
    
    self.tipAddImage = [[UILabel alloc] initWithFrame:CGRectMake(g_template_AddImageViewLeftMargin, 0, self.tipAddImageBackGroud.bounds.size.width - g_template_AddImageViewLeftMargin, g_template_TipAddImageHeight)];
    
    self.tipAddImage.text = [[NSString alloc] initWithFormat:g_tipAddImagetemplate,(unsigned long)(g_template_MaxImageCount-self.originImages.count)];
    self.tipAddImage.textColor =UMComColorWithHexString(@"#666666");
    self.tipAddImage.font = UMComFontNotoSansLightWithSafeSize(15);
    self.tipAddImage.backgroundColor = [UIColor clearColor];
    [self.tipAddImageBackGroud addSubview:self.tipAddImage];
}

-(void)viewsFrameChange
{
    if (self.originImages.count > 0) {
        self.addImgView.hidden = NO;
        self.tipAddImageBackGroud.hidden = NO;
    }
    else{
        self.addImgView.hidden = YES;
        self.tipAddImageBackGroud.hidden = YES;
    }
    
    CGRect orginFrame = self.tipAddImageBackGroud.frame;
    orginFrame.origin.y = self.addImgView.frame.origin.y + self.addImgView.frame.size.height;
    
    self.tipAddImage.text = [[NSString alloc] initWithFormat:g_tipAddImagetemplate,(unsigned long)(g_template_MaxImageCount-self.originImages.count)];
    self.tipAddImageBackGroud.frame = orginFrame;
    
    [self.selectedTopicView setTopicTitle:self.topic.name];
    
    //设置self.backgroudScrollView的contentSize
    self.backgroudScrollView.contentSize = CGSizeMake(self.view.bounds.size.width,  self.addImgView.frame.origin.y + self.addImgView.frame.size.height + self.tipAddImage.bounds.size.height);
    //YZLog(@"self.view.height = %f,self.backgroudScrollView.height = %f",self.view.bounds.size.height,self.backgroudScrollView.contentSize.height);
}

#pragma mark - UMComEditTextViewDelegate

//- (NSArray *)editTextViewDidUpdate:(UMComEditTextView *)textView matchWords:(NSArray *)matchWords
//{
//    return [NSArray array];
//}

- (BOOL)editTextView:(UMComEditTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text complection:(void (^)())block
{
    return YES;
}

- (void)editTextViewDidChangeSelection:(UMComEditTextView *)textView
{
}

- (void)editTextViewDidEndEditing:(UMComEditTextView *)textView
{
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11111)//点击确定按钮
    {
        if (buttonIndex == 1)
        {
            //iOS 8.0，dismiss alert view时系统会尝试恢复之前的keyboard input,导致界面消失了，键盘会闪现,
            //此处延迟0.5秒就是为了让键盘弹出，再做onClickClose的关闭操作
            [self performSelector:@selector(handleBackBtn:) withObject:nil afterDelay:0.5];
            //[self onClickClose:nil];
        }
    }
    else if (alertView.tag == 11112)
    {
        if (buttonIndex == 1)
        {
            [self doPostWithType:UMComCreateFeedType_Announcement];
        }
        else
        {
            [self doPostWithType:UMComCreateFeedType_Normal];
        }
    }
    else{
    }
    
}


@end
