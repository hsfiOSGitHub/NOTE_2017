//
//  MPLockViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/16.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPLockViewController.h"

@interface MPLockViewController ()
@property(atomic,strong)NSMutableArray *myMutableList;

//要运用atomic 线程安全 只能是相对安全 只有这个属性也会出现线程问题
@property(strong,atomic)NSMutableArray *myThreadList;

@property(strong)NSLock *mylock;
@end

@implementation MPLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.myMutableList)
    {
        self.myMutableList=[@[@"图片1",@"图片2",@"图片3",@"图片4",@"图片5",@"图片6",@"图片7",@"图片8",@"图片9"] mutableCopy];
    }
    
    //初始化锁对象
    self.mylock=[[NSLock alloc]init];
    
    
    [self addArrayThtead];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addArrayThtead
{
    if (!self.myThreadList) {
        self.myThreadList=[[NSMutableArray alloc]init];
    }
    
    [self.myThreadList removeAllObjects];
    
    for(int i=0; i<10;i++)
    {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadAction:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];
        
        [self.myThreadList addObject:thread];
    }
    
    
    for (int i=0; i<self.myThreadList.count; i++) {
        NSThread *thread=self.myThreadList[i];
        [thread start];
    }
}

-(void)loadAction:(NSNumber *)index
{

    NSThread *thread=[NSThread currentThread];
    NSLog(@"loadAction是在线程%@中执行",thread.name);
    
    //结合下面的cancel运用 进行强制退出线程的操作
    if ([[NSThread currentThread] isCancelled]) {
        NSLog(@"当前thread-exit被exit动作了");
        [NSThread exit];
    }
    
    //第一种情况，第二种情况：
//    NSString *name;
//    if (self.myMutableList.count>0) {
//        name=[self.myMutableList lastObject];
//        [self.myMutableList removeObject:name];
//    }
    
    //第三种情况
//    NSString *name;
//    
//    //加锁
//    [_mylock lock];
//    if (self.myMutableList.count>0) {
//        name=[self.myMutableList lastObject];
//        [self.myMutableList removeObject:name];
//    }
//    [_mylock unlock];
    
//    第四种情况
    //线程同步
    NSString *name;
    @synchronized(self){
            if (self.myMutableList.count>0) {
                name=[self.myMutableList lastObject];
                [self.myMutableList removeObject:name];
            }
    }
    
    NSLog(@"当前要加载的图片名称%@",name);
    
    //回主线程去执行  有些UI相应 必须在主线程中更新
    [self performSelectorOnMainThread:@selector(updateImage) withObject:nil waitUntilDone:YES];
}

-(void)updateImage
{
    @autoreleasepool {
        NSLog(@"执行完成了");
    }
    
    //输出：执行方法updateImage是在主线程中
}


//******解决Thread中的内存问题
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //结合VC生命周期 viewWillDisappear退出页面时就把线程标识为cancel 使用Thread一定要在退出前进行退出，否则会有闪存泄露的问题
    for (int i=0; i<self.myThreadList.count; i++){
        NSThread *thread=self.myThreadList[i];
        if (![thread isCancelled]) {
            NSLog(@"当前thread-exit线程被cancel");
            [thread cancel];
            //cancel 只是一个标识 最下退出强制终止线程的操作是exit 如果单写cancel 线程还是会继续执行
        }}
}



//------------------------------------------------------------------------------------------
//第一种情况
//输出  @property(nonatomic,strong)NSMutableArray *myMutableList;
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2


//说明：错乱，当前要加载的图片名称图片8被加载的两次


//------------------------------------------------------------------------------------------
//第二种情况
//输出 @property(atomic,strong)NSMutableArray *myMutableList;  atomic原子性
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2

//说明：错乱，当前要加载的图片名称图片6被加载的两次


//------------------------------------------------------------------------------------------
//第三种情况
//输出  [_mylock lock]; [_mylock unlock];
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片1
//当前要加载的图片名称图片2

//说明：成功防止错乱


//------------------------------------------------------------------------------------------
//第四种情况
//输出  @synchronized
//当前要加载的图片名称图片9
//当前要加载的图片名称图片8
//当前要加载的图片名称图片7
//当前要加载的图片名称图片6
//当前要加载的图片名称图片5
//当前要加载的图片名称图片4
//当前要加载的图片名称图片3
//当前要加载的图片名称图片2
//当前要加载的图片名称图片1

//说明：成功防止错乱 而且还是有顺序执行下来



//------------------------------------------------------------------------------------------
//@synchronized跟NSLock区别 （NSLock性能上优于synchronized）
//synchronized会创建一个异常捕获handler和一些内部的锁。所以，使用@synchronized替换普通锁的代价是，你付出更多的时间消耗。
//创建给@synchronized指令的对象是一个用来区别保护块的唯一标示符。如果你在两个不同的线程里面执行上述方法，每次在一个线程传递了一个不同的对象给anObj参数，那么每次都将会拥有它的锁，并持续处理，中间不被其他线程阻塞。然而，如果你传递的是同一个对象，那么多个线程中的一个线程会首先获得该锁，而其他线程将会被阻塞直到第一个线程完成它的临界区。
//作为一种预防措施，@synchronized块隐式的添加一个异常处理例程来保护代码。该处理例程会在异常抛出的时候自动的释放互斥锁。这意味着为了使用@synchronized指令，你必须在你的代码中启用异常处理。了如果你不想让隐式的异常处理例程带来额外的开销，你应该考虑使用锁的类。




//所有同步锁类型
//@synchronized
//NSLock
//NSCondition
//NSConditionLock
//NSRecursiveLock
//pthread_mutex_t
//OSSpinLock
//dispatch_barrier_async
//------------------------------------------------------------------------------------------

@end
