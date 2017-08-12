//
//  KNFirstViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "KNFirstViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface KNFirstViewController ()

- (IBAction)buttonDidTouch:(id)sender;

@end

@implementation KNFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = NSLocalizedString(@"First", @"First");
      self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)buttonDidTouch:(id)sender {
  // You can present a simple UIImageView or any other UIView like this,
  // without needing to take care of dismiss action
  UIImageView * imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp.jpg"]];
  UIImageView * bgimgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
  [self presentSemiView:imagev withOptions:@{ KNSemiModalOptionKeys.backgroundView:bgimgv }];
}

@end
