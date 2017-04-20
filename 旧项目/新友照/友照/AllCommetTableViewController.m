//
//  AllCommetTableViewController.m
//  友照
//
//  Created by chaoyang on 16/11/30.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "AllCommetTableViewController.h"
#import "ZXNetDataManager+CoachData.h"
#import "ZXCommentTableViewCell.h"

@interface AllCommetTableViewController ()
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AllCommetTableViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"教练全部评价";
    self.page = @"0";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZXCommentTableViewCellID"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int p = [_page intValue];
        p++;
        _page = [NSString stringWithFormat:@"%d",p];
        }];
    [self getPinLunData];
}

- (void)getPinLunData
{
     [[ZXNetDataManager manager] jiaoLianCommentWithTimeStamp:[ZXDriveGOHelper getCurrentTimeStamp] andTid:self.tid andPage:self.page success:^(NSURLSessionDataTask *task, id responseObject)
    {
         NSError *err;
         NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *jsonString = [receiveStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
         jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
         NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
         if(err)
         {
             NSLog(@"json解析失败：%@",err);
         }
         if ([jsonDict[@"res"] isEqualToString:@"1001"])
         {
             for (NSDictionary *dic in jsonDict[@"list"])
             {
                 [self.dataSource addObject:dic];
             }
             [self.tableView reloadData];
             [self.tableView.mj_footer endRefreshing];
         }
         else  if ([jsonDict[@"res"] isEqualToString:@"1002"])
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录状态已过期, 请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *anotherAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                 //让用户重新登录
                 [ZXUD setObject:nil forKey:@"ident_code"];
                 ZX_Login_ViewController *VC = [[ZX_Login_ViewController alloc] init];
                 UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
                 [self presentViewController:navi animated:YES completion:nil];
             }];
             [alert addAction:anotherAction];
             [self presentViewController:alert animated:YES completion:^{
                 
             }];
         }
         else if ([jsonDict[@"res"] isEqualToString:@"1005"] || [jsonDict[@"res"] isEqualToString:@"1004"])
         {
             
         }
         else
         {
             [MBProgressHUD showError:jsonDict[@"msg"]];
         }
     } failed:^(NSURLSessionTask *task, NSError *error)
      {
         [self.tableView.mj_footer endRefreshing];
     }];
}

- (void) goToBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentTableViewCellID"];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _dataSource[indexPath.row];
    [commentCell resetContentLabelFrame:dic];
    [commentCell setUpCellWith:dic];
    return commentCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataSource[indexPath.row];
    return [ZXCommentTableViewCell calculateContentHeight:dic];

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
