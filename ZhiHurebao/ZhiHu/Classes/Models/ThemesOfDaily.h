//
//  ThemesOfDaily.h
//  ZhiHu
//
//  Created by lanou3g.com on 15/11/21.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemesOfDaily : NSObject

@property (nonatomic, strong) NSNumber * limit;
@property (nonatomic, strong) NSArray * others;
@property (nonatomic, retain) NSString *background;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, retain) NSString *name;

@end
