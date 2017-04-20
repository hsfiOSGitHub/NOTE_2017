//
//  CoordinateManipulationVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "CoordinateManipulationVC.h"

#import "UIView+DCAnimationKit.h"

@interface CoordinateManipulationVC ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *frameLabel;

@end

@implementation CoordinateManipulationVC

/*
 备注： 这个位移的方法还是有点问题  可以用UIView的animation动画来代替
 
 该部分内容已舍弃！
 
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"coordinate manipulation";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
}
- (IBAction)btnACTION:(UIButton *)sender {
    [self.testView removeCurrentAnimations];//先将原来的动画移除
    switch (sender.tag) {
        case 100:{//setX
            [self.testView setX:10 finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 101:{//moveX
            [self.testView moveX:100 finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 102:{//setY
            [self.testView setY:10 finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 103:{//moveY
            [self.testView moveY:100 finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 104:{//setPoint
            [self.testView setPoint:CGPointMake(10, 10) finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 105:{//movePoint
            [self.testView movePoint:CGPointMake(100, 100) finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 106:{//setRotation
            [self.testView setRotation:100 finished:^{
                self.frameLabel.text = [NSString stringWithFormat:@"Frame:(%.2f, %.2f, %.2f, %.2f)",self.testView.frame.origin.x, self.testView.frame.origin.y, self.testView.frame.size.width, self.testView.frame.size.height];
            }];
        }
            break;
        case 107:{//moveRotation
            [self.testView moveRotation:100 finished:^{
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
