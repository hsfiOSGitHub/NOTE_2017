//
//  UMComBriefEditViewController.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/16.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComViewController.h"
@class UMComTopic;

@interface UMComBriefEditViewController : UMComViewController

/**
 *  在话题界面调用，用于传入不可更改的话题
 *
 *  @param topic 话题对象 @see UMComTopic
 *
 *  @return UMComBriefEditViewController对象
 */
-(id)initNOModifiedTopic:(UMComTopic*)topic withPopToViewController:(UIViewController*)popToViewController;

/**
 *  在其他需要先选择话题界面的时候，调用此方法来选择话题
 *
 *  @param parentContrtoller 话题返回或者发送成功后，返回的UIViewController
 *
 *  @return UMComBriefEditViewController对象
 */

-(id)initModifiedTopic:(UMComTopic*)topic withPopToViewController:(UIViewController*)popToViewController;




@end
