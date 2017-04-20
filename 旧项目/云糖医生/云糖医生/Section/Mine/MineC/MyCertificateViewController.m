//
//  MyCertificateViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MyCertificateViewController.h"
#import "SZBNetDataManager+CerNetData.h"
//服务条款
#import "SZBDelegateVC.h"
//封装放大图片
#import "SJAvatarBrowser.h"
#import "SZBFmdbManager+userInfo.h"
@interface MyCertificateViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic) NSInteger numOfPage;//滑动标记第几页
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic) BOOL isTakePhoto;
@property (nonatomic, strong)NSData *data;//资格证
@end

@implementation MyCertificateViewController
#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的认证";
    self.ScrollView.delegate = self;
    self.PicCerPhoneTF.delegate = self;
    self.guaranteeCerPhoneTF1.delegate = self;
    self.guaranteeCerPhoneTF2.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.navigationController.navigationBar.translucent = YES;
    //给两个按钮加点击事件并给tag值
    [self prefectBtnThings];
    //键盘弹出
    [self keyboardAction];
    //添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    //配置一些圆角及颜色的属性
    self.LowLable.adjustsFontSizeToFitWidth = YES;
    self.CommitCerBtn.layer.cornerRadius = 10;
    self.CommitCerBtn.layer.masksToBounds = YES;
    [self.CommitCerBtn addTarget:self action:@selector(CommitCerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:self.LowLable.text];
     [text addAttribute:NSForegroundColorAttributeName value:KRGB(0, 172, 204, 1.0) range:NSMakeRange(7, self.LowLable.text.length - 7)];
    self.LowLable.attributedText = text;
    //认证头像
    if ([self.is_check isEqualToString:@"1"] && ![self.postic_url isEqualToString:@""]) {
        [self.LeftImageV sd_setImageWithURL:[NSURL URLWithString:self.postic_url] placeholderImage:[UIImage imageNamed:@"组-5"]];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [self.LeftImageV addGestureRecognizer:tap3];
        
    }else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        [self.LeftImageV addGestureRecognizer:tap];
    }
  
    //示例头像
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.RightImageV addGestureRecognizer:tap1];
    //判断认证状态
    [self judgeCerStation];
    //服务协议
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fuwuAction:)];
    [ self.LowLable addGestureRecognizer:tap2];
   
    
}
//服务条款
- (void)fuwuAction:(UITapGestureRecognizer *)tap {
    SZBDelegateVC *FuWuVC = [[SZBDelegateVC alloc]init];
    [self presentViewController:FuWuVC animated:YES completion:nil];
}
- (void)judgeCerStation {
    if ([self.is_check isEqualToString:@"0"]) {
        if ([self.auth_check isEqualToString:@"0"] || [self.auth_check isEqualToString:@"2"] ) {//审核不通过
            self.TopCerImageV.image = [UIImage imageNamed:@"未认证"];
            self.TopLable.text = @"完成身份认证, 开通糖尿病特色服务";
        }else if ([self.auth_check isEqualToString:@"1"]){//审核通过
            self.TopCerImageV.image = [UIImage imageNamed:@"已认证（有字）"];
            [self.CommitCerBtn setTitle:@"已认证" forState:UIControlStateNormal];
            self.TopLable.text = @"已完成身份认证, 开通糖尿病特色服务";
            self.CommitCerBtn.backgroundColor = [UIColor lightGrayColor];
            self.CommitCerBtn.userInteractionEnabled = NO;
        }else if ([self.auth_check isEqualToString:@"3"]){//认证中
            self.TopCerImageV.image = [UIImage imageNamed:@"认证中"];
            self.TopLable.text = @"正在认证中";
            [self.CommitCerBtn setTitle:@"认证中" forState:UIControlStateNormal];
            self.CommitCerBtn.backgroundColor = [UIColor lightGrayColor];
            self.CommitCerBtn.userInteractionEnabled = NO;
        }
    }else {
        self.TopCerImageV.image = [UIImage imageNamed:@"已认证（有字）"];
        [self.CommitCerBtn setTitle:@"已认证" forState:UIControlStateNormal];
        self.TopLable.text = @"已完成身份认证, 开通糖尿病特色服务";
        self.CommitCerBtn.backgroundColor = [UIColor lightGrayColor];
        self.CommitCerBtn.userInteractionEnabled = NO;
    }
    
}
- (void)goToBack {

    [self.navigationController popViewControllerAnimated:YES];
}
//提交认证
- (void)CommitCerBtnAction:(UIButton *)btn {
    
        if (![self.userInfoModel.name isKindOfClass:[NSString class]] || [self.userInfoModel.name isEqualToString:@""]){
//            [MBProgressHUD showError:@"请先填写姓名"];
             [MBProgressHUD showError:@"请先完善个人信息"];
        }else if(![self.userInfoModel.gender isKindOfClass:[NSString class]] || [self.userInfoModel.gender isEqualToString:@""]) {
//            [MBProgressHUD showError:@"请先选择性别"];
             [MBProgressHUD showError:@"请先完善个人信息"];
        }else if (![self.userInfoModel.hid isKindOfClass:[NSString class]] || [self.userInfoModel.hid isEqualToString:@""]) {
//            [MBProgressHUD showError:@"请完善您所在医院"];
             [MBProgressHUD showError:@"请先完善个人信息"];
        }else if (![self.userInfoModel.did isKindOfClass:[NSString class]] || [self.userInfoModel.did isEqualToString:@""]) {
//            [MBProgressHUD showError:@"请完善您的科室"];
             [MBProgressHUD showError:@"请先完善个人信息"];
        }else if (![self.userInfoModel.ttid isKindOfClass:[NSString class]] || [self.userInfoModel.ttid isEqualToString:@""]) {
//            [MBProgressHUD showError:@"请完善您的职称"];
             [MBProgressHUD showError:@"请先完善个人信息"];
        }else {
            //去认证
            [self CommitCerStatus];
        }

}
//认证
- (void)CommitCerStatus{
    if (_numOfPage) {
        if (_guaranteeCerPhoneTF1.text.length == 0 || _guaranteeCerPhoneTF2.text.length == 0) {
            
            [MBProgressHUD showError:@"请输入担保人手机号码"];
            
        }else if (![self checkTelNumber:_guaranteeCerPhoneTF1.text] || ![self checkTelNumber:_guaranteeCerPhoneTF2.text])
        {
            
            [MBProgressHUD showError:@"请输入正确的手机号码"];
        }else {
            //号码担保认证
            [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
            [[SZBNetDataManager manager]doctorAuth2RandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andPhone1:_guaranteeCerPhoneTF1.text andPhone2:_guaranteeCerPhoneTF2.text success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];

                if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                    // 保存用户认证状态
                    NSDictionary *dic = responseObject[@"resault"];
                    [[SZBFmdbManager sharedManager] modifyUserInfoDataAtDBWith:@{@"auth_check":dic[@"auth_check"]}];
                    [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //让用户重新登录
                        [ZXUD setObject:nil forKey:@"ident_code"];
                        LoginVC *VC = [[LoginVC alloc] init];
                        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                        [self presentViewController:navi animated:YES completion:nil];
                    }];
                    [alert addAction:anotherAction];
                    [self presentViewController:alert animated:YES completion:^{
                        
                    }];
                }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
                    
                }else {
                    [MBProgressHUD showError:responseObject[@"msg"]];
                }
                
                
            } failed:^(NSURLSessionTask *task, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"网络错误"];
            }];
        }
    }else {
        //证件认证
        if (!_data) {
            [MBProgressHUD showError:@"请上传照片"];
        }else {
            [MBProgressHUD showMessage:@"正在提交数据" toView:self.view];
            [[SZBNetDataManager manager] doctorAuthWithFile:_data andRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] andKeshiPhone:_PicCerPhoneTF.text success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                //                   NSLog(@"%@", responseObject);
                if ([responseObject[@"res"] isEqualToString:@"1001"]) {
                    // 保存用户认证状态
                    NSDictionary *dic = responseObject[@"resault"];
                    [[SZBFmdbManager sharedManager] modifyUserInfoDataAtDBWith:@{@"auth_check":dic[@"auth_check"], @"pospic_url":dic[@"pospic_url"]}];
                    [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if ([responseObject[@"res"] isEqualToString:@"1002"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //让用户重新登录
                        [ZXUD setObject:nil forKey:@"ident_code"];
                        LoginVC *VC = [[LoginVC alloc] init];
                        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                        [self presentViewController:navi animated:YES completion:nil];
                    }];
                    [alert addAction:anotherAction];
                    [self presentViewController:alert animated:YES completion:^{
                        
                    }];
                }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
                    
                }else {
                    [MBProgressHUD showError:responseObject[@"msg"]];
                }
                
            } failed:^(NSURLSessionTask *task, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:@"网络错误"];
                
            }];
            
        }
    }

}
//检查电话号码是否正确
-(BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[345678]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
//手机号输入框 动态监控
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _PicCerPhoneTF) {
        if (range.location > 11) {
            [MBProgressHUD showError:@"科室号码最多12位"];
            _PicCerPhoneTF.text = [_PicCerPhoneTF.text substringToIndex:12];
            return NO;
        }
        return YES;
    }else if (textField == _guaranteeCerPhoneTF1) {
        if (range.location > 10) {
             [MBProgressHUD showError:@"手机号码为11位"];
            _guaranteeCerPhoneTF1.text = [_guaranteeCerPhoneTF1.text substringToIndex:11];
            return NO;
        }
        return YES;
    }else {
        if (range.location > 10) {
             [MBProgressHUD showError:@"手机号码为11位"];
            _guaranteeCerPhoneTF2.text = [_guaranteeCerPhoneTF2.text substringToIndex:11];
            return NO;
        }
        return YES;
    }
    
}

//点击图片放大
- (void)tapView:(UITapGestureRecognizer *)tap{
    tap.view.userInteractionEnabled = NO;
    //优先取缓存
    [self CacheIamge:(UIImageView *)tap.view];
}
- (void)CacheIamge:(UIImageView *)imageV {
//    ZXCoachModel *coach = _coachManage.teacher[0];
//    //获取cache文件夹路径
//    NSString *cachePath = [self getCachePath];
//    //在Cache文件夹下创建一个存放图片的文件夹
//    NSFileManager *manager = [NSFileManager defaultManager];
//    //拼接Cache文件夹路径,得到图片文件夹路径
//    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"images"];
//    [manager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
//    //处理文件名
//    NSString *fileName = coach.big_pic;
//    NSString *fileName1 = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//    NSString *fileName2 = [fileName1 stringByReplacingOccurrencesOfString:@"." withString:@"_"];
//    NSString *imageFilePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileName2]];
//    if (![manager fileExistsAtPath:imageFilePath]) {
//        NSURL *url = [NSURL URLWithString:coach.big_pic];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        //异步加载
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//            
//            if ([data length] > 225 && connectionError == nil) {
//                imageV.image = [UIImage imageWithData:data];
//                [data writeToFile:imageFilePath atomically:YES];
//            }
//            [SJAvatarBrowser showImage:imageV];
//            imageV.userInteractionEnabled = YES;
//        }];
//    }else{
//        //如果文件存在从沙盒中读取数据
//        imageV.image = [UIImage imageWithContentsOfFile:imageFilePath];
        [SJAvatarBrowser showImage:imageV];
        imageV.userInteractionEnabled = YES;
//    }
}
-(NSString *)getCachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}
- (void)prefectBtnThings {
    self.PicCerBtn.tag = 100;
    self.guaranteeCerBtn.tag = 101;
    _buttonArray = [NSMutableArray array];
    [_buttonArray addObject:self.PicCerBtn];
    [_buttonArray addObject:self.guaranteeCerBtn];
   
    for (UIButton *btn in _buttonArray)
    {
        [btn addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//点击切换
- (void)functionBtnClick:(UIButton *)btn {
    NSInteger X = btn.tag - 100;
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [self animationMove:X];
    self.ScrollView.contentOffset = CGPointMake(KScreenWidth * X, 0);
}

//动画条移动
- (void)animationMove:(NSInteger)X {
    [UIView animateWithDuration:0.2 animations:^{
        self.annimationView.frame = CGRectMake((KScreenWidth / 2) * X , self.BackV.frame.size.height - 2,  KScreenWidth / 2, 2);
    }];
    _numOfPage = X;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _numOfPage = self.ScrollView.contentOffset.x / scrollView.frame.size.width;
    for (UIButton *btn in _buttonArray)
    {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIButton *btn = [self.view viewWithTag:100 + _numOfPage];
    [btn setTitleColor:KRGB(0, 172, 204, 1.0) forState:UIControlStateNormal];
    [self animationMove:_numOfPage];
}
- (void)hideKeyboard {
    [self.view endEditing:YES];
}


#pragma mark -监听键盘弹出与回收
-(void)keyboardAction{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    //动画(往上弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration integerValue] animations:^{
        [UIView setAnimationCurve:[curve integerValue]];
        self.view.frame = CGRectMake(0.0f, -height + self.LowLable.frame.size.height + self.CommitCerBtn.frame.size.height + 45 , self.view.frame.size.width, self.view.frame.size.height);
        [self.view setNeedsLayout];
    }];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    //动画(往下弹)
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIView animateWithDuration:[duration integerValue] animations:^{
        [UIView setAnimationCurve:[curve integerValue]];
        self.view.frame = CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view setNeedsLayout];
    }];
}
//点击图像选取图片
- (void)selectImage:(UITapGestureRecognizer *)tap {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:otherAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    _isTakePhoto = NO;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
//拍照
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    _isTakePhoto = YES;
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    ip.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    ip.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:ip animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_isTakePhoto) {
        image = info[UIImagePickerControllerOriginalImage];
    } else {
        image = info[UIImagePickerControllerEditedImage];
        
    }
    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(_LeftImageV.frame.size.width, _LeftImageV.frame.size.height)];
    self.LeftImageV.image = uploadImage;
    // 取出选中的图片
    _data = UIImageJPEGRepresentation(uploadImage, 1.0);
 }
//改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
