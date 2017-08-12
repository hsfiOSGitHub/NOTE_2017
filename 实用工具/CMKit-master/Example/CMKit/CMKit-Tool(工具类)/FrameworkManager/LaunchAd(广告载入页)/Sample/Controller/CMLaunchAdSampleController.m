//
//  CMLaunchAdSampleController.m
//  CMKit
//
//  Created by HC on 16/12/26.
//  Copyright © 2016年 UTOUU. All rights reserved.
//

#import "CMLaunchAdSampleController.h"
#import "XHLaunchAd.h"
#import "Network.h"
#import "LaunchAdModel.h"
#import "CMHeadView.h"
#import "CMLaunchAdWebSampleController.h"

//静态图
#define imageURL1 @"http://c.hiphotos.baidu.com/image/pic/item/4d086e061d950a7b78c4e5d703d162d9f2d3c934.jpg"
#define imageURL2 @"http://d.hiphotos.baidu.com/image/pic/item/f7246b600c3387444834846f580fd9f9d72aa034.jpg"
#define imageURL3 @"http://d.hiphotos.baidu.com/image/pic/item/64380cd7912397dd624a32175082b2b7d0a287f6.jpg"
#define imageURL4 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"

//动态图
#define imageURL5 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"
#define imageURL6 @"http://p1.bqimg.com/567571/4ce1a4c844b09201.gif"
#define imageURL7 @"http://p1.bqimg.com/567571/23a4bc7a285c1179.gif"

//视频链接
#define videoURL1 @"http://ohnzw6ag6.bkt.clouddn.com/video0.mp4"
#define videoURL2  @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
#define videoURL3 @"http://ohnzw6ag6.bkt.clouddn.com/video1.mp4"
#define videoURL4 @"https://github.com/it7090.com/XHLaunchAdExample/blob/master/Source/video0.mp4?raw=true"


@interface CMLaunchAdSampleController ()<UITableViewDelegate,UITableViewDataSource,XHLaunchAdDelegate>

@property (nonatomic, strong) NSArray *adArray;

@end

@implementation CMLaunchAdSampleController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化数据
    [self initData];
    
    //2.创建UI
    [self initUI];
    
}


#pragma mark - 初始化数据
- (void)initData{
    self.adArray = @[@{@"name":@"图片开屏广告 - 网络数据",@"methodName":@"example01_imageAd_networkData"},
                     @{@"name":@"图片开屏广告 - 本地数据",@"methodName":@"example02_imageAd_localData"},
                     @{@"name":@"视频开屏广告 - 网络数据(网络视频只支持缓存OK后下次显示)",@"methodName":@"example03_videoAd_networkData"},
                     @{@"name":@"视频开屏广告 - 本地数据",@"methodName":@"example04_videoAd_localData"},
                     @{@"name":@"如需自定义跳过按钮,请看这个示例",@"methodName":@"example05_customSkipButton"},
                     @{@"name":@"使用默认配置快速初始化一",@"methodName":@"example06_imageAd_defaultConfiguration"},
                     @{@"name":@"使用默认配置快速初始化二",@"methodName":@"example07_videoAd_defaultConfiguration"}
                ];
    
}

#pragma mark - 初始化UI
//创建UI
- (void)initUI{
    //1.
    self.title = @"广告载入页";
    
    //2.创建TableView
    UITableView *tableView = [UITableView initWithFrame:self.view.bounds style:UITableViewStylePlain cellSeparatorStyle:UITableViewCellSeparatorStyleSingleLine separatorInset:UIEdgeInsetsMake(0, 0, 0, 0) dataSource:self delegate:self];
    
//    [tableView registerClass:[CMHeadView class] forHeaderFooterViewReuseIdentifier:@"CMHeadView"];
    
    tableView.tableHeaderView = [CMHeadView headView];
    
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.adArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"CMLaunchAdSampleController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSDictionary *dict = self.adArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    CMHeadView *headView = [[CMHeadView alloc] initWithReuseIdentifier:@"CMHeadView"];
    CMHeadView *headView = [CMHeadView headView];
    headView.hight = 170;
    headView.titleStr = @"官方示例为保证程序加载只显示一个载入广告，使用单例。但此处为了演示各个载入广告效果，取消了单例 \n实际使用注意:\n1️⃣请打开XHLaunchAd.m文件中shareLaunchAd方法的单例\n2️⃣或下载源码查看官方示例，源码地址：https://github.com/CoderZhuXH/XHLaunchAd";
    
    return headView;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.adArray[indexPath.row];
    if (dict) {
        
        if (dict[@"methodName"]) {
            [self performSelector:NSSelectorFromString(dict[@"methodName"])];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 170;
}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据
-(void)example01_imageAd_networkData
{
    //设为3即表示,启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    [XHLaunchAd setWaitDataDuration:3];//请求广告数据前,必须设置
    
    //广告数据请求
    [Network getLaunchAdImageDataSuccess:^(NSDictionary * response) {
        
        NSLog(@"广告数据 = %@",response);
        
        //广告数据转模型
        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
        //配置广告数据
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = model.duration;
        //广告frame
//        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/model.width*model.height);
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = model.content;
        //缓存机制(仅对网络图片有效)
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        //广告点击打开链接
        imageAdconfiguration.openURLString = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        
        //图片已缓存 - 显示一个 "已预载" 视图 (可选)
        if([XHLaunchAd checkImageInCacheWithURL:[NSURL URLWithString:model.content]])
        {
            //设置要添加的自定义视图(可选)
            imageAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        //显示开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
#pragma mark - 图片开屏广告-本地数据-示例
//图片开屏广告 - 本地数据
-(void)example02_imageAd_localData
{
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
//    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image2.jpg";
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)example03_videoAd_networkData
{
    //设为3即表示,启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    [XHLaunchAd setWaitDataDuration:3];//请求广告数据前,必须设置
    
    //广告数据请求
    [Network getLaunchAdVideoDataSuccess:^(NSDictionary * response) {
        
        NSLog(@"广告数据 = %@",response);
        
        //广告数据转模型
        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
        
        //配置广告数据
        XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
        //广告停留时间
        videoAdconfiguration.duration = model.duration;
        //广告frame
        videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/model.width*model.height);
        //广告视频URLString/或本地视频名(请带上后缀)
        //注意:视频广告只支持先缓存,下次显示
        videoAdconfiguration.videoNameOrURLString = model.content;
        //视频缩放模式
        videoAdconfiguration.scalingMode = MPMovieScalingModeAspectFill;
        //广告点击打开链接
        videoAdconfiguration.openURLString = model.openUrl;
        //广告显示完成动画
        videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
        //后台返回时,是否显示广告
        videoAdconfiguration.showEnterForeground = NO;
        //跳过按钮类型
        videoAdconfiguration.skipButtonType = SkipTypeTimeText;
        //视频已缓存 - 显示一个 "已预载" 视图 (可选)
        if([XHLaunchAd checkVideoInCacheWithURL:[NSURL URLWithString:model.content]])
        {
            //设置要添加的自定义视图(可选)
            videoAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
            
        }
        
        [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
        
    } failure:^(NSError *error) {
    }];
    
}
#pragma mark - 视频开屏广告-本地数据-示例
//视频开屏广告 - 本地数据
-(void)example04_videoAd_localData
{
    //配置广告数据
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
    //广告停留时间
    videoAdconfiguration.duration = 5;
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video1.mp4";
    //视频填充模式
    videoAdconfiguration.scalingMode = MPMovieScalingModeAspectFill;
    //广告点击打开链接
    videoAdconfiguration.openURLString =  @"http://www.it7090.com";
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = SkipTypeTimeText;
    //广告显示完成动画
    videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    //设置要添加的子视图(可选)
    //videoAdconfiguration.subViews = [self launchAdSubViews];
    //显示开屏广告
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
}
#pragma mark - 自定义跳过按钮-示例
-(void)example05_customSkipButton
{
    //注意:
    //1.自定义跳过按钮很简单,configuration有一个customSkipView属性.
    //2.自定义一个跳过的view 赋值给configuration.customSkipView属性便可替换默认跳过按钮,如下:
    
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 5;
    //广告frame
//    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"image11.gif";
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    imageAdconfiguration.subViews = [self launchAdSubViews];
    
    //start********************自定义跳过按钮**************************
    imageAdconfiguration.customSkipView = [self customSkipView];
    //********************自定义跳过按钮*****************************end
    
    
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
    
}
#pragma mark - 使用默认配置快速初始化 - 示例
/**
 *  图片
 */
-(void)example06_imageAd_defaultConfiguration
{
    //使用默认配置
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = imageURL3;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"http://www.it7090.com";
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}
/**
 *  视频
 */
-(void)example07_videoAd_defaultConfiguration
{
    //使用默认配置
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration defaultConfiguration];
    //广告视频URLString/或本地视频名(请带上后缀)
    videoAdconfiguration.videoNameOrURLString = @"video0.mp4";
    ////广告点击打开链接
    videoAdconfiguration.openURLString = @"http://www.it7090.com";
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
}
#pragma mark - subViews
-(NSArray<UIView *> *)launchAdSubViews_alreadyView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, 30, 60, 30)];
    label.text  = @"已预载";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}
-(NSArray<UIView *> *)launchAdSubViews
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, 30, 60, 30)];
    label.text  = @"subViews";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}
#pragma mark - customSkipView
//自定义跳过按钮
-(UIView *)customSkipView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor orangeColor];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100,30, 85, 40);
    [button addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//跳过按钮点击事件
-(void)skipAction
{
    [XHLaunchAd skipAction];
}
#pragma mark - XHLaunchAd delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd XHLaunchAd
 *  @param duration 倒计时时间
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration
{
    //设置自定义跳过按钮时间
    UIButton *button = (UIButton *)customSkipView;//此处转换为你之前的类型
    //设置时间
    [button setTitle:[NSString stringWithFormat:@"自定义%lds",duration] forState:UIControlStateNormal];
}
#pragma mark - XHLaunchAd delegate - 其他

/**
 *  广告点击事件 回调
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString;
{
    NSLog(@"广告点击");
    if(openURLString)
    {
        CMLaunchAdWebSampleController *VC = [[CMLaunchAdWebSampleController alloc] init];
        VC.URLString = openURLString;
        
        [self.navigationController pushViewController:VC animated:YES];
        
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:VC animated:YES completion:nil];
    }
}
/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd XHLaunchAd
 *  @param image    image
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image
{
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}
/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd XHLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL
{
    NSLog(@"video下载/加载完成/保存path = %@",pathURL.absoluteString);
}

/**
 *  视频下载进度回调
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current
{
    NSLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
    
}
/**
 *  广告显示完成
 */
-(void)xhLaunchShowFinish:(XHLaunchAd *)launchAd
{
    NSLog(@"广告显示完成");
}
/**
 如果你想用SDWebImage等框架加载网络广告图片,请实现此代理
 
 @param launchAd          XHLaunchAd
 @param launchAdImageView launchAdImageView
 @param url               图片url
 */
//-(void)xhLaunchAd:(XHLaunchAd *)launchAd launchAdImageView:(UIImageView *)launchAdImageView URL:(NSURL *)url
//{
//    [launchAdImageView sd_setImageWithURL:url];
//
//}




@end
