//
//  NewsOfDayViewController.h
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "ThemesOfDaily.h"
#import "ThemeOfDailyController.h"
@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;  // 分类
@property (nonatomic, retain) NSArray *titles;
@end

@implementation LeftMenuViewController
static NSString *cellIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableView class] forCellReuseIdentifier:cellIdentifier];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 7) / 2.0f, self.view.frame.size.width, 54 * 7) style:UITableViewStylePlain];
        
        //自动调整子控件和父控件之间的位置(枚举值)
        //UIViewAutoresizingFlexibleTopMargin 自动调整与superView顶部的距离，保证与superView底部的距离不变。
        //UIViewAutoresizingFlexibleBottomMargin 自动调整与superView底部的距离，也就是说，与superView顶部的距离不变。
        //UIViewAutoresizingFlexibleWidth 自动调整自己的宽度，保证与superView左边和右边的距离不变。
//        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self requestData];
    [self.tableView reloadData];
}

- (void)requestData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:kThemes parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // 解析
        NSArray *array = responseObject[@"others"];
        for (NSDictionary *dic in array) {
            ThemesOfDaily *model = [ThemesOfDaily new];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
//            NSLog(@"%ld",model.id);
        };
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"-------失败");
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    //设置左标题栏
    self.titles = @[@"首页", @"设计日报", @"互联网安全", @"开始游戏", @"音乐日报",@"动漫日报",@"用户推荐日报"];
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_titles[indexPath.row] isEqual: @"首页"]) {
    [self.sideMenuViewController hideMenuViewController];
    }
    // 设计日报
    if ([_titles[indexPath.row] isEqual: @"设计日报"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.name = @"设计日报";
        mixVC.id = 4;
        [self presentViewController:mixVC animated:YES completion:nil];
    }
    // 互联网安全
    if ([_titles[indexPath.row] isEqual: @"互联网安全"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.id = 10;
        mixVC.name = @"互联网安全";
        [self presentViewController:mixVC animated:YES completion:nil];
    }
    // 开始游戏
    if ([_titles[indexPath.row] isEqual: @"开始游戏"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.id = 2;
        mixVC.name = @"开始游戏";
        [self presentViewController:mixVC animated:YES completion:nil];
    }
    // 音乐日报
    if ([_titles[indexPath.row] isEqual: @"音乐日报"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.id = 7;
        mixVC.name = @"音乐日报";
        [self presentViewController:mixVC animated:YES completion:nil];
    }
    // 动漫日报
    if ([_titles[indexPath.row] isEqual: @"动漫日报"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.id = 9;
        mixVC.name = @"动漫日报";
        [self presentViewController:mixVC animated:YES completion:nil];
    }
    // 用户推荐日报
    if ([_titles[indexPath.row] isEqual: @"用户推荐日报"]) {
        ThemeOfDailyController *mixVC = [ThemeOfDailyController sharedThemes];
        mixVC.id = 12;
        mixVC.name = @"用户推荐日报";
        [self presentViewController:mixVC animated:YES completion:nil];
    }
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
