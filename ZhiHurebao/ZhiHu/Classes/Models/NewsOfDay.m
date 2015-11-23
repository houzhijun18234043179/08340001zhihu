//
//  NewsOfDay.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "NewsOfDay.h"

@implementation NewsOfDay

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        _ID = value;
//    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@,%@，%@",_title,_images,_date];
}

@end
