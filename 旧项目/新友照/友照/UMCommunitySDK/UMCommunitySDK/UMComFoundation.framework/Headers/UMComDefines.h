//
//  UMComDefines.h
//  UMComFoundation
//
//  Created by wyq.Cloudayc on 7/21/16.
//  Copyright © 2016 umeng. All rights reserved.
//

#ifndef UMComDefines_h
#define UMComDefines_h

//判断系统版本方法
#define UMComSystem_Version_Equal_To(vesion)                  ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedSame)
#define UMComSystem_Version_Greater_Than(version)              ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedDescending)
#define UMComSystem_Version_Greater_Than_Or_Equal_To(vesion)  ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] != NSOrderedAscending)
#define UMComSystem_Version_Less_Than(vesion)                 ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedAscending)
#define UMComSyatem_Version_Less_Than_Or_Equal_To(vesion)     ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] != NSOrderedDescending)
#define UMCom_Current_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]



#endif /* UMComDefines_h */
