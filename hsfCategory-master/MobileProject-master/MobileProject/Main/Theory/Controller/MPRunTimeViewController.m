//
//  MPRunTimeViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPRunTimeViewController.h"

@interface MPRunTimeViewController ()

@property (nonatomic, strong) MPRunTimeTest *myRunTimeTest;

@property(nonatomic,strong)UIButton *myButton;

@end

@implementation MPRunTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.myRunTimeTest=[[MPRunTimeTest alloc]init];
    
    [self getClassInfo];
    [self getClassProperty];
    [self getClassMemberVariable];
    [self getClassMethod];
    [self getClassProtocol];
    [self addClassAction];
    [self addCategoryProperty];
    [self changeMethod];
    
    //利用关联 封装BLOCK调用
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"可以直接查看输出信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alert showWithBlock:^(NSInteger buttonIndex) {
        NSLog(@"当前选中了%ld",buttonIndex);
    }];
    
    //HOCK 注入影响方法里面
    self.myButton=[[UIButton alloc]init];
    self.myButton.backgroundColor=[UIColor blueColor];
    [self.myButton setTitle:@"实现方法注入" forState:UIControlStateNormal];
    [self.view addSubview:self.myButton];
    [self.myButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveAction
{
    NSLog(@"saveAction");
}

#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"运行时知识点"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}


#pragma mark RunTime代码

//获取类的信息
-(void)getClassInfo
{
    //类名
    NSLog(@"class name: %s", class_getName([self.myRunTimeTest class]));
    
    NSLog(@"==========================================================");
    
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass([self.myRunTimeTest class])));
    NSLog(@"==========================================================");
    
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass([self.myRunTimeTest class]) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName([self.myRunTimeTest class]));
    NSLog(@"%s's meta-class is %s", class_getName([MPRunTimeTest class]), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize([self.myRunTimeTest class]));
    NSLog(@"==========================================================");
}


//获取类的对应属性
-(void)getClassProperty
{
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self.myRunTimeTest class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"属性名称为---->%@", [NSString stringWithUTF8String:propertyName]);
        
        NSString *getPropertyNameString = [NSString stringWithCString:property_getAttributes(propertyList[i]) encoding:NSUTF8StringEncoding];
        NSLog(@"属性类型及修饰符为:  %@",getPropertyNameString);
    }
    
    free(propertyList);
    
    //******显示内容如下******
    //属性名称为---->name
    //属性类型及修饰符为:  T@"NSString",C,N,V_name
    //属性名称为---->address
    //属性类型及修饰符为:  T@"NSString",C,N,V_address
    
    objc_property_t array = class_getProperty([self.myRunTimeTest class], "address");
    if (array != NULL) {
        NSLog(@"当前存在属性 %s", property_getName(array));
    }
    
    //******显示内容如下******
    //当前存在属性 address
}

//获取类的成员变量
-(void)getClassMemberVariable
{
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self.myRunTimeTest class], &count);
    for (unsigned int i; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"成员变量为---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    free(ivarList);
    
    //******显示内容如下******
    //成员变量为---->_UserAge
    //成员变量为---->_name
    //成员变量为---->_address
    
    Ivar string = class_getInstanceVariable([self.myRunTimeTest class], "_UserAge");
    if (string != NULL) {
        NSLog(@"当前存在变量 %s", ivar_getName(string));
    }
    
    //******显示内容如下******
    //当前存在变量 _UserAge
    
    
    //动态修改变量的值
    MPRunTimeTest *testModel=[[MPRunTimeTest alloc]init];
    testModel.name=@"wujunyang";
    
    NSLog(@"当前值没有被修改为：%@",testModel.name);
    
    unsigned int myCount = 0;
    Ivar *ivar = class_copyIvarList([testModel class], &myCount);
    for (int i = 0; i<myCount; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *proname = [NSString stringWithUTF8String:varName];
        
        if ([proname isEqualToString:@"_name"]) {   //这里别忘了给属性加下划线
            object_setIvar(testModel, var, @"Good");
            break;
        }
    }
    free(ivar);
    NSLog(@"当前修改后的变量值为：%@",testModel.name);
    
    //******显示内容如下******
    //可以用来动态改变一些已经存在的值，或者是统一变量处理
    //当前值没有被修改为：wujunyang
    //当前修改后的变量值为：Good
}

//获取方法
-(void)getClassMethod
{
    unsigned int count;
    Method *methods = class_copyMethodList([self.myRunTimeTest class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        NSLog(@"类的实例方法: %s", method_getName(method));
    }
    
    free(methods);
    
    //******显示内容如下******
    //类的实例方法: showUserName:
    //类的实例方法: setName
    //类的实例方法: name
    //类的实例方法: address
    //类的实例方法: .cxx_destruct
    //类的实例方法: setAddress
    
    unsigned int classcount;
    Method *classmethods = class_copyMethodList(object_getClass([self.myRunTimeTest class]), &classcount);
    for (int i = 0; i < classcount; i++) {
        Method method = classmethods[i];
        NSLog(@"类方法: %s", method_getName(method));
    }
    
    free(classmethods);
    
    //******显示内容如下******
    //注意主要差别是在object_getClass 如果是类方法的获取要object_getClass（Class）
    //类方法:showAddressInfo
    
    
    
    //判断类实例方法是否存在
    Method method1 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserName:));
    if (method1 != NULL) {
        NSLog(@"当前存在方法 %s", method_getName(method1));
    }
    
    //******显示内容如下******
    //当前存在方法 showUserName:
    
    
    //判断类方法是否存在
    Method classMethod = class_getClassMethod([self.myRunTimeTest class], @selector(showAddressInfo));
    if (classMethod != NULL) {
        NSLog(@"当前存在方法 : %s", method_getName(classMethod));
    }
    
    //******显示内容如下******
    //当前存在方法 : showAddressInfo
}


//获取类的协议列表
-(void)getClassProtocol
{
    unsigned int count;
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList([self.myRunTimeTest class], &count);
    Protocol * protocol;
    for (int i = 0; i < count; i++) {
        protocol = protocols[i];
        NSLog(@"协议名称: %s", protocol_getName(protocol));
    }
    
    //******显示内容如下******
    //协议名称:NSCopying
    
     NSLog(@"MPRunTimeTest is%@ responsed to protocol %s", class_conformsToProtocol([self.myRunTimeTest class], protocol) ? @"" : @" not", protocol_getName(protocol));
    
    //******显示内容如下******
    //MPRunTimeTest is responsed to protocol NSCopying
}


//动态增加方法
-(void)addClassAction
{
    class_addMethod([self.myRunTimeTest class], @selector(guess), (IMP)guessAnswer, "v@:");
    if ([self.myRunTimeTest respondsToSelector:@selector(guess)]) {
        //Method method = class_getInstanceMethod([self.myRunTimeTest class], @selector(guess));
        [self.myRunTimeTest performSelector:@selector(guess)];
        
    } else{
        NSLog(@"方法没有增加成功");
    }
}

void guessAnswer(id self,SEL _cmd){
    //一个Objective-C方法是一个简单的C函数，它至少包含两个参数–self和_cmd。所以，我们的实现函数(IMP参数指向的函数)至少需要两个参数
    NSLog(@"我是动态增加的方法响应");
}

//分类动态增加属性
-(void)addCategoryProperty
{
    MPRunTimeTest *test=[[MPRunTimeTest alloc]init];
    [test setWorkName:@"XM"];
    
    NSLog(@"当前的公司为：%@",test.getWorkName);
    
    //******显示内容如下******
    //可以为已经存在的类进行分类动态增加属性
    //当前的公司为：XM
}


//动态交换两个方法的实现
-(void)changeMethod
{
    Method m1 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserName:));
    Method m2 = class_getInstanceMethod([self.myRunTimeTest class], @selector(showUserAge:));
    
    method_exchangeImplementations(m1, m2);
    
    NSLog([self.myRunTimeTest showUserName:@"wujunyang"]);
    NSLog([self.myRunTimeTest showUserAge:@"20"]);
    
    //******显示内容如下******
    //注意 如果有参数 记得参数的类型要一般 或者可以进行相应的转换 或者两个方法类型不同会闪退
    //当前显示年龄wujunyang
    //user name is 20
}



#pragma mark RunTime API 说明

//***************************************************
//// 获取类的类名
//const char * class_getName ( Class cls );
//
//// 获取类的父类
//Class class_getSuperclass ( Class cls );
//
//// 判断给定的Class是否是一个元类
//BOOL class_isMetaClass ( Class cls );
//
//// 获取实例大小
//size_t class_getInstanceSize ( Class cls );
//
//// 获取类中指定名称实例成员变量的信息
//Ivar class_getInstanceVariable ( Class cls, const char *name );
//
//// 获取类成员变量的信息
//Ivar class_getClassVariable ( Class cls, const char *name );
//
//// 添加成员变量
//BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
//
//// 获取整个成员变量列表
//Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );
//
//// 获取指定的属性
//objc_property_t class_getProperty ( Class cls, const char *name );
//
//// 获取属性列表
//objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
//
//// 为类添加属性
//BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
//
//// 替换类的属性
//void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
//
//// 添加方法
//BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
//
//// 获取实例方法
//Method class_getInstanceMethod ( Class cls, SEL name );
//
//// 获取类方法
//Method class_getClassMethod ( Class cls, SEL name );
//
//// 获取所有方法的数组
//Method * class_copyMethodList ( Class cls, unsigned int *outCount );
//
//// 替代方法的实现
//IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
//
//// 返回方法的具体实现
//IMP class_getMethodImplementation ( Class cls, SEL name );
//IMP class_getMethodImplementation_stret ( Class cls, SEL name );
//
//// 类实例是否响应指定的selector
//BOOL class_respondsToSelector ( Class cls, SEL sel );
//
//// 添加协议
//BOOL class_addProtocol ( Class cls, Protocol *protocol );
//
//// 返回类是否实现指定的协议
//BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
//
//// 返回类实现的协议列表
//Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
//
//// 获取版本号
//int class_getVersion ( Class cls );
//
//// 设置版本号
//void class_setVersion ( Class cls, int version );
//
//***************************************************



//***************************************************
// 调用指定方法的实现
//    id method_invoke ( id receiver, Method m, ... );
//
//    // 调用返回一个数据结构的方法的实现
//    void method_invoke_stret ( id receiver, Method m, ... );
//
//    // 获取方法名
//    SEL method_getName ( Method m );
//
//    // 返回方法的实现
//    IMP method_getImplementation ( Method m );
//
//    // 获取描述方法参数和返回值类型的字符串
//    const char * method_getTypeEncoding ( Method m );
//
//    // 获取方法的返回值类型的字符串
//    char * method_copyReturnType ( Method m );
//
//    // 获取方法的指定位置参数的类型字符串
//    char * method_copyArgumentType ( Method m, unsigned int index );
//
//    // 通过引用返回方法的返回值类型字符串
//    void method_getReturnType ( Method m, char *dst, size_t dst_len );
//
//    // 返回方法的参数的个数
//    unsigned int method_getNumberOfArguments ( Method m );
//
//    // 通过引用返回方法指定位置参数的类型字符串
//    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
//
//    // 返回指定方法的方法描述结构体
//    struct objc_method_description * method_getDescription ( Method m );
//
//    // 设置方法的实现
//    IMP method_setImplementation ( Method m, IMP imp );
//
//    // 交换两个方法的实现
//    void method_exchangeImplementations ( Method m1, Method m2 );
//
//***************************************************



//***************************************************
//方法选择器 SEL
//// 返回给定选择器指定的方法的名称
//const char * sel_getName ( SEL sel );
//
//// 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
//SEL sel_registerName ( const char *str );
//
//// 在Objective-C Runtime系统中注册一个方法
//SEL sel_getUid ( const char *str );
//
//// 比较两个选择器
//BOOL sel_isEqual ( SEL lhs, SEL rhs );
//
//***************************************************

@end
