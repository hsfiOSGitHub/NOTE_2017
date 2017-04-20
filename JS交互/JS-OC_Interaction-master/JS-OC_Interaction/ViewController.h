//
//  ViewController.h
//  JS-OC_Interaction
//
//  Created by tonin on 2017/4/12.
//  Copyright © 2017年 tonin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestObjectProtocol <JSExport>
- (NSString *)testOCMethodWithFirstParam:(NSString *)className secondMethod:(int)number;
@end
@interface ViewController : UIViewController


@end

