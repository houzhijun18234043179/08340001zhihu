//
//  DetailNewsViewController.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "DetailNewsViewController.h"
#import "NewsOfDay.h"

@interface DetailNewsViewController ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIWebView *bodyWab;
@property (weak, nonatomic) IBOutlet UILabel *lab4title;
@property (weak, nonatomic) IBOutlet UILabel *lab4source;

- (IBAction)back:(id)sender;
@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollview.delegate = self;
    self.bodyWab.delegate = self;
    self.bodyWab.scrollView.scrollEnabled = NO;
    
    [self requestCell];
}

//
- (void)requestCell{
    // 拼接字符串
    NSString * str = [NSString stringWithFormat:@"%@%@",kCellURL,self.sring];
    NSLog(@"%@",str);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"%@",self.sring);
    
    [manager GET:str  parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"成功");
        
        NewsOfDay *news =[NewsOfDay new];
        [news setValuesForKeysWithDictionary:responseObject];
        NSLog(@"%@",news);
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:news.image]];
        self.lab4title.text = news.title;
        self.lab4source.text  = news.image_source;
        [self.bodyWab loadHTMLString:news.body baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= scrollView.frame.size.height * 0.3) {
        self.bodyWab.scrollView.scrollEnabled = YES;
    }else{
        self.bodyWab.scrollView.scrollEnabled = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
