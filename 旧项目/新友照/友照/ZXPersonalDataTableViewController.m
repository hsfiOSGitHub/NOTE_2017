//
//  ZXPersonalDataTableViewController.m
//  友照
//
//  Created by chaoyang on 16/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZXPersonalDataTableViewController.h"
#import "PersonalDataTableViewCell.h"
#import "ImageVTableViewCell.h"
#import "SexView.h"
#import "ZXCityTableViewController.h"

@interface ZXPersonalDataTableViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) SexView *sexView;
@property (nonatomic,strong) UIView *bgView;//背景view
@property (nonatomic, assign) BOOL isTakePhoto;
@property(nonatomic,strong)UIImageView* img;
@property(nonatomic,strong)UITextField* nicheng;
@property(nonatomic,strong)UITextField* xingbie;

@property(nonatomic) BOOL isWanCheng;
    
@end

@implementation ZXPersonalDataTableViewController


-(void)viewDidDisappear:(BOOL)animated
{
    if (!_isWanCheng)
    {
        [ZXUD setObject:@"1" forKey:@"personalCity"];
    }
}

//初始化方法
-(instancetype)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
    
-(void)viewWillAppear:(BOOL)animated
{
    _isWanCheng=NO;
    if (!([ZXUD objectForKey:@"personalCity"] == nil))
    {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    UIBarButtonItem *letfbarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goBackToFrontPages)];
    //测试
    letfbarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem =letfbarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completeAction)];
    //测试
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageVTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImageVTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //性别
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(genderWith:) name:@"sex" object:nil];
}
//>>>>>>>性别
-(void)genderWith:(NSNotification *)noti
{
    
    if ([noti.userInfo[@"gender"] isEqualToString:@"0"])
    {
        [ZXUD setObject:@"0" forKey:@"sex"];
        _xingbie.text=@"男";
    }
    else
    {
        [ZXUD setObject:@"1" forKey:@"sex"];
        _xingbie.text=@"女";
    }
    [_bgView removeFromSuperview];
}

/**返回上一页*/
-(void)goBackToFrontPages
{
    [self.navigationController popViewControllerAnimated:YES];
}

//完成
- (void)completeAction
{
    if ([_nicheng.text length] == 0)
    {
        [MBProgressHUD showSuccess:@"输入内容不能为空格。"];
        return ;
    }
    if ([_nicheng.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [ZXUD setObject:_nicheng.text forKey:@"username"];
        [ZXUD synchronize];
        
        [[ZXNetDataManager manager] modifyUserInfoSuccess:^(NSURLSessionDataTask *task, id responseObject)
         {
             [MBProgressHUD showSuccess:@"修改成功"];

             _isWanCheng = YES;
             [self.navigationController popViewControllerAnimated:YES];
         } failed:^(NSURLSessionTask *task, NSError *error)
         {
             [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
             YZLog(@"修改失败%@",error);
         }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, KScreenWidth, 1)];
    label.backgroundColor = ZX_BG_COLOR;
    [cell.contentView addSubview:label];
    cell.TF.delegate = self;

    ImageVTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ImageVTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        //头像
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
        [cell1.imageV sd_setImageWithURL:[ZXUD objectForKey:@"userpic"] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        [cell1.imageV addGestureRecognizer:tap];
        [cell1.SetBtn addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        self.img=cell1.imageV;
         cell1.imageV.tag = 888;
         return cell1;
    }
    else if (indexPath.row == 1)
    {
        cell.stylelable.text = @"昵称";
        if ([[ZXUD objectForKey:@"username"] length] > 0)
        {
            if ([_nicheng.text isEqualToString:[ZXUD objectForKey:@"username"]] || cell.TF.text.length == 0)
            {
                cell.TF.text=[ZXUD objectForKey:@"username"];
            }
            else
            {
                cell.TF.text=_nicheng.text;
            }
        }
        else
        {
            if (_nicheng.text.length>0)
            {
                cell.TF.text=_nicheng.text;
            }
            else
            {
                cell.TF.text = @"";
            }
        }
        cell.TF.userInteractionEnabled = YES;
        _nicheng = cell.TF;
        return cell;
    }
    else  if (indexPath.row == 2)
    {
         cell.stylelable.text = @"性别";
        if ([[ZXUD objectForKey:@"sex"] integerValue] == 0)
        {
             cell.TF.text=@"男";
        }
        else
        {
             cell.TF.text=@"女";
        }
         cell.TF.userInteractionEnabled = NO;
        _xingbie = cell.TF;
         return cell;
    }
    else
    {
         cell.stylelable.text = @"地区";
        YZLog(@"%@",[ZXUD objectForKey:@"area"]);
        if ([[ZXUD objectForKey:@"personalCity"] isEqualToString:@"1"])
        {
            if ([[ZXUD objectForKey:@"area"] isEqualToString:@"1"])
            {
                YZLog(@"%@",[ZXUD objectForKey:@"personalCity"]);
                cell.TF.text = @"";
            }
            else
            {
                cell.TF.text = [ZXUD objectForKey:@"area"];
                [ZXUD setObject:[ZXUD objectForKey:@"area"] forKey:@"personalCity"];
            }
        }
        else
        {
            cell.TF.text = [ZXUD objectForKey:@"personalCity"];
        }
         cell.TF.userInteractionEnabled = NO;
         return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        //设置背景
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self addTapGesture];//点击消失
        [self.view addSubview:_bgView];
        _sexView = [[SexView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 60, (KScreenWidth - 60) * 2/5)];
        _sexView.center = _bgView.center;
         [_bgView addSubview:_sexView];
    }
    else if (indexPath.row == 3)
    {
        [self xuanZeCity5];
    }
}

//选择城市
-(void)xuanZeCity5
{
    ZXCityTableViewController *cityVC =[[ZXCityTableViewController alloc]init];
    cityVC.isPersonalData = YES;
    [self.navigationController  pushViewController:cityVC animated:YES];
}

-(void)addTapGesture
{
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_bgView addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [_bgView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击图像选取图片
- (void)selectImage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self openAlbum];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self takePhoto];
    }];
    
    UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
    {
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
    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(90, 90)];
    UIImageView *tempV = (UIImageView *)[self.view viewWithTag:888];
    tempV.image = uploadImage;
    //友盟社区登录
    UMComLoginUser *userAccount = [[UMComLoginUser alloc] init];
    
    userAccount.userNameType=userNameNoRestrict;
    userAccount.updatedProfile=YES;
    userAccount.usid = [ZXUD objectForKey:@"phoneNum"];
    
    UMComDataRequestManager *request = [UMComDataRequestManager defaultManager];
    [request userUpdateAvatarWithImage:uploadImage completion:^(NSDictionary *responseObject, NSError *error)
      {
        if(!error)
        {
            [UMComLoginManager userLogout];
            __weak typeof(self) weakSelf = self;
            [UMComLoginManager requestLoginWithLoginAccount:userAccount requestCompletion:^(NSDictionary *responseObject, NSError *error, dispatch_block_t callbackCompletion) {
                if (error) {
                    // 登录失败
                } else {
                   
                    // 当前有登录界面时调用，weakSelf是指presentViewController弹出的UIViewController
                    [weakSelf dismissViewControllerAnimated:YES completion:callbackCompletion];
                
                }
            }];
        }
    }] ;
     
     

    // 1.取出选中的图片
    NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
    [[ZXNetDataManager manager] uploadUserHeadImageWithFile:data andTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andCode:[ZXUD objectForKey:@"ident_code"] success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
 
        if ([[jsonDict objectForKey:@"res"] isEqualToString:@"1001"])
         {
            [MBProgressHUD showSuccess:@"修改成功"];
             self.img.image=uploadImage;
         }
        
     } failed:^(NSURLSessionTask *task, NSError *error)
    {
         [MBProgressHUD showSuccess:@"网络不好，请稍后重试。"];
         YZLog(@"上传图片出错%@",error);
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

@end
