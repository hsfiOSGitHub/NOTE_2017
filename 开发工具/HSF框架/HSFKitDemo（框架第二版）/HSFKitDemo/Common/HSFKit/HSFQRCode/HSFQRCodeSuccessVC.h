//
//  HSFQRCodeSuccessVC.h
//  HSFKitDemo
//
//  Created by JuZhenBaoiMac on 2017/8/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseVC.h"

@interface HSFQRCodeSuccessVC : BaseVC

/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *jump_URL;
/** 接收扫描的条形码信息 */
@property (nonatomic, copy) NSString *jump_bar_code;

@end
