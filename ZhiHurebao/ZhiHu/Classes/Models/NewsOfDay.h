//
//  NewsOfDay.h
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsOfDay : NSObject
@property (nonatomic, strong)NSString * date;      // 日期
@property (nonatomic, strong)NSString * ga_prefix; // 新闻的排序前缀
@property (nonatomic, strong)NSString * id;        // 新闻的id
@property (nonatomic, strong)NSArray * images;     // 新闻里所含图片的网址
@property (nonatomic, strong)NSString * title;     // 新闻的标题
@property (nonatomic, strong)NSNumber * type;
@property (nonatomic, strong)NSString * image;     // 轮播图上新闻的图片

// 消息内容获取与离线下载
@property (nonatomic, strong) NSString * body;        // HTML 格式的新闻
@property (nonatomic, strong) NSArray * css;          // 供手机端的 WebView(UIWebView) 使用
@property (nonatomic, strong) NSString * image_source;// 版权提供库
@property (nonatomic, strong) NSString * js;          // 供手机端的 WebView(UIWebView) 使用

@property (nonatomic, strong) NSString * share_url;   // 供在线查看内容与分享至 SNS 用的 URL


@end
