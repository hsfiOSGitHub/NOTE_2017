//
//  ImageBlurVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/27.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ImageBlurVC.h"

#import "UIImage+Category.h"

@interface ImageBlurVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *resultmgView;

@end

@implementation ImageBlurVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Blur";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (IBAction)btnACTION:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{//soft
            UIImage *image = [self.imgView.image imageByBlurSoft];
            self.resultmgView.image = image;
        }
            break;
        case 200:{//light
            UIImage *image = [self.imgView.image imageByBlurLight];
            self.resultmgView.image = image;
        }
            break;
        case 300:{//extraLight
            UIImage *image = [self.imgView.image imageByBlurExtraLight];
            self.resultmgView.image = image;
        }
            break;
        case 400:{//dark
            UIImage *image = [self.imgView.image imageByBlurDark];
            self.resultmgView.image = image;
        }
            break;
        case 500:{//imageByBlurWithTint:[UIClolor redColor]
            UIImage *image = [self.imgView.image imageByBlurWithTint:[UIColor redColor]];
            self.resultmgView.image = image;
        }
            break;
        case 600:{
            
        }
            break;
        case 700:{
            
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
