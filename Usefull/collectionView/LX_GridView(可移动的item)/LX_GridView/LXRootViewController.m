//
//  LXRootViewController.m
//  DemoSummary
//
//   技术点: 毛玻璃效果
//
//

#import "LXRootViewController.h"

@interface LXRootViewController ()

@end

@implementation LXRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *icon =[[UIImageView alloc]initWithFrame:self.view.bounds];
    icon.image =[UIImage imageNamed:@"meinv07.jpg"];
    [self.view addSubview:icon];
    
    //毛玻璃效果
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, icon.frame.size.width, icon.frame.size.height);
    [icon addSubview:effectView];

    self.backGroundImageview = icon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
