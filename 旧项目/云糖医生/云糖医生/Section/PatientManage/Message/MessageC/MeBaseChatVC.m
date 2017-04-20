//
//  MeBaseChatVC.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/8.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "MeBaseChatVC.h"

#import "MeBaseChatCellLeft.h"
#import "MeBaseChatCellRight.h"

@interface MeBaseChatVC ()

@end

static NSString *identifierBaseChatCellLeft = @"identifierBaseChatCellLeft";
static NSString *identifierBaseChatCellRight = @"identifierBaseChatCellRight";
@implementation MeBaseChatVC
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置数据源代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeBaseChatCellLeft class]) bundle:nil] forCellReuseIdentifier:identifierBaseChatCellLeft];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeBaseChatCellRight class]) bundle:nil] forCellReuseIdentifier:identifierBaseChatCellRight];
}
#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sourceArr count];
}
//行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // Configure the cell...
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
