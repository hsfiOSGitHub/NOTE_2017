 //
//  MineVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MineVC.h"
#import "SZBNetDataManager+RegisterAndLoginNetData.h"
#import "SZBNetDataManager+PersonalInformation.h"
#import "SZBNetDataManager+CerNetData.h"
#import "MyCertificateViewController.h"
#import "UserInfoVC.h"
#import "SZBFmdbManager+userInfo.h"
#import "UserInfoModel.h"
#import "SystemNewsVC.h"
@interface MineVC ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, assign) BOOL isTakePhoto;
@property (nonatomic,strong) UserInfoModel *userInfoModel;//个人信息模型

@property (nonatomic,strong) UIButton *systemMessageBtn;//系统消息按钮
@property (nonatomic,strong) UILabel *numLabel;//系统消息个数
@end

@implementation MineVC
#pragma mark -从数据库加载数据
-(void)loadDataFromLocal{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    NSArray *result = [manager readUserInfoModelArrFromDB];
    if (!result || result.count == 0) {
        [MBProgressHUD showError:@"请完善基本信息"];
    }else{
        self.userInfoModel = result[0];
    }
    [self.tableV reloadData];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //获取系统消息数量
    [self getSystemMessageNum];
    //获取验证状态
    [self getCheck_status];
    //加载数据库数据
    [self loadDataFromLocal];
}

#pragma mark  -获取验证状态
- (void)getCheck_status {
    NSString *newUrlString = [[NSString stringWithFormat:SCheck_status_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", [NSString stringWithFormat:SCheck_status_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"]]);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data > 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"res"] isEqualToString:@"1001"]) {
                [[SZBFmdbManager sharedManager] modifyUserInfoDataAtDBWith:@{@"auth_check":dic[@"auth_check"], @"is_check":dic[@"is_check"], @"pospic_url":dic[@"pospic_url"]}];
                //加载数据库数据
                [self loadDataFromLocal];
            }
        }
    }];
}

#pragma mark  -添加系统消息
-(void)addSystemNewsBtn{
    //添加系统消息
    _systemMessageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_systemMessageBtn addTarget:self action:@selector(systemNews) forControlEvents:UIControlEventTouchUpInside];
    [_systemMessageBtn   setImage:[UIImage imageNamed:@"系统消息"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_systemMessageBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)systemNews{
    if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
        SystemNewsVC *systemNews_VC = [[SystemNewsVC alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:systemNews_VC];
        [self presentViewController:navi animated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"当前没有消息"];
    }
    
}
# pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加系统消息
    [self addSystemNewsBtn];
    //配置tableView
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
     //注册cell
    [self.tableV registerNib:[UINib nibWithNibName:@"MineInformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineInformationTableViewCellID"];
    [self.tableV registerNib:[UINib nibWithNibName:@"MineMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineMoreTableViewCellID"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MineInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineInformationTableViewCellID" forIndexPath:indexPath];
        //头像
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
        [cell.headImageV addGestureRecognizer:tap];
        cell.headImageV.tag = 888;
        [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.pic] placeholderImage:[UIImage imageNamed:@"默认医生头像"]];

        if (!self.userInfoModel.name || ![self.userInfoModel.name isKindOfClass:[NSString class]] || [self.userInfoModel.name isEqualToString:@""]) {
            cell.name.text = @"填写姓名";
        }else {
            cell.name.text = self.userInfoModel.name;
        }
        if (!self.userInfoModel.department || ![self.userInfoModel.department isKindOfClass:[NSString class]] || [self.userInfoModel.department isEqualToString:@""]) {
            self.userInfoModel.department = @"科室";
        }
        if (!self.userInfoModel.title || ![self.userInfoModel.title isKindOfClass:[NSString class]] || [self.userInfoModel.title isEqualToString:@""]) {
            self.userInfoModel.title = @"职称";
        }
        NSString *str = [NSString stringWithFormat:@"%@ %@",self.userInfoModel.department, self.userInfoModel.title];
        //计算最大宽度
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        CGSize size =  [str boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGRect frame = cell.keShiAndPositionLable.frame;
        frame.size.width = size.width;
        frame.origin.x = cell.bgView.frame.size.width - size.width;
        cell.keShiAndPositionLable.frame = frame;
        cell.keShiAndPositionLable.text = str;
        CGRect frame1 = cell.name.frame;
        frame1.size.width = frame.origin.x - 5;
        cell.name.frame = frame1;
        
        if (!self.userInfoModel.hospital || ![self.userInfoModel.hospital isKindOfClass:[NSString class]] || [self.userInfoModel.hospital isEqualToString:@""]) {
            self.userInfoModel.hospital = @"医院";
        }
        cell.hospital.text = self.userInfoModel.hospital;
        return cell;
    }else {
        MineMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMoreTableViewCellID" forIndexPath:indexPath];
        NSArray *arr = @[@"我要认证",@"排班设置", @"我的收藏", @"系统设置", @"我的名片", @"我报名的会议"];
        NSArray *imageArr = @[@"图层-3",@"排班-1", @"收藏", @"系统设置", @"我的名片", @"我报名的会议"];
        if (indexPath.row == 1) {
            cell.renzhengLable.hidden = NO;
            NSString *renzhengType;
            if ([self.userInfoModel.is_check isEqualToString:@"0"]) {//待审核
                if ([self.userInfoModel.auth_check isEqualToString:@"0"]) {
                    renzhengType = @"未认证";
                }else if ([self.userInfoModel.auth_check isEqualToString:@"1"]) {
                    renzhengType = @"审核通过";
                }else if ([self.userInfoModel.auth_check isEqualToString:@"2"]) {
                    renzhengType = @"审核不通过";
                }else if ([self.userInfoModel.auth_check isEqualToString:@"3"]) {
                    renzhengType = @"待审核";
                }else {
                    renzhengType = @"未认证";
                }
            }else if ([self.userInfoModel.is_check isEqualToString:@"1"]){//审核通过
                renzhengType = @"已认证";
            }
            cell.renzhengLable.text = renzhengType;
        }else {
            cell.renzhengLable.hidden = YES;
        }
        cell.MineListStyleLable.text = arr[indexPath.row - 1];
        cell.MsmallImageV.image = [UIImage imageNamed:imageArr[indexPath.row - 1]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            //个人信息
            UserInfoVC *userInfo_VC = [[UserInfoVC alloc]init];
            [self.navigationController pushViewController:userInfo_VC animated:YES];
            
        }
            break;
        case 1:{
            //认证
            MyCertificateViewController *MyCerVC = [[MyCertificateViewController alloc]init];
            MyCerVC.is_check = self.userInfoModel.is_check;
            MyCerVC.auth_check = self.userInfoModel.auth_check;
            NSLog(@"%@ %@ %@", self.userInfoModel.pospic_url,self.userInfoModel.is_check, self.userInfoModel.auth_check);
            MyCerVC.postic_url = self.userInfoModel.pospic_url;
            MyCerVC.userInfoModel = self.userInfoModel;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyCerVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 2:{
            //排班设置
            SchedulingSetTableViewController *SVC = [[SchedulingSetTableViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:SVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 3:{
            //我的收藏
            MyCollectViewController *CollectVC = [[MyCollectViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:CollectVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 4:{
            //系统设置
            SystemSetVC *SVC = [[SystemSetVC alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:SVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 5:{
            //我的名片
            MyCardViewController *CardVC = [[MyCardViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:CardVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
            
        case 6:{
            //我报名的会议
            MyMeetingListVC *MyMeetingVC = [[MyMeetingListVC alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MyMeetingVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
            
        default:
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110;
    }else {
        return 80;
    }
    
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
    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
    UIImageView *tempV = (UIImageView *)[self.view viewWithTag:888];
    tempV.image = uploadImage;

    // 1.取出选中的图片
    NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    [manager POST:[NSString stringWithFormat:SDoctor_avatar_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",[ToolManager getCurrentTimeStamp]] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"res"] isEqualToString:@"1002"]) {
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
        }else if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            NSString *url = [responseObject objectForKey:@"resault"];
            //保存用户的图片信息
            [[SZBFmdbManager sharedManager] modifyUserInfoDataAtDBWith:@{@"pic":url}];
            [ZXUD setObject:url forKey:@"pic"];
            //加载数据库数据
            [self loadDataFromLocal];
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBProgressHUD showError:@"网络错误"];
        
    }];
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//获取消息数量
- (void)getSystemMessageNum {
    [[SZBNetDataManager manager] remindNumRandomString:[ToolManager getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"res"] isEqualToString:@"1002"]) {
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
        }else if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            [_numLabel removeFromSuperview];
            _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 - 15, 15/3, 16, 16)];
            [_numLabel setFont:[UIFont systemFontOfSize:10]];
            _numLabel.textColor = [UIColor whiteColor];
            _numLabel.textAlignment = NSTextAlignmentCenter;
            _numLabel.layer.cornerRadius = 8;
            _numLabel.layer.masksToBounds = YES;
            _numLabel.backgroundColor = [UIColor redColor];
            _numLabel.text = responseObject[@"num"];
            if (![_numLabel.text isEqualToString:@"0"] && _numLabel.text != NULL ) {
                [self.systemMessageBtn addSubview:_numLabel];
            }
        }else if ([responseObject[@"res"] isEqualToString:@"1005"] || [responseObject[@"res"] isEqualToString:@"1004"]) {
            
        }else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failed:^(NSURLSessionTask *task, NSError *error) {

    }];
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
