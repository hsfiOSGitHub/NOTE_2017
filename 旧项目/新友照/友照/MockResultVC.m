//
//  MockResultVC.m
//  友照
//
//  Created by monkey2016 on 16/12/14.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "MockResultVC.h"

//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface MockResultVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *usedTime;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end

@implementation MockResultVC
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    //配置user
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 30;
    self.userIcon.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.userIcon.layer.borderWidth = 1;
    //配置shareBtn
    self.shareBtn.layer.masksToBounds = YES;
    self.shareBtn.layer.cornerRadius = 10;
    self.shareBtn.layer.borderWidth = 1;
    self.shareBtn.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    //时间、分数
    if (self.yourScore < 90)
    {
        self.score.textColor = [UIColor redColor];
        self.bgImgView.image = [UIImage imageNamed:@"马路杀手"];
    }
    else
    {
        self.score.textColor = [UIColor greenColor];
        self.bgImgView.image = [UIImage imageNamed:@"车神"];
    }
    self.score.text = [NSString stringWithFormat:@"%ld",(long)self.yourScore];
    
    self.usedTime.text = self.usedTimeStr;
    [self submitKaoShiJiLuData];
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:[ZXUD objectForKey:@"userpic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        _userName.text = [ZXUD objectForKey:@"username"];
    }

}
/**
 *  截取当前屏幕的内容
 */
- (UIImage *)snapshotScreen
{
    // 判断是否为retina屏, 即retina屏绘图时有放大因子
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.view.window.bounds.size);
    }
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 保存到相册
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}
//分享
- (IBAction)shareBtnACTION:(UIButton *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1、创建分享参数
        UIImage *image = [self snapshotScreen];
        NSArray* imageArray = @[image];
        //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (imageArray)
        {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:nil images:imageArray url:nil title:nil type:SSDKContentTypeAuto];
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
             {
                 switch (state)
                 {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                         break;
                     }
                     default:
                         break;
                 }
             }
             ];
        }
    });
}
//返回
- (IBAction)backBtnACTION:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//得到考试记录文件路径
-(NSString *)getFilePath
{
    //1.获取library目录
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //2.创建文件夹
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"kaoshijiluwenjian"];
    //创建文件夹
    //文件管理器对象
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if(![fileManger createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:0 error:nil])
    {
        return nil;
    }
    //3.合闭文件路径
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"kaoshijilu"];
    return filePath;
}

// 上传或保存考试记录
- (void)submitKaoShiJiLuData
{
    if ([ZXUD boolForKey:@"IS_LOGIN"])
    {
        NSArray *arr = [_usedTimeStr componentsSeparatedByString:@":"];
        NSString *timeStr = [NSString stringWithFormat:@"%ld",[arr[0] integerValue]*60 + [arr[1] integerValue]];
        
        [[ZXNetDataManager manager] saveRecordDataWithRndString:[ZXDriveGOHelper getCurrentTimeStamp] andIdent_code:[ZXUD objectForKey:@"ident_code"] andScore:[NSString stringWithFormat:@"%ld",_yourScore] andUseTime:timeStr andSubjects:_subject success:^(NSURLSessionDataTask *task, id responseObject)
         {
             //保存考试数据到服务器
             YZLog(@"服务器保存数据成功。");
         }failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
             
             //保存考试数据到服务器失败
             YZLog(@"服务器保存数据失败。");
         }];
        //读取本地缓存的考试记录
        NSMutableArray* kaoShiJiLuArr = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
        if (!kaoShiJiLuArr)
        {
            kaoShiJiLuArr = [NSMutableArray array];
        }
        //追加新的考试记录
        NSMutableDictionary *recordDic = [[NSMutableDictionary alloc] init];
        //科几
        [recordDic setValue:_subject forKey:@"keji"];
        //考试的分
        [recordDic setValue:[NSString stringWithFormat:@"%ld",_yourScore] forKey:@"score"];
        //考试用时
        [recordDic setValue:_usedTimeStr forKey:@"use_time"];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [inputFormatter stringFromDate:now];
        //提交时间
        [recordDic setValue:currentDateStr forKey:@"addtime"];
        //追加到原有的考试记录里
        [kaoShiJiLuArr addObject:recordDic];
        //覆盖原有的文件
        [kaoShiJiLuArr writeToFile:[self getFilePath] atomically:YES];
    }
    else
    {
        //读取本地缓存的考试记录
        NSMutableArray* kaoShiJiLuArr = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
        if (!kaoShiJiLuArr)
        {
            kaoShiJiLuArr = [NSMutableArray array];
        }
        //追加新的考试记录
        NSMutableDictionary *recordDic = [[NSMutableDictionary alloc] init];
        //科几
        [recordDic setValue:_subject forKey:@"keji"];
        //考试的分
        [recordDic setValue:[NSString stringWithFormat:@"%ld",_yourScore] forKey:@"score"];
        //考试用时
        [recordDic setValue:_usedTimeStr forKey:@"use_time"];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDateStr = [inputFormatter stringFromDate:now];
        //提交时间
        [recordDic setValue:currentDateStr forKey:@"addtime"];
        //追加到原有的考试记录里
        [kaoShiJiLuArr addObject:recordDic];
        //覆盖原有的文件
        [kaoShiJiLuArr writeToFile:[self getFilePath] atomically:YES];
    }
}
#pragma mark -didReceiveMemoryWarning
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
