//
//  ThemesCell.m
//  ZhiHu
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 lanou3g.com. All rights reserved.
//

#import "ThemesCell.h"
#import "ThemesOfDaily.h"

@implementation ThemesCell

- (void)setModel:(ThemesOfDaily *)model {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.images.lastObject] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    self.nameLabel.text = model.title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
