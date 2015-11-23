//
//  ThemesOfDaily.m
//  ZhiHu
//
//  Created by lanou3g.com on 15/11/21.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "ThemesOfDaily.h"

@implementation ThemesOfDaily

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.Description = value;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@--%@--%@--%ld",_name,_Description,_title,_id];
}

@end
