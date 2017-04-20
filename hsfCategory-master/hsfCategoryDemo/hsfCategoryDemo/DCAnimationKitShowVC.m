//
//  DCAnimationKitShowVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "DCAnimationKitShowVC.h"

#import "UIView+DCAnimationKit.h"

@interface DCAnimationKitShowVC ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *frameLabel;
@property (nonatomic, assign) CGRect origionFrame;

@end

@implementation DCAnimationKitShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Outros";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
    self.origionFrame = self.testView.frame;
}
- (IBAction)cBtnACTION:(UIButton *)sender {
    [self.testView removeCurrentAnimations];//先将原来的动画移除
    switch (sender.tag) {
        case 100:{//compressIntoView
            [self.testView compressIntoView:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIView *view = [[UIView alloc]initWithFrame:self.origionFrame];
                    view.backgroundColor = [UIColor colorWithRed:65/255.0 green:174/255.0 blue:152/255.0 alpha:1];
                    self.testView = view;
                    [self.view addSubview:self.testView];
                });
            }];
        }
            break;
        case 101:{//hinge
            [self.testView hinge:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIView *view = [[UIView alloc]initWithFrame:self.origionFrame];
                    view.backgroundColor = [UIColor colorWithRed:65/255.0 green:174/255.0 blue:152/255.0 alpha:1];
                    self.testView = view;
                    [self.view addSubview:self.testView];
                });
            }];
        }
            break;
        case 102:{//drop
            [self.testView drop:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIView *view = [[UIView alloc]initWithFrame:self.origionFrame];
                    view.backgroundColor = [UIColor colorWithRed:65/255.0 green:174/255.0 blue:152/255.0 alpha:1];
                    self.testView = view;
                    [self.view addSubview:self.testView];
                });
            }];
        }
            break;
        default:
            break;
    }
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
