//
//  HorizontalTableView.h
//  TableViewHorizontalScroll
//
//  Created by Umeng on 14-6-16.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView, UMComUser,UMComSearchUserListDataController;

@interface UMComHorizontalTableView : UITableView

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, copy) void (^didSelectedUser)(UMComUser *user);

- (void)searchUsersWithKeyWord:(NSString *)keyWord;


@property(nonatomic,strong)UMComSearchUserListDataController* searchUserListDataController;
@end




//  HorizontalTableViewCell.h
//  TableViewHengGun
//
//  Created by Umeng on 14-6-16.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//
@interface HorizontalTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UMComImageView *userImageView;

@property (nonatomic, strong) UMComUser *user;

- (void)setUser:(UMComUser *)user;

@end


