//
//  YLCyclicChart.h
//  DrawTest
//
//  Created by LELE on 17/4/11.
//  Copyright © 2017年 rect. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Cyclic chart type, has been abandoned
 */
typedef  NS_ENUM(NSInteger,YLCyclicChartType){
    
    YLCyclicChartType_sequence = 0, /*        Default         */
    YLCyclicChartType_while = 1
};

@interface YLCyclicChart : UIView
-(instancetype)initWithFrame:(CGRect)frame dataValue:(NSArray*)dataValue colors:(NSArray*)colors duration:(CGFloat)duration startAngle:(CGFloat)startAngle radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth cyclicChartType:(YLCyclicChartType)type;



@end
