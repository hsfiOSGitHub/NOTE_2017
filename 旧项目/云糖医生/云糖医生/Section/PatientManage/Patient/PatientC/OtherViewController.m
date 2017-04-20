//
//  OtherViewController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "OtherViewController.h"
#import "DateAndSugarHeaderView.h"
#import "UUDatePicker.h"
#import "DateDetailTableViewCell.h"
#import "SugarHightOrLowTableViewCell.h"
#import "SZBNetDataManager+PatientManageNetData.h"

static dispatch_once_t onceToken;
@interface OtherViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *BackGrayView;
@property (nonatomic)float Y;//视图滑动的偏移量
@property (nonatomic, strong)UIImageView *leftImageV;
@property (nonatomic, strong)UIImageView *rightImageV;//展开与否
@property (nonatomic, strong)DateAndSugarHeaderView *header;
@property (nonatomic,strong) NSString *start_date;//开始时间
@property (nonatomic,strong) NSString *end_date;//结束时间
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) NSString *higher;//高
@property (nonatomic,strong) NSString *normal;//正常
@property (nonatomic,strong) NSString *lower;//低
@property (nonatomic, strong) NetworkLoadFailureView *loadFailureView;//网络加载失败
@property (nonatomic, strong)LoadingView *loadingView;//加载中动画
@end

@implementation OtherViewController
-(NetworkLoadFailureView *)loadFailureView{
    if (!_loadFailureView) {
        _loadFailureView = [[NetworkLoadFailureView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _loadFailureView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UIView *)BackGrayView {
    if (_BackGrayView) {
        [_BackGrayView removeFromSuperview];
    }
    _BackGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.Y, KScreenWidth, KScreenHeight)];
    _BackGrayView.alpha = 0.5;
    _BackGrayView.backgroundColor = [UIColor grayColor];
   
    return _BackGrayView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 110)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DateAndSugarHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"DateAndSugarHeaderView"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SugarHightOrLowTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SugarHightOrLowTableViewCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DateDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"DateDetailTableViewCellID"];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加回收键盘手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    //设置默认开始与结束日期
    NSDate *currentDate = [NSDate date];
    NSDate *newDate = [currentDate dateByAddingTimeInterval: - 60 * 60 * 24 * 6];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *NewdateString = [dateFormatter stringFromDate:newDate];
    self.start_date = NewdateString;
    self.end_date = dateString;
    [self.view addSubview:_loadingView];
    //获取血糖记录数据
    [self getBloodSugData];
}
- (void)getBloodSugData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *set = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = set;
    NSLog(@"%@", [NSString stringWithFormat:SGet_patient_bloodsugar_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"],[ZXUD objectForKey:@"patient_id"],self.start_date, self.end_date]);
    [manager GET:[NSString stringWithFormat:SGet_patient_bloodsugar_Url, [ToolManager getCurrentTimeStamp], [ZXUD objectForKey:@"ident_code"],[ZXUD objectForKey:@"patient_id"],self.start_date, self.end_date] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_loadingView dismiss];
        [self.loadFailureView removeFromSuperview];
        if ([responseObject[@"res"] isEqualToString:@"1001"]) {
            [self.dataSource removeAllObjects];
            for (NSDictionary *dic in  responseObject[@"list"]) {
                [self.dataSource addObject:dic];
            }
            self.higher = responseObject[@"higher"];
            self.normal = responseObject[@"normal"];
            self.lower = responseObject[@"lower"];
         [self.tableView reloadData];
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_loadingView dismiss];
        [self.view addSubview:self.loadFailureView];
        [self.loadFailureView.loadAgainBtn addTarget:self action:@selector(getBloodSugData) forControlEvents:UIControlEventTouchUpInside];
    }];
}
- (void)hideKeyboard {
    [self.view endEditing:YES];
}
-(void)timehandle:(UITextField *)startDateTF and:(UITextField *)endStartTF{
    
    UIView *backgroundview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    UIView *backgroundview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    UUDatePicker *datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, KScreenWidth, 216 *3/4) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        startDateTF.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
       
    }];
    [backgroundview1 addSubview:datePicker];
    UUDatePicker *datePicker2 = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, KScreenWidth, 216 *3/4) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        //        NSLog(@"选择日期");
        endStartTF.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
       
    }];
    [backgroundview2 addSubview:datePicker2];
    UIView *V = [[UIView alloc]initWithFrame:CGRectMake(0, 216 *3/4, KScreenWidth, 216/4)];
    V.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 1, KScreenWidth, 216/4-2);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KRGB(0, 172, 204, 1.0);
    [V addSubview:btn];
    [btn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UIView *VV = [[UIView alloc]initWithFrame:CGRectMake(0, 216 *3/4, KScreenWidth, 216/4)];
    VV.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 1, KScreenWidth, 216/4-2);
    [btn1 setTitle:@"确认" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.backgroundColor = KRGB(0, 172, 204, 1.0);
    [VV addSubview:btn1];
    [btn1 addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [backgroundview2 addSubview:VV];
    [backgroundview1 addSubview:V];
    startDateTF.inputView = backgroundview1;
    endStartTF.inputView = backgroundview2;
   
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
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return (KScreenWidth - 40) / 3 + 60;
    }else {
        return (KScreenWidth - 8) / 9;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    SugarHightOrLowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SugarHightOrLowTableViewCellID" forIndexPath:indexPath];
        if (![self.higher isEqualToString:@""] && [self.higher isKindOfClass:[NSString class]]) {
             cell.HightLable.text = [NSString stringWithFormat:@"%@次", self.higher];
        }
        if (![self.normal isEqualToString:@""] && [self.normal isKindOfClass:[NSString class]]) {
            cell.Midlable.text = [NSString stringWithFormat:@"%@次", self.normal];
        }
        if (![self.lower isEqualToString:@""] && [self.lower isKindOfClass:[NSString class]]) {
            cell.LowLable.text = [NSString stringWithFormat:@"%@次", self.lower];
        }
       
        return cell;
    }else {
    DateDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateDetailTableViewCellID" forIndexPath:indexPath];
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.contentView.frame) - 1, KScreenWidth, 1)];
    backV.backgroundColor = J_BackLightGray;
    [cell.contentView addSubview:backV];
    // Configure the cell...
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell steDetaiData:dic];
        
    return cell;
   }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 80 + (KScreenWidth - 8) / 9 * 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        _header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DateAndSugarHeaderView"];
        self.leftImageV = _header.startimageV;
        self.rightImageV = _header.endImageV;
        _header.startDateTF.text = _start_date;
        _header.endDateTF.text = _end_date;
      //只实现一次的方法
        dispatch_once(&onceToken, ^{
        _header.startDateTF.delegate = self;
        _header.endDateTF.delegate = self;
        //日期选择
        [self timehandle:_header.startDateTF and:_header.endDateTF];
        });
        return _header;
    }
}
//页面销毁的时候重置onceToken, 使再次进入的时候重走一遍,以免重用
- (void)dealloc {
    onceToken = 0;
}
//设置时间键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
  
    if (_header.startDateTF.editing) {
           self.leftImageV.image = [UIImage imageNamed:@"展开"];
    }
    if (_header.endDateTF.editing) {
          self.rightImageV.image = [UIImage imageNamed:@"展开"];
    }
 
    [self.tableView addSubview: self.BackGrayView];
    self.tableView.scrollEnabled = NO;
  
}

//设置时间键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
     self.leftImageV.image = [UIImage imageNamed:@"下一步-拷贝"];
     self.rightImageV.image = [UIImage imageNamed:@"下一步-拷贝"];
    [self.BackGrayView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
   
}

//实时监听滑动的偏移量
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.Y = scrollView.contentOffset.y;
}
//结束编辑的时候 赋值
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _header.startDateTF) {
        self.start_date = textField.text;
    }else {
        self.end_date = textField.text;
    }
    NSComparisonResult result = [_end_date compare:_start_date];
    if (result == -1) {
        [MBProgressHUD showError:@"日期选择有误" toView:self.view];
        return;
    }
    [self getBloodSugData];
  
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
