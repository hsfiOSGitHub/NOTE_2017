//
//  EditScheduleTagVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/29.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditScheduleTagVC.h"

#import "editScheduleTagCell.h"
#import "EditScheduleTagColorVC.h"//标签颜色

@interface EditScheduleTagVC ()<HSFTagViewDelegate,UITableViewDelegate,UITableViewDataSource,EditScheduleTagColorVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *editBgView;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBgViewBottomCons;


@property (nonatomic,strong) HSFTagView *tagView;
@property (nonatomic,strong) NSMutableArray *currentTagsArr;//当前已经添加的标签数组
@property (nonatomic,strong) NSMutableArray *allTagsArr;//所有的标签数组
@property (nonatomic,strong) NSMutableArray *seleteStateArr;//所有标签的添加状态
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *editBtn;//编辑按钮
@property (nonatomic,strong) NSMutableArray *editStateArr;//编辑状态时的选中状态
@property (nonatomic,strong) NSMutableArray *editStateArr_copy;//编辑状态时的选中状态_copy
@property (nonatomic,strong) NSMutableDictionary *tagColorDic;//标签的颜色
@property (nonatomic,strong) UIView *maskView_tag;

@end

static NSString *identifierCell = @"identifierCell";
@implementation EditScheduleTagVC
#pragma mark -懒加载
-(UIView *)maskView_tag{
    if (!_maskView_tag) {
        _maskView_tag = [[UIView alloc]initWithFrame:self.tagView.bounds];
        _maskView_tag.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.2];
    }
    return _maskView_tag;
}
-(NSMutableArray *)currentTagsArr{
    if (!_currentTagsArr) {
        _currentTagsArr = [NSMutableArray array];
    }
    return _currentTagsArr;
}
-(NSMutableArray *)allTagsArr{
    if (!_allTagsArr) {
        _allTagsArr = [NSMutableArray array];
    }
    return _allTagsArr;
}
-(NSMutableArray *)seleteStateArr{
    if (!_seleteStateArr) {
        _seleteStateArr = [NSMutableArray array];
    }
    return _seleteStateArr;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, 0, 44, 44);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    return _editBtn;
}
-(NSMutableArray *)editStateArr{
    if (!_editStateArr) {
        _editStateArr = [NSMutableArray array];
    }
    return _editStateArr;
}
-(NSMutableArray *)editStateArr_copy{
    if (!_editStateArr_copy) {
        _editStateArr_copy = [NSMutableArray array];
    }
    return _editStateArr_copy;
}
-(NSMutableDictionary *)tagColorDic{
    if (!_tagColorDic) {
        _tagColorDic = [NSMutableDictionary dictionary];
    }
    return _tagColorDic;
}

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //标题
    self.navigationItem.title = @"标签";
    //返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    //编辑
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
    [self.editBtn addTarget:self action:@selector(editBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
}
//返回
-(void)backAction{
    if ([self.delegate respondsToSelector:@selector(backToEditScheduleVCWithCurrentTags:)]) {
        [self.delegate backToEditScheduleVCWithCurrentTags:self.currentTagsArr];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑
-(void)editBtnACTION:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {//编辑 ——> 完成
        //初始化编辑状态时的选中状态
        [self.editStateArr removeAllObjects];
        for (int i = 0; i < self.allTagsArr.count; i++) {
            [self.editStateArr addObject:@"0"];
        }
        //更改布局
        [self.tagView addSubview:self.maskView_tag];
        self.tagView.userInteractionEnabled = NO;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY - 100);
            self.editBgViewBottomCons.constant = 0;
            [self.editBgView setNeedsLayout];
        }];
    }else{//完成 －> 编辑
        [self.maskView_tag removeFromSuperview];
        self.tagView.userInteractionEnabled = YES;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY);
            self.editBgViewBottomCons.constant = -100;
            [self.editBgView setNeedsLayout];
        }];
    }
    //刷表
    [self.tableView reloadData];
}
//点击全选/取消全选
- (IBAction)seleteAllBtnACTION:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {//全选
        self.editStateArr_copy = self.editStateArr.mutableCopy;
        [self.editStateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"0"]) {
                [self.editStateArr replaceObjectAtIndex:idx withObject:@"1"];
            }
        }];
        [sender setImage:[UIImage imageNamed:@"unselete_all_tag"] forState:UIControlStateNormal];
        [sender setTitle:@"取消" forState:UIControlStateNormal];
    }else{//取消全选
        self.editStateArr = self.editStateArr_copy.mutableCopy;
        [sender setImage:[UIImage imageNamed:@"selete_all_tag"] forState:UIControlStateNormal];
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
    //刷表
    [self.tableView reloadData];
}
//点击删除
- (IBAction)deleteBtnACTION:(UIButton *)sender {
    NSMutableArray *mt_arr = [NSMutableArray array];
    [self.editStateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"1"]) {
            NSString *title = self.allTagsArr[idx];
            [mt_arr addObject:title];
        }
    }];
    [self.allTagsArr removeObjectsInArray:mt_arr];
    [self.seleteStateArr removeAllObjects];
    [self.editStateArr removeAllObjects];
    [self.allTagsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.currentTagsArr containsObject:obj]) {
            [self.seleteStateArr addObject:@"1"];
        }else{
            [self.seleteStateArr addObject:@"0"];
        }
        //初始化editStateArr
        [self.editStateArr addObject:@"0"];
    }];
    //刷表
    [self.tableView reloadData];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark -viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *allTagsPath = [path stringByAppendingPathComponent:@"allTags"];
    NSString *currentTagsPath = [path stringByAppendingPathComponent:@"currentTags"];
    
    [self.allTagsArr writeToFile:allTagsPath atomically:YES];
    [self.currentTagsArr writeToFile:currentTagsPath atomically:YES];
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //点击空白回收键盘
    [self backKeyboard];
    //初始化数据
    [self initData];
    //配置全选和删除按钮
    [self.seleteAllBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.deleteBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    //配置tagView
    [self setUpTagView];
    //配置tableView
    [self setUpTableView];
}
//点击空白回收键盘
-(void)backKeyboard{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapToBackKeyboard)];
    [self.view addGestureRecognizer:singleTap];
}
-(void)singleTapToBackKeyboard{
    [self.view endEditing:YES];
}
//初始化数据
-(void)initData{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *allTagsPath = [path stringByAppendingPathComponent:@"allTags"];
//    NSString *currentTagsPath = [path stringByAppendingPathComponent:@"currentTags"];
    self.allTagsArr = [NSMutableArray arrayWithContentsOfFile:allTagsPath];
//    self.currentTagsArr = [NSMutableArray arrayWithContentsOfFile:currentTagsPath];
    self.currentTagsArr = [NSMutableArray arrayWithArray:[self.tagsStr componentsSeparatedByString:@"、 "]];
    //状态
    if (self.allTagsArr.count <= 0) {
        return;
    }
    [self.allTagsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.currentTagsArr containsObject:obj]) {
            [self.seleteStateArr addObject:@"1"];
        }else{
            [self.seleteStateArr addObject:@"0"];
        }
        //初始化editStateArr
        [self.editStateArr addObject:@"0"];
    }];
    //标签颜色
    NSString *tagColorDicPath = [path stringByAppendingPathComponent:@"tagColorDicPath"];
    self.tagColorDic = [NSMutableDictionary dictionaryWithContentsOfFile:tagColorDicPath];
}
//配置tagView
-(void)setUpTagView{
    _tagView = [[HSFTagView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 0)];
    _tagView.delegate = self;
    _tagView.bgViewDic_color = self.tagColorDic;
    _tagView.tagsArr = self.currentTagsArr; 
    _tagView.backgroundColor = KRGB(245, 245, 245, 1);
    [self.view addSubview:_tagView];
}

//配置tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([editScheduleTagCell class]) bundle:nil] forCellReuseIdentifier:identifierCell];
    
}
#pragma mark -HSFTagViewDelegate
//添加标签
-(void)addTag:(NSString *)title{
    //判断allTagsArr中是否已经存在
    if ([self.allTagsArr containsObject:title]) {
        //判断self.currentTagsArr中是否已经存在
        if ([self.currentTagsArr containsObject:title]) {
            //HUD:该标签已添加，请勿重复添加
        }else{
            [self.currentTagsArr addObject:title];
        }
    }else{
        [self.allTagsArr addObject:title];
        [self.currentTagsArr addObject:title];
        [self.editStateArr addObject:@"0"];
    }
    _tagView.bgViewDic_color = self.tagColorDic;
    _tagView.tagsArr = self.currentTagsArr;
    self.tableView.frame = CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY);
    //状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.allTagsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.currentTagsArr containsObject:obj]) {
                [self.seleteStateArr addObject:@"1"];
            }else{
                [self.seleteStateArr addObject:@"0"];
            }
        }];
        //刷表
        [self.tableView reloadData];
    });
    
}
//删除标签
-(void)removeTagAtIndex:(NSInteger)index{
    [self.currentTagsArr removeObjectAtIndex:index];
    _tagView.bgViewDic_color = self.tagColorDic;
    _tagView.tagsArr = self.currentTagsArr;
    self.tableView.frame = CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY);
    //状态
    [self.allTagsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.currentTagsArr containsObject:obj]) {
            [self.seleteStateArr replaceObjectAtIndex:idx withObject:@"1"];
        }else{
            [self.seleteStateArr replaceObjectAtIndex:idx withObject:@"0"];
        }
    }];
    //刷表
    [self.tableView reloadData];
}
//美化标签
-(void)showColorCardAtIndex:(NSInteger)index{
    EditScheduleTagColorVC *color_VC = [[EditScheduleTagColorVC alloc]init];
    color_VC.delegate = self;
    color_VC.currentTagIndex = index;
    [self presentViewController:color_VC animated:YES completion:nil];
}
#pragma mark -EditScheduleTagColorVCDelegate
-(void)changeTagColorAtIndex:(NSInteger)index withColor:(UIColor *)color{
    CGFloat components[3];
    [UIColor getRGBComponents:components forColor:color];
    NSLog(@"%f %f %f", components[0], components[1], components[2]);
    NSString *RGB = [NSString stringWithFormat:@"%f,%f,%f",components[0], components[1], components[2]];
    
    [self.tagColorDic setObject:RGB forKey:[NSString stringWithFormat:@"%ld",index]];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *tagColorDicPath = [path stringByAppendingPathComponent:@"tagColorDicPath"];
    [self.tagColorDic writeToFile:tagColorDicPath atomically:YES];
    
    //更新tagView
    _tagView.bgViewDic_color = self.tagColorDic;
    _tagView.tagsArr = self.currentTagsArr;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTagsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    editScheduleTagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    cell.titleLabel.text = self.allTagsArr[indexPath.row];
    //seleteBtn的状态
    NSString *state = self.seleteStateArr[indexPath.row];
    if ([state isEqualToString:@"0"]) {//未添加的标签
        [cell.seleteBtn setImage:[UIImage imageNamed:@"unselete_tag"] forState:UIControlStateNormal];
    }else if ([state isEqualToString:@"1"]) {//已经添加的标签
        [cell.seleteBtn setImage:[UIImage imageNamed:@"seleted_tag"] forState:UIControlStateNormal];
    }
    //点击seleteBtn
    [cell.seleteBtn setTag:indexPath.row];
    [cell.seleteBtn addTarget:self action:@selector(seleteBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    //编辑状态的selete——editBtn
    if (self.editBtn.selected) {
        cell.seleteBtnLeftCons.constant = -40;
        cell.selete_editBtnRightCons.constant = 10;
    }else{
        cell.seleteBtnLeftCons.constant = 10;
        cell.selete_editBtnRightCons.constant = -40;
    }
    //selete_editBtn的状态
    NSString *editState = self.editStateArr[indexPath.row];
    if ([editState isEqualToString:@"0"]) {//未选中
        [cell.selete_editBtn setImage:[UIImage imageNamed:@"unselete_edit_tag"] forState:UIControlStateNormal];
    }else if ([editState isEqualToString:@"1"]) {//已选中
        [cell.selete_editBtn setImage:[UIImage imageNamed:@"seleted_edit_tag"] forState:UIControlStateNormal];
    }
    //点击selete_editBtn
    [cell.selete_editBtn setTag:indexPath.row + 1000];
    [cell.selete_editBtn addTarget:self action:@selector(selete_editBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//禁止高亮cell
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
//点击seleteBtn
-(void)seleteBtnACTION:(UIButton *)sender{
    if ([self.seleteStateArr[sender.tag] isEqualToString:@"0"]) {
        [self.seleteStateArr replaceObjectAtIndex:sender.tag withObject:@"1"];
        [self.currentTagsArr addObject:self.allTagsArr[sender.tag]];
    }else if ([self.seleteStateArr[sender.tag] isEqualToString:@"1"]) {
        [self.seleteStateArr replaceObjectAtIndex:sender.tag withObject:@"0"];
        [self.currentTagsArr removeObject:self.allTagsArr[sender.tag]];
    }
    self.tagView.tagsArr = self.currentTagsArr;
    self.tableView.frame = CGRectMake(0, self.tagView.maxY, KScreenWidth, KScreenHeight - self.tagView.maxY);
    //刷表
    [self.tableView reloadData];
}
//点击selete_editBtn
-(void)selete_editBtnACTION:(UIButton *)sender{
    if ([self.editStateArr[sender.tag - 1000] isEqualToString:@"0"]) {
        [self.editStateArr replaceObjectAtIndex:(sender.tag - 1000) withObject:@"1"];
    }else if ([self.editStateArr[sender.tag - 1000] isEqualToString:@"1"]) {
        [self.editStateArr replaceObjectAtIndex:(sender.tag - 1000) withObject:@"0"];
    }
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
