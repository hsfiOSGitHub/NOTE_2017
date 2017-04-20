//
//  UMComProfileSettingController.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComSimpleProfileSettingController.h"
#import "UMComImageView.h"
#import "UMComShowToast.h"
#import <UMComFoundation/UMUtils.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UIViewController+UMComAddition.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import "UMComUserUpdateDataController.h"
#import <UMComFoundation/UMComKit+String.h>
#import <UMComFoundation/UMComKit+Image.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComResouceDefines.h"
#import <UMComFoundation/UMComKit+String.h>
#import <UMComFoundation/UMComKit+Color.h>

#define NoticeLabelTag 10001

@interface UMComSimpleProfileSettingController ()

@property (nonatomic, assign) NSUInteger gender;

@property (nonatomic, strong) UMComUserUpdateDataController *dataController;

@end

@implementation UMComSimpleProfileSettingController
{
    UILabel *noticeLabel;
}


- (id)init
{
    self = [super initWithNibName:@"UMComSimpleProfileSettingController" bundle:nil];
    if (self) {
        _gender = 1;
        self.dataController = [[UMComUserUpdateDataController alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setUserProfile];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (self.navigationController.viewControllers.count <= 1) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItems = nil;
        
        UIButton *closeButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButon setImage:UMComSimpleImageWithImageName(@"close") forState:UIControlStateNormal];
        [closeButon addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
        closeButon.frame = CGRectMake(0.f, 0.f, 22.f, 22.f);
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButon];
        [self.navigationItem setLeftBarButtonItem:closeItem];
    }
    
    [self setRightButtonWithTitle:UMComLocalizedString(@"um_com_save",@"保存") action:@selector(onClickSave)];
    [self setTitleViewWithTitle:UMComLocalizedString(@"um_com_profileSetting", @"设置")];
    [self.cameraIcon setImage:UMComSimpleImageWithImageName(@"camera_icon")];
    
    UITapGestureRecognizer *userImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChangeUserImage)];
    [self.userPortrait addGestureRecognizer:userImageGesture];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapBackground];
    
    [self updateGender];
    
    _logoutButton.layer.borderColor = UMComColorWithHexString(@"#eeeff3").CGColor;
    _logoutButton.layer.borderWidth = 1.f;
    if (_hideLogout) {
        _logoutButton.hidden = YES;
    }
}


- (void)onClickChangeUserImage
{
    [_nameField resignFirstResponder];
    __weak typeof(self) ws = self;
    [[UMComKit sharedInstance] fetchImageFromAlbum:self completion:^(UIImagePickerController *picker, NSDictionary *info) {
        
        UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
        
        if (selectImage) {
            selectImage = [UMComKit fixOrientation:selectImage];
            
            [_dataController updateAvatarWithImage:selectImage completion:^(id responseObject, NSError *error) {
                if (!error) {
                    [ws.userPortrait setImage:selectImage];
                }
            }];
        }
    }];
}

- (void)setUserProfile
{
    UMComUser *user = [UMComSession sharedInstance].loginUser;
    if ([user isKindOfClass:[UMComUser class]]) {
        _nameField.text = user.name;
        _souceUidLabel.text = user.source_uid;
        _gender = [user.gender integerValue];
        [_userPortrait setImageURL:user.icon_url.small_url_string placeHolderImage:UMComSimpleImageWithImageName(@"um_default_avatar")];
        [self updateGender];
    }
}

-(void)onClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        if (_updateCompletion) {
            _updateCompletion();
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:_updateCompletion];
    }
}

- (void)hideKeyboard
{
    [_nameField resignFirstResponder];
}

-(void)onClickSave
{
    [self.nameField resignFirstResponder];
    if (self.nameField.text.length < 2) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉") message:UMComLocalizedString(@"um_com_userNicknameTooShort", @"用户昵称太短了") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.nameField.text.length > 20) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_userNicknameTooLong", @"用户昵称过长") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if ([UMComKit includeSpecialCharact:self.nameField.text]) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"um_com_sorry", @"抱歉")  message:UMComLocalizedString(@"um_com_inputCharacterDoesNotConformRequirements", @"昵称只能包含中文、中英文字母、数字和下划线") delegate:nil cancelButtonTitle:UMComLocalizedString(@"um_com_ok", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    
    __weak typeof(self) ws = self;
    [_dataController updateProfileWithName:_nameField.text age:nil gender:[NSNumber numberWithInteger:_gender] custom:nil userNameType:userNameDefault userNameLength:userNameLengthDefault completion:^(id responseObject, NSError *error) {
        if (error) {
            [UMComShowToast showFetchResultTipWithError:error];
        } else {
            [UMComShowToast accountModifyProfileSuccess];
            [ws dismissViewControllerAnimated:YES completion:ws.updateCompletion];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //当时删除的时候text为空,以此方法判断是否用户点击删除按键
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSInteger markLength = 0;//标记的长度
    UITextRange* curMarkText = textField.markedTextRange;
    if (curMarkText) {
        //http://stackoverflow.com/questions/19377299/cgcontextsavegstate-invalid-context
        //CGContextSaveGState invalid context联想输入法警告ipod5
        markLength = [textField offsetFromPosition:curMarkText.start toPosition:curMarkText.end];
    }
    
    NSInteger curLength = 0.f;
    NSInteger nextLength = 0.f;
    curLength = [UMComKit getStringLengthWithString:textField.text];//当前长度(用于判断表情)
    nextLength = [UMComKit getStringLengthWithString:string];//即将要输入的长度(用于判断表情)
    curLength -= markLength;
    if (curLength +  nextLength > 20 ){
        [self creatNoticeLabelWithView:textField];
        noticeLabel.text = UMComLocalizedString(@"um_com_userNicknameTooLong", @"用户昵称过长");
        self.nameField.hidden = YES;
        noticeLabel.hidden = NO;
        string = nil;
        [self performSelector:@selector(hiddenNoticeView) withObject:nil afterDelay:0.8f];
        return NO;
    }
    return YES;
}

- (void)creatNoticeLabelWithView:(UITextField *)textField
{
    if (!noticeLabel) {
        noticeLabel = [[UILabel alloc]initWithFrame:textField.frame];
        noticeLabel.backgroundColor = [UIColor clearColor];
        [textField.superview addSubview:noticeLabel];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = [UIColor grayColor];
        noticeLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)hiddenNoticeView
{
    noticeLabel.hidden = YES;
    self.nameField.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateGender
{
    if (_gender == 0) {
        _femaleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"chosen.png").CGImage;
        _maleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"unchosen.png").CGImage;
    } else {
        _femaleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"unchosen.png").CGImage;
        _maleIcon.layer.contents = (id)UMComSimpleImageWithImageName(@"chosen.png").CGImage;
    }
}

- (IBAction)choseMale:(id)sender {
    _gender = 1;
    [self updateGender];
    [_nameField resignFirstResponder];
}

- (IBAction)choseFemale:(id)sender {
    _gender = 0;
    [self updateGender];
    [_nameField resignFirstResponder];
}

- (IBAction)logout:(id)sender {
    [[UMComSession sharedInstance] userLogout];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
