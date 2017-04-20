//
//  UMComUserCommentViewController.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/19/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComSimpleSubCommentViewController.h"
#import "UMComResouceDefines.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSimpleFeedDetailViewController.h"
#import "UMComSimpleAssociatedFeedTableViewCell.h"
#import "UMComFeedClickActionDelegate.h"
#import <UMComDataStorage/UMComComment.h>


@interface UMComSimpleSubCommentViewController ()<UITableViewDataSource, UITableViewDelegate, UMComFeedClickActionDelegate>
@property (nonatomic, strong) UMComListDataController *secondDataController;

@property (nonatomic, strong) NSMutableDictionary *cellCacheDict;

@property (nonatomic, strong) UMComSimpleAssociatedFeedTableViewCell *baseCell;


@end

@implementation UMComSimpleSubCommentViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setForumUITitle:UMComLocalizedString(@"um_com_my_comment", @"评论")];
    
    UINib *cellNib = [UINib nibWithNibName:kUMComSimpleAssociatedFeedTableViewCellName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    
    self.baseCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.cellCacheDict = [NSMutableDictionary dictionary];
    self.isLoadFinish = YES;
    self.doNotShowNodataNote = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataController.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComComment *obj = self.dataController.dataArray[indexPath.row];
    
    UMComSimpleAssociatedFeedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kUMComSimpleAssociatedFeedTableViewCellId];
    cell.delegate = _delegate;
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    [cell refreshWithComment:obj];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComComment *obj = self.dataController.dataArray[indexPath.row];

    NSString *heightKey = [NSString stringWithFormat:@"height_%@",obj.commentID];
    
    CGFloat height = 0;
    if (![self.cellCacheDict valueForKey:heightKey] ) {

        _baseCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(_baseCell.bounds));
        
        [_baseCell setNeedsLayout];
        [_baseCell layoutIfNeeded];
        
        [_baseCell refreshWithComment:obj];
        
        height = [_baseCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height += 1;
        [self.cellCacheDict setValue:@(height) forKey:heightKey];
    }else{
        height = [[self.cellCacheDict valueForKey:heightKey] floatValue];
    }
    return height;
}



@end
