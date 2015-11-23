//
//  NewsOfDayViewController.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "NewsOfDayViewController.h"
#import "NewsOfDay.h"
#import "NewsOfDayCell.h"
#import "DetailNewsViewController.h"
typedef void(^block) (NSMutableArray *);
@interface NewsOfDayViewController ()

@property (nonatomic, copy) block myBlock;

// 轮播图
@property (nonatomic, strong)UIScrollView * scollview;
@property (nonatomic, strong)UIPageControl * page;
@property (nonatomic, strong)NSTimer * time;
// 承接当日新闻
@property (nonatomic, strong)NSMutableArray * dataArray;
// 承接轮播图上的
@property (nonatomic, strong)NSMutableArray * dataArray1;
// 承接往日新闻
@property (nonatomic, strong)NSMutableArray * dataArray2;
// 模块
@property (nonatomic, strong)NSMutableArray * sectionArray;
// 当日时间
@property (nonatomic, assign)NSInteger currentDate;
// 将解析出的放入字典
@property (nonatomic, strong)NSMutableDictionary * dataDictionary;

@property (nonatomic, strong)NSMutableArray * mutableArray;

@end

static NSString *identifier = @"newCell";

@implementation NewsOfDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.sectionArray = [NSMutableArray array];
    self.dataArray1 = [NSMutableArray array];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsOfDayCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self request];
    [self carousel];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
}

// 下拉刷新
- (void)headerRereshing{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark ----轮播图----
- (void)carousel{
    
    // 创建view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 414, 260)];
    
    // scollview
    self.scollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 414, 240)];
    _scollview.contentSize = CGSizeMake(5*414, 240);
    _scollview.pagingEnabled = YES;
    _scollview.backgroundColor = [UIColor whiteColor];
    [view addSubview:_scollview];
    
    // block导入
    __weak typeof (self)temp = self;
    self.myBlock = ^(NSMutableArray *array){
        for (int i = 0; i < array.count; i++) {
            UIImageView * image = [UIImageView new];
            image.frame = CGRectMake(414*i, 0, 414, 260);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 390, 100)];
            label.numberOfLines = 0;
            label.textColor = [UIColor whiteColor];
            
            NewsOfDay *news= array[i];
            label.text = news.title;
            [image addSubview:label];
            [image sd_setImageWithURL:[NSURL URLWithString:news.image]];
            [temp.scollview addSubview:image];
            // page
            temp.page = [[UIPageControl alloc]initWithFrame:CGRectMake(130, 240, 150, 20)];
            temp.page.numberOfPages = 5;
            temp.page.currentPage = 0;
          temp.page.currentPageIndicatorTintColor = [UIColor redColor];
          temp.page.pageIndicatorTintColor = [UIColor cyanColor];
            [temp.page addTarget:temp action:@selector(page:) forControlEvents:UIControlEventValueChanged];
            [temp.view addSubview:temp.page];
            
            temp.tableView.tableHeaderView = view;
        }
    };
    
// 一开始就开启定时器 并且滚动后 仍继续滚动
    [self startTimer];
}

#pragma mark ----事件----
- (void)page:(UIPageControl *)sender{
    NSInteger index = sender.currentPage;
    _scollview.contentOffset = CGPointMake(414*index, 0);
}

// 开启定时器
- (void)startTimer{
    self.time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];}

- (void)timeAction{
   
    int page1 = (int)self.page.currentPage;
    if (page1 == 4) {
        page1 = -1;
    }
        page1 ++;
    
    CGFloat x = page1 * 414;
    self.scollview.contentOffset = CGPointMake(x, 0);
    self.page.currentPage = page1;
}

#pragma mark ----保证拖拽跳转等操作后，轮播图继续滚动----

// 关闭计时器
- (void)removeTimer{
    [self.time invalidate];
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

// 将结束拖拽时触发
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 开启定时器
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _page.currentPage = _scollview.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
}
#pragma mark ----当日新闻以及轮播图的解析----
- (void)request{
    // 子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 数据链接
        NSURL * url = [NSURL URLWithString:kNewsOfDayURL];
        
        // 解析数据
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        // 创建session
        NSURLSession * session = [NSURLSession sharedSession];
        // 加载数据
        NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *array = dict[@"stories"];
            
            self.currentDate = [dict[@"date"] integerValue];
        
            // 数组遍历
            for (NSDictionary * dic in array) {
                // 初始化model
                NewsOfDay * news = [NewsOfDay new];
                [news setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:news];
            }
            
            // 解析轮播图
            NSArray *array1 = dict[@"top_stories"];
            for (NSDictionary * dic1 in array1) {
                NewsOfDay * news1 = [NewsOfDay new];
                [news1 setValuesForKeysWithDictionary:dic1];
                [self.dataArray1 addObject:news1];
            }
            
//            NSLog(@"%ld",self.dataArray1.count);
            // 将日期添加到sectionArray
            [self.sectionArray addObject:dict[@"date"]];
            
            // 将解析完的数据添加到字典
            [self.dataDictionary setObject:self.dataArray forKey:dict[@"date"]];
//            NSLog(@"----%@",dict[@"date"]);
            
            // 返回主线程更新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self request2];
                self.myBlock(self.dataArray1);
                [self.tableView reloadData];
            });
        }];
        // 执行 使用resume方法启动任务
        [task resume];
    });
}

#pragma mark ----解析往日新闻----
- (void)request2{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i < 5; i++) {
            // 数据链接
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld",kOldNewsURL,_currentDate - i]];
            
//            NSLog(@"%@",url);
            // 解析数据
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *array = dict[@"stories"];
                // 数组遍历
                for (NSDictionary * dic in array) {
                    // 初始化model
                    NewsOfDay * news = [NewsOfDay new];
                    [news setValuesForKeysWithDictionary:dic];
                    [self.dataArray2 addObject:news];
                    
                }
                [self.sectionArray addObject:dict[@"date"]];
                
                // 日期排序
                // 顺序排列
                if (i == 5) {
                    NSArray *array2  = [self.sectionArray sortedArrayUsingSelector:@selector(compare:)];
                    self.sectionArray = [NSMutableArray arrayWithArray:array2];
                }
                
                // 倒叙排列
                [self.sectionArray sortUsingSelector:@selector(compare:)];
                // 第一个和最后一个交换位置
                for (int i = 0; i < self.sectionArray.count/2; i++) {
                    NSInteger count = self.sectionArray.count;
                    [self.sectionArray exchangeObjectAtIndex:i withObjectAtIndex:count-i-1 ];
                }
//                NSLog(@"%@", self.sectionArray);
                
                // 将解析的数据添加到字典
                [self.dataDictionary setObject:self.dataArray2 forKey:dict[@"date"]];
                
                // 返回主线程
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.tableView reloadData];
                });
                
            }];
            [task resume];
        }
    });
}

#pragma mark ----懒加载----
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dataArray2{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}

- (NSMutableDictionary *)dataDictionary{
    if (!_dataDictionary) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataDictionary[_sectionArray[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return _sectionArray[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsOfDayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSArray *array = _dataDictionary[_sectionArray[indexPath.section]];
    NewsOfDay * news = array[indexPath.row];
    [cell setNewsOfDay:news];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailNewsViewController * detail = [[DetailNewsViewController alloc]init];
    
    if (indexPath.section == 0) {
        NewsOfDay *model = _dataArray[indexPath.row];
        detail.sring = model.id;
    }else{
        NewsOfDay *model = _dataArray2[indexPath.row];
        detail.sring = model.id;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
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
