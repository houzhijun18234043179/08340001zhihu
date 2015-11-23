//
//  ThemeDetailViewController.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "ThemesOfDaily.h"
#import "ThemesCell.h"
#import "ThemeOfDailyController.h"

@interface ThemeDetailViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation ThemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self requestData];
    
    [self.view addSubview:_webView];
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    [self.webView addGestureRecognizer:swipe];

}

-(void)back:(UITapGestureRecognizer *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)requestData {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString * str = [NSString stringWithFormat:@"%@%ld",kCellURL,self.id];
    NSLog(@"%ld",self.id);
    NSLog(@"%@", str);
    [manager GET:str  parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功");
        NSURL * url = [NSURL URLWithString:responseObject[@"share_url"]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.webView reload];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
