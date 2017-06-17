//
//  BaseVC.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()<YBPopupMenuDelegate>

@end

@implementation BaseVC
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = k_bgViewColor_normal;
    
    //是否设置返回icon
    if (self.isFirstClass) {
        
    }else{
        [self setBackIconWith:@"back_nav"];
    }
    
}
#pragma mark -没有结果View
-(HSFNoResultView *)noResultView{
    if (!_noResultView) {
        _noResultView = [[HSFNoResultView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _noResultView.icon.image = [UIImage imageNamed:@"pic_noResult"];
        _noResultView.title.text = @"没有数据！";
        [_noResultView.bottomBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [_noResultView.bottomBtn addTarget:self action:@selector(noResultBottomBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noResultView;
}
-(void)noResultBottomBtnACTION:(UIButton *)sender{
    
}
#pragma mark -导航栏菜单menu
-(UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.frame = CGRectMake(0, 0, 44, 44);
        //        _menuBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        [_menuBtn setImage:[UIImage imageNamed:@"menu_nav"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}
-(NSMutableArray *)menuSource_icon{
    if (!_menuSource_icon) {
        _menuSource_icon = [NSMutableArray arrayWithArray:@[@"message_menu", @"aboutUs_menu"]];
    }
    return _menuSource_icon;
}
-(NSMutableArray *)menuSource_title{
    if (!_menuSource_title) {
        _menuSource_title = [NSMutableArray arrayWithArray:@[@"消息", @"关于我们"]];
    }
    return _menuSource_title;
}
//弹出菜单
-(void)menuBtnACTION:(UIButton *)sender{
    
    YBPopupMenu * menu = [YBPopupMenu showRelyOnView:sender titles:self.menuSource_title icons:self.menuSource_icon menuWidth:150 delegate:self];
    menu.type = YBPopupMenuTypeDark;
}
//#pragma mark -YBPopupMenuDelegate
//选中了某一项
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    
}
- (void)ybPopupMenuBeganDismiss{
    
}
- (void)ybPopupMenuDidDismiss{
    
}
#pragma mark -导航栏
//搜索
-(void)searchItemACTION{
    
}







#pragma mark -返回上一级
-(void)goBack{
    if(self.currentReturnType == PopTpey){
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.currentReturnType == DismissType){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark -导航栏左边 -- 默认返回样式
-(void)setBackIconWith:(NSString *)backIconName{
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:backIconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

#pragma mark -导航栏左边
-(void)setLeftItemWithTitle:(NSString *)title tintColor:(UIColor *)color{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftItemACTION)];
    self.navigationItem.leftBarButtonItem.tintColor = color;
}
-(void)setLeftItemWithImageNamed:(NSString *)imageName{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemACTION)];
}
-(void)leftItemACTION{
    
}
#pragma mark -导航栏右边
-(void)setRightItemWithTitle:(NSString *)title tintColor:(UIColor *)color{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemACTION)];
    self.navigationItem.rightBarButtonItem.tintColor = color;
}
-(void)setRightItemWithImageNamed:(NSString *)imageName{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemACTION)];
}
-(void)rightItemACTION{
    
}

#pragma mark -HUD
-(void)showTopMessage:(NSString *)message{
    [XHToast showTopWithText:message];
}
-(void)showCenterMessage:(NSString *)message{
    [XHToast showCenterWithText:message];
}
-(void)showBottomMessag:(NSString *)message{
    [XHToast showBottomWithText:message];
}

-(void)showSuccessMessage:(NSString *)message{
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

-(void)showErorrMessage:(NSString *)message{
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}

-(void)showLoadingMessage:(NSString *)message{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
}


#pragma mark -实用方法
//网络请求返回的是字典
-(NSDictionary *)dictionaryRequestSuccess:(NSDictionary *)responseObject{
    //    return [responseObject dictionaryValueForKey:kRequsetDataKey default:@{}];
    return [responseObject objectForKey:kRequsetDataKey];
}
//网络请求返回的是数组
-(NSArray *)arrayRequestSuccess:(NSDictionary *)responseObject{
    //    return [responseObject arrayValueForKey:kRequsetDataKey default:@[]];
    return [responseObject objectForKey:kRequsetDataKey];
}
//网络请求返回的状态码 （根据实际网络请求返回的数据结构 更改以下代码）
-(NSInteger)requestFinshCode:(NSDictionary *)responseObject isShowMessage:(BOOL)isShow{
    int stateCode = -1;
    if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary* state = [responseObject objectForKey:kRequsetStateKey];
        NSString *message = [state stringValueForKey:kRequsetMessage default:@""];
        stateCode = [state intValueForKey:kRequsetCode default:-1];
        if (state != nil && [state isKindOfClass:[NSDictionary class]]) {
            if (stateCode != 0 && message.length != 0 && isShow) {
                [XHToast showBottomWithText:message];
            }
        }
    }
    return stateCode;
}
//通知栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

@end
