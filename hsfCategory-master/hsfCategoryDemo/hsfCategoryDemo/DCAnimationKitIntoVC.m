//
//  DCAnimationKitIntoVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "DCAnimationKitIntoVC.h"

#import "UIView+DCAnimationKit.h"

@interface DCAnimationKitIntoVC ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *frameLabel;

@end

@implementation DCAnimationKitIntoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Intros";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
}
- (IBAction)dBtnACTION:(UIButton *)sender {
    [self.testView removeCurrentAnimations];//先将原来的动画移除
    switch (sender.tag) {
        case 100:{//snapIntoView
            [self.testView snapIntoView:self.view direction:DCAnimationDirectionBottom];
        }
            break;
        case 101:{//bounceIntoView
            [self.testView bounceIntoView:self.view direction:DCAnimationDirectionBottom];
        }
            break;
        case 102:{//expandIntoView
            [self.testView expandIntoView:self.view finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
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
