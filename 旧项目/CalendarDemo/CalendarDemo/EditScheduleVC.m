//
//  EditScheduleVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditScheduleVC.h"

#import "EditScheduleCell1.h"
#import "EditScheduleCell2.h"
#import "EditScheduleCell3.h"
#import "EditScheduleCell4.h"
#import "EditScheduleCell5.h"
#import "EditScheduleCell6.h"
#import "EditScheduleCell_pic.h"//图片
#import "EditScheduleCell_tag.h"//标签
#import "CustomKeyboardInputView.h"//键盘inputView
#import "EditScheduleContentVC.h"//备注



@interface EditScheduleVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,EditScheduleTagVCDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditScheduleContentVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIButton *saveBtn;//保存按钮

//Cell
@property (nonatomic,strong) EditScheduleCell1 *cell1;
@property (nonatomic,strong) EditScheduleCell2 *cell2;
@property (nonatomic,strong) EditScheduleCell3 *cell3;
@property (nonatomic,strong) EditScheduleCell4 *cell4;
@property (nonatomic,strong) EditScheduleCell5 *cell5;
@property (nonatomic,strong) EditScheduleCell6 *cell6;
@property (nonatomic,strong) EditScheduleCell_tag *cell_tag;
@property (nonatomic,strong) EditScheduleCell_pic *cell_pic;
//键盘调用时
@property (nonatomic,strong) UIView *keyboardTool;
@property (nonatomic,strong) UIView *keyboardTool2;
@property (nonatomic,strong) CustomKeyboardInputView *keyboardInputView;
@property (nonatomic,strong) UILabel *currentInputTimeLabel;
//开始结束时间
@property (nonatomic,strong) NSDate *currentStartDate;
@property (nonatomic,strong) NSDate *currentEndDate;
//图片数组
@property(nonatomic,strong) NSMutableArray *picArr;
@property (nonatomic, assign) BOOL isTakePhoto;//相册 还是  拍照



@property (nonatomic,strong) UITapGestureRecognizer *endEditingTap;//弹出键盘时点击空白退出键盘

@end

static NSString *identifierCell1 = @"identifierCell1";
static NSString *identifierCell2 = @"identifierCell2";
static NSString *identifierCell3 = @"identifierCell3";
static NSString *identifierCell4 = @"identifierCell4";
static NSString *identifierCell5 = @"identifierCell5";
static NSString *identifierCell6 = @"identifierCell6";
static NSString *identifierCell_pic = @"identifierCell_pic";
static NSString *identifierCell_tag = @"identifierCell_tag";
@implementation EditScheduleVC

#pragma mark- 懒加载
//数据源
-(ScheduleModel *)model{
    if (!_model) {
        _model = [ScheduleModel modelWithDic:@{}];
    }
    return _model;
}
-(NSMutableArray *)picArr{
    if (!_picArr) {
        _picArr = [NSMutableArray array];
        if (!self.model.schedule_id) {
            NSArray *all = [[HSFFmdbManager sharedManager] readAllSchedules];
            self.model.schedule_id = [NSNumber numberWithInteger:(all.count + 1)];
        }
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *picArrPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.model.schedule_id]];
        NSArray *imageDataArr = [NSMutableArray arrayWithContentsOfFile:picArrPath];
        [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image = [UIImage imageWithData:obj];
            [_picArr addObject:image];
        }];
    }
    return _picArr;
}
-(UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(0, 0, 44, 44);
        [_saveBtn setImage:[UIImage imageNamed:@"save_hd_edit"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(UIView *)keyboardTool{
    if (!_keyboardTool) {
        _keyboardTool = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [hiddenBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hiddenBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool addSubview:hiddenBtn];
    }
    return _keyboardTool;
}
-(UIView *)keyboardTool2{
    if (!_keyboardTool2) {
        _keyboardTool2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _keyboardTool2.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0];
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(KScreenWidth - 50, 0, 40, 40);
        [hiddenBtn setImage:[UIImage imageNamed:@"keyboard_common"] forState:UIControlStateNormal];
        [hiddenBtn addTarget:self action:@selector(hiddenBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardTool2 addSubview:hiddenBtn];
        //时间（开始、结束）
        _currentInputTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 60, 40)];
        _currentInputTimeLabel.textColor = [UIColor whiteColor];
        _currentInputTimeLabel.font = [UIFont systemFontOfSize:15];
        [_keyboardTool2 addSubview:_currentInputTimeLabel];
    }
    return _keyboardTool2;
}
-(void)hiddenBtnACTION:(UIButton *)sender{
    [self.view endEditing:YES];//收回键盘
}
-(CustomKeyboardInputView *)keyboardInputView{
    if (!_keyboardInputView) {
        _keyboardInputView = [[CustomKeyboardInputView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 250)];
    }
    return _keyboardInputView;
}
#pragma mark -配置导航栏
-(void)setUpNavi{
    //标题
    self.navigationItem.title = @"编辑";
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    //保存
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
}
//返回
-(void)backAction{
    if ([self.pushOrMode isEqualToString:@"push"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.pushOrMode isEqualToString:@"mode"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//保存
-(void)saveBtnACTION:(UIButton *)sender{
    //必填项 ：name start_time end_time 
    if (!self.model.name || [self.model.name isEqualToString:@""] || !self.model.start_time || [self.model.start_time isEqualToString:@""] || !self.model.end_time || [self.model.end_time isEqualToString:@""]) {
        [MBProgressHUD showError:@"“名称”、“开始／结束时间”为必填项!"];
    }else{
        //先将图片保存到沙盒
        if (!self.model.schedule_id) {
            NSArray *all = [[HSFFmdbManager sharedManager] readAllSchedules];
            self.model.schedule_id = [NSNumber numberWithInteger:(all.count + 1)];
        }
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *picArrPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self.model.schedule_id]];
        NSMutableArray *imageDataArr = [NSMutableArray array];
        [self.picArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImagePNGRepresentation(obj);
            [imageDataArr addObject:imageData];
        }];
        [imageDataArr writeToFile:picArrPath atomically:YES];
        //保存到数据库
        if ([self.pushOrMode isEqualToString:@"push"]) {//更新事件
            [[HSFFmdbManager sharedManager] modifyScheduleWith:self.model whereCondition:self.condition];
        }else if ([self.pushOrMode isEqualToString:@"mode"]) {//新建事件
            [[HSFFmdbManager sharedManager] insertNewSchedule:self.model];
        }
        //保存成功，退出
        [MBProgressHUD showError:@"保存成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSaveEditedSchedule" object:nil];
            [self backAction];
        });
    }
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[color colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置tableView
    [self setUpTableView];
    //注册通知（键盘）
    [self registerNotification];
}
//配置tableView
-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell1 class]) bundle:nil] forCellReuseIdentifier:identifierCell1];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell2 class]) bundle:nil] forCellReuseIdentifier:identifierCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell3 class]) bundle:nil] forCellReuseIdentifier:identifierCell3];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell4 class]) bundle:nil] forCellReuseIdentifier:identifierCell4];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell5 class]) bundle:nil] forCellReuseIdentifier:identifierCell5];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell6 class]) bundle:nil] forCellReuseIdentifier:identifierCell6];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell_pic class]) bundle:nil] forCellReuseIdentifier:identifierCell_pic];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditScheduleCell_tag class]) bundle:nil] forCellReuseIdentifier:identifierCell_tag];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }else if (section == 3) {
        return 1;
    }else if (section == 4) {
        return 1;
    }else if (section == 5) {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//标题
        _cell1 = [tableView dequeueReusableCellWithIdentifier:identifierCell1 forIndexPath:indexPath];
        _cell1.titleTF.delegate = self;
        self.keyboardTool = nil;
        _cell1.titleTF.inputAccessoryView = self.keyboardTool;
        //配置数据
        _cell1.titleTF.text = self.model.name;
        return _cell1;
    }
    else if (indexPath.section == 1) {//事件紧急程度
        _cell2 = [tableView dequeueReusableCellWithIdentifier:identifierCell2 forIndexPath:indexPath];
        //配置数据
        if ([self.model.emergency isEqualToString:@""] || !self.model.emergency) {
            self.model.emergency = @"重要／紧急";
        }
        _cell2.emergencyStr.text = self.model.emergency;
        if ([self.model.emergency isEqualToString:@"重要／紧急"]) {
            _cell2.emergencyType.image = [UIImage imageNamed:@"A"];
        }else if ([self.model.emergency isEqualToString:@"重要／不紧急"]) {
            _cell2.emergencyType.image = [UIImage imageNamed:@"B"];
        }else if ([self.model.emergency isEqualToString:@"不重要／紧急"]) {
            _cell2.emergencyType.image = [UIImage imageNamed:@"C"];
        }else if ([self.model.emergency isEqualToString:@"不重要／不紧急"]) {
            _cell2.emergencyType.image = [UIImage imageNamed:@"D"];
        }
        return _cell2;
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//设定时间
            _cell3 = [tableView dequeueReusableCellWithIdentifier:identifierCell3 forIndexPath:indexPath];
            _cell3.starTimeTF.delegate = self;
            _cell3.endTimeTF.delegate = self;
            self.keyboardTool2 = nil;
            _cell3.starTimeTF.inputAccessoryView = self.keyboardTool2;
            _cell3.endTimeTF.inputAccessoryView = self.keyboardTool2;
            _cell3.starTimeTF.inputView = self.keyboardInputView;
            _cell3.endTimeTF.inputView = self.keyboardInputView;
            //默认开始时间
            _cell3.starTimeTF.placeholder = [NSDate starEndTimeWithDate:[NSDate date]];
            //是否设置为全天事件
            [_cell3.settingAllDaySW addTarget:self action:@selector(allDaySWACTION:) forControlEvents:UIControlEventValueChanged];
            
            //配置数据
            _cell3.starTimeTF.text = self.model.start_time;
            _cell3.endTimeTF.text = self.model.end_time;
            //是否为全天事件
            if ([self.model.start_time isEqualToString:self.model.end_time]) {
                _cell3.settingAllDaySW.on = YES;
//                _cell3.starTimeTF.text = [NSDate allDayTimeWithDate:self.model.end_time];
//                _cell3.endTimeTF.text = self.model.end_time;
            }else{
                _cell3.settingAllDaySW.on = NO;
            }
            if (_cell3.settingAllDaySW.on) {//开启全天事件
                _cell3.bgTFView.backgroundColor = KRGB(230, 230, 230, 1);
                _cell3.starTimeTF.backgroundColor = KRGB(230, 230, 230, 1);
                _cell3.endTimeTF.backgroundColor = KRGB(230, 230, 230, 1);
                _cell3.starTimeTF.userInteractionEnabled = NO;
                _cell3.endTimeTF.userInteractionEnabled = NO;
            }else{//关闭全天事件
                _cell3.bgTFView.backgroundColor = KRGB(248, 248, 248, 1);
                _cell3.starTimeTF.backgroundColor = [UIColor whiteColor];
                _cell3.endTimeTF.backgroundColor = [UIColor whiteColor];
                _cell3.starTimeTF.userInteractionEnabled = YES;
                _cell3.endTimeTF.userInteractionEnabled = YES;
            }
            
            return _cell3;
        }else if (indexPath.row == 1) {//地点
            _cell4 = [tableView dequeueReusableCellWithIdentifier:identifierCell4 forIndexPath:indexPath];
            if (!self.model.address || [self.model.address isEqualToString:@""]) {
                self.model.address = @"洛阳市";//默认地点
            }
            _cell4.address.text = self.model.address;
            return _cell4;
        }else if (indexPath.row == 2) {//设置提醒
            _cell5 = [tableView dequeueReusableCellWithIdentifier:identifierCell5 forIndexPath:indexPath];
            if (!self.model.alarm || [self.model.alarm isEqualToString:@""]) {
                self.model.alarm = @"不提醒";
            }
            _cell5.alarmTimeBefore.text = self.model.alarm;
            return _cell5;
        }
    }
    else if (indexPath.section == 3) {//图片
        _cell_pic = [tableView dequeueReusableCellWithIdentifier:identifierCell_pic forIndexPath:indexPath];
        [_cell_pic.addPicBtn addTarget:self action:@selector(addPicBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        //配置图片
        if (self.picArr.count <= 0) {
            _cell_pic.pictopCons.constant = 0;
            _cell_pic.picBottomCons.constant = 0;
            _cell_pic.picWidthCons.constant = 0;
            _cell_pic.bgView1.hidden = YES;
            _cell_pic.bgView2.hidden = YES;
            _cell_pic.bgView3.hidden = YES;
            _cell_pic.deleteBtn1widthCons.constant = 0;
            _cell_pic.deleteBtn2WidthCons.constant = 0;
            _cell_pic.deleteBtn3WidthCons.constant = 0;
            [_cell_pic layoutIfNeeded];
        }else{
            _cell_pic.pictopCons.constant = 10;
            _cell_pic.picBottomCons.constant = 10;
            _cell_pic.picWidthCons.constant = 80;
            if (self.picArr.count == 1) {
                _cell_pic.bgView1.hidden = NO;
                _cell_pic.bgView2.hidden = YES;
                _cell_pic.bgView3.hidden = YES;
                _cell_pic.deleteBtn1widthCons.constant = 35;
                _cell_pic.pic1.image = self.picArr[0];
            }else if (self.picArr.count == 2) {
                _cell_pic.bgView1.hidden = NO;
                _cell_pic.bgView2.hidden = NO;
                _cell_pic.bgView3.hidden = YES;
                _cell_pic.deleteBtn1widthCons.constant = 35;
                _cell_pic.deleteBtn2WidthCons.constant = 35;
                _cell_pic.pic1.image = self.picArr[0];
                _cell_pic.pic2.image = self.picArr[1];
            }else if (self.picArr.count == 3) {
                _cell_pic.bgView1.hidden = NO;
                _cell_pic.bgView2.hidden = NO;
                _cell_pic.bgView3.hidden = NO;
                _cell_pic.deleteBtn1widthCons.constant = 35;
                _cell_pic.deleteBtn2WidthCons.constant = 35;
                _cell_pic.deleteBtn3WidthCons.constant = 35;
                _cell_pic.pic1.image = self.picArr[0];
                _cell_pic.pic2.image = self.picArr[1];
                _cell_pic.pic3.image = self.picArr[2];
            }
            [_cell_pic layoutIfNeeded];
        }
        //点击图片查看大图
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigPic:)];
        [_cell_pic.pic1 setTag:1000];
        [_cell_pic.pic2 setTag:2000];
        [_cell_pic.pic3 setTag:3000];
        [_cell_pic.pic1 addGestureRecognizer:singleTap];
        [_cell_pic.pic2 addGestureRecognizer:singleTap];
        [_cell_pic.pic3 addGestureRecognizer:singleTap];
        //点击删除按钮 tag:10000、20000、30000
        [_cell_pic.deleteBtn1 addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [_cell_pic.deleteBtn2 addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [_cell_pic.deleteBtn3 addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        return _cell_pic;
    }
    else if (indexPath.section == 4) {//标签
        _cell_tag = [tableView dequeueReusableCellWithIdentifier:identifierCell_tag forIndexPath:indexPath];
        //配置标签
        if (!self.model.tags || [self.model.tags isEqualToString:@""]) {
            self.model.tags = @"点击添加标签";
        }
        _cell_tag.tagStr.text = self.model.tags;
        return _cell_tag;
    }
    else if (indexPath.section == 5) {//备注
        _cell6 = [tableView dequeueReusableCellWithIdentifier:identifierCell6 forIndexPath:indexPath];
        //配置数据
        if (!self.model.content || [self.model.content isEqualToString:@""]) {
            self.model.content = @"点击添加备注";
        }
        _cell6.content.text = self.model.content;
        return _cell6;
    }
    return nil;
}
//是否高亮cell
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//标题
        return NO;
    }
    else if (indexPath.section == 1) {//事件紧急程度
        return YES;
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//设定时间
            return NO;
        }else if (indexPath.row == 1) {//地点
            return YES;
        }else if (indexPath.row == 2) {//设置提醒
            return YES;
        }
    }
    else if (indexPath.section == 3) {//图片
        return NO;
    }
    else if (indexPath.section == 4) {//标签
        return YES;
    }
    else if (indexPath.section == 5) {//备注
        return YES;
    }
    return YES;
}
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消点击效果
    if (indexPath.section == 0) {//标题
        //nothing
    }
    else if (indexPath.section == 1) {//事件紧急程度
        EditEmergencyView *emergency_V = [[EditEmergencyView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [KMyWindow addSubview:emergency_V];
        [emergency_V show];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//设定时间
            //nothing
        }else if (indexPath.row == 1) {//地点

        }else if (indexPath.row == 2) {//设置提醒
            EditAlarmView *alarm_V = [[EditAlarmView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [KMyWindow addSubview:alarm_V];
            [alarm_V show];
        }
    }
    else if (indexPath.section == 3) {//图片
        //nothing
    }
    else if (indexPath.section == 4) {//标签
        EditScheduleTagVC *tag_VC = [[EditScheduleTagVC alloc]init];
        tag_VC.delegate = self;
        tag_VC.tagsStr = self.model.tags;
        [self.navigationController pushViewController:tag_VC animated:YES];
    }
    else if (indexPath.section == 5) {//备注
        
        EditScheduleContentVC *content_VC = [[EditScheduleContentVC alloc]init];
        content_VC.delegate = self;
        if ([_cell6.content.text isEqualToString:@"点击添加备注"]) {
            content_VC.contentStr = @"";
        }else{
            content_VC.contentStr = _cell6.content.text;
        }
        [self.navigationController pushViewController:content_VC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 15;
    }
}
//点击全天时间开关
-(void)allDaySWACTION:(UISwitch *)sender{
    if (sender.on) {
        NSDate *date = [NSDate date];
        if ([_cell3.starTimeTF.text isEqualToString:@""]) {
            date = [NSDate date];
        }else{
            date = self.currentStartDate;
        }
        self.model.start_time = [NSDate allDayTimeWithDate:date];
        self.model.date = [NSDate allDayTimeWithDate:date];
        self.model.end_time = [NSDate allDayTimeWithDate:date];
    }else{
        self.model.start_time = [NSDate starEndTimeWithDate:self.currentStartDate];
        self.model.date = [NSDate allDayTimeWithDate:self.currentStartDate];
        self.model.end_time = [NSDate starEndTimeWithDate:self.currentEndDate];
    }
    [self.tableView reloadData];
}
//点击添加图片
-(void)addPicBtnACTION:(UIButton *)sender{
    //先判断有几张图片（因为最多添加三张图片）
    if (self.picArr.count >= 3) {
        //HUD提示
        [MBProgressHUD showError:@"最多添加三张图片!"];
    }else{
        EditPicView *pic_V = [[EditPicView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [KMyWindow addSubview:pic_V];
        [pic_V show];
    }
}
//点击图片查看大图
-(void)showBigPic:(UITapGestureRecognizer *)singleTap{
    UIImageView *pic = (UIImageView *)singleTap.view;
    switch (pic.tag) {
        case 1000:{
            
        }
            break;
        case 2000:{
            
        }
            break;
        case 3000:{
            
        }
            break;
            
        default:
            break;
    }
}
//点击删除按钮 tag:10000、20000、30000
-(void)deletePic:(UIButton *)sender{
    switch (sender.tag) {
        case 10000:{
            [self.picArr removeObjectAtIndex:0];
        }
            break;
        case 20000:{
            [self.picArr removeObjectAtIndex:1];
        }
            break;
        case 30000:{
            [self.picArr removeObjectAtIndex:2];
        }
            break;
            
        default:
            break;
    }
    //刷表
    [self.tableView reloadData];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
    //赋值时间（开始、结束）
    NSString *dateStr = [NSDate starEndTimeWithDate:[NSDate date]];
    if ([_cell3.starTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",dateStr];
    }else if ([_cell3.endTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",dateStr];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _cell1.titleTF) {
        self.model.name = textField.text;
    }else if (textField == _cell3.starTimeTF) {
        self.model.start_time = textField.text;
    }else if (textField == _cell3.endTimeTF) {
        self.model.end_time = textField.text;
    } 
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _cell1.titleTF) {
        self.model.name = textField.text;
    }else if (textField == _cell3.starTimeTF) {
        self.model.start_time = textField.text;
    }else if (textField == _cell3.endTimeTF) {
        self.model.end_time = textField.text;
    } 
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];//取消第一响应，回收键盘
    return YES;
}
#pragma mark -键盘
//注册通知
- (void)registerNotification{  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //用于事件的重要\紧急程度的选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseEmergency:) name:@"kEditEmergencyView_noti" object:nil];
    //用于选择提醒时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAlarm:) name:@"kEditAlarmView_noti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAlarm_dateSeletor:) name:@"kDateSeletor_notify_EditScheduleVC" object:nil];
    //用于日期时间选择的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getYouChoosedCurrentDate:) name:@"kCustomKeyboardInputView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOkBtnDate:) name:@"kKeyboardOkBtn" object:nil];
    //用于照片的选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAlbum) name:@"kEditPicView_photo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:@"kEditPicView_camera" object:nil];
}  
//移除通知
- (void)removeNotification{  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];  
} 
- (void)keyboardWillShow:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]; 
    
    self.endEditingTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapACtION:)];
    [self.view addGestureRecognizer:self.endEditingTap];
}  
-(void)singleTapACtION:(UITapGestureRecognizer *)singleTap{
    [self.view endEditing:YES];
}
- (void)keyboardDidShow:(NSNotification *)notification{  
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];  
    CGRect keyboardRect = [aValue CGRectValue];  
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];  
    CGFloat keyboardHeight = keyboardFrame.size.height;  
    
    
}  
- (void)keyboardWillHide:(NSNotification *)note{  
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];  
    [self.view removeGestureRecognizer:self.endEditingTap];
} 
//用于事件的重要\紧急程度的选择
-(void)chooseEmergency:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *title = userInfo[@"title"];
//    NSString *icon = userInfo[@"icon"];
    self.model.emergency = title;
    [self.tableView reloadData];
}
//用于选择提醒时间
-(void)chooseAlarm:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *title = userInfo[@"title"];
    if ([title isEqualToString:@"自定义"]) {
        DateSeletor *dateSeletor = [[DateSeletor alloc]initWithFrame:[UIScreen mainScreen].bounds];
        dateSeletor.title.text = @"自定义提醒时间";
        dateSeletor.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        dateSeletor.sourceVC = @"EditScheduleVC";
        [KMyWindow addSubview:dateSeletor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [dateSeletor show];
        });
    }else{
        self.model.alarm = title;
        [self.tableView reloadData];
    }
}
//自定义提醒时间
-(void)chooseAlarm_dateSeletor:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSString *alarmStr = userInfo[@"alarmStr"];
    self.model.alarm = alarmStr;
    [self.tableView reloadData];
}
//键盘选择器更改时间
-(void)getYouChoosedCurrentDate:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSDate *date = userInfo[@"youChoosedDate"];
    NSString *dateStr = [NSDate starEndTimeWithDate:date];
    //赋值时间（开始、结束）
    if ([_cell3.starTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",dateStr];
    }else if ([_cell3.endTimeTF isFirstResponder]) {
        _currentInputTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",dateStr];
    }
}
//点击键盘的确认按钮
-(void)keyboardOkBtnDate:(NSNotification *)sender{
    NSDictionary *userInfo = sender.userInfo;
    NSDate *date = userInfo[@"okBtnDate"];
    NSString *dateStr = [NSDate starEndTimeWithDate:date];
    //赋值时间（开始、结束）
    if ([_cell3.starTimeTF isFirstResponder]) {
        self.currentStartDate = date;
        self.model.start_time = [NSString stringWithFormat:@"%@",dateStr];
        self.model.date = [NSDate allDayTimeWithDate:date];
    }else if ([_cell3.endTimeTF isFirstResponder]) {
        self.currentEndDate = date;
        self.model.end_time = [NSString stringWithFormat:@"%@",dateStr];
    }
    //刷表
    [self.tableView reloadData];
    [self.view endEditing:YES];
}
/**
 *  打开相册
 */
- (void)openAlbum{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    _isTakePhoto = NO;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
/**
 *  拍照
 */
-(void)takePhoto{
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
    if (_isTakePhoto) {
        image = info[UIImagePickerControllerOriginalImage];
    } else {
        image = info[UIImagePickerControllerEditedImage];
    }
    if (self.picArr.count < 3) {
        [self.picArr addObject:image];
    }
    //刷表
    [self.tableView reloadData];
    //退出
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 改变图像的尺寸，方便上传服务器
//    UIImage *uploadImage = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
//    UIImageView *tempV = (UIImageView *)[self.view viewWithTag:888];
//    tempV.image = uploadImage;
    
    //取出选中的图片
//    NSData *data = UIImageJPEGRepresentation(uploadImage, 1.0);
    
    
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -EditScheduleTagVCDelegate
-(void)backToEditScheduleVCWithCurrentTags:(NSArray *)currentTags{
    __block NSString *currentTagsStr = @"";
    [currentTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([currentTagsStr isEqualToString:@""]) {
            currentTagsStr = [NSString stringWithFormat:@"%@",obj];
        }else{
            currentTagsStr = [NSString stringWithFormat:@"%@、 %@",currentTagsStr,obj];
        }
    }];
    
    if ([currentTagsStr isEqualToString:@""]) {
        self.model.tags = @"点击添加标签";
    }else{
        self.model.tags = currentTagsStr;
    }
    //刷表
    [self.tableView reloadData];
}
#pragma mark -EditScheduleContentVCDelegate
-(void)endEditContentWith:(NSString *)content{
    self.model.content = content;
    //刷表
    [self.tableView reloadData];
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
