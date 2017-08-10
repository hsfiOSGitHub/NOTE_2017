//
//  PreviewPhotosCell.h
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewPhotosCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//获取重用标识符
+(NSString *)getCellReuseIdentifier;

@end
