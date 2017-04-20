//
//  chatVC.m
//  云糖医生
//
//  Created by yuntangyi on 16/8/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "chatVC.h"
#import "EMSDK.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EMTextMessageBody.h"
#import "TableViewCell_xiao_xi.h"
#import "EaseUi.h"
#import "ChatViewController.h"

@interface chatVC ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>

@property(nonatomic,strong)NSMutableArray* dataLoadDataSource;
@property(nonatomic,strong)NSMutableArray* liaotian;
@property(nonatomic,strong)NSString *nicheng;
@property(nonatomic)BOOL en;
@property (nonatomic, strong)KongPlaceHolderView *placeholdView;//数据为空的占位图

@end

@implementation chatVC



-(void)viewWillAppear:(BOOL)animated
{
    _en=YES;
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:0];
    item.badgeValue=nil;
    _dataLoadDataSource =[self loadDataSource];
    
    [self.placeholdView removeFromSuperview];
    _liaotian=[NSMutableArray arrayWithArray:[ZXUD arrayForKey:@"liaotian"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_dataLoadDataSource.count == 0) {
            //加载的数据为空
            _placeholdView = [[KongPlaceHolderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
            _placeholdView.label.text = @"您还没有消息";
            [self.view addSubview:_placeholdView];
        }
         [_tab reloadData];
    });
}
-(void)viewWillDisappear:(BOOL)animated
{
    _en=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataLoadDataSource =[self loadDataSource];

    _liaotian=[NSMutableArray arrayWithArray:[ZXUD arrayForKey:@"liaotian"]];
    //创建界面
    [self chaungjianjiemian];
   
}

-(void)hehe
{
    //添加环信消息的代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

//创建界面
-(void)chaungjianjiemian
{
//    self.navigationController.navigationBar.translucent = NO;
    _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, -34, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 42) style:UITableViewStyleGrouped];
    _tab.delegate=self;
    _tab.dataSource=self;
    [_tab registerNib:[UINib nibWithNibName:@"TableViewCell_xiao_xi" bundle:nil] forCellReuseIdentifier:@"xiao_xi"];
    [self.view addSubview:_tab];
    _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataLoadDataSource.count;
}

//内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell_xiao_xi* cell=[tableView dequeueReusableCellWithIdentifier:@"xiao_xi" forIndexPath:indexPath];
    //聊天的会话对象
    if ([_dataLoadDataSource[indexPath.row] isKindOfClass:[EMMessage class]])
    {
        //头像
        cell.tou_xiang.image = [UIImage imageNamed:@"11111"];
        //昵称
        cell.ni_cheng.text = @"电脑终结者";
        //消息的时间
        cell.shi_jian.text =[NSDate formattedTimeFromTimeInterval:((EMMessage*)_dataLoadDataSource[indexPath.row]).timestamp];
        NSLog(@"%@",cell.shi_jian.text);
        switch (((EMMessage*)_dataLoadDataSource[indexPath.row]).body.type)
        {
            case EMMessageBodyTypeImage:
            {
                cell.zui_hou_xiao_xi.text = @"[图片]";
            }
                break;
            case EMMessageBodyTypeText:
            {
                // 表情映射。
                cell.zui_hou_xiao_xi.text = [ConvertToCommonEmoticonsHelper
                                             convertToSystemEmoticons:((EMTextMessageBody *)((EMMessage*)_dataLoadDataSource[indexPath.row]).body).text];
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                cell.zui_hou_xiao_xi.text = @"[音频]";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                cell.zui_hou_xiao_xi.text = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                cell.zui_hou_xiao_xi.text = @"[视频]";
            }
                break;
            default:
                break;
        }
        cell.wei_du_xiao_xi.text = [NSString stringWithFormat:@"1"];
        
    }
    else
    {
        EMConversation *conversation = _dataLoadDataSource[indexPath.row];
        if (conversation.lastReceivedMessage)
        {
            //头像
            [cell.tou_xiang sd_setImageWithURL:[NSURL URLWithString:((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"]] placeholderImage:[UIImage imageNamed:@"默认患者头像"]];
            //昵称
            cell.ni_cheng.text =((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"];
            if(cell.ni_cheng.text.length==0)
            {
                cell.ni_cheng.text=conversation.conversationId;
            }
            
            BOOL haha=NO;
            for (int i=0; i<_liaotian.count; i++)
            {
                if ([_liaotian[i][@"phone"] isEqualToString:conversation.conversationId])
                {
                    NSMutableDictionary* mdict=[[NSMutableDictionary alloc]initWithDictionary:_liaotian[i]];

                    if (![_liaotian[i][@"pic"] isEqualToString:((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"]])
                    {
                      
                        if ([((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] isKindOfClass:[NSString class]] && [((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] length]>0)
                        {
                            [mdict setObject:((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] forKey:@"pic"];
                        }
                        [_liaotian replaceObjectAtIndex:i withObject:mdict];
                    }
                    
                   if (![_liaotian[i][@"name"] isEqualToString:((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"]])
                    {
                        if ([((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] isKindOfClass:[NSString class]] && [((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] length]>0)
                        {
                            [mdict setObject:((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] forKey:@"name"];
                        }
                    }
                    [_liaotian replaceObjectAtIndex:i withObject:mdict];
                    [ZXUD setObject:_liaotian forKey:@"liaotian"];
                    [ZXUD synchronize];
                    haha=YES;
                    continue;
                }
            }
            
            if (!haha)
            {
                NSMutableDictionary* mdict=[[NSMutableDictionary alloc]init];
                [mdict setObject:conversation.conversationId forKey:@"phone"];
            
                if ([((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] isKindOfClass:[NSString class]] && [((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] length]>0)
                {
                    [mdict setObject:((EMMessage*)conversation.lastReceivedMessage).ext[@"nickName"] forKey:@"name"];
                }
                
                if ([((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] isKindOfClass:[NSString class]] && [((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] length]>0)
                {
                    [mdict setObject:((EMMessage*)conversation.lastReceivedMessage).ext[@"pic"] forKey:@"pic"];
                }
                [_liaotian addObject:mdict];
            }
            [ZXUD setObject:_liaotian forKey:@"liaotian"];
            [ZXUD synchronize];
        }
        else
        {
            for (int i=0; i<_liaotian.count; i++)
            {
                if ([_liaotian[i][@"phone"] isEqualToString:conversation.conversationId])
                {
                    //头像
                    [cell.tou_xiang sd_setImageWithURL:[NSURL URLWithString:_liaotian[i][@"pic"]] placeholderImage:[UIImage imageNamed:@"默认患者头像"]];
//                    _nicheng=_liaotian[i][@"name"];
                    //昵称
                    cell.ni_cheng.text =_liaotian[i][@"name"];
                    if(cell.ni_cheng.text.length==0)
                    {
                        cell.ni_cheng.text=conversation.conversationId;
                    }
                    continue;
                }
            }
        }
        if (conversation.latestMessage)
        {
            //最后一条消息的时间
            cell.shi_jian.text =[self lastMessageTimeByConversation:conversation];
            
            //最后的一条消息
            switch (((EMMessage*)conversation.latestMessage).body.type)
            {
                case EMMessageBodyTypeImage:
                {
                    cell.zui_hou_xiao_xi.text = @"[图片]";
                }
                    break;
                case EMMessageBodyTypeText:
                {
                    // 表情映射。
                    cell.zui_hou_xiao_xi.text =[self subTitleMessageByConversation:conversation];
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    cell.zui_hou_xiao_xi.text = @"[音频]";
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    cell.zui_hou_xiao_xi.text = @"[位置]";
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    cell.zui_hou_xiao_xi.text = @"[视频]";
                }
                    break;
                default:
                    break;
            }

        }
        else
        {
            cell.zui_hou_xiao_xi.text=@"";
            cell.shi_jian.text =@"";
        }
        //未读消息的条数
        NSInteger num = [self unreadMessageCountByConversation:conversation];
        if(num>0)
        {
            if(num > 99)
            {
                cell.wei_du_xiao_xi.text = [NSString stringWithFormat:@"99+"];
                cell.wei_du_xiao_xi.frame = CGRectMake(35, 5, 30, 20);
            }
            else
            {
                cell.wei_du_xiao_xi.text = [NSString stringWithFormat:@"%tu",num];
                cell.wei_du_xiao_xi.frame = CGRectMake(35, 5, 30, 20);
            }
            cell.wei_du_xiao_xi.hidden = NO;
        }
        else
        {
            cell.wei_du_xiao_xi.hidden = YES;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //打开聊天界面
    //将未读消息设置成已读
    EMConversation *conversation = _dataLoadDataSource[indexPath.row];
    [conversation markMessageAsReadWithId:conversation.conversationId];
    
    [_tab reloadData];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:EMConversationTypeChat];
    for (int i=0; i<_liaotian.count; i++)
    {
        if ([_liaotian[i][@"name"] isKindOfClass:[NSString class]] && [_liaotian[i][@"name"] length]>0)
        {
            chatController.title=_liaotian[i][@"name"];
        }
        else
        {
            chatController.title=_liaotian[i][@"phone"];
        }
        continue;
    }
    chatController.flag = @"0";
    [self.navigationController pushViewController:chatController animated:YES];
}
- (void)didReceiveMessages:(NSArray *)aMessages
{

    NSString *title=@"";
    NSString *messageStr=@"";
    NSLog(@"%d",[ZXUD boolForKey:@"ht"]);
    if([ZXUD boolForKey:@"ht"])
    {
        for (int f=0; f<aMessages.count; f++)
        {
            
            if (((EMMessage*)aMessages[f]).ext[@"nickName"])
            {
                title=((EMMessage*)aMessages[f]).ext[@"nickName"];
            }
            else
            {
                title=((EMMessage*)aMessages[f]).from;
            }
            
            //最后的一条消息
            switch (((EMMessage*)aMessages[f]).body.type)
            {
                case EMMessageBodyTypeImage:
                {
                    messageStr = @"[图片]";
                }
                    break;
                case EMMessageBodyTypeText:
                {
                    messageStr = [ConvertToCommonEmoticonsHelper
                                                convertToSystemEmoticons:((EMTextMessageBody *)((EMMessage*)aMessages[f]).body).text];
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    messageStr = @"[音频]";
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    messageStr = @"[位置]";
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    messageStr = @"[视频]";
                }
                    break;
                default:
                    break;
            }
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.repeatInterval=0;
            notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
            notification.soundName=@"";
            
            // 收到消息时，震动
            if ([ZXUD boolForKey:@"zd"] && [ZXUD boolForKey:@"sy"])
            {
                [[EMCDDeviceManager sharedInstance] playVibration];
                [[EMCDDeviceManager sharedInstance] playNewMessageSound];
            }
            else if ([ZXUD boolForKey:@"zd"] && ![ZXUD boolForKey:@"sy"])
            {
                [[EMCDDeviceManager sharedInstance] playVibration];
            }
            else if(![ZXUD boolForKey:@"zd"] && ![ZXUD boolForKey:@"sy"])
            {
                
            }
            else if (![ZXUD boolForKey:@"zd"] && [ZXUD boolForKey:@"sy"])
            {
                [[EMCDDeviceManager sharedInstance] playNewMessageSound];
            }
            notification.alertAction = @"打开";
            notification.timeZone =[NSTimeZone defaultTimeZone];
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            UIApplication *application = [UIApplication sharedApplication];
            application.applicationIconBadgeNumber += 1;
        }
    }
    
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    
    _dataLoadDataSource=[NSMutableArray arrayWithArray:conversations];
    
    [_tab reloadData];
    
    NSInteger xx=0;
    for (int  i=0; i<_dataLoadDataSource.count; i++)
    {
        if (![_dataLoadDataSource[i] isKindOfClass:[EMMessage class]])
        {
            EMConversation *conversation = _dataLoadDataSource[i];
            xx += [self unreadMessageCountByConversation:conversation];
        }
    }
    if (!_en)
    {
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:0];
        if(xx > 99)
        {
            item.badgeValue=@"99+";
        }
        else
        {
            item.badgeValue=[NSString stringWithFormat:@"%lu",(long)xx];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[EMClient sharedClient].chatManager deleteConversation:((EMConversation*)_dataLoadDataSource[indexPath.row]).conversationId deleteMessages:YES];
        [_dataLoadDataSource removeObjectAtIndex:indexPath.row];
        [_tab reloadData];
    }
}


- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    NSLog(@"收到消息");
}


// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    
    if (conversation.latestMessage) {
        switch (conversation.latestMessage.body.type)
        {
            case EMMessageBodyTypeImage:
            {
                ret = @"[图片]";
            }
                break;
            case EMMessageBodyTypeText:
            {
                // 表情映射
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)((EMMessage*)conversation.latestMessage).body).text];
                ret = didReceiveText;
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                ret = @"[音频]";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                ret = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                ret = @"[视频]";
            }
                break;
            default:
                break;
        }
    }
    
    return ret;
}

//获取最后一条消息的发送者
- (NSString *)subNameMessageByConversation:(EMConversation *)conversation{
    NSDictionary *ext = conversation.latestMessage.ext;   //(环信：扩展消息）
    if(ext){
        return [NSString stringWithFormat:@"%@:",[ext objectForKey:@"name"]];
    }else{
        return conversation.latestMessage.from;
    }
}

//获取消息的发送者的头像
- (NSString *)subHeadImageMessageByConversation:(EMConversation *)conversation{
    
    NSDictionary *ext = conversation.latestMessage.ext;   //环信：扩展消息）
    if(ext){
        return [ext objectForKey:@"headImage"];
    }
    return @"";
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    
    NSLog(@"%lld",conversation.latestMessage.localTime);
    
    return [NSDate formattedTimeFromTimeInterval:conversation.latestMessage.localTime];
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    return  ret;
}

//当前登陆用户的会话对象列表
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    
    return ret;
}

//获取群和好友列表
- (void)reloadDataNews{
    //    [self.friendsArry removeAllObjects];
    //    [self.groupArry removeAllObjects];
    
    //好友列表
    //    EMError *error = nil;
    //    NSArray *buddyListB = [[EMClient sharedClient].chatManager fetchBuddyListWithError:&error];
    //    NSLog(@"%@",error);
    //    NSMutableArray *buddyList = [[NSMutableArray alloc] initWithArray:buddyListB];
    //
    //    if(buddyList.count > 0){
    //        [self.friendsArry addObjectsFromArray:buddyList];
    //    }
    //
    //    //群组列表
    //    NSArray *roomsList = [[EMClient sharedClient].chatManager groupList];
    //    if(roomsList.count > 0){
    //        [self.groupArry addObjectsFromArray:roomsList];
    //    }
}

//未读消息改变时
-(void)didUnreadMessagesCountChanged{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//群组列表变化后的回调
- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//添加了好友时的回调
- (void)didAcceptedByBuddy:(NSString *)username{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//接受好友请求成功的回调
- (void)didAcceptBuddySucceed:(NSString *)username{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//登录的用户被好友从列表中删除了
- (void)didRemovedByBuddy:(NSString *)username{
    //    [[EMClient sharedClient].chatManager removeConversationByChatter:username deleteMessages:YES append2Chat:NO];
    
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//将好友加到黑名单完成后的回调
- (void)didBlockBuddy:(NSString *)username error:(EMError *)pError{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//将好友移出黑名单完成后的回调
- (void)didUnblockBuddy:(NSString *)username error:(EMError *)pError{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//收到消息时(可以播放提示音什么的)
- (void)didReceiveMessage:(EMMessage *)message{
    
    
    
}

// 发送消息后的回调
- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//删除了好友
- (void)didRemoveFirendGroup:(NSNotification*)notification{
    [self reloadDataNews];
    _dataLoadDataSource = [self loadDataSource];
    [_tab reloadData];
}

//- (NSMutableArray *)friendsArry{
//    if(!_friendsArry){
//        _friendsArry = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    return _friendsArry;
//}
//
//- (NSMutableArray *)groupArry{
//    if(!_groupArry){
//        _groupArry = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    return _groupArry;
//}

- (NSMutableArray *)dataLoadDataSource{
    if(!_dataLoadDataSource){
        _dataLoadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataLoadDataSource;
}

//用户将要进行自动登录操作的回调
- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    NSLog(@"dddd");
}

//结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    //    [[EMClient sharedClient].chatManager loadDataFromDatabase];
    //    //获取群组列表
    //    [[EMClient sharedClient].chatManager asyncFetchMyGroupsList];
}


@end
