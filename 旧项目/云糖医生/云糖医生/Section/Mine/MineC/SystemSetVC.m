//
//  SystemSetVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SystemSetVC.h"
#import "ZXOpinionFeedBackVC.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "PassWordSetViewController.h"
#import "AboutUsViewController.h"
#import "ValueHelper.h"
#import "SDWebImageManager.h"
#import "UMessage.h"
#import "shengyin_TableViewCell.h"
#import "zhen_dong_TableViewCell.h"
@interface SystemSetVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic,strong) LoadingView2 *loadingView2;//登录中
@end

@implementation SystemSetVC
#pragma mark -懒加载
-(LoadingView2 *)loadingView2{
    if (!_loadingView2) {
        _loadingView2 = [[LoadingView2 alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _loadingView2.lable.text = @"正在退出";
    }
    return _loadingView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"系统设置";
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = J_BackLightGray;
    //退出登录
    [self.logoutBtn addTarget:self action:@selector(IfLogout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemSetTableViewCell" bundle:nil] forCellReuseIdentifier:@"SystemSetTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"shengyin_TableViewCell" bundle:nil] forCellReuseIdentifier:@"shengyin_TableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"zhen_dong_TableViewCell" bundle:nil] forCellReuseIdentifier:@"zhen_dong_TableViewCell"];
}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return 44;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0)
    {
        SystemSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetTableViewCellID" forIndexPath:indexPath];
         cell.sizeLable.hidden = YES;
         cell.lable.text = @"修改密码";
        return cell;
    }
    else
    {
        
        if (indexPath.row==0)
        {
            shengyin_TableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"shengyin_TableViewCell"];
            cell3.selectionStyle = NO;
            return cell3;
        }
        else if(indexPath.row==1)
        {
            zhen_dong_TableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"zhen_dong_TableViewCell"];
            cell2.selectionStyle = NO;
            return cell2;
        }
        else if(indexPath.row==2)
        {
            SystemSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetTableViewCellID" forIndexPath:indexPath];
            cell.sizeLable.hidden = NO;
            //缓存大小
            CGFloat size =  [self getCacheSizeAtPath:[self getCachesPath]];
            cell.sizeLable.text = [NSString stringWithFormat:@"%.2fM", size];
            cell.lable.text = @"清除缓存";
            return cell;
        }
        else if(indexPath.row==3)
        {
            SystemSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetTableViewCellID" forIndexPath:indexPath];
            cell.sizeLable.hidden = YES;
            cell.lable.text = @"意见反馈";
            return cell;
        }
        else if(indexPath.row==4)
        {
            SystemSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetTableViewCellID" forIndexPath:indexPath];
            cell.sizeLable.hidden = NO;
            //版本号
            cell.sizeLable.text = [ToolManager getVersion];
            cell.lable.text = @"当前版本";
            return cell;
        }
        else
        {
            SystemSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetTableViewCellID" forIndexPath:indexPath];
            cell.sizeLable.hidden = YES;
            cell.lable.text = @"关于我们";
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self setPassword];
    }else {
        switch (indexPath.row)
        {
                
            case 2:
                [self qingChuAction];
                break;
            case 3:
                [self FeedBack];
                break;
            case 5:
                [self aboutUs];
                break;
            default:
                break;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *V = [[UIView alloc]init];
    V.backgroundColor = J_BackLightGray;
    return V;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *V = [[UIView alloc]init];
    V.backgroundColor = J_BackLightGray;
    return V;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else {
        return 0.1;
    }
}
//设置密码
- (void)setPassword {
    PassWordSetViewController *VC = [[PassWordSetViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
-(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    return filePath;
}
-(long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(float)getCacheSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0 * 1024.0);
}
- (void)clearCacheAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
//清除缓存
-(void)qingChuAction
{
    //获取缓存大小
    float size =  [self getCacheSizeAtPath:[self getCachesPath]];
    if (size > 0) {
        NSString *count = [NSString stringWithFormat:@"是否清除[%.2fM]的缓存" ,size];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:count preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clearCacheAtPath:[self getCachesPath]];
            [self.tableView reloadData];
        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }else {
        [MBProgressHUD showError:@"暂无缓存"];
    }
}
//跳转意见反馈
-(void)FeedBack
{
    ZXOpinionFeedBackVC *VC = [[ZXOpinionFeedBackVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
//跳转关于我们
-(void)aboutUs
{
    AboutUsViewController *VC = [[AboutUsViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:KRGB(0, 172, 204, 1.0)}];
}
- (void)IfLogout {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出当前账户吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //退出登录
        //判断网络状态，网络不可用时直接显示网络状态
        if ([[ZXUD objectForKey:@"NetDataState"] isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请检查您的网络"];
            return;
        }
        [self logoutAction];
    }];
    [alert addAction:cancelAction];
    [alert addAction:anotherAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
//退出登录
- (void)logoutAction {
    //退出动画
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.loadingView2];
    [[SZBNetDataManager manager] logoutRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.loadingView2 removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            
            //让用户重新登录
            [ZXUD setObject:nil forKey:@"ident_code"];
            LoginVC *VC = [[LoginVC alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
            [self presentViewController:navi animated:YES completion:nil];
            //退出环信
            [[EMClient sharedClient] asyncLogout:YES success:^{
                //DLog(@"环信退出成功");
                
            } failure:^(EMError *aError)
             {
                 //DLog(@"环信退出失败");
             }];
            //清账号缓存
            [UMessage removeAlias:[ZXUD objectForKey:@"phone"] type:@"suizhenbao" response:^(id responseObject, NSError *error) {
            }];
            [[ValueHelper sharedHelper] cleanDisk];
            [MBProgressHUD showError:@"退出成功"];
        }else  if ([responseObject[@"res"] isEqualToString:@"1002"]) {
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
        [MBProgressHUD showError:@"网络错误"];
    }];
}

@end
