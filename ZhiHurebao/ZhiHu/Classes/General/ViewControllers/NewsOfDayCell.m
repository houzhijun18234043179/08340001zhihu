//
//  NewsOfDayCell.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "NewsOfDayCell.h"
@implementation NewsOfDayCell

- (void)setNewsOfDay:(NewsOfDay *)newsOfDay{
    
    self.lab4title.text = newsOfDay.title;
    [self.imgview sd_setImageWithURL:[NSURL URLWithString:[newsOfDay.images lastObject]] placeholderImage:nil];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
