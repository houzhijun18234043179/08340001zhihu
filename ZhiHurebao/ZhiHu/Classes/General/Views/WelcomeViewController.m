//
//  WelcomeViewController.m
//  ZhiHu
//
//  Created by 高升 on 15/11/21.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RootViewController.h"

@interface WelcomeViewController ()

@property (nonatomic,retain)NSTimer *timer;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestWelcome];
}

- (void)requestWelcome{
    __weak typeof(self)temp = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kStart parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功");
        [temp.img4Img sd_setImageWithURL:[NSURL URLWithString:responseObject[@"img"]]];
        temp.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:temp selector:@selector(backView) userInfo:nil repeats:NO];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
}

-(void)backView{
    
    RootViewController *rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootVC"];
     rootVC.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    [self presentViewController:rootVC animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
