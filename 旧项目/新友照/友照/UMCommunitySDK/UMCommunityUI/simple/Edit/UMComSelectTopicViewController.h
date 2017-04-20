//
//  UMComSelectTopicViewController.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComViewController.h"
#import "UMComRequestTableViewController.h"

@class UMComTopic;

typedef void (^SelectTopicViewFinishAction)(UMComTopic* topic);
typedef void (^CloseTopicViewAction)();

//typedef NS_ENUM(NSInteger, UMComSelectTopictType)
//{
//    UMComSelectTopic_FromViewControllerWithoutTopic, //从其他viewcontrller 没有代入UMComTopic
//    UMComSelectTopic_FromViewControllerWithTopic,   //从其他viewcontrller 代入UMComTopic(目前类型不处理)
//    UMComSelectTopic_FromEditViewController,    //从编辑界面
//};

@interface UMComSelectTopicViewController : UMComRequestTableViewController


//@property(nonatomic,assign)UMComSelectTopictType selectTopictType;
//@property(nonatomic,strong)UMComTopic* curTopic;

@property(nonatomic,copy)CloseTopicViewAction closeTopicViewAction;
@property(nonatomic,copy)SelectTopicViewFinishAction selectTopicViewFinishAction;



@end
