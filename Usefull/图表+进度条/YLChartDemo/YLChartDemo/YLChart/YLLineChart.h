//
//  YLLineChart.h
//  DrawTest
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLLineChart : UIView
-(instancetype)initWithFrame:(CGRect)frame dataValue:(NSArray*)dataValue colors:(NSArray*)colors pathCurve:(BOOL)pathCurve;

@end
