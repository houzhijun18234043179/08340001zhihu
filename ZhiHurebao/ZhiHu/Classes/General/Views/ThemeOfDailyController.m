//
//  ThemeOfDailyController.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "ThemeOfDailyController.h"
#import "ThemesOfDaily.h"
#import "ThemesCell.h"
#import "ThemeDetailViewController.h"

@interface ThemeOfDailyController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBackgroud;
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;



@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSString * string;

@end

@implementation ThemeOfDailyController
static ThemeOfDailyController *homeNav = nil;
+(ThemeOfDailyController *)sharedThemes{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeNav = [sb instantiateViewControllerWithIdentifier:@"identifierCell"];
    });
    return homeNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ThemesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    [self.tableView addGestureRecognizer:swipe];
    
}

-(void)back:(UITapGestureRecognizer *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [_dataArray removeAllObjects];
    self.title = _name;
    [self requestData];
}

// 解析分段数据
- (void)requestData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.string = [NSString stringWithFormat:@"%@%ld",kThemesListUrl,self.id];
    NSLog(@"%ld",self.id);
    [manager GET:_string parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // cell解析
        NSArray *array = responseObject[@"stories"];
        for (NSDictionary *dic in array) {
            ThemesOfDaily *model = [ThemesOfDaily new];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        // 解析大图标
        ThemesOfDaily *model = [ThemesOfDaily new];
        [model setValuesForKeysWithDictionary:responseObject];
        // 赋值
        [self.imgBackgroud sd_setImageWithURL:[NSURL URLWithString:model.background]];
        self.descripLabel.text = model.Description;
        
        //刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"---失败");
        NSLog(@"%@",error);
    }];
    
}

// 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    ThemesOfDaily *theme = _dataArray[indexPath.row];
    [cell setModel:theme];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeDetailViewController *detaiVC = [[ThemeDetailViewController alloc] init];
    
    ThemesOfDaily *model = _dataArray[indexPath.row];
    detaiVC.id = model.id;
    
    [self presentViewController:detaiVC animated:YES completion:nil];
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
