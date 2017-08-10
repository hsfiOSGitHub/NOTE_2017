//
//  Macros.h
//  YKC好了吗客户端
//
//  Created by Insect on 2017/1/5.
//  Copyright © 2017年 Insect. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"
/*****************  屏幕适配  ******************/
#define iphone6p (ScreenH == 763)
#define iphone6 (ScreenH == 667)
#define iphone5 (ScreenH == 568)
#define iphone4 (ScreenH == 480)

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

//全局背景色
#define DCBGColor RGB(245,245,245)

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"

#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UserInfoData [DCUserInfo findAll].lastObject


//数组
#define GoodsRecommendArray  @[@"http://gfs8.gomein.net.cn/T1TkDvBK_j1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1loYvBCZj1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1L.VvBCxv1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1joLvBKhT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1AoVvB7_v1RCvBVdK.jpg"];

#define GoodsHandheldImagesArray  @[@"http://gfs1.gomein.net.cn/T1koKvBT_g1RCvBVdK.jpg",@"http://gfs3.gomein.net.cn/T1n5JvB_Eb1RCvBVdK.jpg",@"http://gfs10.gomein.net.cn/T1jThTB_Ls1RCvBVdK.jpeg",@"http://gfs7.gomein.net.cn/T1T.YvBbbg1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1toCvBKKT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1JZLvB4Jj1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1JZLvB4Jj1RCvBVdK.jpg",@"http://gfs3.gomein.net.cn/T1ckKvBTW_1RCvBVdK.jpg",@"http://gfs.gomein.net.cn/T1hNCvBjKT1RCvBVdK.jpg"]


#endif /* Macros_h */
